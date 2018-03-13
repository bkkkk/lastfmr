connect_to_server <- function(username, startpage) {
  baseurl <- 'http://ws.audioscrobbler.com/2.0/?'

  params <- list(
    method = 'user.getrecenttracks',
    api_key = 'e38cc7822bd7476fe4083e36ee69748e',
    user = username,
    page = startpage,
    limit = 50,
    format = 'json'
  )

  url <- modify_url(baseurl, query = params)
  resp <- GET(url)

  if (resp$status_code != 200) {
    stop("Problem with calling the API - response: ", content(req))
  }

  resp <- content(resp, as = "text")
  json_response <- fromJSON(resp)
  json_response <- json_response$recenttracks

  structure(
    list(
      content = get_tracklist(json_response),
      username = username,
      total_pages = get_pageinfo(json_response)
    ),
    class = "lastfm_api"
  )
}

print.lastfm_api <- function(x, ...) {
  cat("<LastFM ", x$username, ">\n", sep = "")
  cat("<Total Pages: ", x$total_pages, ">\n", sep = "")

  print(x$content)
  invisible(x)
}

get_pageinfo <- function(response) {
  as.integer(response[["@attr"]]$totalPages)
}

get_tracklist <- function(response) {
  response$track
}
