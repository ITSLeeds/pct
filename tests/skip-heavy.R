#' To not run heavy tests add:
#' PCT_RUN_HEAVY_TESTS=false
#' to .Renviron, e.g. with usethis::edit_r_environ()
skip_heavy = function() {
  if(!curl::has_internet() |
     identical(Sys.getenv("PCT_RUN_HEAVY_TESTS"), "false"))
    skip("No connection or not running run once tests.")
}
