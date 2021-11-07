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
