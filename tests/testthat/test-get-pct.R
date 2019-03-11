context("test-get-pct")

test_that("get_pct_zones works", {
  z = get_pct_zones("isle-of-wight")
  expect_true(nrow(z) == 18)
  z = get_pct_centroids("isle-of-wight")
  expect_true(nrow(z) == 18)
})
