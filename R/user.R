#' Get a list of the recent tracks listened to by this user.
#'
#' @param username The last.fm username to fetch the recent tracks of.
#' @param from (optional) Beginning timestamp of a range - only display
#'   scrobbles after this time.
#' @param to (optional) End timestamp of a range - only display scrobbles before
#'   this time.
#' @param extended (optional) Whether to include extended data in each artist, and whether
#'   or not the user has loved each track.
#' @inheritParams paginated-endpoint
#'
#' @family raw user functions
#' 
#' @return A vector of LastFM API objects
#' @export
raw_user_get_recent_tracks <- function(username, from = NULL, to = NULL, extended = 0, .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "user.getrecenttracks",
    result_node = "recenttracks",
    username = username,
    from = from,
    to = to,
    extended = extended,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' Get a list of the recent tracks listened to by this user as tidy data
#'
#' @inheritParams raw_user_get_recent_tracks
#'
#' @family tidy user functions
#' 
#' @return A dataframe
#' @export
user_get_recent_tracks <- function(username, from = NULL, to = NULL, extended = 0, .start_page = 1, .n_pages = NULL) {
  raw_responses <- raw_user_get_recent_tracks(username, from, to, extended, .start_page, .n_pages)
  tidy_raw_response(raw_responses, function(record) {
    tibble(
      mbid = map_chr(record, "mbid"),
      artist = map_chr(record, c("artist", "#text")),
      album = map_chr(record, c("album", "#text")),
      name = map_chr(record, "name"),
      date_text = map_chr(record, c("date", "#text")),
      date = convert_uts(map_chr(record, c("date", "uts"))),
      streamable = as.integer(map_chr(record, "streamable")),
      url = map_chr(record, "url")
    )
  }, .path = "track")
}

#' Get the top albums listened to by a user. You can stipulate a time period. Sends the overall chart by default.
#'
#' @param username The user name to fetch top albums for.
#' @param period (optional) overall | 7day | 1month | 3month | 6month | 12month - The time period over which to retrieve top albums for.
#' @inheritParams paginated-endpoint
#' 
#' @family raw user functions
#' 
#' @return A LastFM API object
#' @export
raw_user_get_top_albums <- function(username, period = "7day", .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "user.getTopAlbums",
    result_node = "topalbums",
    username = username,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' Get the top albums by scrobbles for a given user as tidy data
#' 
#' You can stipulate a time period. Sends the overall chart by default.
#'
#' @inheritParams raw_user_get_top_albums
#'
#' @family tidy user functions
#'
#' @return a tibble
#' @export
user_get_top_albums <- function(username, period = "7day", .start_page = 1, .n_pages = NULL) {
  raw_results <- raw_user_get_top_albums(username, period, .start_page, .n_pages)

  tidy_raw_response(raw_results, .tidy = function(record) {
    tibble::tibble(
      rank = as.integer(purrr::map_chr(record, c("@attr", "rank"))),
      mbid = map_chr(record, "mbid"),
      name = map_chr(record, "name"),
      artist_name = map_chr(record, c("artist", "name")),
      url = map_chr(record, "url"),
    )
  }, .path = "album")
}

#' Get the top artists listened to by a user
#' 
#' You can stipulate a time period. Sends the overall chart by default.
#'
#' @param username The user name to fetch top artists for.
#' @param period (optional) overall | 7day | 1month | 3month | 6month | 12month - The time period over which to retrieve top artists for.
#' @inheritParams paginated-endpoint
#'
#' @family raw user functions
#' 
#' @return A LastFM API object
#' @export
raw_user_get_top_artists <- function(username, period = "7day", .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "user.getTopArtists",
    username = username,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' Get the top artists listened to by a user as tidy data
#' 
#' You can stipulate a time period. Sends the overall chart by default.
#'
#' @inheritParams raw_user_get_top_artists
#' 
#' @family tidy user functions
#' 
#' @return a dataframe
#' @export
user_get_top_artists <- function(username, period = "7day", .start_page = 1, .n_pages = NULL) {
  raw_results <- raw_user_get_top_artists(username, period, .start_page, .n_pages)
  
  tidy_raw_response(raw_results, function(record) {
    tibble::tibble(
      rank = as.integer(purrr::map_chr(record, c("@attr", "rank"))),
      mbid = purrr::map_chr(record, "mbid"),
      name = purrr::map_chr(record, "name"),
      playcount = as.integer(purrr::map_chr(record, "playcount")),
      url = purrr::map_chr(record, "url"),
      streamable = as.logical(purrr::map_chr(record, "streamable"))
    )
  })
}

#' Get the top tracks listened to by a user. You can stipulate a time period.
#' Sends the overall chart by default.
#'
#' @param username The user name to fetch top tracks for.
#' @param period overall | 7day | 1month | 3month | 6month | 12month - The time
#'   period over which to retrieve top tracks for.
#' @inheritParams paginated-endpoint
#' 
#' @family raw user functions
#' 
#' @return A LastFM API object
#' @export
raw_user_get_top_tracks <- function(username, period = "7day", .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "user.getTopTracks",
    username = username,
    period = period,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

user_get_top_tracks <- function(username, period = "7day", .start_page = 1, .n_pages = NULL) {
  raw_results <- raw_user_get_top_tracks(username, period, .start_page, .n_pages)

  tidy_raw_response(raw_results, function(record) {
    tibble::tibble(
      rank = as.integer(purrr::map_chr(record, c("@attr", "rank"))),
      mbid = purrr::map_chr(record, "mbid"),
      name = purrr::map_chr(record, "name"),
      playcount = as.integer(purrr::map_chr(record, "playcount")),
      url = purrr::map_chr(record, "url"),
      streamable = as.integer(purrr::map_chr(record, "streamable"))
    )
  })
}

# TODO user.getFriends
# TODO user.getInfo
# TODO user.getLovedTracks
# TODO user.getPersonalTags
# TODO user.getTopTags
