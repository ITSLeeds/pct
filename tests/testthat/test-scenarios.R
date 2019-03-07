context("test-scenarios")

test_that("1 and 1 test is 0.04768831", {
  # need to compare some data
  expect_equal(uptake_pct_govtarget(1,1), 0.04768831)
})
