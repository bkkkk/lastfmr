lastfm_api_key <- function() {
  key <- Sys.getenv('LASTFM_KEY')
  if (identical(key, '')) {
    stop('LastFM API key not found. Please set env var LASTFM_KEY', call. = FALSE)
  }

  key
}

#' Title
#'
#' @param api_method 
#' @param startpage 
#' @param ... 
#'
#' @return
#' @export
#'
#' @importFrom httr modify_url GET content
#' @importFrom jsonlite fromJSON
lastfm_api <- function(query) {
  baseurl <- 'http://ws.audioscrobbler.com/2.0/?'

  params <- append(list(limit = 50, format = "json", api_key = lastfm_api_key()), query)

  url <- modify_url(baseurl, query = params)
  resp <- GET(url)
  
  if (resp$status_code != 200) {
    stop("Problem with calling the API - response: ", content(resp))
  }
  
  json_response <- fromJSON(content(resp, as = "text", encoding = "utf-8"))
  
  structure(
    list(
      result = parse_result(json_response),
      attrs = parse_response_attribute(json_response),
      response = resp,
      request = list(query=params)
    ),
    class = "lastfm_api"
  )
}

#' @importFrom tibble tibble
parse_result <- function(resp) {
  tibble::tibble(resp[[1]][[1]])
}

parse_response_attribute <- function(resp) {
  resp[[1]][[2]]
}
