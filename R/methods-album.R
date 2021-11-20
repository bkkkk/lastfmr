#' Album Methods
#'
#' @description
#'
#' The methods are used to retrieve information about albums:
#'
#' * [raw_album_get_info()] - Search for an album by name.
#' * [raw_album_search()] - Retrieve information about an album exactly by artist and album name or MBID. If both are provided the Artist and Album name are used by default.
#'
#' @inherit common-params params
#' @inheritSection common-params Language Setting
#' @inheritSection common-params Name Autocorrection
#'
#' @param album Album name as a string.
#' @param artist Artist name as a string.
#' @param username (Optional) Username as a string. If provided, the user playcount of the album is included in the response.
#' @param mbid (Optional) MusicBrainz ID for the album as a string. Can be provided instead of artist and album names
#'
#' @inheritParams paginated-endpoint
#'
#' @returns
#'
#' * [raw_album_search()] returns a list of lastfm objects
#' * [raw_album_get_info()] returns a single lastfm object
#'
#' @name album-methods
NULL


#' @keywords internal
sanitize_raw_album_get_info_parameters <- function(artist = NULL, album = NULL, mbid = NULL) {
  if (is.null(artist) && is.null(album) && is.null(mbid)) {
    abort("`raw_album_get_info` expects to get either an artist and album or the mbid. None were provided.")
  }

  if (!is.null(mbid)) {
    if (!is.null(artist) && !is.null(album)) {
      warn("`raw_album_get_info` got both artist/album names and mbid. The endpoint accepts one or the other. Defaulting to artist and album.")
      mbid <- NULL
    }
  }

  if (xor(!is.null(artist), !is.null(album))) {
    is_null_field <- ifelse(is.null(artist), "artist", "album")
    stop(glue("`raw_album_get_info` is missing {is_null_field} name."))
  }

  list("artist" = artist, "album" = album, "mbid" = mbid)
}

#' @rdname album-methods
#' @export
raw_album_search <- function(album, .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "album.search",
    result_node = "results",
    album = album,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' @rdname album-methods
#' @export
raw_album_get_info <- function(artist = NULL, album = NULL, mbid = NULL, autocorrect = TRUE, username = NULL, lang = NULL) {
  params <- sanitize_raw_album_get_info_parameters(artist, album, mbid)

  lastfm(
    method = "album.getInfo",
    result_node = "album",
    artist = params[["artist"]],
    album = params[["album"]],
    mbid = params[["mbid"]],
    autocorrect = autocorrect,
    lang = lang,
    username = username
  )
}
