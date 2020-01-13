#' Download MSOA centroids for England and Wales
#'
#' Downloads and processes data on where people live in England and Wales.
#' See [geoportal.statistics.gov.uk](http://geoportal.statistics.gov.uk/datasets/b0a6d8a3dc5d4718b3fd62c548d60f81_0).
#'
#' @export
#' @examples
#' pwc = get_centroids_ew()
#' plot(pwc[sample(nrow(pwc), 1000), ])
get_centroids_ew = function() {
  # vanished dataset
  # u = paste0("https://opendata.arcgis.com/datasets/b0a6d8a3dc5d4718b3fd62c548d60f81_0.csv?",
  # "outSR=%7B%22latestWkid%22%3A27700%2C%22wkid%22%3A27700%7D")
  u = "https://github.com/ITSLeeds/pct/releases/download/0.2.5/MSOA_2011_EW_PWC_COORD_V2.CSV"
  # suggestion: store locally if API changes again?
  # f = "centroids-msoa.csv" # store locally
  # download.file(u, f)
  # pwc = readr::read_csv(f)
  pwc = readr::read_csv(u)
  names(pwc) = c("msoa11cd", "msoa11nm", "X", "Y", "lon", "lat")
  sf::st_as_sf(x = pwc[c("X", "Y", "msoa11cd", "msoa11nm")],
               coords = c("X", "Y"), crs = 27700)
}

# Note: this is an attempt to get the LSOA data:
# https://data.cdrc.ac.uk/dataset/cdrc-2011-population-weighted-centroids-gb
# u = "https://data.cdrc.ac.uk/dataset/e95b3bef-11c6-4d1e-bd72-a3315e6c398d/resource/90de9c16-f064-4a11-ada1-ab1ab1b5a323/download/englandwelshscotlandpwc2011.csv"
# pwc = readr::read_csv(u)
