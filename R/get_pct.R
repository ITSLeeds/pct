#' Generic function to get regional data from the PCT
#'
#' This function gets data generated for the Propensity to Cycle Tool
#' project and returns objects in the modern `sf` class.
#'
#' @param base_url Where the data is stored.
#' @param purpose Trip purpose (typically `school` or `commute`)
#' @param geography Geographic resolution of outputs, `msoa` or `lsoa` (the default)
#' @param region The PCT region or local authority to download data from (e.g. `west-yorkshire` or `Leeds`).
#' See `View(pct_regions_lookup)` for a full list of possible region names.
#' @param layer The PCT layer of interest, `z`, `c`, `l`, `rf`, `rq` or `rnet`
#' for zones, centroids, desire lines, routes (fast or quiet) and route networks, respectively
#' @param extension The type of file to download (only `.geojson` supported at present)
#' @param national Download nationwide data? `FALSE` by default
#' @export
#' @examples
#' \dontrun{
#' rf = get_pct(region = "isle-of-wight", layer = "rf")
#' names(rf)[1:20]
#' vars_to_plot = 10:13
#' plot(rf[vars_to_plot])
#' z = get_pct(region = "isle-of-wight", layer = "z")
#' rf = get_pct(region = "west-yorkshire", layer = "rf")
#' z_all = get_pct(layer = "z", national = TRUE)
#' }
get_pct = function(
  base_url = "https://github.com/npct/pct-outputs-regional-notR/raw/master",
  purpose = "commute",
  geography = "lsoa",
  region = NULL,
  layer = NULL,
  extension = ".geojson",
  national = FALSE
) {
  layers = c("z", "c", "l", "rf", "rq", "rnet")
  if(is.null(layer) || !is.element(layer, layers))
    stop(c("Layer needs to be one of: ",
         paste0(layers, collapse = ", "), "."))
  if(national & is.character(purpose)) {
    extension = ".Rds"
    layer = paste0(layer, "_all")
    base_url = "https://github.com/npct/pct-outputs-national/raw/master"
    u_folder = paste(base_url, purpose, geography, sep = "/")
    f = paste0(layer, extension)
    u_file = paste(u_folder, f, sep = "/")
    read_url = function(u) readRDS(url(u))
    res_sp = read_pct(u_file, read_url)
    return(sf_object = sf::st_as_sf(res_sp))
  } else {
    if(length(region) != 1L)
      stop("'region' must be of length 1")
    if(is.na(region) || (region == "") || !is.character(region))
      stop("invalid region name")
    if(geography == "msoa" && layer == "rnet") {
      message("No MSOA route network data available, downloading LSOA data")
      geography = "lsoa"
    }
    if(layer == "rnet") {
      layer = "rnet_full"
    }
    u_folder = paste(base_url, purpose, geography, region, sep = "/")
    f = paste0(layer, extension)
    u_file = paste(u_folder, f, sep = "/")
  }
  read_pct(u_file, fun = sf::read_sf)
}
#' Get zone results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets zone data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' \dontrun{
#' # don't test to reduce build times
#' z = get_pct_zones("isle-of-wight")
#' plot(z)
#' }
get_pct_zones = function(
  region = NULL,
  purpose = "commute",
  geography = "lsoa",
  extension = ".geojson"
) {
  get_pct(base_url = "https://github.com/npct/pct-outputs-regional-notR/raw/master",
          purpose, geography, region,
          layer = "z",
          extension = ".geojson")
}

#' Get centroid results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets centroid data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' \dontrun{
#' # don't test to reduce build times
#' c = get_pct_centroids("isle-of-wight")
#' plot(c)
#' }
get_pct_centroids = function(
  region = NULL,
  purpose = "commute",
  geography = "lsoa",
  extension = ".geojson"
) {
  get_pct(base_url =
            "https://github.com/npct/pct-outputs-regional-notR/raw/master",
          purpose, geography, region,
          layer = "c",
          extension = ".geojson")
}

#' Get desire lines results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets l (lines) data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' \dontrun{
#' # don't test to reduce build times
#' l = get_pct_lines("isle-of-wight")
#' plot(l)
#' }
get_pct_lines = function(
  region = NULL,
  purpose = "commute",
  geography = "lsoa",
  extension = ".geojson"
) {
  get_pct(base_url =
            "https://github.com/npct/pct-outputs-regional-notR/raw/master",
          purpose, geography, region,
          layer = "l",
          extension = ".geojson")
}

#' Get fast road network results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets rf data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' \dontrun{
#' # don't test to reduce build times
#' rf = get_pct_routes_fast("isle-of-wight")
#' plot(rf)
#' }
get_pct_routes_fast = function(
  region = NULL,
  purpose = "commute",
  geography = "lsoa",
  extension = ".geojson"
) {
  get_pct(base_url =
            "https://github.com/npct/pct-outputs-regional-notR/raw/master",
          purpose, geography, region,
          layer = "rf",
          extension = ".geojson")
}

#' Get quiet road network results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets rq data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' \dontrun{
#' # don't test to reduce build times
#' rq =  get_pct_routes_quiet("isle-of-wight")
#' plot(rq)
#' }
get_pct_routes_quiet = function(
  region = NULL,
  purpose = "commute",
  geography = "lsoa",
  extension = ".geojson"
) {
  get_pct(base_url =
            "https://github.com/npct/pct-outputs-regional-notR/raw/master",
          purpose, geography, region,
          layer = "rq",
          extension = ".geojson")
}

#' Get route network results from the PCT
#'
#' Wrapper around `[get_pct()]` that gets route road network data from the PCT.
#'
#' @inheritParams get_pct
#' @export
#' @examples
#' \dontrun{
#' # don't test to reduce build times
#' rnet =  get_pct_rnet("isle-of-wight")
#' plot(rnet)
#' }
get_pct_rnet = function(
  region = NULL,
  purpose = "commute",
  geography = "lsoa",
  extension = ".geojson"
) {
  get_pct(base_url = "https://github.com/npct/pct-outputs-regional-notR/raw/master",
          purpose, geography, region,
          layer = "rnet",
          extension = ".geojson")
}
