req_query_as_list <- function(req) {
  url <- httr2::url_parse(req$url)
  url$query
}

convert_uts <- function(x) {
  lubridate::as_datetime(as.double(x))
}
