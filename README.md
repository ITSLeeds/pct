
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pct

# pct  &middot; [![Coverage status](https://codecov.io/gh/ITSLeeds/pct/branch/master/graph/badge.svg)](https://codecov.io/github/ITSLeeds/pct?branch=master) [![Travis build status](https://travis-ci.org/ropensci/stats19.svg?branch=master)](https://travis-ci.org/ITSLeeds/pct)


The goal of pct is to increase the reproducibility of the Propensity to
Cycle Tool (PCT), a research project and web application hosted at
[www.pct.bike](http://www.pct.bike/). For an overview of what the PCT
can do, click on the previous link and try it out. If you want to know
how PCT works, be able to reproduce the results it generates, and build
scenarios of cycling uptake to inform transport policies enabling
cycling in cities worldwide, this package is for you.

## Installation

You can install the development version of the package as follows:

``` r
remotes::install_github("ITSLeeds/pct")
#> Skipping install of 'pct' from a github remote, the SHA1 (dd45a901) has not changed since last install.
#>   Use `force = TRUE` to force installation
```

<!-- You can install the released version of pct from [CRAN](https://CRAN.R-project.org) with: -->

<!-- ``` r -->

<!-- install.packages("pct") -->

<!-- ``` -->

Load the package as follows:

``` r
library(pct)
```

## Example for Leeds

This example shows how scenarios of cycling uptake, and how ‘distance
decay’ works (short trips are more likely to be cycled than long trips).

The input data looks like this (origin-destination data and geographic
zone data):

``` r
class(od_leeds)
#> [1] "tbl_df"     "tbl"        "data.frame"
od_leeds[c(1:3, 12)]
#>    area_of_residence area_of_workplace  all bicycle
#> 1          E02002363         E02006875  922      43
#> 2          E02002373         E02006875 1037      73
#> 3          E02002384         E02006875  966      13
#> 4          E02002385         E02006875  958      52
#> 5          E02002392         E02006875  753      19
#> 6          E02002404         E02006875 1145      10
#> 7          E02002411         E02006875  929      27
#> 8          E02006852         E02006875 1221      99
#> 9          E02006861         E02006875 1177      56
#> 10         E02006876         E02006875 1035      10
class(zones_leeds)
#> [1] "sf"         "data.frame"
zones_leeds[1:3, ]
#>      objectid  msoa11cd  msoa11nm msoa11nmw st_areasha st_lengths
#> 2270     2270 E02002330 Leeds 001 Leeds 001    3460674  10002.983
#> 2271     2271 E02002331 Leeds 002 Leeds 002   21870986  26417.665
#> 2272     2272 E02002332 Leeds 003 Leeds 003    2811303   8586.548
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              geometry
#> 2270                                                                                                                                                                                                                                                                                                                                           -1.392046, -1.398989, -1.410523, -1.417764, -1.420581, -1.415028, -1.412073, -1.408357, -1.406710, -1.410629, -1.409197, -1.409140, -1.402347, -1.400684, -1.397198, -1.383674, -1.386428, -1.384679, -1.383307, -1.392046, 53.929899, 53.915569, 53.917471, 53.915215, 53.919331, 53.921274, 53.919534, 53.927881, 53.927850, 53.930156, 53.935466, 53.935475, 53.936831, 53.938446, 53.942529, 53.941456, 53.938680, 53.936829, 53.932811, 53.929899
#> 2271 -1.340405, -1.344712, -1.339539, -1.307191, -1.308992, -1.300420, -1.294313, -1.307311, -1.297203, -1.300588, -1.313723, -1.321054, -1.322272, -1.328700, -1.345094, -1.350501, -1.357661, -1.364050, -1.359934, -1.362844, -1.370039, -1.370925, -1.386029, -1.378174, -1.390462, -1.386554, -1.398211, -1.398989, -1.392046, -1.383307, -1.384679, -1.386428, -1.383674, -1.381683, -1.340405, 53.945888, 53.939502, 53.940810, 53.934543, 53.924098, 53.929417, 53.927217, 53.921494, 53.921682, 53.907486, 53.904702, 53.903480, 53.900457, 53.901750, 53.906925, 53.909079, 53.907272, 53.908818, 53.911667, 53.914355, 53.915530, 53.907548, 53.909903, 53.906165, 53.908110, 53.912444, 53.914786, 53.915569, 53.929899, 53.932811, 53.936829, 53.938680, 53.941456, 53.940487, 53.945888
#> 2272                                                                                                                                                                                                                                                                                                                                                                                       -1.682211, -1.688594, -1.695156, -1.700993, -1.702196, -1.709330, -1.715693, -1.727245, -1.727217, -1.722314, -1.717959, -1.716302, -1.706112, -1.707084, -1.698520, -1.690103, -1.688199, -1.682211, 53.910461, 53.906725, 53.908527, 53.904621, 53.904330, 53.902113, 53.905049, 53.909524, 53.910197, 53.911958, 53.908542, 53.916552, 53.917071, 53.919131, 53.916921, 53.916713, 53.911742, 53.910461
```

The `stplanr` package can be used to convert the non-geographic OD data
into geographic desire lines as follows:

``` r
library(sf)
#> Linking to GEOS 3.7.0, GDAL 2.3.2, PROJ 5.2.0
desire_lines = stplanr::od2line(flow = od_leeds, zones = zones_leeds[2])
#> Warning in st_centroid.sf(zones): st_centroid assumes attributes are
#> constant over geometries of x
#> Warning in st_centroid.sfc(st_geometry(x), of_largest_polygon =
#> of_largest_polygon): st_centroid does not give correct centroids for
#> longitude/latitude data
plot(desire_lines[c(1:3, 12)])
```

<img src="man/figures/README-desire-1.png" width="100%" />

We can convert these straight lines into routes with a routing service,
e.g.:

``` r
routes_fast = stplanr::line2route(desire_lines, route_fun = stplanr::route_cyclestreet)
#> 10 % out of 10 distances calculated
#> 20 % out of 10 distances calculated
#> 30 % out of 10 distances calculated
#> 40 % out of 10 distances calculated
#> 50 % out of 10 distances calculated
#> 60 % out of 10 distances calculated
#> 70 % out of 10 distances calculated
#> 80 % out of 10 distances calculated
#> 90 % out of 10 distances calculated
#> 100 % out of 10 distances calculated
```

We got useful information from this routing operation. We will add the
desire line data onto vital data from the routes (from a cycling uptake
perspective, distance and hilliness of routes):

``` r
routes_vital = sf::st_sf(
  cbind(
  sf::st_drop_geometry(desire_lines[c(1:3, 12)]),
  sf::st_drop_geometry(routes_fast[c("length", "av_incline")]),
  geometry = routes_fast$geometry
  ))
plot(routes_vital)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

Now we estimate cycling
uptake:

``` r
routes_vital$uptake = uptake_pct_govtarget(distance = routes_vital$length, gradient = routes_vital$av_incline)
#> Distance assumed in m, switching to km
routes_vital$bicycle_govtarget = routes_vital$bicycle +
  round(routes_vital$uptake * routes_vital$all)
```

Let’s see how many people started cycling:

``` r
sum(routes_vital$bicycle_govtarget) - sum(routes_vital$bicycle)
#> [1] 768
```

Nearly 1000 more people cycling to work, just in 10 desire is not bad\!
What % cyling is this, for those routes?

``` r
sum(routes_vital$bicycle_govtarget) / sum(routes_vital$all)
#> [1] 0.1153505
sum(routes_vital$bicycle) / sum(routes_vital$all)
#> [1] 0.03963324
```

It’s gone from 4% to 11%, a realistic increase if cycling were enabled
by good infrastructure and policies.

Now: where to prioritise that infrastructure and those
policies?

``` r
rnet = stplanr::overline2(routes_vital, attrib = c("bicycle", "bicycle_govtarget"))
#> Loading required namespace: pbapply
#> 2019-03-07 15:23:52 constructing segments
#> 2019-03-07 15:23:52 transposing 'B to A' to 'A to B'
#> 2019-03-07 15:23:52 removing duplicates
#> 2019-03-07 15:23:52 restructuring attributes
#> 2019-03-07 15:23:52 building geometry
#> 2019-03-07 15:23:52 simplifying geometry
#> 2019-03-07 15:23:52 rejoining segments into linestrings
lwd = rnet$bicycle_govtarget / mean(rnet$bicycle_govtarget)
plot(rnet["bicycle_govtarget"], lwd = lwd)
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

We can view the results in an interactive map and share with policy
makers, stakeholders, and the public\! E.g. (see interactive map
[here](http://rpubs.com/RobinLovelace/474074)):

``` r
mapview::mapview(rnet, zcol = "bicycle_govtarget", lwd = lwd * 2)
```

![](pct-leeds-demo.png)

## Next steps and further resources (work in progress)

  - Add additional scenarios of cycling uptake from different places
    (e.g. goCambridge)
  - Add additional distance decay functions
  - Make it easy to use data from other cities around the world
  - Show how to create raster tiles of cycling uptake
