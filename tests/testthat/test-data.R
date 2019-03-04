context("test-data")

test_that("od_leeds", {
  expect_true(exists("od_leeds"))
  expect_true(nrow(od_leeds) == 10)
})

test_that("leeds_uber_sample", {
  expect_true(exists("leeds_uber_sample"))
  expect_true(nrow(leeds_uber_sample) == 10)
})
