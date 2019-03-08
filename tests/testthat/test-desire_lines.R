source("../skip-heavy.R")
context("test-desire_lines")

test_that("pct_area_desire_lines works", {
  skip_heavy()
  expect_equal(nrow(pct_area_desire_lines(n = 10)), 10)
})
