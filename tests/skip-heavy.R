#' To run heavy tests set
#' PCT_RUN_HEAVY_TESTS env to false
skip_heavy = function() {
  if(!curl::has_internet() |
     identical(Sys.getenv("PCT_RUN_HEAVY_TESTS"), "false"))
    skip("No connection or not running run once tests.")
}
