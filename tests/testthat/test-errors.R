test_that("Error catching in case of error works", {
  expect_error(handle_error(list(error = "Error", message = "Gorbble")), "Gorbble")
})

test_that("Error catching with no error passes value", {
  expect_equal(handle_error(list(something_else = "test")), list(something_else = "test"))
})
