#' Pagination Management
#' 
#' @description 
#' Many of last.fm API responses are paginated with a page size maximum of 50.
#' lastfmr provides a series of functions that help to deal with these pages. 
#' End-users are not expected to interact with these functions directly in most
#' cases since pagination is already taken into account when invoking the raw
#' or tidy data request functions.
#' 
#' * [get_current_page()] and [get_total_pages()] return the current page of a
#' response and the total number of pages available, respectively.
#' * [has_next_page()] checks if there are more pages after the current page.
#' * [get_next_page()] returns the next page after the a response.
#' 
#' @param resp lastfm_api response object
#' 
#' @returns 
#' * [get_current_page()] and [get_total_pages()] return integers
#' * [has_next_page()] returns a boolean
#' * [get_next_page()] returns a `lastfm_api` object
#' 
#' @name pagination
NULL


#' @rdname pagination
get_current_page <- function(resp) {
  as.integer(get_response_attr(resp)$page)
}

#' @rdname pagination
get_total_pages <- function(resp) {
  as.integer(get_response_attr(resp)$totalPages)
}

#' @rdname pagination
has_next_page <- function(resp) {
  current_page <- get_current_page(resp)
  last_page <- get_total_pages(resp)
  
  current_page + 1 <= last_page
}

#' @rdname pagination
get_next_page <- function(resp) {
  if (!has_next_page(resp)) {
    return(NULL)
  }
  current_page <- get_current_page(resp)
  total_pages <- get_total_pages(resp)
  next_page <- current_page + 1

  query <- resp$request$query
  query$page <- next_page

  logger::log_info("Reading the next page of results: ", next_page , "/", total_pages)
  lastfm_api(query = query)
}

get_response_attr <- function(resp) {
  resp[["attrs"]]
}
