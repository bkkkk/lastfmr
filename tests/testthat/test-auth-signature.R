test_that("Test fragment signature creation", {
  expect_equal(create_signature_fragment(list(w = "orld", w = "orld", hel = "lo")), "helloworld")
})
