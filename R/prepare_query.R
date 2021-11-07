prepare_query <- function(method, ..., .page, .limit = 50) {
  check_limit(.limit)
  dots <- list(method = method, page = .page, limit = .limit, format = "json", ...)
  purrr::compact(purrr::modify_if(dots, lubridate::is.POSIXct, as.numeric))
}

check_limit <- function(.limit) {
  if (.limit > 50) {
    abort("Your provided page ({limit}) size is larger than the API limit of 50.")
  }
}
