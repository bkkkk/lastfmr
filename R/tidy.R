#' Raw response tidying
#' 
#' @description Used for documenting tidying functions
#' 
#' @name tidy-function
#' 
#' @return A tibble
NULL

tidy_raw_response <- function(.x, .tidy, .path = "data") {
  path <- unique(c("data", path))
  .result <- if (inherits(.x, "list")) {
    map(.x, path)
  } else {
    pluck_data(.x, path)
  }
  map_df(.result, .tidy)
}

pluck_data <- function(.x, .path) {
  pluck(.x, !!!.path)
}
