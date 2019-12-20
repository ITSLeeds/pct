# Cycling potential to leeds valley park

library(tidyverse)
library(osmdata)
library(stplanr)
library(pct)

lvp_osm = opq("leeds") %>%
  add_osm_feature("name", "")

# get od data
od = pct::get_od()
od

# get centroids data
centroids = pct::get_pct_centroids(region = "west-yorkshire")

msoa_codes_study_area = c("E02006876", "E02002423")

summary(od$geo_code2 %in% msoa_codes_study_area)
od_wy = od %>%
  filter(geo_code1 %in% centroids$geo_code)

od_wy_lvp = od_wy %>%
  filter(geo_code2 %in% msoa_codes_study_area)

class(od_wy_lvp)
class(centroids)
mapview::mapview(centroids)

desire_lines_lvp = od2line(flow = od_wy_lvp, centroids)
mapview::mapview(desire_lines_lvp)

sum(desire_lines_lvp$all)
mean(centroids$all)


desire_lines_lvp$hilliness = 0.01
desire_lines_lvp$distance = as.numeric(sf::st_length(desire_lines_lvp))

desire_lines_lvp$potential_cycling = pct::uptake_pct_godutch(
  distance = desire_lines_lvp$distance,
  gradient = desire_lines_lvp$hilliness
  )

plot(desire_lines_lvp$distance, desire_lines_lvp$potential_cycling)

hist(desire_lines_lvp$all, breaks = 10)

# get route data from pct

pct_routes = get_pct_routes_fast(region = "west-yorkshire")

pct_routes_lvp = pct_routes %>%
  filter(geo_code1 %in% msoa_codes_study_area | geo_code2 %in% msoa_codes_study_area)

ids_lvp = od_id_order(x = desire_lines_lvp)
desire_lines_lvp$id = ids_lvp$stplanr.key

ids_routes = od_id_order(x = pct_routes_lvp[2:3])
pct_routes_lvp$id = ids_routes$stplanr.key

# check matches
summary(desire_lines_lvp$id %in% pct_routes_lvp$id)

names(desire_lines_lvp)
pct_routes_small = pct_routes_lvp %>%
  select(all_bidirection = all, bicycle_bidirectional = bicycle, rf_dist_km, rf_avslope_perc, id) %>%
  filter(id %in% desire_lines_lvp$id)
names(pct_routes_small)

desire_lines_non_spatial = sf::st_drop_geometry(desire_lines_lvp) %>%
  filter(id %in% pct_routes_small$id)
routes_lvp = right_join(pct_routes_small, desire_lines_non_spatial)

mapview::mapview(routes_lvp)

# recalculate cycling potential based on better data
summary(routes_lvp$all)
summary(pct_routes$all)
plot(routes_lvp$geometry, lwd = routes_lvp$bicycle)

rnet_lvp = overline2(routes_lvp, attrib = "bicycle")

library(tmap)
tmap_mode("view")
tm_shape(rnet_lvp) +
  tm_lines(lwd = "bicycle", scale = 9)


# calculate go dutch ------------------------------------------------------

plot(routes_lvp$bicycle, routes_lvp$bicycle_bidirectional)
plot(routes_lvp$distance, routes_lvp$rf_dist_km)
routes_lvp$go_dutch_percent = pct::uptake_pct_godutch(
  distance = routes_lvp$rf_dist_km,
  gradient = routes_lvp$rf_avslope_perc
  )

plot(routes_lvp$distance, routes_lvp$go_dutch_percent)
routes_lvp$go_dutch = routes_lvp$go_dutch_percent * routes_lvp$all
summary(routes_lvp$go_dutch)
sum(routes_lvp$go_dutch)

rnet_lvp_go_dutch = overline2(routes_lvp, attrib = "go_dutch")
tm_shape(rnet_lvp_go_dutch) +
  # tm_basemap(server = leaflet::providers$Thunderforest.OpenCycleMap) +
  tm_lines(lwd = "go_dutch", scale = 9)
