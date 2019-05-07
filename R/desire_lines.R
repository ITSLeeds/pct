#' Desire lines
#'
#' This function generates "desire lines" from census 2011 data.
#' By default gets all desire lines from census in region, but
#' can get the top `n`.
#'
#' @inheritParams get_od
#'
#' @export
#' @examples \donttest{
#' desire_lines = get_desire_lines("wight")
#' plot(desire_lines)
#' intra_zonal = desire_lines$geo_code1 == desire_lines$geo_code2
#' plot(desire_lines[intra_zonal, ])
#' }
get_desire_lines = function(area = NULL, n = NULL, omit_intrazonal = FALSE) {

  if(is.null(area)){
    stop("Select a region or local authority name.")
  }
  # TODO: explore ways of returning 'intrazonal' flows
  od_all = get_od(area, omit_intrazonal = omit_intrazonal)
  # get UK zones with msoa11cd, msoa11nm and the geom for stplanr::od2line
  zones_all = get_centroids_ew() # TODO: some warning?
  zones = zones_all[grepl(area, zones_all$msoa11nm, ignore.case = TRUE), ]
  od = od_all
  if(!is.null(n)) {
    od = order_and_subset(od_all, "all", n) # subset before processing
  }
  # generate desirelines.
  area_desire_lines = stplanr::od2line(flow = od, zones)
  area_desire_lines
}
#' Get origin destination data from the 2011 Census
#'
#' This function downloads a .csv file representing movement
#' between MSOA areas in England and Wales.
#' By default it returns national data, but
#' `area` can be set to subset the output to a specific
#' local authority or region.
#'
#' @param area for which desire lines to be generated.
#' @param n top n number of destinations with most trips in the 2011 census
#' within the `area`.
#' @param type the type of subsetting: one of `from`, `to` or `within`, specifying how
#' the od dataset should be subset in relation to the `area`.
#' @param omit_intrazonal should intrazonal OD pairs be omited from result?
#' `FALSE` by default.
#' @export
#' @examples \donttest{
#' get_od("wight", n = 3)
#' }
get_od = function(area = NULL,
                  n = NULL,
                  type = "within",
                  omit_intrazonal = FALSE) {
  if(length(area) > 1L) {
    stop("'area' must be of length 0 or 1")
  }
  if(is.na(area) || (area == "") || !is.character(area)) {
    if(is.null(area)) {
      message("No area provided. Returning national OD data.")
    } else {
      stop("invalid area name")
    }
  }
  # get the census file to read the trip counts
  census_file = file.path(tempdir(), "wu03ew_v2.csv")
  if(!exists(census_file)) {
    utils::download.file(paste0("https://s3-eu-west-1.amazonaws.com/",
                                "statistics.digitalresources.jisc.ac.uk",
                                "/dkan/files/FLOW/wu03ew_v2/wu03ew_v2.zip"),
                  file.path(tempdir(), "wu03ew_v2.zip"))
    utils::unzip(file.path(tempdir(), "wu03ew_v2.zip"), exdir = tempdir())
  }
  od_all = readr::read_csv(census_file)
  # format columns
  names(od_all) = rename_od_variables(names(od_all))

  # get centroids to provide zone name lookup
  zones_all = get_centroids_ew() # TODO: some warning?
  od_all$geo_name1 = zones_all$msoa11nm[match(od_all$geo_code1, zones_all$msoa11cd)]
  od_all$geo_name2 = zones_all$msoa11nm[match(od_all$geo_code2, zones_all$msoa11cd)]

  if(is.null(area)) {
    od_all$la_1 = gsub(" [0-9][0-9][0-9]", replacement = "", x = od_all$geo_name1)
    od_all$la_2 = gsub(" [0-9][0-9][0-9]", replacement = "", x = od_all$geo_name2)
    return(od_all)
  }

  if(omit_intrazonal) {
    od_all = od_all[od_all$geo_code1 != od_all$geo_code2, ]
  }
  # is area valid? do it once
  valid_areas = grepl(area, od_all$geo_name1, ignore.case = TRUE)
  if(!any(valid_areas))
    stop(paste0("Did you enter the right area name (", area,"?"))
  if(type == "within") {
    grepl(area, od_all$geo_name1, ignore.case = TRUE) &
      grepl(area, od_all$geo_name2, ignore.case = TRUE)
  }
  od = od_all[valid_areas,]

  # finally
  if(!is.null(n)) {
    od = order_and_subset(od, "all", n)
  }
  od
}

order_and_subset = function(od, var, n) {

  od = od[order(od[[var]], decreasing = TRUE), ]
  od[1:n, ]

}

# does this want to be exported at some point?
# x = c("Area of residence", "Area of workplace", "All categories:
#       Method of travel to work",
#       "Work mainly at or from home", "Underground, metro, light rail, tram",
#       "Train", "Bus, minibus or coach", "Taxi", "Motorcycle, scooter or moped",
#       "Driving a car or van", "Passenger in a car or van", "Bicycle",
#       "On foot", "Other method of travel to work")
# rename_od_variables(x)
rename_od_variables = function(x){
  pct::mode_names$variable[match(x, pct::mode_names$census_name)]
}
