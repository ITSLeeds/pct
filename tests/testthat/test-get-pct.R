source("../skip-heavy.R")

context("test-get-pct")

test_that("get_pct_ works", {
  expect_error(get_pct_zones())
  expect_error(get_pct_centroids())
  expect_error(get_pct(region = NA, layer = NA))
  expect_error(get_pct(region = NA, layer = "z"))
  skip_heavy()
  z = get_pct_zones("isle-of-wight")
  expect_true(nrow(z) == 89)
  z = get_pct_centroids("isle-of-wight")
  expect_true(nrow(z) == 89)
  # national
  # r = get_pct(national = TRUE, layer = "z")
  # expect_true(inherits(r, "sf"))
})
