context("test-get-pct")

test_that("get_pct_ works", {
  expect_error(get_pct_zones())
  expect_error(get_pct_centroids())
  z = get_pct_zones("isle-of-wight")
  expect_true(nrow(z) == 18)
  z = get_pct_centroids("isle-of-wight")
  expect_true(nrow(z) == 18)
})
