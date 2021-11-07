#' Last.FM querying endpoint
#' 
#' @description Used for documenting single-query endpoints
#' 
#' @param .page Page to query, by default query the first page
#' @param .limit Number of response to return in a single request, 50 by
#'   default, the maximum allowed by the last.fm API.
#'   
#' @name single-page-endpoint
NULL

#' Query a Last.FM endpoint.
#'
#' @param method string stating the endpoint to call
#' @param ... named parameters to be passed to the endpoint
#' @inheritParams single-page-endpoint
#'
#' @return A LastFM API object.
#' 
#' @export
lastfmr <- function(method, ..., .limit = 50, .page = 1) {
  params <- prepare_query(method = method, ..., .page = .page, .limit = .limit)
  
  request(api_endpoint()) %>%
    req_url_query(!!!params) %>%
    req_error(body = handle_error) %>%
    req_perform() %>%
    parse_lastfm_response()
}

parse_lastfm_response <- function(resp, params) {
  json_response <- resp_body_json(resp)
  structure(
    list(
      result = parse_result(json_response),
      attrs = parse_response_attribute(json_response),
      response = resp
    ),
    class = "lastfmr"
  )
}

parse_result <- function(resp) {
  tibble::tibble(resp[[1]][[1]])
}

parse_response_attribute <- function(resp) {
  resp[[1]][[2]]
}
