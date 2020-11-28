# Aim: explore PCT data for isle of wight

# load packages
library(pct)
library(tidyverse)
library(tmap)

region_name = "isle-of-wight"
# other regions are possible

zones_all = get_pct_zones(region = region_name, geography = "msoa")
lines_all = get_pct_lines(region = region_name, geography = "msoa")
routes_all = get_pct_routes_fast(region = region_name, geography = "msoa")
routes_all_quiet = get_pct_routes_quiet(region = region_name, geography = "msoa")
rnet_all = get_pct_rnet(region = region_name, geography = "msoa")

plot(zones_all$all, zones_all$bicycle)
plot(zones_all$geometry)
plot(lines_all$geometry, col = "blue", add = TRUE)
plot(routes_all$geometry, col = "red", add = TRUE)
lwd = rnet_all$bicycle / 10
plot(rnet_all$geometry, col = "green", add = TRUE, lwd = lwd)

tmap_mode("plot")
tm_shape(rnet_all) +
  tm_lines(lwd = "bicycle", scale = 9)
tmap_mode("view")
tm_shape(rnet_all) +
  tm_lines(lwd = "bicycle", scale = 9)
names(rnet_all)
tm_shape(rnet_all) +
  tm_lines(lwd = "dutch_slc", scale = 9) +
  tm_shape(zones_all) +
  tm_borders()

l_msoa = lines_all
nrow(routes_all)
nrow(lines_all)

routes_all$potential = uptake_pct_godutch_2020(
  distance = l_msoa$rf_dist_km,
  gradient = l_msoa$rf_avslope_perc
) * l_msoa$all + l_msoa$bicycle

plot(routes_all %>% select(potential))
rnet_new = overline(routes_all, attrib = "potential")
plot(rnet_new)
tm_shape(rnet_new) +
  tm_lines(lwd = "potential", scale = 9)
