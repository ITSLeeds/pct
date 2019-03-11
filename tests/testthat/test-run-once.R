context("test-run-once")

source("../skip-heavy.R")

test_that("run once tests here", {
  skip_heavy()
  # depends on PCT_RUN_HEAVY_TESTS
  message("Running computation intensive tests.")
})
