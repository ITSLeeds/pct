library(pct)
library(stplanr)
library(dplyr)

key = Sys.getenv("CYCLESTREETS")
nchar(key)
desire_lines = desire_lines_leeds # pre-saved data in pct package
desire_lines

plot(desire_lines_leeds[c("all", "bicycle")])

routes_fast = route(l = desire_lines_leeds, route_fun = cyclestreets::journey)

plot(routes_fast) # shows segment level data
nrow(routes_fast)
length(unique(routes_fast$name)) # many overlapping segments
length(unique(routes_fast$distances)) # many overlapping segments, some duplication
length(unique(routes_fast$elevations)) # many overlapping segments, some duplication

routes_fast_grouped = routes_fast %>%
  group_by(area_of_residence, area_of_workplace) %>%
  summarise(
    distance = sum(distances),
    hilliness = sum(abs(diff(elevations))) / distance,
    all = unique(all),
    bicycle = unique(bicycle)
    )

plot(routes_fast_grouped$distance, routes_fast_grouped$hilliness)
plot(routes_fast_grouped[c("all", "bicycle")])
routes_fast_grouped$dutch_pct_proportion = uptake_pct_godutch(
  distance = routes_fast_grouped$distance,
  gradient = routes_fast_grouped$hilliness
)
routes_fast_grouped$dutch_pct_proportion
routes_fast_grouped$bicycle_go_dutch = routes_fast_grouped$dutch_pct_proportion *
  routes_fast_grouped$all + routes_fast_grouped$bicycle

routes_fast_grouped_linestring = sf::st_cast(routes_fast_grouped, "LINESTRING")
rnet_go_dutch = overline(routes_fast_grouped_linestring, attrib = "bicycle_go_dutch")
plot(rnet_go_dutch, breaks = c(0, 500, 1000, 4000))

# an alternative way to calculate the route network - not recommended:
routes_fast_joined = left_join(routes_fast, sf::st_drop_geometry(routes_fast_grouped))
routes_fast_aggregated = routes_fast_joined %>%
  group_by(name, distances, elevations) %>%
  summarise(bicycle_go_dutch2 = sum(bicycle_go_dutch))
plot(routes_fast_aggregated["bicycle_go_dutch2"], breaks = c(0, 500, 1000, 4000))
