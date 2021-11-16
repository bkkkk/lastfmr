#' Documenting a generic paginated endpoint
#' 
#' @param method the method to query
#' @param result_node a string with the name of record in the response
#' @param .start_page the page to start pulling from, by default starts from the
#'   1st page
#' @param .n_pages the total number of pages to pull. If no value is provided,
#'   all pages are retrieved.
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
#' @param is_opensearch Is the response paginated using OpenSearch
#' @inheritParams paginated-endpoint
#' 
#' @return A list of lastfmr objects
#' @export
paginate <- function(method, ..., result_node = NULL, .start_page = 1, .n_pages = NULL) {
  out <- vector("list", length = ifelse(is.null(.n_pages), 10, .n_pages))
  i <- 1L

  log_info("Reading paginated endpoint {method}")

  .n_pages <- ifelse(is.null(.n_pages), 5000, .n_pages)
  
  log_info("Using limit of {.n_pages} pages, starting from {.start_page}")

  pb <- progress::progress_bar$new(format = "Downloading multiple pages :bar", total = .n_pages)
  withr::defer(pb$terminate())
  
  repeat ({
    resp <- lastfmr(method, ..., result_node = result_node, .page = .start_page + i - 1)
  
    out[[i]] <- resp

    if (get_current_page(resp) + 1 >= .start_page + .n_pages) {
      break
    }
    
    if (!has_next_page(resp)) {
      break
    }
    i <- i + 1

    pb$update(i / get_total_pages(resp))
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
#' 
#' @param resp lastfmr response object
#' 
#' @returns 
#' * [get_current_page()] returns an integer
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

get_response_attr <- function(resp) {
  response_data <- resp$data
  if (!is.null(response_data[["opensearch:totalResults"]])) {
    items_per_page = as.integer(response_data[["opensearch:itemsPerPage"]])
    total_items = as.integer(response_data[["opensearch:totalResults"]])

    return (list(
      totalPages = total_pages(total_items, items_per_page),
      page = as.integer(response_data[["opensearch:Query"]][["startPage"]])
    ))
  } else {
    response_data[["@attr"]]
  }
}

total_pages <- function(total_items, items_per_page) {
  return (trunc(total_items / items_per_page) + (total_items %% items_per_page > 0))
}
