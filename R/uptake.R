#' Calculate cycling uptake for UK 'Government Target' scenario
#'
#' Uptake model that takes distance and hilliness and returns
#' a percentage of trips that could be made by cycling along a desire line
#' under scenarios of change. Source: appendix of pct paper, hosted at:
#' [www.jtlu.org](https://www.jtlu.org/index.php/jtlu/article/download/862/1381/4359)
#' which states that: "To  estimate  cycling  potential,the  Propensity  to  Cycle  Tool  (PCT)  was
#' designed  to  use  the  best available  geographically  disaggregated
#' data  sources  on  travel  patterns."
#'
#' The functional form of the cycling uptake model used in the PCT is as follows:
#' (Source: [npct.github.io](https://npct.github.io/pct-shiny/regions_www/www/static/03a_manual/pct-bike-eng-user-manual-c1.pdf))
#'
#' ```
#' logit (pcycle) = -3.959 +   # alpha
#'   (-0.5963 * distance) +    # d1
#'   (1.866 * distancesqrt) +  # d2
#'   (0.008050 * distancesq) + # d3
#'   (-0.2710 * gradient) +    # h1
#'   (0.009394 * distance * gradient) +  # i1
#'   (-0.05135 * distancesqrt *gradient) # i2
#'
#' pcycle = exp ([logit (pcycle)]) / (1 + (exp([logit(pcycle)])
#' ```
#'
#' `uptake_pct_govtarget_2020()` and
#' `uptake_pct_godutch_2020()`
#' approximate the uptake models used in the updated 2020 release of
#' the PCT results.
#'
#' If the `distance` parameter is greater than 100, it is assumed that it is in m.
#' If for some reason you want to model cycling uptake associated with trips with
#' distances of less than 100 m, convert the distances to km first.
#'
#' @param distance Vector distance numeric values of routes in km
#' (switches to km if more than 100).
#' @param gradient Vector gradient numeric values of routes.
#' @param alpha The intercept
#' @param d1 Distance term 1
#' @param d2 Distance term 2
#' @param d3 Distance term 3
#' @param h1 Hilliness term 1
#' @param h2 Hilliness term 2
#' @param i1 Distance-hilliness interaction term 1
#' @param i2 Distance-hilliness interaction term 2
#' @param verbose Print messages? `FALSE` by default.
#'
#' @export
#' @examples
#' distance = 15
#' gradient = 2
#' logit_pcycle = -3.959 + # alpha
#'   (-0.5963 * distance) + # d1
#'   (1.866 * sqrt(distance)) + # d2
#'   (0.008050 * distance^2) + # d3
#'   (-0.2710 * gradient) + # h1
#'   (0.009394 * distance * gradient) + # i1
#'   (-0.05135 * sqrt(distance) * gradient) # i2
#' boot::inv.logit(logit_pcycle)
#' uptake_pct_govtarget(15, 2)
#' l = routes_fast_leeds
#' pcycle_scenario = uptake_pct_govtarget(l$length, l$av_incline)
#' pcycle_scenario_2020 = uptake_pct_govtarget_2020(l$length, l$av_incline)
#' plot(l$length, pcycle_scenario, ylim = c(0, 0.2))
#' points(l$length, pcycle_scenario_2020, col = "blue")
#'
#' # compare with published PCT data:
#' l_pct_2020 = get_pct_lines(region = "isle-of-wight")
#' # test for another region:
#' # l_pct_2020 = get_pct_lines(region = "west-yorkshire")
#' l_pct_2020$rf_avslope_perc[1:5]
#' l_pct_2020$rf_dist_km[1:5]
#' govtarget_slc = uptake_pct_govtarget(
#'   distance = l_pct_2020$rf_dist_km,
#'   gradient = l_pct_2020$rf_avslope_perc
#' ) * l_pct_2020$all + l_pct_2020$bicycle
#' govtarget_slc_2020 = uptake_pct_govtarget_2020(
#'   distance = l_pct_2020$rf_dist_km,
#'   gradient = l_pct_2020$rf_avslope_perc
#' ) * l_pct_2020$all + l_pct_2020$bicycle
#' mean(l_pct_2020$govtarget_slc)
#' mean(govtarget_slc)
#' mean(govtarget_slc_2020)
#' godutch_slc = uptake_pct_godutch(
#'   distance = l_pct_2020$rf_dist_km,
#'   gradient = l_pct_2020$rf_avslope_perc
#' ) * l_pct_2020$all + l_pct_2020$bicycle
#' godutch_slc_2020 = uptake_pct_godutch_2020(
#'   distance = l_pct_2020$rf_dist_km,
#'   gradient = l_pct_2020$rf_avslope_perc
#' ) * l_pct_2020$all + l_pct_2020$bicycle
#' mean(l_pct_2020$dutch_slc)
#' mean(godutch_slc)
#' mean(godutch_slc_2020)
uptake_pct_govtarget = function(distance,
                                gradient,
                                alpha = -3.959,
                                d1 = -0.5963,
                                d2 = 1.866,
                                d3 = 0.008050,
                                h1 = -0.2710,
                                i1 = 0.009394,
                                i2 = -0.05135,
                                verbose = FALSE) {
  distance_gradient = check_distance_gradient(distance, gradient, verbose)
  distance = distance_gradient$distance
  gradient = distance_gradient$gradient
  pcycle_scenario = alpha +
    (d1 * distance) + # d1
    (d2 * sqrt(distance)) + # d2
    (d3 * distance ^ 2) + # d3
    (h1 * gradient) + # h1
    (i1 * distance * gradient) + # i1
    (i2 * sqrt(distance) * gradient) # i2
  boot::inv.logit(pcycle_scenario)
}

#' Calculate cycling uptake for UK 'Go Dutch' scenario
#'
#' This function implements the uptake model described in the original
#' Propensity to Cycle Tool paper (Lovelace et al. 2017):
#' https://doi.org/10.5198/jtlu.2016.862
#'
#' See [uptake_pct_govtarget()].
#'
#' @inheritParams uptake_pct_govtarget
#' @export
#' @examples
#' # https://www.jtlu.org/index.php/jtlu/article/download/862/1381/4359
#' # Equation 1B:
#' distance = 15
#' gradient = 2
#' logit = -3.959 + 2.523 +
#'   ((-0.5963 - 0.07626) * distance) +
#'   (1.866 * sqrt(distance)) +
#'   (0.008050 * distance^2) +
#'   (-0.2710 * gradient) +
#'   (0.009394 * distance * gradient) +
#'   (-0.05135 * sqrt(distance) * gradient)
#' logit
#' # Result: -3.144098
#'
#' pcycle = exp(logit) / (1 + exp(logit))
#' # Result: 0.04132445
#' boot::inv.logit(logit)
#' uptake_pct_godutch(distance, gradient,
#'   alpha = -3.959 + 2.523, d1 = -0.5963 - 0.07626,
#'   d2 = 1.866, d3 = 0.008050, h1 = -0.2710, i1 = 0.009394, i2 = -0.05135
#' )
#' # these are the default values
#' uptake_pct_godutch(distance, gradient)
#' l = routes_fast_leeds
#' pcycle_scenario = uptake_pct_godutch(l$length, l$av_incline)
#' plot(l$length, pcycle_scenario)
uptake_pct_godutch = function(distance,
                              gradient,
                              alpha = -3.959 + 2.523,
                              d1 = -0.5963 - 0.07626,
                              d2 = 1.866,
                              d3 = 0.008050,
                              h1 = -0.2710,
                              i1 = 0.009394,
                              i2 = -0.05135,
                              verbose = FALSE) {
  distance_gradient = check_distance_gradient(distance, gradient, verbose)
  distance = distance_gradient$distance
  gradient = distance_gradient$gradient
  logit_pcycle = alpha + (d1 * distance) +
    (d2 * sqrt(distance)) + (d3 * distance ^ 2) +
    (h1 * gradient) +
    (i1 * distance * gradient) +
    (i2 * sqrt(distance) * gradient)
  boot::inv.logit(logit_pcycle)
}

#' @rdname uptake_pct_govtarget
#' @export
uptake_pct_govtarget_2020 = function(distance,
                                     gradient,
                                     alpha = -4.018,
                                     d1 = -0.6369,
                                     d2 = 1.988,
                                     d3 = 0.008775,
                                     h1 = -0.2555,
                                     h2 = -0.78,
                                     i1 = 0.02006,
                                     i2 = -0.1234,
                                     verbose = FALSE) {
  distance_gradient = check_distance_gradient(distance, gradient, verbose)
  distance = distance_gradient$distance
  gradient = distance_gradient$gradient
  # Uptake formula from
  # https://raw.githubusercontent.com/npct/pct-shiny/
  # a59ebd1619af4400eeb7ffb2a8ecdd8ce4c3753d/
  # regions_www/www/static/03a_manual/pct-bike-eng-user-manual-c1.pdf
  #
  # logit (pcycle)= -4.018 +  (-0.6369 *  distance)  +
  #   (1.988  * distancesqrt)  +  (0.008775* distancesq) +
  #   (-0.2555* gradient) + (0.02006* distance*gradient) +
  #   (-0.1234* distancesqrt*gradient)
  gradient = gradient + h2
  pcycle_scenario = alpha +
    (d1 * distance) + # d1
    (d2 * sqrt(distance)) + # d2
    (d3 * distance ^ 2) + # d3
    (h1 * gradient) + # h1
    (i1 * distance * gradient) + # i1
    (i2 * sqrt(distance) * gradient) # i2
  boot::inv.logit(pcycle_scenario)
}

#' @rdname uptake_pct_govtarget
#' @export
uptake_pct_godutch_2020 = function(distance,
                                   gradient,
                                   alpha = -4.018 + 2.550,
                                   d1 = -0.6369 - 0.08036,
                                   d2 = 1.988,
                                   d3 = 0.008775,
                                   h1 = -0.2555,
                                   h2 = -0.78,
                                   i1 = 0.02006,
                                   i2 = -0.1234,
                                   verbose = FALSE) {
  distance_gradient = check_distance_gradient(distance, gradient, verbose)
  distance = distance_gradient$distance
  gradient = distance_gradient$gradient
  # Uptake formula from manual:
  # logit_pcycle = -4.018  +  (-0.6369  *  distance)  +  (1.988  *  distancesqrt) +
  # (0.008775  * distancesq) + (-0.2555 * gradient) + (0.02006 * distance*gradient) +
  # (-0.1234 * distancesqrt*gradient) + (2.550 * dutch) +  (-0.08036* dutch * distance) +
  # (0.05509* ebike * distance) + (-0.0002950* ebike * distancesq) + (0.1812* ebike * gradient)
  gradient = gradient + h2
  pcycle_scenario = alpha +
    (d1 * distance) + # d1
    (d2 * sqrt(distance)) + # d2
    (d3 * distance ^ 2) + # d3
    (h1 * gradient) + # h1
    (i1 * distance * gradient) + # i1
    (i2 * sqrt(distance) * gradient) # i2
  boot::inv.logit(pcycle_scenario)
}

#' @rdname uptake_pct_govtarget
#' @export
uptake_pct_ebike_2020 = function(distance,
                                   gradient,
                                   alpha = -4.018 + 2.550,
                                   d1 = -0.6369 - 0.08036 + 0.05509,
                                   d2 = 1.988,
                                   d3 = 0.008775 -0.0002950,
                                   h1 = -0.2555 + 0.1812,
                                   h2 = -0.78,
                                   i1 = 0.02006,
                                   i2 = -0.1234,
                                   verbose = FALSE) {
  distance_gradient = check_distance_gradient(distance, gradient, verbose)
  distance = distance_gradient$distance
  gradient = distance_gradient$gradient
  # Uptake formula from manual:
  # logit_pcycle = -4.018  +  (-0.6369  *  distance)  +  (1.988  *  distancesqrt) +
  # (0.008775  * distancesq) + (-0.2555 * gradient) + (0.02006 * distance*gradient) +
  # (-0.1234 * distancesqrt*gradient) + (2.550 * dutch) +  (-0.08036* dutch * distance) +
  # (0.05509* ebike * distance) + (-0.0002950* ebike * distancesq) + (0.1812* ebike * gradient)
  gradient = gradient + h2
  pcycle_scenario = alpha +
    (d1 * distance) + # d1
    (d2 * sqrt(distance)) + # d2
    (d3 * distance ^ 2) + # d3
    (h1 * gradient) + # h1
    (i1 * distance * gradient) + # i1
    (i2 * sqrt(distance) * gradient) # i2
  boot::inv.logit(pcycle_scenario)
}

#' @rdname uptake_pct_govtarget
#' @export
#' @examples
#' # Take an origin destination (OD) pair between an LSOA centroid and a
#' # secondary school. In this OD pair, 30 secondary school children travel, of
#' # whom 3 currently cycle. The fastest route distance is 3.51 km and the
#' # gradient is 1.11%. The
#' # gradient as centred on Dutch hilliness levels is 1.11 – 0.63 = 0.48%.
#' # The observed number of cyclists is 2. ... Modelled baseline= 30 * .0558 = 1.8.
#' uptake_pct_govtarget_school2(3.51, 1.11)
uptake_pct_govtarget_school2 = function(
  distance,
  gradient,
  alpha = -7.178,
  d1 = -1.870,
  d2 = 5.961,
  # d3 = -0.2401,
  h1 = -0.5290,
  h2 = -0.63,
  verbose = FALSE
  # i1 = 0.02006,
  # i2 = -0.1234
) {
  # Uptake formula from Goodman et al. (2019)
  # http://www.sciencedirect.com/science/article/pii/S2214140518301257
  #
  # Equation 1.1 (primary school children):
  #   logit (pcycle) = −4.813 + (0.9743 * distance) + (−0.2401 * distancesq) + (−0.4245 * centred_gradient)
  # pcycle = exp ([logit (pcycle)])/(1 + (exp([logit(pcycle)]))).
  # Equation 2.1 (secondary school children):
  #   logit (pcycle) = −7.178 + (−1.870 * distance) + (5.961 * distance sqrt) + (−0.5290 * centred_gradient)
  # pcycle = exp ([logit (pcycle)])/(1 + (exp([logit(pcycle)])))
  distance_gradient = check_distance_gradient(distance, gradient, verbose)
  distance = distance_gradient$distance
  gradient = distance_gradient$gradient
  gradient = gradient + h2
  pcycle_scenario = alpha +
    (d1 * distance) + # d1
    (d2 * sqrt(distance)) + # d2
    # (d3 * distance^2) + # d3
    (h1 * gradient)
  # +    # h1
  # (i1 * distance * gradient) +  # i1
  # (i2 * sqrt(distance) * gradient) # i2
  boot::inv.logit(pcycle_scenario)
}

#' @rdname uptake_pct_govtarget
#' @export
#' @examples
#' # pcycle = exp ([logit (pcycle)])/(1 + (exp([logit(pcycle)]))).
#' # pcycle = exp(1.953)/(1 + exp(1.953)) = .8758, or 87.58%.
#' uptake_pct_godutch_school2(3.51, 1.11)
uptake_pct_godutch_school2 = function(
  distance,
  gradient,
  alpha = -7.178 + 3.574,
  d1 = -1.870 + 0.3438,
  d2 = 5.961,
  # d3 = -0.2401,
  h1 = -0.5290,
  h2 = -0.63,
  verbose = FALSE
  # i1 = 0.02006,
  # i2 = -0.1234
) {
  # Uptake formula from Goodman et al. (2019)
  # http://www.sciencedirect.com/science/article/pii/S2214140518301257
  #
  # Equation 2.2 (secondary school children):
  #   logit(pcycle) = Equation 1.2 + Dutch parameters.
  # logit (pcycle) = −7.178 + (−1.870 * distance) + (5.961 * distancesqrt) + (−0.5290 * centred_gradient)+(3.574) +
  #   (0.3438 * distance).
  # pcycle = exp ([logit (pcycle)])/(1 + (exp([logit(pcycle)]))).
  #

  # logit (pcycle)= -4.018 +  (-0.6369 *  distance)  +
  #   (1.988  * distancesqrt)  +  (0.008775* distancesq) +
  #   (-0.2555* gradient) + (0.02006* distance*gradient) +
  #   (-0.1234* distancesqrt*gradient)
  distance_gradient = check_distance_gradient(distance, gradient, verbose)
  distance = distance_gradient$distance
  gradient = distance_gradient$gradient
  gradient = gradient + h2
  pcycle_scenario = alpha +
    (d1 * distance) + # d1
    (d2 * sqrt(distance)) + # d2
    # (d3 * distance^2) + # d3
    (h1 * gradient)
  # +    # h1
  # (i1 * distance * gradient) +  # i1
  # (i2 * sqrt(distance) * gradient) # i2
  boot::inv.logit(pcycle_scenario)
}

check_distance_gradient = function(distance, gradient, verbose = TRUE) {
  if (!is.numeric(c(distance, gradient))) {
    stop("distance and gradient need to be numbers.")
  }
  # is it in m
  if (mean(distance, na.rm = TRUE) > 100) {
    if (verbose) {
      message("Distance assumed in m, switching to km")
    }
    distance = distance / 1000
  }
  # is it in %? If mean of gradient is more than 0.1 (10% as ratio), probably
  is_gradient_percent = mean(gradient) > 0.1
  if(!is_gradient_percent) {
    if (verbose) {
      message("Gradient assumed to be gradient, switching to % (*100)")
    }
    gradient = gradient * 100
  }
  list(distance = distance, gradient = gradient)
}
