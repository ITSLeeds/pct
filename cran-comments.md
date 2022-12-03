Updates to make the package fail gracefully.

I have updated all functions that download files or that read directly from web URLs to check if the endpoint is 'alive'.
I've tested the package on a laptop with wifi switched off to ensure that the results fail gracefully and indeed they do, e.g., this happens when the user is offline now:

pct::get_pct_zones("west-yorkshire")
Could not resolve host: github.com
Could not find anything at this URL:
https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/lsoa/west-yorkshire/z.geojson
Error in read_pct(u_file, fun = sf::read_sf) : 
  Check the region exists and internet connection

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
