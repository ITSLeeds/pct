
# Download and map data from Rapid Cycleway Prioritisation Tool -----------

# select URLS
west_of_england_existing_url = "https://www.cyipt.bike/rapid/west-of-england/cycleways.geojson"
west_of_england_cohesive_url = "https://www.cyipt.bike/rapid/west-of-england/cohesive_network.geojson"
west_of_england_top_url = "https://www.cyipt.bike/rapid/west-of-england/top_routes.geojson"
west_of_england_spare_url = "https://www.cyipt.bike/rapid/west-of-england/spare_lanes.geojson"
west_of_england_wide_url = "https://www.cyipt.bike/rapid/west-of-england/wide_lanes.geojson"
north_somerset_top_url = "https://www.cyipt.bike/rapid/north-somerset/top_routes.geojson"

rapid_urls = c(west_of_england_existing_url, west_of_england_cohesive_url, west_of_england_top_url, west_of_england_spare_url, west_of_england_wide_url, north_somerset_top_url)

# create new directory
dir.create("data/rapid-data")

# assign file names and paths
rapid_file_names = file.path("data/rapid-data", paste(substring(dirname(rapid_urls),30), basename(rapid_urls), sep = "_"))

# download files
download.file(url = rapid_urls, destfile = rapid_file_names)

# read one file at a time
library(sf)
west_of_england_cycleways = read_sf("data/rapid-data/west-of-england_cycleways.geojson")
west_of_england_cohesive_network = read_sf("data/rapid-data/west-of-england_cohesive_network.geojson")

# read all files in directory
library(sf)
library(stringr)

file_path = "data/rapid-data/"
files_wanted = list.files(file_path)

files_wanted %>%
  purrr::map(function(file_name){
    assign(x = gsub("-", "_", str_remove(file_name, ".geojson")),
           value = read_sf(paste0(file_path, file_name)),
           envir = .GlobalEnv)
  })

# set up basemaps
s = c(
  `Grey basemap` = "CartoDB.Positron",
  `Coloured basemap` = "Esri.WorldTopoMap",
  `OSM existing cycle provision (CyclOSM)` = "https://b.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png",
  `PCT commuting, Government Target` = "https://npttile.vs.mythic-beasts.com/commute/v2/govtarget/{z}/{x}/{y}.png",
  `PCT schools, Government Target` = "https://npttile.vs.mythic-beasts.com/school/v2/govtarget/{z}/{x}/{y}.png",
  `Satellite image` = "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'"
)
tms = c(FALSE, FALSE, FALSE, TRUE, TRUE, FALSE)
# Find other basemaps at https://leaflet-extras.github.io/leaflet-providers/preview/

# create map
library(tmap)
tmap_mode("view")

tm_shape(west_of_england_cohesive_network) +
  tm_lines(col = "#9077AD", lwd = 5) +
  tm_shape(west_of_england_spare_lanes) +
  tm_lines(col = "#B91F48", lwd = 3) +
  tm_shape(west_of_england_wide_lanes) +
  tm_lines(col = "#FF7F00", lwd = 3) +
  tm_shape(west_of_england_top_routes) +
  tm_lines(col = "blue", lwd = 3) +
  tm_shape(west_of_england_cycleways) +
  tm_lines(col = "darkgreen", lwd = 1.3) +
  tm_basemap(server = s, tms = tms)

