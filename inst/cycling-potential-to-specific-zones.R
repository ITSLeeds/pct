# Cycling potential to leeds valley park

library(tidyverse)
library(osmdata)
library(stplanr)
library(pct)


# with osmdata
lvp_osm = opq("leeds") %>%
  add_osm_feature("name", "")
lvp_sf = osmdata_sf(lvp_osm)

# with geofabric
devtools::install_github("itsleeds/geofabric")
library(geofabric)
# View(geofabric_zones)
# wy_osm = get_geofabric("west yorkshire")
# wy_osm = get_geofabric("west yorkshire", layer = "multipolygons")
f = geofabric::gf_filename(name = "West Yorkshire")
query = "select * from multipolygons where name = 'Leeds Valley Park'"
lvp = sf::read_sf(f, query = query)
plot(lvp[1, ])
lvp = lvp[1, ]
sf::write_sf(lvp, "lvp.geojson")
piggyback::pb_upload("lvp.geojson")

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


# get postcode locations --------------------------------------------------

remotes::install_github("ropensci/PostcodesioR")
library(PostcodesioR)

# simple reproducible example
od_postcode = readRDS(url("https://github.com/ITSLeeds/pct/releases/download/0.2.5/od_postcode_min.Rds"))
post_code_points = readRDS(url("https://github.com/ITSLeeds/pct/releases/download/0.2.5/post_code_points_min.Rds"))
lvp_centroid = sf::read_sf("https://github.com/ITSLeeds/pct/releases/download/0.2.5/lvp.geojson")
desire_lines_lvp = stplanr::od2line(flow = od_postcode, post_code_points, lvp_centroid)

# on many postcodes -------------------------------------------------------




# pcodes = readxl::read_excel("Copy of LVP 2019 Travel Survey_Postcodes only.xlsx")
names(pcodes)[1] = "code"
stplanr::geo_code(pcodes[[1]][181]) # test - fail
stplanr::geo_code("ls10 3xe")
tmaptools::geocode_OSM("ls10 3xe")
PostcodesioR::postcode_lookup("ls10 3xe")
PostcodesioR::bulk_postcode_lookup(postcodes = list(pcodes$code[100:109]))

pc_list <- list(
  postcodes = c("PR3 0SG", "M45 6GN", "EX165BL")) # spaces are ignored
bulk_postcode_lookup(pc_list)

summary(nchar(pcodes$code))
pcodes_complete = pcodes %>%
  filter(str_detect(code, " ")) %>%
  filter(nchar(code) > 6) %>%
  filter(nchar(code) < 9) %>%
  mutate(code = gsub(pattern = " ", replacement = "", x = code))

pcodes_list = list(postcodes = pcodes_complete$code[100:109])


pcodes_list = list(postcodes = pcodes$code[100:109])
bulk_postcode_lookup(postcodes = pcodes_list) # works!

pcodes_list = list(postcodes = pcodes$code[1:100])
pcode_result_1_100 = bulk_postcode_lookup(postcodes = pcodes_list) # works!

library(purrr)

bulk_list <- lapply(pcode_result_1_100, "[[", 2)

bulk_df <-
  map_dfr(bulk_list,
          `[`,
          c("postcode", "longitude", "latitude"))

post_code_points = sf::st_as_sf(bulk_df, coords = c("longitude", "latitude"), crs = 4326)
mapview::mapview(post_code_points)

pcodes_list = list(postcodes = pcodes$code[101:200])
pcode_result_100 = bulk_postcode_lookup(postcodes = pcodes_list) # works!
pcodes_list = list(postcodes = pcodes$code[201:300])
pcode_result_200 = bulk_postcode_lookup(postcodes = pcodes_list) # works!
pcodes_list = list(postcodes = pcodes$code[301:400])
pcode_result_300 = bulk_postcode_lookup(postcodes = pcodes_list) # works!
pcodes_list = list(postcodes = pcodes$code[401:500])
pcode_result_400 = bulk_postcode_lookup(postcodes = pcodes_list) # works!
pcodes_list = list(postcodes = pcodes$code[501:600])
pcode_result_500 = bulk_postcode_lookup(postcodes = pcodes_list) # works!
pcodes_list = list(postcodes = pcodes$code[601:700])
pcode_result_600 = bulk_postcode_lookup(postcodes = pcodes_list) # works!
pcodes_list = list(postcodes = pcodes$code[701:nrow(pcodes)])
pcode_result_700 = bulk_postcode_lookup(postcodes = pcodes_list) # works!

pcodes_list_all = c(
  pcode_result_1_100,
  pcode_result_100,
  pcode_result_200,
  pcode_result_300,
  pcode_result_400,
  pcode_result_500,
  pcode_result_600,
  pcode_result_700
  )

bulk_list <- lapply(pcodes_list_all, "[[", 2)

bulk_df <-
  map_dfr(bulk_list,
          `[`,
          c("postcode", "longitude", "latitude"))

head(bulk_df)
post_code_points = sf::st_as_sf(bulk_df, coords = c("longitude", "latitude"), crs = 4326)
mapview::mapview(post_code_points)
saveRDS(post_code_points, "post_code_points.Rds")

lvp_centroid = sf::st_centroid(lvp)
od_postcode = sf::st_drop_geometry(post_code_points)
od_postcode$dest = lvp$osm_id
od_postcode$all = 1
summary(od_postcode$postcode %in% post_code_points$postcode)
summary(od_postcode$dest %in% lvp_centroid$osm_id)

# this fails: issue with stplanr?
desire_lines_lvp = stplanr::od2line(flow = od_postcode, post_code_points, lvp_centroid)



# out-takes ---------------------------------------------------------------


# pcodes = tibble::tibble(code = c("LS7 3HB", "LS2 9JT"))
# pcodes_list = list(postcodes = pcodes$code)
# bulk_postcode_lookup(postcodes = pcodes_list) # works!
# bulk_list <- lapply(pcode_result_1_100, "[[", 2)
#
# bulk_df <-
#   map_dfr(bulk_list,
#           `[`,
#           c("postcode", "longitude", "latitude"))
#
# post_code_points = sf::st_as_sf(bulk_df, coords = c("longitude", "latitude"), crs = 4326)
# saveRDS(post_code_points, "post_code_points_min.Rds")
# lvp_centroid = sf::st_centroid(lvp)
# od_postcode = sf::st_drop_geometry(post_code_points)
# od_postcode$dest = lvp$osm_id
# od_postcode$all = 1
# summary(od_postcode$postcode %in% post_code_points$postcode)
# summary(od_postcode$dest %in% lvp_centroid$osm_id)
#
# mapview::mapview(post_code_points) + mapview::mapview(lvp_centroid)
# # this fails: issue with stplanr?
# desire_lines_lvp = stplanr::od2line(flow = od_postcode, post_code_points, lvp_centroid)
#
# # create-reproducible example
# saveRDS(od_postcode, "od_postcode_min.Rds")
# saveRDS(post_code_points, "post_code_points_min.Rds")
# piggyback::pb_upload("od_postcode_min.Rds")
# piggyback::pb_upload("post_code_points_min.Rds")
# piggyback::pb_download_url()
#
# lvp_centroid

