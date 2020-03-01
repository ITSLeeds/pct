source("../skip-heavy.R")
context("test-desire_lines")

test_that("get_desire_lines works", {
  skip_heavy()
  skip_on_cran()
  if(.Platform$OS.type == "windows") {
    skip("stplanr might need a env var. Skipping.")
  }
  expect_equal(nrow(get_desire_lines(region = "wight", n = 10)), 10)
  expect_true(nrow(get_desire_lines(region = "isle", omit_intrazonal = TRUE)) > 10)
  expect_error(get_desire_lines(region = "baz"))
  expect_error(get_desire_lines(region = ""))
  expect_error(get_desire_lines(region = NULL))
  expect_equal(nrow(get_od(region = "wight", n = 10)), 10)
  expect_error(get_desire_lines(region = NA))
  expect_error(get_desire_lines(region = LETTERS))
})
