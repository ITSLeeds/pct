#' Uptake scenario for OD?
#'
#' Uptake model that takes distance and hilliness and returns
#' a percentage of people likely to cycle along a desire line.
#' Source: appendix of pct paper:
#' https://www.jtlu.org/index.php/jtlu/article/downloadSuppFile/862/360
#'
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
  d2 = 1.832,
  d3 = 0.007956,
  h1 = -0.2872,
  i1 = 0.01784,
  i2 = -0.09770
) {
  # is it in m
  if(mean(distance) > 1000) {
    message("Distance assumed in m, switching to km")
    distance = distance / 1000
  }
  distance = l$length / 1000
  gradient = l$cum_hill
  pcycle_scenario = alpha + (d1 * distance) +
    (d2 * sqrt(distance) ) + (d3 * distance^2)
  + (h1 * gradient) +
    (i1 * distance * gradient) +
    (i2 * sqrt(distance) * gradient)
  boot::inv.logit(pcycle_scenario)
}

