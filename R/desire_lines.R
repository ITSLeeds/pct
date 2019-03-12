#' Desire lines
#'
#' This function generates "desire lines" from census 2011 data.
#'
#' @inheritParams get_od
#'
#' @export
#' @examples
#' desire_sheffield = get_desire_lines("sheffield", n = 20)
#' desire_sheffield
get_desire_lines = function(area = "sheffield", n = 100) {

  # TODO: explore ways of returning 'intrazonal' flows
  od_all = get_od(area, n = n * 2 + 100) # ensure enough od pairs are returned
  # get UK zones with msoa11cd, msoa11nm and the geom for stplanr::od2line
  zones_all = get_centroids_ew() # TODO: some warning?
  zones = zones_all[grepl(area, zones_all$msoa11nm, ignore.case = TRUE), ]
  od = od_all[od_all$geo_code1 %in% zones$msoa11cd &
                od_all$geo_code2 %in% zones$msoa11cd, ]
  od = od[od$geo_code1 != od$geo_code2, ]
  od = order_and_subset(od, "all", n) # subset before heavy processing.
  # generate desirelines.
  area_desire_lines = stplanr::od2line(flow = od, zones)
  area_desire_lines
}
#' Get origin destination data from the 2011 Census
#'
#' @param area for which desire lines to be generated.
#' @param n top n number of destinations with most trips in the 2011 census
#' within the `area`.
#' @param type the type of subsetting: one of `from`, `to` or `within`, specifying how
#' the od dataset should be subset in relation to the `area`.
#' @export
#' @examples \donttest{
#' od_sheffield = get_od("sheffield", n = 3)
#' od_sheffield
#' }
get_od = function(area = "sheffield", n = 100, type = "within") {
  if(length(area) != 1L)
    stop("'area' must be of length 1")
  if(is.na(area) || (area == "") || !is.character(area))
    stop("invalid area name")
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

  if(type == "within") {
    od = od_all[
      grepl(area, od_all$geo_name1, ignore.case = TRUE) &
        grepl(area, od_all$geo_name2, ignore.case = TRUE),
      ]
  }

  od = order_and_subset(od, "all", n)

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
