# Aim: test the pct pkg can reproduce data on www.pct.bike

# see https://github.com/ITSLeeds/pct/issues/65#issuecomment-674237160

# Uptake formula from
# https://raw.githubusercontent.com/npct/pct-shiny/a59ebd1619af4400eeb7ffb2a8ecdd8ce4c3753d/regions_www/www/static/03a_manual/pct-bike-eng-user-manual-c1.pdf
#
# logit (pcycle)= -4.018 +  (-0.6369 *  distance)  +
#   (1.988  * distancesqrt)  +  (0.008775* distancesq) +
#   (-0.2555* gradient) + (0.02006* distance*gradient) +
#   (-0.1234* distancesqrt*gradient)
library(pct)

l_pct_2020 = get_pct_lines(region = "isle-of-wight")
pcycle_pct_2019 = uptake_pct_govtarget(distance = l_pct_2020$rf_dist_km, gradient = l_pct_2020$rf_avslope_perc)
summary(pcycle_pct_2019)
# Min.  1st Qu.   Median     Mean  3rd Qu.     Max.
# 0.004712 0.007869 0.011871 0.014671 0.020958 0.043210
govtarget_slc_2019 = round(pcycle_pct_2019 * l_pct_2020$all + l_pct_2020$bicycle)

cor(l_pct_2020$govtarget_slc, govtarget_slc_2019) # 0.9953986
round(1 - mean(govtarget_slc_2019) / mean(l_pct_2020$govtarget_slc), digits = 5) * 100
# [1] 4.774 # values in pct package 2019 are 5% lower

# previous (2019) values:
alpha = -3.959
d1 = -0.5963
d2 = 1.866
d3 = 0.008050
h1 = -0.2710
i1 = 0.009394
i2 = -0.05135

# New (2020) values:
alpha = -4.018
d1 = -0.6369
d2 = 1.988
d3 = 0.008775
h1 = -0.2555
i1 = 0.02006
i2 = -0.1234

# try to reproduce 2020 values:
pcycle_pct_2020 = uptake_pct_govtarget(
  distance = l_pct_2020$rf_dist_km,
  gradient = l_pct_2020$rf_avslope_perc,
  alpha = alpha,
  d1 = d1,
  d2 = d2,
  d3 = d3,
  h1 = h1,
  i1 = i1,
  i2 = i2
)

govtarget_slc_2020 = round(pcycle_pct_2020 * l_pct_2020$all + l_pct_2020$bicycle)
cor(l_pct_2020$govtarget_slc, govtarget_slc_2020) # 0.9953986
round(1 - mean(govtarget_slc_2020) / mean(l_pct_2020$govtarget_slc), digits = 5) * 100
# 11.599

# from 1st principles
l_pct_2020 = pct::get_pct_lines(region = "isle-of-wight")
l_pct_2020$rf_avslope_perc
l_pct_2020$rf_dist_km
uptake_pct_govtarget_2020 = function(
  distance,
  gradient,
  alpha = -4.018,
  d1 = -0.6369,
  d2 = 1.988,
  d3 = 0.008775,
  h1 = -0.2555,
  i1 = 0.02006,
  i2 = -0.1234
) {
  ned_rf_avslope_perc = gradient - 0.78
  distancesqrt = sqrt(distance)
  distancesq = distance^2
  logit_pcycle = alpha + (d1 *  distance)  +
    (d2 * distancesqrt)  +  (d3 * distancesq) +
    (h1 * ned_rf_avslope_perc) + (i1 * distance*ned_rf_avslope_perc) +
    (i2* distancesqrt*ned_rf_avslope_perc)
  boot::inv.logit(logit_pcycle)
}


pcycle_pct_2020 = uptake_pct_govtarget_2020(
  distance = l_pct_2020$rf_dist_km,
  gradient = l_pct_2020$rf_avslope_perc
  )


govtarget_slc_2020 = pcycle_pct_2020 * l_pct_2020$all + l_pct_2020$bicycle
plot(l_pct_2020$govtarget_slc, govtarget_slc_2020)
cor(l_pct_2020$govtarget_slc, govtarget_slc_2020) # 0.9928463
round(1 - mean(govtarget_slc_2020) / mean(l_pct_2020$govtarget_slc), digits = 5) * 100
# New estimate is less than 0.3% out

# test on national data ---------------------------------------------------

download.file("https://github.com/npct/pct-outputs-national/raw/master/commute/msoa/l_all.Rds",
              "l_all.Rds", mode = "wb")
l_all = readRDS("l_all.Rds")

pcycle_govtarget_uptake = pct::uptake_pct_govtarget(distance = l_all$rf_dist_km, gradient = l_all$rf_avslope_perc)
uptake_pct = round(pcycle_govtarget_uptake * l_all$all + l_all$bicycle)

summary(l_all$govtarget_slc)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 0.000   0.050   0.200   2.579   1.420 715.130
summary(uptake_pct)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 0.000   0.000   0.000   2.275   1.000 700.000
plot(l_all$govtarget_slc, uptake_pct)
cor(l_all$govtarget_slc, uptake_pct)
# 0.9976965
round(1 - mean(uptake_pct) / mean(l_all$govtarget_slc), digits = 5) * 100
# [1] 11.773 # values in pct package are 12% lower


