fm_attr <- function(resp) {
  resp[["attrs"]]
}

get_current_page <- function(resp) {
  as.integer(fm_attr(resp)$page)
}

get_total_pages <- function(resp) {
  as.integer(fm_attr(resp)$totalPages)
}

fm_hasnext <- function(resp) {
  current_page <- get_current_page(resp)
  last_page <- get_total_pages(resp)
  
  current_page + 1 <= last_page
}

fm_next <- function(resp) {
  if (!fm_hasnext(resp)) {
    return(NULL)
  }
  current_page <- get_current_page(resp)
  total_pages <- get_total_pages(resp)
  next_page <- current_page + 1

  query <- resp$request$query
  query$page <- next_page

  fm_log_page(next_page, total_pages)
  lastfm_api(query = query)
}

fm_log_page <- function(next_page, total_pages) {
  logger::log_info("Reading the next page of results: ", next_page , "/", total_pages)
}
