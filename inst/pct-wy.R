# Show PCT data

library(pct)
library(stplanr)
library(tmap)
library(dplyr)
tmap_mode("view")

centroids = get_centroids_ew()
plot(centroids$geometry)

wy = pct_regions[pct_regions$region_name == "west-yorkshire", ]
tm_shape(wy) + tm_polygons()

centroids = st_transform(centroids, st_crs(wy))
centroids_wy = centroids[wy, ]
plot(centroids_wy)

od = get_od()

head(od$geo_code1)
head(centroids$msoa11cd)

od_wy = od[od$geo_code1 %in% centroids_wy$msoa11cd, ]
od_wy_ew = od_wy[od_wy$geo_code2 %in% centroids$msoa11cd, ]

od_wy_ew_top = od_wy_ew %>%
  filter(all > 50)

lines_wy_top = od2line(od_wy_ew_top, centroids)
plot(lines_wy_top)

tm_shape(wy) + tm_polygons() +
  tm_shape(lines_wy_top) + tm_lines()

r = line2route(lines_wy_top[8, ], plan = "quietest")
tm_shape(r) + tm_lines()

# assignment --------------------------------------------------------------

system.time(r = line2route(lines_wy_top[8, ], plan = "quietest"))
system.time(r <- line2route(lines_wy_top[8, ], plan = "quietest"))
system.time({r = line2route(lines_wy_top[8, ], plan = "quietest")})

# comparison with infrastructure data

library(osmdata)
leeds_ring_road = opq("leeds") %>%
  add_osm_feature(key = "name", value = "Leeds Inner Ring Road") %>%
  osmdata_sf()
lrr_points = leeds_ring_road$osm_points %>% st_transform(27700)
lrr_lines = leeds_ring_road$osm_lines %>% st_transform(27700)
lrr_mline = leeds_ring_road$osm_multilines %>% st_transform(27700)
# qtm(lrr_lines) # looks good, with some gaps
# qtm(lrr_mline)
lrr_buff = lrr_lines %>%
  st_buffer(30) %>%
  st_union()
# qtm(lrr_buff)
lrr_buff_pol = smoothr::fill_holes(lrr_buff, 1e9)
lrr_concave = concaveman::concaveman(points = lrr_points, concavity = 2)
lrr_concave_10 = concaveman::concaveman(points = lrr_points, concavity = 10)

# qtm(lrr_concave) # works very well...
lrr_30 = lrr_concave_10 %>%
  st_buffer(30)
lrr_100 = lrr_concave_10 %>%
  st_buffer(100)
# qtm(lrr_100)
tm_shape(lrr_100) +
  tm_polygons(col = "blue", alpha = 0.05, border.col = "blue") +
  tm_shape(lrr_buff_pol) +
  tm_polygons(col = "red", alpha = 0.05, border.col = "red") +
  tm_shape(lrr_lines) +
  tm_lines() +
  tm_scale_bar()

lrr = st_transform(lrr_30, st_crs(centroids_wy))
centroid_lcc = centroids_wy[lrr, ]

lines_wy_top$dist_km = as.numeric(st_length(lines_wy_top) / 1000)
lines_wy_top_5km = lines_wy_top %>% filter(dist_km <= 5)
lines = lines_wy_top_5km[lrr, ] %>% filter(geo_code1 != geo_code2)
routes = line2route(lines)
plot(routes$geometry)

routes = st_sf(
  cbind(st_drop_geometry(routes), st_drop_geometry(lines)),
  geometry = routes$geometry
)

pcycle_dutch = uptake_pct_godutch(
  distance = routes$length,
  gradient = routes$av_incline
  )

plot(routes$dist_km, pcycle_dutch)

routes$pcycle_godutch = pcycle_dutch
routes$bicycle_dutch = pcycle_dutch * routes$all + routes$bicycle

rnet = overline2(routes, "bicycle_dutch")
plot(rnet)

tm_shape(rnet) + tm_lines(lwd = "bicycle_dutch", scale = 9)

existing = read_sf("https://github.com/ITSLeeds/pct/releases/download/0.2.4/inst.2frmd.2fexisting.geojson")

tm_shape(existing) + tm_lines()

# existing_buff = geo_buffer(existing, 100)
existing_buff = existing %>%
  st_transform(27700) %>%
  st_buffer(100) %>%
  st_transform(4326) %>%
  st_union()

rnet_infra = st_intersection(rnet, existing_buff)
plot(rnet_infra$geometry)

rnet_infra = st_difference(rnet, existing_buff)

tm_shape(existing_buff) + tm_polygons() +
tm_shape(rnet_infra) +
  tm_lines(lwd = "bicycle_dutch", scale = 9)
