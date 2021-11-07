req_query_as_list <- function(req) {
  url <- httr2::url_parse(req$url)
  url$query
}