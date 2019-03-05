#' Uptake scenario for OD?
#'
#' Uptake model that takes distance and hilliness and returns
#' a percentage of people likely to cycle along a desire line.
#' Source: appendix of pct paper:
#' https://www.jtlu.org/index.php/jtlu/article/downloadSuppFile/862/360
#'
#' @param distance Vector distance numeric values of routes.
#' @param gradient Vector gradient numeric values of routes.
#' @param d1 document!
#' @param d2
#' @param d3
#' @param h1
#' @param i1
#' @param i2
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
  boot::inv.logit(pcycle_scenario)
}

#' Go Dutch
#' @import uptake_pct_govtarget
#' TODO: extract the shared parts between the two
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
