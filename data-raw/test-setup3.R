# Test set-up and R packages for estimating cycling potential

library(sf)
library(tidyverse)
library(stplanr)
library(pct)
library(tmap)

od_data = od_data = read.csv("https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/avon/od_attributes.csv")
nrow(od_data)
head(od_data)
od_data$pcycle = od_data$bicycle / od_data$all
plot(od_data$rf_dist_km, od_data$pcycle)
plot(od_data$rf_dist_km, od_data$pcycle, cex = od_data$all / 500)

# ggplot2
ggplot(od_data) +
  geom_point(aes(rf_dist_km, pcycle, size = all), alpha = 0.1) +
  geom_smooth(aes(rf_dist_km, pcycle))

centroids = get_pct_centroids(region = "avon", geography = "msoa")
plot(centroids)
unique(centroids$lad_name)
centroids_bristol = centroids %>%
  filter(lad_name == "Bristol, City of")
plot(centroids)
districts = get_pct_zones("avon", geography = "msoa")
districts_bristol = districts %>%
  filter(lad_name == "Bristol, City of")
districts_geo_centroid = sf::st_centroid(districts_bristol)
plot(districts_bristol$geometry)
plot(districts_geo_centroid$geometry, col = "red", add = TRUE)
plot(centroids_bristol$geometry, add = TRUE)

desire_lines = get_pct_lines(region = "avon", geography = "msoa")
desire_lines_bristol = desire_lines %>%
  filter(geo_code1 %in% centroids_bristol$geo_code) %>%
  filter(geo_code2 %in% centroids_bristol$geo_code)
plot(desire_lines_bristol)
nrow(desire_lines_bristol)

routes = get_pct_routes_fast(region = "avon", geography = "msoa")
routes_bristol = routes %>%
  filter(geo_code1 %in% centroids_bristol$geo_code) %>%
  filter(geo_code2 %in% centroids_bristol$geo_code)
mapview::mapview(routes_bristol)

rnet = overline(routes_bristol, "bicycle")
mapview::mapview(rnet)

routes$Potential = pct::uptake_pct_godutch(distance = routes$rf_dist_km, gradient = routes$rf_avslope_perc) *
  routes$all
rnet_potential = overline(routes, "Potential")
mean(rnet_potential$Potential)
