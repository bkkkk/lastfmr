fm_query <- function(method, page = 1, ...) {
  list(method = method, page = page, ...)
}

prepare_query <- function(q) {
  purrr::compact(purrr::modify_if(q, lubridate::is.POSIXct, as.numeric))
}

add_headers <- function(q, limit = 50) {
  append(q, list(limit = limit, format = "json", api_key = default_api_key()))
}
