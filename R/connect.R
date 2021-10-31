params <- list(
  method = 
  
)

lastfm_api_key <- function() {
  key <- Sys.getenv('LASTFM_KEY')
  if (identical(key, '')) {
    stop('LastFM API key not found. Please set env var LASTFM_KEY', call. = FALSE)
  }

  key
}

lastfm_api <- function(endpoint, startpage = 0, ...) {
  baseurl <- 'http://ws.audioscrobbler.com/2.0/?'
  
  params <- list(
    method = endpoint,
    api_key = lastfm_api_key(),
    page = startpage,
    limit = 50,
    format = "json",
    ...
  )
  
  url <- modify_url(baseurl, query = params)
  resp <- GET(url)
  
  if (resp$status_code != 200) {
    stop("Problem with calling the API - response: ", content(req))
  }
  structure(
    list(
      content = fromJSON(content(resp, as = "text")),
      method = method,
      response = resp
    ),
    class = "lastfm_api"
  )
}

get_recent_tracks <- function(username) {
  resp <- lastfm_api('user.getrecenttracks', )
  json_response <- resp[["content"]][["recenttracks"]]
  json_response 
  structure(
    list(
      content = get_tracklist(json_response),
      total_pages = get_pageinfo(json_response)
    ),
    class = "lastfm_api"
  )
}

get_pageinfo <- function(response) {
  as.integer(response[["@attr"]]$totalPages)
}

get_tracklist <- function(response) {
  response$track
}
