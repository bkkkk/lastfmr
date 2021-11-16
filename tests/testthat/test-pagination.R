test_that("Getting pagination attributes works with @attr mode", {
  attr_info <- list(`@attr` = list(totalPages = 10, nextPage = 1))
  resp <- list(data = list(`@attr` = attr_info))

  result <- get_response_attr(resp)
  expect_equal(result, attr_info)
})

test_that("Getting pagination attributes works with opensearch mode", {
  attr_info <- list(`opensearch:totalResults` = "58583", `opensearch:Query` = list(
    `#text` = "", role = "request", searchTerms = "Atlas", startPage = "1"), 
    `opensearch:itemsPerPage` = "50")
  resp <- list(data = attr_info)
  
  result <- get_response_attr(resp)
  expect_equal(result, list(totalPages = 1172, page = 1))
})
