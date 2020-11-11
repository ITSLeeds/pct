
# Intro script for Part 3 - Getting and visualising PCT data -----------------

# find names of pct regions
View(pct_regions_lookup)
pct_regions_lookup$region_name[pct_regions_lookup$lad16nm == "Leeds"]

# get pct data
region_name = "isle-of-wight"

iow_zones = get_pct_zones(region_name)
iow_centroids = get_pct_centroids(region_name)
iow_lines = get_pct_lines(region_name)
iow_routes_fast = get_pct_routes_fast(region_name)
iow_routes_quiet = get_pct_routes_quiet(region_name) # geometry only; cycling potential not available
iow_rnet = get_pct_rnet(region_name)

# map route network with base-r
plot(iow_rnet)
plot(iow_rnet["bicycle"], lwd = 2)
plot(iow_zones["bicycle"])

# map route network with mapview
library(mapview)

mapview(iow_rnet)
mapview(iow_rnet["bicycle"]) # with colour gradient and legend
mapview(iow_centroids) + mapview(iow_rnet["bicycle"])

# map route network with tmap
library(tmap)

tm_shape(iow_zones) +
  tm_polygons(col = "lightblue") +
  tm_shape(iow_rnet) +
  tm_lines(col = "bicycle", lwd = 2) +
  tm_basemap(server = "Esri.WorldTopoMap")

# compare top individual routes with top route network segments
top_routes_fast = top_n(iow_routes_fast, 20, wt = bicycle)
top_rnet_segments = top_n(iow_rnet, 100, wt = bicycle)

tm_shape(top_routes_fast) +
  tm_lines(col = "bicycle", lwd = 2)

tm_shape(top_rnet_segments) +
  tm_lines(col = "bicycle", lwd = 2)

# try out different colour palettes
tmaptools::palette_explorer()

tm_shape(top_rnet_segments) +
  tm_lines(col = "bicycle", lwd = 2, palette = "viridis")
