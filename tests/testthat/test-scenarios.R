context("test-scenarios")

test_that("uptake_pct_govtarget(1,1) should be 0.04768831", {
  # need to compare some data
  expect_equal(uptake_pct_govtarget(1,1), 0.04768831)
})

test_that("uptake_pct_godutch(1,1) should be 0.04768831", {
  # need to compare some data
  # expect_equal(uptake_pct_godutch(1,1), 0.04768831)
})
