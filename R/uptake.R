#' Calculate cycling uptake for UK 'Government Target' scenario
#'
#' Uptake model that takes distance and hilliness and returns
#' a percentage of people likely to cycle along a desire line.
#' Source: appendix of pct paper, hosted at:
#' [www.jtlu.org](https://www.jtlu.org/index.php/jtlu/article/downloadSuppFile/862/360)
#' which states that:
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
#' @param distance Vector distance numeric values of routes.
#' @param gradient Vector gradient numeric values of routes.
#' @param alpha The intercept
#' @param d1 Distance term 1
#' @param d2 Distance term 2
#' @param d3 Distance term 3
#' @param h1 Hilliness term 1
#' @param i1 document!
#' @param i2 document!
#'
#' @export
#' @examples
#' l = routes_fast_leeds
#' pcycle_scenario = uptake_pct_govtarget(l$length, l$cum_hill)
#' plot(l$length, pcycle_scenario)
uptake_pct_govtarget = function(
  distance,
  gradient,
  alpha = -3.959,
  d1 = -0.5963,
  d2 = 1.866,
  d3 = 0.008050,
  h1 = -0.2710,
  i1 = 0.009394,
  i2 = -0.05135
) {
  if(!exists(c("distance", "gradient")) |
     !is.numeric(c(distance, gradient))) {
    stop("distance and gradient need to be numbers.")
  }
  # is it in m
  if(mean(distance) > 1000) {
    message("Distance assumed in m, switching to km")
    distance = distance / 1000
  }
  # = α + d1x + d2sqrt(x) + d3x^2 + hy + i1xy + i2sqrt(x)y
  # = α + d1x + d2i2xy + d3x^2 + hy + i1xy
  # = α + d1x + d2i2i12xy + d3x^2 + hy
  # = α + d3x^2 + d2i2i12xy + d1x + hy
  ##############################
  # = α + ax^2 + bxy + cx + dy #
  ##############################
  # a = 0.008050
  # b = -0.000900
  # c = -0.5963
  # d = -0.2710
  pcycle_scenario = alpha +
    (d1 * distance) +    # d1
    (d2 * sqrt(distance)) +  # d2
    (d3 * distance^2) + # d3
    (h1 * gradient) +    # h1
    (i1 * distance * gradient) +  # i1
    (i2 * sqrt(distance) * gradient) # i2
  boot::inv.logit(pcycle_scenario)
}

#' Calculate cycling uptake for UK 'Go Dutch' scenario
#'
#' See [uptake_pct_govtarget()].
#'
#' @inheritParams uptake_pct_govtarget
#' @export
uptake_pct_godutch = function(
  distance,
  gradient,
  alpha = -3.959,
  d1 = -0.5963,
  d2 = 1.832,
  d3 = 0.007956,
  h1 = -0.2872,
  i1 = 0.01784,
  i2 = -0.09770
) {
  if(!exists(c("distance", "gradient")) |
     !is.numeric(c(distance, gradient))) {
    stop("distance and gradient need to be numbers.")
  }
  # is it in m
  if(mean(distance) > 1000) {
    message("Distance assumed in m, switching to km")
    distance = distance / 1000
  }
  pcycle_scenario = alpha + (d1 * distance) +
    (d2 * sqrt(distance) ) + (d3 * distance^2) +
    (h1 * gradient) +
    (i1 * distance * gradient) +
    (i2 * sqrt(distance) * gradient)
  # looks like this
  pcycle_scenario = pcycle_scenario + 2.499 -0.07384 * distance
  boot::inv.logit(pcycle_scenario)
}
