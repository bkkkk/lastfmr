#' Query management
#' 
#' @name query

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

auth_end_user_request <- function(req) {
  req_with_session_key <- req_url_query(req, sk = deobfuscate(get_session_key()))

  auth_client_auth_request(req_with_session_key)
}
