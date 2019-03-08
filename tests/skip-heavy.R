#' To run heavy tests set
#' PCT_SKIP_HEAVY env to false
skip_heavy = function() {
  if(!curl::has_internet() |
     !identical(Sys.getenv("PCT_RUN_HEAVY_TESTS"), "true"))
    skip("No connection or not running run once tests.")
}
