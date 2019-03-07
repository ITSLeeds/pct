context("test-run-once")

source("../skip-heavy.R")

test_that("run once tests here", {
  skip_heavy()
  # depends on DONT_DOWNLOAD_ANYTHING
  message("Running computation intensive tests.")
})
