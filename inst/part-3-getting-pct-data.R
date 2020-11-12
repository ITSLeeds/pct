
# Intro script for Part 3 - Getting and visualising PCT data -----------------

# find names of pct regions
View(pct_regions_lookup)
pct_regions_lookup$region_name[pct_regions_lookup$lad16nm == "Leeds"]

# get pct data (travel to work; LSOA level)
region_name = "isle-of-wight"

iow_zones = get_pct_zones(region_name)
iow_centroids = get_pct_centroids(region_name)
iow_lines = get_pct_lines(region_name)
iow_routes_fast = get_pct_routes_fast(region_name)
iow_routes_quiet = get_pct_routes_quiet(region_name) # geometry only; cycling potential not available
iow_rnet = get_pct_rnet(region_name)

# get pct data at MSOA level
iow_zones_msoa = get_pct_zones(region_name, geography = "msoa")
iow_centroids_msoa = get_pct_centroids(region_name, geography = "msoa")
iow_routes_fast_msoa = get_pct_routes_fast(region_name, geography = "msoa")
iow_rnet_msoa = get_pct_rnet(region_name, geography = "msoa")

# get pct data for travel to schools
iow_zones_school = get_pct_zones(region_name, purpose = "school", geography = "lsoa")
iow_centroids_school_msoa = get_pct_centroids(region_name, purpose = "school", geography = "msoa")
iow_routes_fast_school = get_pct_routes_fast(region_name, purpose = "school")
iow_rnet_school = get_pct_rnet(region_name, purpose = "school")

# map route network with base-r
plot(iow_rnet)
plot(iow_zones$geometry)
plot(iow_rnet$geometry, col = "green", add = TRUE)

# map route network with mapview
library(mapview)

mapview(iow_rnet)
mapview(iow_rnet[, "bicycle"]) # with colour gradient and legend
mapview(iow_centroids) + mapview(iow_rnet[, "bicycle"])

# map route network with tmap
library(tmap)

tm_shape(iow_zones) +
  tm_polygons(col = "lightblue") +
  tm_shape(iow_rnet) +
  tm_lines(col = "bicycle", lwd = 2) +
  tm_basemap(server = "Esri.WorldTopoMap")

# compare top desire lines and routes with top route network segments
top_lines = top_n(iow_lines, 20, wt = bicycle)
top_routes_fast = top_n(iow_routes_fast, 20, wt = bicycle)
top_rnet_segments = top_n(iow_rnet, 100, wt = bicycle)

tm_shape(top_lines) +
  tm_lines(col = "bicycle", lwd = 2)

top_routes_fast = arrange(top_routes_fast, bicycle)
tm_shape(top_routes_fast) +
  tm_lines(col = "bicycle", lwd = 2)

tm_shape(top_rnet_segments) +
  tm_lines(col = "bicycle", lwd = 2)

# look at different PCT cycling uptake scenarios
tm_shape(iow_rnet) +
  tm_lines(col = "dutch_slc", lwd = 2)

tm_shape(iow_zones_msoa) +
  tm_polygons(col = "ebike_slc")

tm_shape(iow_rnet_school) +
  tm_lines(col = "cambridge_slc", lwd = 2)

# try out different colour palettes
install.packages("tmaptools") # in case the package is not already installed
tmaptools::palette_explorer()

tm_shape(top_rnet_segments) +
  tm_lines(col = "bicycle", lwd = 2, palette = "viridis")


# Exercises ---------------------------------------------------------------

# 1) Find the name of the PCT region for an area of your choice. Download the following data for that region and map them using either mapview or tmap
#      - MSOA zones
#      - MSOA fast routes (travel to work)
#      - MSOA route network (travel to work)

# 2) Identify the top 10 MSOA to MSOA routes in your region (according to 2011 cycling levels), and map them using tmap. What is the mean percentage increase in cycling on these routes, when comparing the Go Dutch scenario with 2011 cycling levels?

# 3) According to both 2011 cycling levels and the Go Dutch scenario, which zone has the largest number of cyclists? Which has the largest proportion of cyclists?

