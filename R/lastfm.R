lastfm_api_key <- function() {
  key <- Sys.getenv("LASTFM_KEY")
  if (identical(key, "")) {
    stop("LastFM API key not found. Please set env var LASTFM_KEY", call. = FALSE)
  }

  key
}

#' Query a Last.FM endpoint.
#'
#' @param query A list of parameters that define the query. Use `lastfm_query`
#'   to create an appopriate object.
#'
#' @return A LastFM response object including the response from the endpoint,
#'   pagination information and the request.
#' @export
lastfm_api <- function(query) {
  baseurl <- "http://ws.audioscrobbler.com/2.0/?"

  params <- prepare_query(query)

  url <- httr::modify_url(baseurl, query = add_headers(params))
  resp <- httr::GET(url)

  if (resp$status_code != 200) {
    stop("Problem with calling the API - response: ", content(resp))
  }

  json_response <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "utf-8"))

  structure(
    list(
      result = parse_result(json_response),
      attrs = parse_response_attribute(json_response),
      response = resp,
      request = list(query = params)
    ),
    class = "lastfm_api"
  )
}

parse_result <- function(resp) {
  tibble::tibble(resp[[1]][[1]])
}

parse_response_attribute <- function(resp) {
  resp[[1]][[2]]
}
