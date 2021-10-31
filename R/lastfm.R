fm_api_key <- function() {
  key <- Sys.getenv("LASTFM_KEY")
  if (identical(key, "")) {
    stop("LastFM API key not found. Please set env var LASTFM_KEY", call. = FALSE)
  }

  key
}

#' Query a Last.FM endpoint.
#'
#' @param query A list of parameters that define the query. Use `fm_query`
#'   to create an appopriate object.
#'
#' @return A LastFM API object.
#' 
#' @export
fm_api <- function(query, .limit = NULL) {
  params <- prepare_query(query)
  raw <- fm_make_request(params)
  resp <- fm_parse_response(raw, params)
  
  while (fm_hasnext(resp)) {
    resp2 <- fm_next(resp)
    resp$result <- bind_rows(resp$result, resp2$result)
    resp$attrs <- resp2$attrs
    resp$request <- resp2$request
  }
  
  resp
}

fm_make_request <- function(params) {
  baseurl <- "http://ws.audioscrobbler.com/2.0/?"

  url <- httr::modify_url(baseurl, query = add_headers(params))
  httr::GET(url)
}

fm_parse_response <- function(resp, params) {
  if (resp$status_code != 200) {
    stop("Problem with calling the API - response: ", httr::content(resp))
  }

  json_response <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "utf-8"))
  
  structure(
    list(
      result = parse_result(json_response),
      attrs = parse_response_attribute(json_response),
      response = resp,
      request = list(query = params)
    ),
    class = "fm_api"
  )
}

parse_result <- function(resp) {
  tibble::tibble(resp[[1]][[1]])
}

parse_response_attribute <- function(resp) {
  resp[[1]][[2]]
}
