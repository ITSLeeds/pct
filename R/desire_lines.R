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
get_desire_lines = function(region = NULL, n = NULL, omit_intrazonal = FALSE) {

  if(is.null(region)){
    stop("Select a region or local authority name.")
  }
  # TODO: explore ways of returning 'intrazonal' flows
  od_all = get_od(region, omit_intrazonal = omit_intrazonal)
  # get UK zones with msoa11cd, msoa11nm and the geom for stplanr::od2line
  message("Downloading population weighted centroids")
  zones_all = get_centroids_ew() # TODO: some warning?
  zones = zones_all[grepl(region, zones_all$msoa11nm, ignore.case = TRUE), ]
  od = od_all
  if(!is.null(n)) {
    od = order_and_subset(od_all, "all", n) # subset before processing
  }
  flow_origs_in_zones = od$geo_code1 %in% zones$msoa11cd
  if(!all(flow_origs_in_zones)) {
    n_rem = sum(!flow_origs_in_zones)
    message("Not all flows origins have ID in centroids, removing ", n_rem, " OD pairs.")
    od = od[flow_origs_in_zones, ]
  }
  flow_dests_in_zones = od$geo_code2 %in% zones$msoa11cd
  if(!all(flow_dests_in_zones)) {
    n_rem = sum(!flow_dests_in_zones)
    message("Not all flows origins have ID in centroids, removing ", n_rem, " OD pairs.")
    od = od[flow_dests_in_zones, ]
  }
  # generate desire lines
  region_desire_lines = stplanr::od2line(flow = od, zones)
  region_desire_lines
}
#' Get origin destination data from the 2011 Census
#'
#' This function downloads a .csv file representing movement
#' between MSOA zones in England and Wales.
#' By default it returns national data, but
#' `region` can be set to subset the output to a specific
#' local authority or region.
#'
#' OD datasets available include [wu03uk_v3](https://www.statistics.digitalresources.jisc.ac.uk/)
#' and others listed on the Wicid website.
#'
#' @param n top n number of destinations with most trips in the 2011 census
#' within the `region`.
#' @param type the type of subsetting: one of `from`, `to` or `within`, specifying how
#' the od dataset should be subset in relation to the `region`.
#' @param base_url the base url where the OD dataset is stored
#' @param filename the name of the file to download, if not the default MSOA level
#' data.
#' @param omit_intrazonal should intrazonal OD pairs be omited from result?
#' `FALSE` by default.
#' @inheritParams get_pct
#' @export
#' @examples \donttest{
#' get_od("wight", n = 3)
#' get_od()
#' get_od(filename = "wu03uk_v3")
#' }
get_od = function(region = NULL,
                  n = NULL,
                  type = "within",
                  omit_intrazonal = FALSE,
                  base_url = paste0("https://s3-eu-west-1.amazonaws.com/",
                                    "statistics.digitalresources.jisc.ac.uk",
                                    "/dkan/files/FLOW/"),
                  filename = "wu03ew_v2") {

  if(length(region) > 1L) {
    stop("region must be of length 0 or 1")
  }

  if(!is.null(region)) {

    valid_region = region %in% c(pct_regions_lookup$region_name)
    valid_region_match = grepl(region, pct_regions_lookup$region_name)
    valid_la_match = grepl(region, pct_regions_lookup$lad16cd)
    if(!valid_region & !any(valid_la_match) & !any(valid_region_match)) {
      stop("region must contain a valid name in the pct_regions_lookup")
    }

    # find matching las
    if(valid_region) {
      las = pct_regions_lookup$lad16nm[pct_regions_lookup$region_name %in% region]
    } else {
      las = pct_regions_lookup$lad16nm[grepl(pattern = region, pct_regions_lookup$lad16nm, ignore.case = TRUE)]
    }
  }

  if(is.na(region) || (region == "") || !is.character(region)) {
    if(is.null(region)) {
      message("No region provided. Returning national OD data.")
    } else {
      stop("invalid region name")
    }
  }

  # get the census file to read the trip counts
  zip_file = file.path(tempdir(), paste0(filename, ".zip"))
  census_file = file.path(tempdir(), paste0(filename, ".csv"))
  file_url = paste0(base_url, filename, "/", filename, ".zip")
  if(!exists(census_file)) {
    utils::download.file(file_url, zip_file)
    utils::unzip(zip_file, exdir = tempdir())
  }
  od_all = readr::read_csv(census_file)
  # format columns
  names(od_all) = rename_od_variables(names(od_all))

  if(!filename == "wu03ew_v2") {
    return(od_all)
  }

  # get centroids to provide zone name lookup
  zones_all = get_centroids_ew() # TODO: some warning?
  od_all$geo_name1 = zones_all$msoa11nm[match(od_all$geo_code1, zones_all$msoa11cd)]
  od_all$geo_name2 = zones_all$msoa11nm[match(od_all$geo_code2, zones_all$msoa11cd)]

  od_all$la_1 = gsub(" [0-9][0-9][0-9]", replacement = "", x = od_all$geo_name1)
  od_all$la_2 = gsub(" [0-9][0-9][0-9]", replacement = "", x = od_all$geo_name2)

  if(is.null(region)) {
    return(od_all)
  }

  if(omit_intrazonal) {
    od_all = od_all[od_all$geo_code1 != od_all$geo_code2, ]
  }
  # is region valid? do it once

  # if(type == "within") {
  #   grepl(region, od_all$geo_name1, ignore.case = TRUE) &
  #     grepl(region, od_all$geo_name2, ignore.case = TRUE)
  # }

  od = od_all[od_all$la_1 %in% las, ]

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
# x = c("region of residence", "Area of workplace", "All categories:
#       Method of travel to work",
#       "Work mainly at or from home", "Underground, metro, light rail, tram",
#       "Train", "Bus, minibus or coach", "Taxi", "Motorcycle, scooter or moped",
#       "Driving a car or van", "Passenger in a car or van", "Bicycle",
#       "On foot", "Other method of travel to work")
# rename_od_variables(x)
rename_od_variables = function(x){
  pct::mode_names$variable[match(x, pct::mode_names$census_name)]
}
