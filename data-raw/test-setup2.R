# Aim: test set-up for PCT training course
# A version that provides more explanation and analysis

# test you can install packages
install.packages("remotes", quiet = TRUE)

# test you have the right packages installed
pkgs = c("sf", "stplanr", "pct", "tmap", "dplyr")
remotes::install_cran(pkgs, quiet = TRUE)

# load packages
library(sf)
library(tidyverse)
library(pct)
library(tmap)
tmap_mode("view")

# test you can read-in csv files:
od_data = read.csv("https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/od_attributes.csv")

od_data$pcycle = od_data$bicycle / od_data$all
# plot(od_data$rf_dist_km, od_data$pcycle, cex = od_data$all / mean(od_data$all))
ggplot(data = od_data) +
  geom_point(aes(x = rf_dist_km, y = pcycle, size = all), alpha = 0.1) +
  geom_smooth(aes(x = rf_dist_km, y = pcycle, size = all)) +
  ylim(c(0, 0.5))

# u1 = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/c.geojson"
# u1b = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/z.geojson"
# centroids = read_sf(u1)
# districts = read_sf(u1b)
centroids = get_pct_centroids(region = "avon", geography = "msoa")
districts = get_pct_zones(region = "avon", geography = "msoa")
plot(districts$geometry)
centroids_geo = st_centroid(districts)
plot(centroids$geometry, add = TRUE)
plot(centroids_geo$geometry, add = TRUE, col = "red")

# check interactive mapping with tmap
u2 = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/l.geojson"
desire_lines = sf::read_sf(u2)
desire_lines_subset = desire_lines[desire_lines$all > 100, ]
tm_shape(desire_lines_subset) +
  tm_lines(col = "bicycle", palette = "viridis", lwd = "all", scale = 9)

# check route network generation with stplanr
# u3 = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/rf.geojson"
# routes = sf::read_sf(u3)
routes = get_pct_routes_fast(region = "avon", geography = "msoa")
routes_1 = routes %>%
  slice(which.max(bicycle))
tm_shape(routes_1) +
  tm_lines()
routes_30 = routes %>%
  top_n(n = 30, wt = bicycle)

tm_shape(routes_30) +
  tm_lines()

rnet = overline(routes_30, "bicycle")
b = c(0, 0.5, 1, 2, 3, 8) * 1e3
tm_shape(rnet) +
  tm_lines(scale = 2, col = "bicycle", palette = "viridis", breaks = b)

routes$Potential = pct::uptake_pct_godutch_2020(
  distance = routes$rf_dist_km,
  gradient = routes$rf_avslope_perc
) *
  routes$all +
  routes$bicycle

rnet_potential = overline(routes, "Potential")
tm_shape(rnet_potential) +
  tm_lines(lwd = "Potential", scale = 9, col = "Potential", palette = "viridis", breaks = b)

summary(routes$rf_dist_km)

ggplot(routes) +
  stat_ecdf(aes(rf_dist_km), geom = "step")

# Uncomment this line to get the mean cycling potential of route segments in Bristol
# round(mean(rnet_potential$Potential))

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

# head(od_data_pct[1:12])
# od_data_raw = get_od(region = "avon")
# nrow(od_data_raw)
# nrow(od_data_pct)
# summary(od_data$all)
# summary(od_data_pct$all)
#
# od_data = od_data_raw %>%
#   filter(all > 20)
#
# nrow(od_data)
# head(od_data)

# ggplot(routes) +
#   geom_point(aes(dutch_slc, Potential))
# cor(routes$dutch_slc, routes$Potential)^2
