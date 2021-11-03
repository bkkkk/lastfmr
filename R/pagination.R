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
#' @param resp lastfmr response object
#' 
#' @returns 
#' * [get_current_page()] and [get_total_pages()] return integers
#' * [has_next_page()] returns a boolean
#' * [get_next_page()] returns a `lastfmr` object
#' 
#' @name pagination
NULL

#' Get a concatenated result from multipage endpoints
#'
#' The pagination approach taken here involves constructing successive requests
#' from an initial response. This initial response represents the first page
#' in our multipage request.
#'
#' @param resp response object of type `lastfmr`
#' @param n_pages number of pages to pull
#'
#' @return
#' @export
#'
#' @examples
paginate <- function(resp, n_pages = NULL) {
  stopifnot(inherits(resp, "lastfmr"))
  if (get_current_page(resp) > n_pages) {
    rlang::abort("Total number of pages requested is less than page or response provided.")
  }
  expected_length <- max(n_pages, get_total_pages(resp)) - get_current_page(resp)
  out <- vector("list", length = expected_length)
  i <- 1L
  out[[i]] <- resp # Should include the first response as well

  while (has_next_page(resp) & get_current_page(resp) <= n_pages) {
    out[[i]] <- get_next_page(resp)
  }
  
  out
}


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
  lastfmr(query = query)
}

get_response_attr <- function(resp) {
  resp[["attrs"]]
}
