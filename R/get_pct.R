#' Generic function to get regional data from the PCT
#'
#' This function gets data generated for the Propensity to Cycle Tool
#' project and returns objects in the modern `sf` class.
#'
#' @param base_url Where the data is stored.
#' @param purpose Trip purpose (typically `school` or `commute`)
#' @param geography Geographic resolution of outputs (`msoa` or `lsoa`)
#' @param region The PCT region that contains the data (e.g. `west-yorkshire`)
#' @param layer The PCT layer of interest, `z`, `c`, `l`, `rf`, `rq` or `rnet`
#' for zones, centroids, desire lines, routes (fast or quiet) and route networks, respectively
#' @param extension The type of file to download (typically `.Rds`)
#' @export
#' @example
#' rf = get_pct(region = "isle-of-wight", layer = "rf")
#' plot(rf)
#' z = get_pct(region = "isle-of-wight", layer = "z")
#' # rf = get_pct(region = "west-yorkshire", layer = "rf")
get_pct = function(
  base_url = "https://github.com/npct/pct-outputs-regional-R/raw/master",
  purpose = "commute",
  geography = "msoa",
  region = NULL,
  layer = NULL,
  extension = ".Rds"
) {
  u_folder = paste(base_url, purpose, geography, region, sep = "/")
  f = paste0(layer, extension)
  u_file = paste(u_folder, f, sep = "/")
  destfile = file.path(tempdir(), f)
  utils::download.file(url = u_file, destfile = destfile)
  sf::st_as_sf(readRDS(destfile))
}
#' Get zone results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets zone data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' z = get_pct_zones("isle-of-wight")
#' plot(z)
get_pct_zones = function(
  region = NULL,
  base_url = "https://github.com/npct/pct-outputs-regional-R/raw/master",
  purpose = "commute",
  geography = "msoa",
  layer = "z",
  extension = ".Rds"
) {
  get_pct(base_url, purpose, geography, region, layer, extension)
}
