#' Desire lines
#'
#' @export
pct_area_desire_lines = function(area = "sheffield", n = 100) {
  if(!exists("area"))
    stop("area is required.")
  if(length(area) != 1L)
    stop("'package' must be of length 1")
  if(is.na(area) || (area == "") || !is.character(area))
    stop("invalid area name")
  census_file = file.path(tempdir(), "wu03ew_v2.csv")
  if(!exists(census_file)) {
    download.file("https://s3-eu-west-1.amazonaws.com/statistics.digitalresources.jisc.ac.uk/dkan/files/FLOW/wu03ew_v2/wu03ew_v2.zip",
                  file.path(tempdir(), "wu03ew_v2.zip"))
    unzip(file.path(tempdir(), "wu03ew_v2.zip"), exdir = tempdir())
  }
  od_all = readr::read_csv(census_file)
  zones = pct::msoa2011_vsimple[
    grepl(area, ukboundaries::msoa2011_vsimple$msoa11nm,
          ignore.case = T), ]

  od_area = od_all[od_all$`Area of residence` %in% zones$msoa11cd &
                     od_all$`Area of workplace` %in% zones$msoa11cd, ]
  od_area = od_area[od_area$`Area of residence` !=
                      od_area$`Area of workplace`, ]
  od_area = od_area[order(od_area$`All categories: Method of travel to work`,
                          decreasing = TRUE),]
  od_area = od_area[1:n,]
  area_desire_lines = stplanr::od2line(
    flow = od_area[,c(2,1)], zones[,2])

  area_desire_lines
}
