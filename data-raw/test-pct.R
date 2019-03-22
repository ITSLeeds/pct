# Aim: test the pct pkg can reproduce data on www.pct.bik

download.file("https://github.com/npct/pct-outputs-national/raw/master/commute/msoa/l_all.Rds",
              "l_all.Rds", mode = "wb")
l_all = readRDS("l_all.Rds")

pcycle_govtarget_uptake = pct::uptake_pct_govtarget(distance = l_all$rf_dist_km, gradient = l_all$rf_avslope_perc)
uptake_pct = round(pcycle_govtarget_uptake * l_all$all + l_all$bicycle)


summary(l_all$govtarget_slc)
summary(uptake_pct)
plot(l_all$govtarget_slc, uptake_pct)
cor(l_all$govtarget_slc, uptake_pct)
