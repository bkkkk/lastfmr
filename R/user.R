#' User Methods
#' 
#' @description 
#' 
#' These functions retrieve information about Last.fm users. Users are identified
#' by `username`:
#' 
#' * [raw_user_get_recent_tracks()] retrieve a list of recent tracks scrobbled by the user.
#' * [raw_user_get_top_albums()], [raw_user_get_top_artists()],
#'   and [raw_user_get_top_tracks()] retrieve lists of top albums, artists,
#'   and tracks respectively played by the user.
#' 
#' @param username The username as a string
#' @param from (Optional) Beginning timestamp of a range - only display
#'   scrobbles after this time.
#' @param to (Optional) End timestamp of a range - only display scrobbles before
#'   this time.
#' @param extended (Optional) Whether to include extended data in each artist, and whether
#'   or not the user has loved each track.
#' @param recent_tracks (Optional) Whether to include recent tracks fro friends in the response
#' @param tag The tag you're interested in.
#' @inheritParams match_period
#' @inheritParams match_tagging_type
#'
#' @inherit paginated-endpoint params
#' 
#' @name user-methods
NULL


#' @family raw user functions
#' @rdname user-methods
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

#' @family tidy user functions
#' @rdname user-methods
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

#' @family raw user functions
#' @rdname user-methods
#' @export
raw_user_get_top_albums <- function(username, period = "7day", .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "user.getTopAlbums",
    result_node = "topalbums",
    period = match_period(period),
    username = username,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' @family tidy user functions
#' @rdname user-methods
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

#' @family raw user functions
#' @rdname user-methods
#' @export
raw_user_get_top_artists <- function(username, period = "7day", .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "user.getTopArtists",
    username = username,
    period = match_period(period),
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' @family tidy user functions
#' @rdname user-methods
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

#' @family raw user functions
#' @rdname user-methods
#' @export
raw_user_get_top_tracks <- function(username, period = "7day", .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "user.getTopTracks",
    username = username,
    period = match_period(period),
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' @family tidy user functions
#' @rdname user-methods
#' @export
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

#' @family raw user functions
#' @rdname user-methods
#' @export
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

#' @family raw user functions
#' @rdname user-methods
#' @export
raw_user_get_info <- function(username = NULL, .page = 1) {
  lastfmr(
    method = "user.getInfo",
    user = username,
    .page = .page
  )
}

#' @family raw user functions
#' @rdname user-methods
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

#' @family raw user functions
#' @rdname user-methods
#' @export
raw_user_get_personal_tags <- function(username, tag, tagging_type, .start_page = 1, .n_pages = NULL) {
  tag_type <- match_tagging_type(tagging_type)

  paginate(
    method = "user.getPersonalTags",
    result_node = paste0(tag_type, "s"),
    user = username,
    taggingtype = tag_type,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' @family raw user functions
#' @rdname user-methods
#' @export
raw_user_get_top_tags <- function(username, .page = 1) {
  lastfmr(
    method = "user.getTopTags",
    result_node = "toptags",
    user = username,
    .page = .page
  )
}

#' Validate period
#' @param period (Optional) The time period to aggregate tracks/albums/artists over as a string.
#'    One of overall, 7day, 1month, 3month, 6month, 12month. `7day` by default.
#' @keywords internal
match_period <- function(period = "7day") {
  arg_match(period, c("overall", "7day", "1month", "3month", "6month", "12month"))
}

#' Validate tagging type
#' @param tagging_type The objects on which the tags were applied as a string
#' @keywords internal
match_tagging_type <- function(tagging_type) {
  arg_match(tagging_type, c("artist", "album", "track"))
}
