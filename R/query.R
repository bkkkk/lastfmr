#' Query management
#'
#' @name query

prepare_query <- function(method, ..., .page) {
  dots <- list(method = method, page = .page, limit = get_limit(), format = "json", ...)
  purrr::compact(purrr::modify_if(dots, lubridate::is.POSIXct, as.numeric))
}

get_limit <- function() {
  .limit <- getOption("lastfmr.page_size")
  if (.limit > 50) {
    abort("Your provided page ({limit}) size is larger than the API limit of 50.")
  }
  .limit
}

auth_end_user_request <- function(req) {
  req_with_session_key <- req_url_query(req, sk = deobfuscate(get_session_key()))

  auth_client_auth_request(req_with_session_key)
}
