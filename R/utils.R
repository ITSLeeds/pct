# define global variables
utils::globalVariables(c("pct_regions_lookup"))

read_pct = function(u_file, fun) {
  u_ok = crul::ok(u_file)
  if(!u_ok) {
    message("Could not find anything at this URL:\n", u_file)
    stop("Check the region exists and internet connection")
  } else {
    fun(u_file)
  }
}
