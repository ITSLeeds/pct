context("test-data")

test_that("od_leeds", {
  expect_true(exists("od_leeds"))
  expect_false(nrow(od_leeds) > 0)
})
