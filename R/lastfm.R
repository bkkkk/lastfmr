#' Last.FM querying endpoint
#'
#' @description Used for documenting single-query endpoints
#'
#' @param method The name of the API method [found here](https://www.last.fm/api).
#' @param result_node The node in the response that contains the data.
#' @param .page Page to query, by default query the first page
#'
#' @name single-page-endpoint
#'
#' @return A lastfmr API object, see [lastfmr()] for information.
NULL

#' Query a Last.FM endpoint.
#'
#' @param ... named parameters to be passed to the endpoint
#'
#' @inherit single-page-endpoint return params
#'
#' @export
lastfmr <- function(method, ..., .page = 1, result_node = NULL) {
  params <- prepare_query(method = method, ..., .page = .page)

  request(api_endpoint()) %>%
    req_url_query(!!!params) %>%
    auth_end_user_request() %>%
    req_error(body = handle_error) %>%
    req_perform() %>%
    parse_lastfm_response(result_node = result_node)
}

parse_lastfm_response <- function(resp, result_node = NULL) {
  json_response <- resp_body_json(resp)

  if (!is.null(result_node)) {
    json_response <- json_response[[result_node]]
  }

  structure(
    list(
      data = json_response,
      response = resp
    ),
    class = "lastfmr"
  )
}

parse_response_attribute <- function(resp) {
  resp[[1]][[2]]
}
