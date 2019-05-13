source("../skip-heavy.R")
context("test-desire_lines")

test_that("get_desire_lines works", {
  skip_heavy()
  if(.Platform$OS.type == "windows") {
    skip("stplanr might need a env var. Skipping.")
  }
  expect_equal(nrow(get_desire_lines(area = "wight", n = 10)), 10)
  expect_true(nrow(get_desire_lines(area = "isle", omit_intrazonal = TRUE)) > 10)
  expect_error(get_desire_lines(area = "baz"))
  expect_error(get_desire_lines(area = ""))
  expect_error(get_desire_lines(area = NULL))
  expect_equal(nrow(get_od(area = "wight", n = 10)), 10)
  expect_error(get_desire_lines(area = NA))
  expect_error(get_desire_lines(area = LETTERS))
})
