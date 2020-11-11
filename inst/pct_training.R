## ---- eval=FALSE, echo=FALSE----------------------------------------------------------
#> header-includes:
#> - \usepackage{fancyhdr}
#> - \pagestyle{fancy}
#> - \fancyhead[CO,CE]{Propensity to Cycle Tool Training Course}
#> - \fancyfoot[CO,CE]{For source code and support see github.com/ITSLeeds and github.com/npct}
#> - \fancyfoot[LE,RO]{\thepage}
#> output: pdf_document


## ---- include = FALSE-----------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  out.width = "50%"
)


## ---- eval=FALSE, echo=FALSE----------------------------------------------------------
#> # get citations
#> refs = RefManageR::ReadZotero(group = "418217", .params = list(collection = "JFR868KJ", limit = 100))
#> refs2 = RefManageR::ReadBib("vignettes/refs.bib")
#> refs = c(refs, refs2)
#> refs_df = as.data.frame(refs)
#> # View(refs_df)
#> # citr::insert_citation(bib_file = "vignettes/refs_training.bib")
#> RefManageR::WriteBib(refs, "vignettes/refs_training.bib")
#> # citr::tidy_bib_file(rmd_file = "vignettes/pct_training.Rmd", messy_bibliography = "vignettes/refs_training.bib")


## ---- eval=FALSE----------------------------------------------------------------------
#> install.packages("remotes")
#> pkgs = c(
#>   "cyclestreets",
#>   "mapview",
#>   "pct",
#>   "sf",
#>   "stats19",
#>   "stplanr",
#>   "tidyverse",
#>   "devtools"
#> )
#> remotes::install_cran(pkgs)
#> # remotes::install_github("ITSLeeds/pct")


## ----testcode, eval = FALSE-----------------------------------------------------------
#> source("https://raw.githubusercontent.com/ITSLeeds/TDS/master/code-r/setup.R")


## ----setup, out.width="30%", message=FALSE--------------------------------------------
library(pct)
library(dplyr)   # in the tidyverse
library(tmap) # installed alongside mapview
region_name = "isle-of-wight"
max_distance = 7
zones_all = get_pct_zones(region_name)
lines_all = get_pct_lines(region_name)
# basic plot
plot(zones_all$geometry)
plot(lines_all$geometry[lines_all$all > 500], col = "red", add = TRUE)

# create 'active' desire lines (less than 5 km)
active = lines_all %>% 
  mutate(`Percent Active` = (bicycle + foot) / all * 100) %>% 
  filter(e_dist_km < max_distance)

# interactive plot
tmap_mode("view")
tm_shape(active) +
  tm_lines("Percent Active", palette = "RdYlBu", lwd = "all", scale = 9)


## ---- echo=FALSE, eval=FALSE----------------------------------------------------------
#> # old code - create with leaflet
#> pal = colorBin(palette = "RdYlBu", domain = active$`Percent Active`, bins = c(0, 2, 4, 10, 15, 20, 30, 40, 90))
#> leaflet(data = active) %>%
#>   addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
#>   addPolylines(color = ~pal(`Percent Active`), weight = active$all / 100) %>%
#>   addLegend(pal = pal, values = ~`Percent Active`)
#> 
#> pal = colorBin(palette = "RdYlBu", domain = car_dependent$`Percent Active`, bins = c(0, 20, 40, 60, 80, 100), reverse = TRUE)
#> leaflet(data = car_dependent) %>%
#>   addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
#>   addPolylines(color = ~pal(`Percent Drive`), weight = active$all / 100) %>%
#>   addLegend(pal = pal, values = ~`Percent Drive`)


## ---- out.width="30%"-----------------------------------------------------------------
# Create car dependent desire lines
car_dependent = lines_all %>% 
  mutate(`Percent Drive` = (car_driver) / all * 100) %>% 
  filter(e_dist_km < max_distance)
tm_shape(car_dependent) +
  tm_lines("Percent Drive", palette = "-RdYlBu", lwd = "all", scale = 9)


## ---- echo=FALSE, out.width="90%"-----------------------------------------------------
# u = "https://raw.githubusercontent.com/npct/pct-team/master/flow-model/flow-diag2.png"
# f = "vignettes/flow-diag2.png"
# download.file(u, f)
# knitr::include_graphics("flow-diag2.png")
knitr::include_graphics("https://raw.githubusercontent.com/npct/pct-team/master/flow-model/flow-diag2.png")


## -------------------------------------------------------------------------------------
library(pct)
library(dplyr) # suggestion: use library(tidyverse)
z_original = get_pct_zones("isle-of-wight")
z = z_original %>% 
  select(geo_code, geo_name, all, foot, bicycle, car_driver)


## ---- echo=FALSE----------------------------------------------------------------------
# the solution:
# View(z)
z_highest_cycling = z %>% 
  top_n(n = 1, wt = bicycle)


## ---- echo=FALSE----------------------------------------------------------------------
plot(z$geometry)
plot(z_highest_cycling$geometry, col = "red", add = TRUE)


## ----get routes-----------------------------------------------------------------------
# Aim: get top 5 cycle routes
l_original_msoa = get_pct_lines("isle-of-wight", geography = "msoa")
l_msoa = l_original_msoa %>% 
  select(geo_code1, geo_code2, all, foot, bicycle, car_driver, rf_avslope_perc, rf_dist_km)


## ---- echo=FALSE, warning=FALSE, fig.show='hold', fig.cap="Top 5 MSOA to MSOA desire lines with highest number of people cycling (left) and driving (right) in the Isle of Wight."----
# View(l)
l = l_msoa
l_top_cycling = l %>% 
  top_n(n = 5, wt = bicycle)
plot(z$geometry)
plot(st_geometry(l_top_cycling), add = TRUE, lwd = 5, col = "green")
 
# top 5 driving routes
l_top_driving = l %>% 
  top_n(n = 5, wt = car_driver)
plot(z$geometry)
plot(st_geometry(l_top_driving), add = TRUE, lwd = 5, col = "red")

# summary(sf::st_length(l_top_cycling))
# summary(sf::st_length(l_top_driving))

# library(tmap)
# tmap_mode("view")
# tm_shape(l_top_cycling) + tm_lines("green", lwd = 7) + tm_basemap(server = leaflet::providers$OpenStreetMap.BlackAndWhite)
# tm_shape(l_top_driving) + tm_lines("red", lwd = 7) + tm_basemap(server = leaflet::providers$OpenStreetMap.BlackAndWhite)


## ---- echo=FALSE, warning=FALSE, fig.show='hold', fig.cap="Top 10 LSOA-LSOA desire lines with highest number of people cycling (left) and driving (right) in the Isle of Wight."----
# at the lsoa level
l_original_lsoa = get_pct_lines("isle-of-wight", geography = "lsoa")
l_lsoa = l_original_lsoa %>% 
  select(geo_code1, geo_code2, all, bicycle, car_driver, rf_avslope_perc, rf_dist_km)
l_top_cycling = l_lsoa %>% 
  top_n(n = 10, wt = bicycle)
l_top_driving = l_lsoa %>% 
  top_n(n = 10, wt = car_driver)

plot(z$geometry)
plot(st_geometry(l_top_cycling), add = TRUE, lwd = 5, col = "green")
plot(z$geometry)
plot(st_geometry(l_top_driving), add = TRUE, lwd = 5, col = "red")


## ---- echo=FALSE, warning=FALSE, fig.show='hold', fig.cap="Top 300 LSOA-LSOA desire lines with highest number of people cycling (left) and driving (right) in the Isle of Wight.", eval=FALSE----
#> # at the lsoa level
#> l_top_cycling = l %>%
#>   top_n(n = 300, wt = bicycle)
#> plot(z$geometry)
#> plot(st_geometry(l_top_driving), add = TRUE, lwd = l_top_cycling$bicycle / mean(l_top_cycling$bicycle), col = "green")
#> 
#> # top 5 driving routes
#> l_top_driving = l %>%
#>   top_n(n = 300, wt = car_driver)
#> plot(z$geometry)
#> plot(st_geometry(l_top_driving), add = TRUE, lwd = l_top_driving$car_driver / mean(l_top_driving$car_driver), col = "red")


## ----p2-------------------------------------------------------------------------------
l_msoa$pcycle = l_msoa$bicycle / l_msoa$all * 100
# plot(l_msoa["pcycle"], lwd = l_msoa$all / mean(l_msoa$all), breaks = c(0, 5, 10, 20, 50))


## ----eval=FALSE, echo=FALSE-----------------------------------------------------------
#> rnet = get_pct_rnet("isle-of-wight")


## ---- echo=FALSE----------------------------------------------------------------------
l_less_than_10km = l %>% 
  filter(rf_dist_km < 10)
sum(l_less_than_10km$all) / sum(l$all)


## ---- fig.show='hold', out.width="33%"------------------------------------------------
plot(l_less_than_10km %>% filter(foot > 5) %>% select(foot))
plot(l_less_than_10km %>% filter(bicycle > 5) %>% select(bicycle))
plot(l_less_than_10km %>% filter(car_driver > 5) %>% select(car_driver))


## -------------------------------------------------------------------------------------
l_msoa$euclidean_distance = as.numeric(sf::st_length(l_msoa))
l_msoa$pcycle_govtarget = uptake_pct_govtarget_2020(
  distance = l_msoa$rf_dist_km,
  gradient = l_msoa$rf_avslope_perc
  ) * 100 + l_msoa$pcycle


## ----change, echo=FALSE---------------------------------------------------------------
l_msoa$pcycle_dutch = uptake_pct_godutch_2020(
  distance = l_msoa$rf_dist_km,
  gradient = l_msoa$rf_avslope_perc
  ) * 100 + l_msoa$pcycle


## ----dutch_pcycle, echo=FALSE, warning=FALSE, fig.show='hold', fig.cap="Percent cycling currently (left) and under a 'Go Dutch' scenario (right) in the Isle of Wight."----
plot(l_msoa["pcycle"], lwd = l_msoa$all / mean(l_msoa$all), breaks = c(0, 5, 10, 20, 50))
plot(l_msoa["pcycle_dutch"], lwd = l_msoa$all / mean(l_msoa$all), breaks = c(0, 5, 10, 20, 50))
# cor(l_original_msoa$dutch_slc / l_original_msoa$all, l_msoa$pcycle_dutch)
# cor(l_original_msoa$govtarget_slc / l_original_msoa$all, l_msoa$pcycle_govtarget)
# plot(l_original_msoa$dutch_slc / l_original_msoa$all, l_msoa$pcycle_dutch)


## -------------------------------------------------------------------------------------
l_top = l_msoa %>% 
  top_n(n = 1, wt = bicycle)


## ---- eval=FALSE, echo=FALSE----------------------------------------------------------
#> library(osrm)
#> r_top = route(l = l_top, route_fun = osrmRoute, returnclass = "sf")
#> # r_top = route(l = l_top, route_fun = cyclestreets::journey)
#> mapview::mapview(r_top)
#> sf::write_sf(r_top, "r_top.geojson")
#> piggyback::pb_upload("r_top.geojson")
#> piggyback::pb_download_url("r_top.geojson")


## ---- echo=FALSE----------------------------------------------------------------------
r_top = sf::read_sf("https://github.com/ITSLeeds/pct/releases/download/0.0.1/r_top.geojson")
tm_shape(r_top) +
  tm_lines(lwd = 5)


## ---- echo=FALSE, eval=FALSE----------------------------------------------------------
#> r_cs = route(l = l_top, route_fun = cyclestreets::journey)
#> library(leaflet)
#> leaflet() %>%
#>   addTiles() %>%
#>   addPolylines(data = r_cs)


## -------------------------------------------------------------------------------------
route_data = sf::st_sf(wight_lines_30, geometry = wight_routes_30$geometry)


## ---- echo=FALSE, message=FALSE-------------------------------------------------------
rnet_walk = overline(route_data, attrib = "foot")
tm_shape(rnet_walk) +
  tm_lines(lwd = "foot", scale = 9)


## ---- eval=FALSE, echo=FALSE----------------------------------------------------------
#> rnet_school = get_pct_rnet(region = "isle-of-wight", purpose = "school")
#> plot(rnet_school)


## ---- echo=FALSE, eval=FALSE----------------------------------------------------------
#> # Demo PCT Analysis#
#> # Make a commuting quiet route network for Isle of Wight
#> # and combine it with the travel to school route network
#> 
#> # Step 1: Load Library
#> library(tidyverse)
#> library(sf)
#> library(pct)
#> library(stplanr)
#> 
#> # Step 2: Get Data
#> routes_commute = get_pct_routes_quiet(region = "isle-of-wight",
#>                               purpose = "commute",
#>                               geography = "lsoa")
#> 
#> lines_commute = get_pct_lines(region = "isle-of-wight",
#>                               purpose = "commute",
#>                               geography = "lsoa")
#> 
#> rnet_school = get_pct_rnet(region = "isle-of-wight",
#>                            purpose = "school",
#>                            geography = "lsoa")
#> 
#> # Step 3: Prepare Data
#> lines_commute = lines_commute %>%
#>   st_drop_geometry() %>%
#>   select(id, bicycle, dutch_slc)
#> 
#> routes_commute = routes_commute %>%
#>   select(id)
#> 
#> # Join Cycling Levels to Routes
#> routes_commute = left_join(routes_commute, lines_commute)
#> plot(routes_commute["bicycle"])
#> 
#> # Make a commuting Rnet
#> rnet_commute = overline2(routes_commute,
#>                          attrib = c("bicycle","dutch_slc"))
#> plot(rnet_commute["bicycle"])
#> 
#> # Combine commuting and travel to schools
#> rnet_school = rnet_school %>%
#>   select(dutch_slc)
#> rnet_commute = rnet_commute %>%
#>   select(dutch_slc)
#> rnet_commute$bicycle = NULL
#> 
#> 
#> rnet_both = rbind(rnet_commute, rnet_school)
#> rnet_both = overline2(rnet_both,
#>                          attrib = c("dutch_slc"))
#> mapview::mapview(rnet_both, at = c(50,100,200,500,1000))
#> 

