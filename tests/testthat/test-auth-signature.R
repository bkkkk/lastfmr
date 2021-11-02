test_that("Test fragment signature creation", {
  parameters <- list(w = "orld", format = "json", hel = "lo")
  expect_equal(create_signature_fragment(parameters), "helloworld")
})

test_that("Test signing a request", {
  parameters <- list(w = "orld", format = "json", hel = "lo")
  result <- sign_request(parameters, client_secret = "secret")
  expect_length(result, length(parameters) + 1)
  expect_true(exists('api_sig', result))
  expect_equal(result$api_sig, "b1bf6554f200db7230b45c43c530e8d6")
})
