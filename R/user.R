#' Get recently played tracks by username
#'
#' @param username
#'
#' @return
#' @export
lastfm_get_recent_tracks <- function(username, page = 1) {
  query <- list(
    method = "user.getrecenttracks",
    username = username,
    page = page
  )
  lastfm_api(query)
}

#' Title
#'
#' @param username
#' @param period
#' @param page
#'
#' @return
#' @export
lastfm_get_top_albums <- function(username, period = "7day", page = 1) {
  query <- list(
    method = "user.getTopAlbums",
    username = username,
    page = page
  )
  lastfm_api(query)
}

#' Title
#'
#' @param username
#' @param period
#' @param page
#'
#' @return
#' @export
lastfm_get_top_artists <- function(username, period = "7day", page = 1) {
  query <- list(
    method = "user.getTopArtists",
    username = username,
    page = page
  )
  lastfm_api(query)
}

#' Title
#'
#' @param username
#' @param period
#' @param page
#'
#' @return
#' @export
lastfm_get_top_tracks <- function(username, period = "7day", page = 1) {
  query <- list(
    method = "user.getTopTracks",
    username = username,
    page = page
  )
  lastfm_api(query)
}
