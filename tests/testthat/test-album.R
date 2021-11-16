test_that("Test sanitize raw album info parameters works with only mbid", {
  test_mbid <- 'MBID_TEST'
  result <- sanitize_raw_album_get_info_parameters(mbid = test_mbid)
  expect_null(result[["artist"]])
  expect_null(result[["album"]])
  expect_equal(result[["mbid"]], test_mbid)
})
