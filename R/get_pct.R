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
  if(length(region) != 1L || length(layer) != 1L)
    stop("'region' and 'layer' must be of length 1")
  if(is.na(region) || (region == "") || !is.character(region) ||
     is.na(layer) || (layer == "") || !is.character(layer))
    stop("invalid region or layer name")
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
  purpose = "commute",
  geography = "msoa",
  extension = ".Rds"
) {
  get_pct(base_url =
            "https://github.com/npct/pct-outputs-regional-R/raw/master",
          purpose, geography, region,
          layer = "c",
          extension = ".Rds")
}

#' Get centroid results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets centroid data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' z = get_pct_centroids("isle-of-wight")
#' plot(z)
get_pct_centroids = function(
  region = NULL,
  purpose = "commute",
  geography = "msoa",
  extension = ".Rds"
) {
  get_pct(base_url =
            "https://github.com/npct/pct-outputs-regional-R/raw/master",
          purpose, geography, region,
          layer = "z",
          extension = ".Rds")
}

#' Get desire lines results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets l (lines) data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' z =  get_pct_lines("isle-of-wight")
#' plot(z)
get_pct_lines = function(
  region = NULL,
  purpose = "commute",
  geography = "msoa",
  extension = ".Rds"
) {
  get_pct(base_url =
            "https://github.com/npct/pct-outputs-regional-R/raw/master",
          purpose, geography, region,
          layer = "l",
          extension = ".Rds")
}

#' Get fast road network results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets rf data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' z = get_pct_routes_fast("isle-of-wight")
#' plot(z)
get_pct_routes_fast = function(
  region = NULL,
  purpose = "commute",
  geography = "msoa",
  extension = ".Rds"
) {
  get_pct(base_url =
            "https://github.com/npct/pct-outputs-regional-R/raw/master",
          purpose, geography, region,
          layer = "rf",
          extension = ".Rds")
}

#' Get quiet road network results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets rq data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' z =  get_pct_routes_quiet("isle-of-wight")
#' plot(z)
get_pct_routes_quiet = function(
  region = NULL,
  purpose = "commute",
  geography = "msoa",
  extension = ".Rds"
) {
  get_pct(base_url =
            "https://github.com/npct/pct-outputs-regional-R/raw/master",
          purpose, geography, region,
          layer = "rq",
          extension = ".Rds")
}

#' Get road network results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets centroid data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' z =  get_pct_rnet("isle-of-wight")
#' plot(z)
get_pct_rnet = function(
  region = NULL,
  purpose = "commute",
  geography = "msoa",
  extension = ".Rds"
) {
  get_pct(base_url =
            "https://github.com/npct/pct-outputs-regional-R/raw/master",
          purpose, geography, region,
          layer = "rnet",
          extension = ".Rds")
}
