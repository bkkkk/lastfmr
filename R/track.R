#' Search for a track by track name. Returns track matches sorted by relevance.
#'
#' @inherit single-page-endpoint return
#'
#' @param track The track name.
#' @param artist Narrow your search by specifying an artist, if not provided the
#'   endpoint searches across artists
#'
#' @export
raw_track_search <- function(track, artist = NULL, .page = 1) {
  lastfmr(
    method = "track.search",
    result_node = "results",
    track = track,
    artist = artist,
    .page = .page
  )
}

track_search <- function(track, artist = NULL, .start_page = 1, .n_pages = NULL) {
  raw_response <- raw_track_search(track, artist, .start_page, .n_pages)

  tidy_raw_response(raw_response, function(record) {
    tibble::tibble(
      name = map_chr(record, "name"),
      name = map_chr(record, "artist"),
      listeners = map_chr(record, "listeners"),
      mbid = map_chr(record, "mbid"),
      url = map_chr(record, "url"),
    )
  }, .path = c("trackmatches", "track"))
}


#' Get track information
#'
#' The track can be retrieved by:
#'     1. Artist and track name OR
#'     2. MusicBrainz ID
#'
#' One and only one of the above must be provided. If both are provided this
#' defaults to using the artist and track name.
#'
#' If the artist and track names provided are misspelled in the search query, this endpoint
#' returns the correct name by default. This can be overriden by calling the function
#' with function argument `autocorrect` set to `FALSE`.
#'
#' Album play count is added to the result if the `username` argument is provided.
#'
#' The biography language is English by default but can be changed using the `lang`
#' argument which accepts an [ISO 639-1 country code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).
#'
#' @param track Required unless mbid is provided. The track name as a string.
#' @param artist Required unless mbid is provided. The artist name as a string.
#' @param mbid (Optional) MusicBrainz ID for the track as a string. Can be provided instead of artist and track names
#' @param autocorrect (Optional) Whether to correct the artist and track names. Defaults to TRUE if not provided.
#' @param username (Optional) Username as a string
#' @param lang (Optional) The language to return the biography in.
#'
#' @export
raw_track_get_info <- function(track = NULL, artist = NULL, mbid = NULL, autocorrect = TRUE, username = NULL, lang = NULL) {
  params <- sanitize_raw_track_get_info_parameters(artist, track, mbid)

  lastfmr(
    method = "track.getInfo",
    result_node = "track",
    artist = params[["artist"]],
    track = params[["track"]],
    mbid = params[["mbid"]],
    autocorrect = autocorrect,
    lang = lang,
    username = username
  )
}


#' Search for similar tracks
#'
#' The search is performed by providing a source track by:
#' 
#'     1. Artist and track name OR
#'     2. MusicBrainz ID
#'
#' One and only one of the above must be provided. If both are provided this
#' defaults to using the artist and track name.
#'
#' If the artist and track names provided are misspelled in the search query, this endpoint
#' returns the correct name by default. This can be overriden by calling the function
#' with function argument `autocorrect` set to `FALSE`.
#'
#' The biography language is English by default but can be changed using the `lang`
#' argument which accepts an [ISO 639-1 country code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).
#'
#' @param track Required unless mbid is provided. The track name as a string.
#' @param artist Required unless mbid is provided. The artist name as a string.
#' @param mbid (Optional) MusicBrainz ID for the track as a string. Can be provided instead of artist and track names
#' @param autocorrect (Optional) Whether to correct the artist and track names. Defaults to TRUE if not provided.
#' @param lang (Optional) The language to return the biography in.
#'
#' @export
raw_track_get_similar <- function(track = NULL, artist = NULL, mbid = NULL, autocorrect = TRUE, lang = NULL) {
  params <- sanitize_raw_track_get_info_parameters(artist, track, mbid)

  lastfmr(
    method = "track.getSimilar",
    result_node = "similartracks",
    artist = params[["artist"]],
    track = params[["track"]],
    mbid = params[["mbid"]], 
    autocorrect = autocorrect,
    lang = lang
  )
}


#' @keywords internal
sanitize_raw_track_get_info_parameters <- function(artist = NULL, track = NULL, mbid = NULL) {
  if (is.null(artist) && is.null(track) && is.null(mbid)) {
    abort("`raw_track_get_info` expects to get either an artist and track or the mbid. None were provided.")
  }

  if (!is.null(mbid)) {
    if (!is.null(artist) && !is.null(track)) {
      warn("`raw_track_get_info` got both artist/track names and mbid. The endpoint accepts one or the other. Defaulting to artist and album.")
      mbid <- NULL
    }
  }

  if (xor(!is.null(artist), !is.null(track))) {
    is_null_field <- ifelse(is.null(artist), "artist", "track")
    stop(glue("`raw_track_get_info` is missing {is_null_field} name."))
  }

  list("artist" = artist, "track" = track, "mbid" = mbid)
}
