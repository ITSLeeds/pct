# Aim: get data on cycling potential in the Isle of Wight

library(sf)
library(pct)
library(tidyverse)

z = get_pct_zones("isle-of-wight", geography = "lsoa")
plot(z)
lines_all = get_pct_lines("isle-of-wight", geography = "lsoa")
lines_active = lines_all %>%
  filter(rf_dist_km <= 5) %>%
  mutate(`Percent Active` = (bicycle + foot) / all * 100)

library(tmap)
tm_shape(lines_active) +
  tm_lines("Percent Active", palette = "RdYlBu")
