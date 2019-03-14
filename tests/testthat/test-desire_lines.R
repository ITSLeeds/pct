source("../skip-heavy.R")
context("test-desire_lines")

test_that("get_desire_lines works", {
  skip_heavy()
  expect_equal(nrow(get_desire_lines(n = 10)), 10)
  expect_error(get_desire_lines(area = "baz"))
  expect_error(get_desire_lines(area = ""))
  expect_error(get_desire_lines(area = NULL))
  expect_error(get_desire_lines(area = NA))
  expect_error(get_desire_lines(area = LETTERS))
})
