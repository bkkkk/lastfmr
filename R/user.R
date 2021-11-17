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

#' Title
#'
#' @param username 
#' @param period 
#' @inheritParams paginated-endpoint
#'
#' @return
#' @export
#'
#' @examples
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

#' Title
#'
#' @param username 
#' @param recent_tracks 
#' @inheritParams paginated-endpoint
#' 
#' @family raw user functions
#'
#' @return
#' @export
#'
raw_user_get_friends <- function(username, recent_tracks = TRUE, .start_page = 1, .n_pages = NULL) {
  # TODO Add better handling for missing page for folks without friends :-|
  paginate(
    method = "user.getFriends",
    user = username,
    recenttracks = recent_tracks,
    result_node = "friends",
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' @param username 
#'
#' @inheritParams paginated-endpoint
#' 
#' @family raw user functions
#' 
#' @return 
#'
#' @export
raw_user_get_info <- function(username = NULL, .start_page = 1, .n_pages = NULL) {
  lastfmr(
    method = "user.getInfo",
    user = username,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' 
#'
#' @param username The username as a string
#' @inheritParams paginated-endpoint
#' 
#' @family raw user functions
#' 
#' @return 
#'
#' @export
raw_user_get_loved_tracks <- function(username, .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "user.getLovedTracks",
    result_node = "lovedtracks",
    user = username,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' Get items that were tagged by a user with a specific tag
#' 
#' Items are queried by type using `tagging_type` which can take one of
#' (artist, album, track).
#' 
#' @param username The username as a string
#' @param tag The tag you're interested in.
#' @param tagging_type A string, see description above for accepted types.
#' @inheritParams paginated-endpoint
#' 
#' @family raw user functions
#' 
#' @return 
#'
#' @export
raw_user_get_personal_tags <- function(username, tag, tagging_type, .start_page = 1, .n_pages = NULL) {
  tag_type = match.arg(tagging_type, c("artist", "album", "track"))
  
  paginate(
    method = "user.getPersonalTags",
    result_node = paste0(tag_type, "s"),
    user = username,
    taggingtype = tag_type,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}


#' Get top tags used by a user
#'
#' @param username Username as a string
#' @inheritParams paginated-endpoint
#'
#' @family raw user functions
#' 
#' @return
#' 
#' @export
raw_user_get_top_tags <- function(username, .start_page = 1, .n_pages = NULL) {
  lastfmr(
    method = "user.getTopTags",
    result_node = "toptags",
    user = username,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}
