context("test-scenarios")

test_that("uptake_pct_govtarget(1,1) should be 0.04768831", {
  # need to compare some data
  expect_equal(uptake_pct_govtarget(1,1), 0.04768831)
})

test_that("uptake_pct_godutch(1,1) should be round(0.341359, digits = 5)", {
  # need to compare some data
  expect_equal(round(uptake_pct_godutch(1,1), digits = 5),
               0.34136)
})
