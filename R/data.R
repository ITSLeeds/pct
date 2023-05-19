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
#' # u = "https://github.com/pedalea/pctSantiago/releases/download/0.0.1/z_centre.Rds"
#' # download.file(u, destfile = "z_centre.Rds", mode = "wb")
#' # santiago_zones = readRDS("z_centre.Rds")
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

#' OD data in central Santiago
#'
#' See https://github.com/pedalea/pctSantiago folder for generation code
#'
#' @docType data
#' @keywords datasets
#' @name santiago_od
#' @examples
#' # u = "https://github.com/pedalea/pctSantiago/releases/download/0.0.1/santiago_od.Rds"
#' # download.file(u, destfile = "santiago_od.Rds", mode = "wb")
#' # santiago_od = readRDS("santiago_od.Rds")
#' santiago_od
NULL

#' Desire lines from the PCT for the Isle of Wight
#'
#' This data was obtained using code shown in the introductory
#' [pct package vignette](https://itsleeds.github.io/pct/articles/pct.html).
#'
#' @docType data
#' @keywords datasets
#' @name wight_lines_30
#' @aliases wight_lines_pct
#' @examples
#' names(wight_lines_30)
#' plot(wight_lines_30)
NULL

#' Zones and centroid data from the PCT for the Isle of Wight
#'
#' This data was obtained using code shown in the introductory
#' [pct package vignette](https://itsleeds.github.io/pct/articles/pct.html).
#'
#' @docType data
#' @keywords datasets
#' @name wight_zones
#' @aliases wight_centroids
#' @examples
#' library(sf)
#' names(wight_lines_30)
#' plot(wight_lines_30)
NULL

#' Official origin-destination data for the Isle of Wight
#'
#' This data was obtained using code shown in the introductory
#' [pct package vignette](https://itsleeds.github.io/pct/articles/pct.html).
#'
#' @docType data
#' @keywords datasets
#' @name wight_od
#' @examples
#' names(wight_od)
#' head(wight_od)
NULL

#' Cycle route data for the Isle of Wight
#'
#' This data was obtained using code shown in the introductory
#' [pct package vignette](https://itsleeds.github.io/pct/articles/pct.html).
#'
#' @docType data
#' @keywords datasets
#' @name wight_routes_30
#' @aliases wight_rnet wight_routes_30_cs
#' @examples
#' library(sf)
#' names(wight_routes_30)
#' head(wight_routes_30)
#' plot(wight_routes_30)
NULL

#' 200 cycle routes in central Santiago, Chile
#'
#' This data was obtained using code shown in the
#' International application of the PCT methods
#' [vignette](https://itsleeds.github.io/pct/articles/pct-international.html).
#'
#' @docType data
#' @keywords datasets
#' @name santiago_routes_cs
#' @examples
#' library(sf)
#' names(santiago_routes_cs)
#' head(santiago_routes_cs)
#' plot(santiago_routes_cs)
NULL

#' Lookup table matching PCT regions to local authorities
#'
#' For matching pct_regions object with local authority names in England and Wales.
#'
#' @docType data
#' @keywords datasets
#' @name pct_regions_lookup
#' @examples
#'
#' names(pct_regions_lookup)
#' head(pct_regions_lookup)
NULL


