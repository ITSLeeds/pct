

library(pct)
library(tidyverse)

l = get_pct_lines("south-yorkshire")
l$pcycle = l$bicycle / l$all
plot(l$rf_dist_km, l$pcycle)
ggplot(l) + geom_point(aes(rf_dist_km, pcycle, alpha = all))
l$distance_groups = cut(l$rf_dist_km, breaks = seq(from = 0, to = 20, by = 1))
head(l$distance_groups)
l_grouped = l %>%
  sf::st_drop_geometry() %>%
  group_by(dist_band = as.character(distance_groups)) %>%
  summarise(
    distance = mean(rf_dist_km),
    all = sum(all), bicycle = sum(bicycle),
    hilliness = mean(l$rf_avslope_perc)
    )

ggplot(l_grouped) +
  geom_point(aes(distance, all)) +
  geom_point(aes(distance, bicycle))

l_grouped = l %>%
  sf::st_drop_geometry() %>%
  group_by(dist_band = as.character(distance_groups)) %>%
  summarise(
    distance = mean(rf_dist_km),
    pcycle = sum(bicycle)/ sum(all),
    hilliness = mean(l$rf_avslope_perc)
  )

ggplot(l_grouped) +
  geom_point(aes(distance, pcycle))

l_grouped$baseline = pct::uptake_pct_govtarget(
  distance = l_grouped$distance,
  gradient = rep(0, nrow(l_grouped))
  ) / 2

ggplot(l_grouped) +
  geom_point(aes(distance, baseline)) +
  geom_point(aes(distance, pcycle)) +
  ylim(c(0, 0.10))


l_grouped$logit_pcycle = boot::logit(l_grouped$pcycle)
ggplot(l_grouped) +
  geom_point(aes(distance, logit_pcycle))

m = lm(logit_pcycle ~ distance, hilliness, data = l_grouped)
ggplot(l_grouped) +
  geom_point(aes(distance, pcycle)) +
  geom_point(aes(distance, boot::inv.logit(m$fitted.values)), col = "grey")


# cid data ----------------------------------------------------------------

library(CycleInfraLnd)
points = get_cid_points(type = "traffic_calming")

