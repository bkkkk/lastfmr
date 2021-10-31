lastfm_attr <- function(resp) {
  resp[["attrs"]]
}

get_current_page <- function(resp) {
  as.integer(lastfm_attr(resp)$page)
}

get_total_pages <- function(resp) {
  as.integer(lastfm_attr(resp)$totalPages)
}

lastfm_previous <- function(resp) {
  current_page <- get_current_page(resp)

  if (current_page - 1 == 0) {
    NULL
  }

  query <- resp$request$query
  query$page <- current_page - 1
  lastfm_api(query = query)
}

lastfm_next <- function(resp) {
  current_page <- get_current_page(resp)
  last_page <- get_total_pages(resp)

  if (current_page + 1 > last_page) {
    NULL
  }

  query <- resp$request$query
  query$page <- current_page + 1
  lastfm_api(query = query)
}
