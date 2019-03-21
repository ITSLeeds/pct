#' Example OD data for Leeds
#'
#' `od_leeds` contains the 100 most travelled work desire lines in Leeds,
#' according to the 2011 Census.
#'
#' @docType data
#' @keywords datasets
#' @name od_leeds
#' @examples
#' # see data-raw folder for generation code
#' od_leeds
NULL

#' Zone data for Leeds
#'
#' Zones in Leeds
#'
#' @docType data
#' @keywords datasets
#' @name zones_leeds
#' @examples
#' # see data-raw folder for generation code
#' zones_leeds
NULL

#' Route network for Leeds
#'
#' @docType data
#' @keywords datasets
#' @name rnet_leeds
#' @examples
#' # see data-raw folder for generation code
#' rnet_leeds
NULL

#' Cycle route desire lines for Leeds
#'
#' @docType data
#' @keywords datasets
#' @name desire_lines_leeds
#' @examples
#' # see data-raw folder for generation code
#' desire_lines_leeds
NULL

#' Fastest cycle routes for the desire_lines_leeds
#'
#' @docType data
#' @keywords datasets
#' @name routes_fast_leeds
#' @examples
#' # see data-raw folder for generation code
#' routes_fast_leeds
NULL

#' Top 15 min mean journy times within Leeds from Uber
#'
#' Data downloaded 4th March 2019.
#' According to Uber, the dataset is from:
#' 1/1/2018 - 1/31/2018 (Every day, Daily Average)
#'
#' @docType data
#' @keywords datasets
#' @name leeds_uber_sample
#' @examples
#' # see data-raw folder for generation code
#' leeds_uber_sample
NULL

#' Mode names in the Census
#'
#' And conversion into R-friendly versions
#'
#' @docType data
#' @keywords datasets
#' @name mode_names
#' @examples
#' mode_names
NULL

#' PCT regions from www.pct.bike
#'
#' See data-raw folder for generation code
#'
#' @docType data
#' @keywords datasets
#' @name pct_regions
#' @examples
#' pct_regions
NULL

#' Zones in central Santiago
#'
#' See https://github.com/pedalea/pctSantiago folder for generation code
#'
#' @docType data
#' @keywords datasets
#' @name santiago_zones
#' @examples
#' u = "https://github.com/pedalea/pctSantiago/releases/download/0.0.1/z_centre.Rds"
#' download.file(u, destfile = "z_centre.Rds")
#' santiago_zones = readRDS("z_centre.Rds")
#' santiago_zones
NULL

#' Desire lines in central Santiago
#'
#' See https://github.com/pedalea/pctSantiago folder for generation code
#'
#' @docType data
#' @keywords datasets
#' @name santiago_lines
#' @examples
#' # u = "https://github.com/pedalea/pctSantiago/releases/download/0.0.1/od_agg_zone_sub.Rds"
#' # download.file(u, destfile = "od_agg_zone_sub.Rds")
#' # desire_lines = readRDS("od_agg_zone_sub.Rds")
#' santiago_zones
NULL
