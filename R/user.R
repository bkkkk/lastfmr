#' Get a list of the recent tracks listened to by this user.
#'
#' @param username The last.fm username to fetch the recent tracks of.
#' @param page (optional) The page number to fetch. Defaults to first page.
#' @param from (optional) Beginning timestamp of a range - only display
#'   scrobbles after this time.
#' @param to (optional) End timestamp of a range - only display scrobbles before
#'   this time.
#' @param extended (optional) Whether to include extended data in each artist, and whether
#'   or not the user has loved each track.
#'
#' @family raw
#' 
#' @return A LastFM API object
#' @export
raw_user_get_recent_tracks <- function(username, from = NULL, to = NULL, extended = 0, page = 1) {
  lastfm_api(fm_query(
    method = "user.getrecenttracks",
    username = username,
    from = from,
    to = to,
    extended = 0,
    page = page
  ))
}

#' Get the top albums listened to by a user. You can stipulate a time period. Sends the overall chart by default.
#'
#' @param username The user name to fetch top albums for.
#' @param period (optional) overall | 7day | 1month | 3month | 6month | 12month - The time period over which to retrieve top albums for.
#' @param page The page number to fetch. Defaults to first page.
#'
#' @family raw
#' 
#' @return A LastFM API object
#' @export
raw_user_get_top_albums <- function(username, period = "7day", page = 1) {
  lastfm_api(fm_query(
    method = "user.getTopAlbums",
    page = page,
    username = username
  ))
}

#' Get the top artists listened to by a user. You can stipulate a time period. Sends the overall chart by default.
#'
#' @param username The user name to fetch top artists for.
#' @param period (optional) overall | 7day | 1month | 3month | 6month | 12month - The time period over which to retrieve top artists for.
#' @param page (optional) The page number to fetch. Defaults to first page.
#'
#' @family raw
#' 
#' @return A LastFM API object
#' @export
raw_user_get_top_artists <- function(username, period = "7day", page = 1) {
  lastfm_api(fm_query(
    method = "user.getTopArtists",
    username = username,
    page = page
  ))
}

#' Get the top tracks listened to by a user. You can stipulate a time period.
#' Sends the overall chart by default.
#'
#' @param username The user name to fetch top tracks for.
#' @param period overall | 7day | 1month | 3month | 6month | 12month - The time
#'   period over which to retrieve top tracks for.
#' @param page The page number to fetch. Defaults to first page.
#'
#' @return A LastFM API object
#' @export
raw_user_get_top_tracks <- function(username, period = "7day", page = 1) {
  lastfm_api(fm_query(
    method = "user.getTopTracks",
    username = username,
    page = page
  ))
}

# TODO user.getFriends
# TODO user.getInfo
# TODO user.getLovedTracks
# TODO user.getPersonalTags
# TODO user.getTopTags
