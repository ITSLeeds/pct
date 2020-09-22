# Aim: test set-up for PCT training course

# test you can install packages
install.packages("remotes", quiet = TRUE)

# test you have the right packages installed
pkgs = c("sf", "stplanr", "pct", "tmap", "dplyr")
remotes::install_cran(pkgs, quiet = TRUE)

# test you can read-in csv files:
od_data = read.csv("https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/od_attributes.csv")
head(od_data)
od_data$pcycle = od_data$bicycle / od_data$all
plot(od_data$rf_dist_km, od_data$pcycle, cex = od_data$all / mean(od_data$all))

# test the sf package: read-in and download zones and centroids
library(sf)
u1 = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/c.geojson"
u1b = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/z.geojson"
centroids = read_sf(u1)
districts = read_sf(u1b)
plot(districts$geometry)
centroids_geo = st_centroid(districts)
plot(centroids$geometry, add = TRUE)
plot(centroids_geo$geometry, add = TRUE, col = "red")

# check interactive mapping with tmap
library(tmap)
tmap_mode("view")
u2 = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/l.geojson"
desire_lines = sf::read_sf(u2)
desire_lines_subset = desire_lines[desire_lines$all > 100, ]
tm_shape(desire_lines_subset) +
  tm_lines(col = "bicycle", palette = "viridis", lwd = "all", scale = 9)

# check route network generation with stplanr
library(stplanr)
u3 = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/rf.geojson"
routes = sf::read_sf(u3)
library(dplyr)
routes_1 = routes %>%
  slice(which.max(bicycle))
tm_shape(routes_1) +
  tm_lines()
rnet = overline(routes, "bicycle")
b = c(0, 0.5, 1, 2, 3, 8) * 1e3
tm_shape(rnet) +
  tm_lines(scale = 2, col = "bicycle", palette = "viridis", breaks = b)

# check analysis with dplyr and estimation of cycling uptake with pct function
library(pct)

routes$Potential = pct::uptake_pct_godutch(
  distance = routes$rf_dist_km,
  gradient = routes$rf_avslope_perc
) *
  routes$all
rnet_potential = overline(routes, "Potential")
tm_shape(rnet_potential) +
  tm_lines(lwd = "Potential", scale = 9, col = "Potential", palette = "viridis", breaks = b)

# Uncomment this line to get the mean cycling potential of route segments in Bristol
# mean(rnet_potential$Potential)

# generate output report
# knitr::spin(hair = "code/reproducible-example.R")

# # to convert OD data into desire lines with the od package you can uncomment the following lines
# # system.time({
# test_desire_lines1 = stplanr::od2line(od_data, centroids)
# # })
# # system.time({
# test_desire_lines2 = od::od_to_sf(x = od_data, z = centroids)
# # })
# plot(test_desire_lines2)

# test routing on a single line (optional - uncomment to test this)
# warning you can only get a small number, e.g. 5, routes before this stops working!
# library(osrm)
# single_route = route(l = desire_lines[1, ], route_fun = osrm::osrmRoute, returnclass = "sf")
# mapview::mapview(desire_lines[1, ]) +
#   mapview::mapview(single_route)
# see https://cran.r-project.org/package=cyclestreets and other routing services
# for other route options, e.g. https://github.com/ropensci/opentripplanner
