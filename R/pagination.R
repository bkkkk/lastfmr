#' Documenting a generic paginated endpoint
#' 
#' @param method The method to query
#' @param .start_page The page to start pulling from, by default starts from the
#'   1st page
#' @param .n_pages The total number of pages to pull. If no value is provided,
#'   all pages are retrieved.
#' @param .limit Total number of results to include in a single page. 50 by default.
#'
#' @name paginated-endpoint
NULL
 
#' A generic paginated request
#' 
#' The pagination approach taken here involves constructing successive requests
#' from an initial response. This initial response represents the first page in
#' our multipage request.
#' 
#' @param ... Endpoint parameters to pass to the API endpoint
#' @inheritParams paginated-endpoint
#' 
#' @return A list of lastfmr objects
#' @export
paginate <- function(method, ..., .start_page = 1, .n_pages = NULL, .limit = 50) {
  out <- vector("list", length = ifelse(is.null(.n_pages), 10, .n_pages))
  i <- 1L
  max_expected_page <- .start_page + .n_pages

  repeat ({
    resp <- lastfmr(method, ...,  .page = .start_page + i - 1, .limit = .limit)

    out[[i]] <- resp
    if (get_current_page(resp) + 1 >= max_expected_page) {
      break
    }
    
    if (!has_next_page(resp)) {
      break
    }
    i <- i + 1
  })
  
  out
}

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
#' @name pagination_helper
NULL

#' @rdname pagination_helper
get_current_page <- function(resp) {
  as.integer(get_response_attr(resp)$page)
}

#' @rdname pagination_helper
get_total_pages <- function(resp) {
  as.integer(get_response_attr(resp)$totalPages)
}

#' @rdname pagination_helper
has_next_page <- function(resp) {
  current_page <- get_current_page(resp)
  last_page <- get_total_pages(resp)
  
  current_page + 1 <= last_page
}

#' @rdname pagination_helper
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
