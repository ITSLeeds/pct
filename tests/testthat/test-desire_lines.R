context("test-desire_lines")

test_that("pct_area_desire_lines works", {
  expect_equal(nrow(pct_area_desire_lines(n = 10)), 10)
})
