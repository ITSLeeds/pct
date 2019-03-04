context("test-data")

test_that("od_leeds", {
  expect_true(exists("od_leeds"))
  expect_true(nrow(od_leeds) == 10)
})
