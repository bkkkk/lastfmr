lastfm_query <- function(method, page = 1, ...) {
  list(method = method, page = page, ...)
}

prepare_query <- function(q) {
  purrr::compact(purrr::modify_if(q, lubridate::is.POSIXct, as.numeric))
}

add_headers <- function(q, limit = 50) {
  purrr::append(q, list(limit = limit, format = "json", api_key = lastfm_api_key()))
}
