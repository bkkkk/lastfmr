prepare_query <- function(method, page, limit = 50, ...) {
  dots <- list(method = method, page = page, limit = limit, format = "json", ...)
  purrr::compact(purrr::modify_if(dots, lubridate::is.POSIXct, as.numeric))
}
