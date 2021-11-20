#' Artist API Methods
#'
#' @description
#'
#' These endpoints return information about artists. Identifying artists can be
#' done either using the artist name or a MusicBrainzID. If both `artist` and
#' `mbid` are provided, the artist name is used by default.
#'
#' * [raw_artist_search()] - Search for an artist by name.
#' * [raw_artist_get_info()] - Retrieve information about an artist exactly by name or MBID.
#' * [raw_artist_get_similar()] - Search for artists which are similar to a given artist.
#' * [raw_artist_get_tags()] - Get the tags applied by an individual user to an artist on Last.fm.
#' * [raw_artist_get_top_albums()] and [raw_artist_get_top_tracks()] - Get the top albums and tracks for an artist on Last.fm respectively.
#'
#' @param artist Artist name as a string.
#' @param mbid MusicBrainzID as a string, this is optional unless the artist is
#'   not provided.
#' @param username (Optional) If provided, the playcount of the artist by the
#'   user is included in the response
#' @inheritParams paginated-endpoint
#' @inheritParams common-params
#'
#' @inheritSection common-params Language Setting
#' @inheritSection common-params Name Autocorrection
#'
#' @returns
#'
#' * [raw_artist_search()], [raw_artist_get_top_albums()], and [raw_artist_get_top_tracks()] return a list of lastfmr object.
#' * [raw_artist_get_info()], [raw_artist_get_similar()], and [raw_artist_get_tags()] return a single lastfmr object.
#'
#' @name artist-methods
NULL

sanitize_artist_search_parameters <- function(artist = NULL, mbid = NULL) {
  missing_artist <- is.null(artist)
  missing_mbid <- is.null(mbid)
  if (missing_artist && missing_mbid) {
    abort("You must provide `artist` or `mbid`.")
  }

  if (!xor(missing_artist, missing_mbid)) {
    warn("You must only one `artist` or `mbid`. Both are set, defaulting to `artist`")
    mbid <- NULL
  }

  list(artist = artist, mbid = mbid)
}

#' @rdname artist-methods
#' @export
raw_artist_search <- function(artist, .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "artist.search",
    result_node = "results",
    artist = artist,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' @rdname artist-methods
#' @export
raw_artist_get_info <- function(artist = NULL, mbid = NULL, autocorrect = TRUE, username = NULL, lang = NULL) {
  params <- sanitize_artist_search_parameters(artist, mbid)

  lastfmr(
    method = "artist.getInfo",
    result_node = "artist",
    artist = params[["artist"]],
    mbid = params[["mbid"]],
    autocorrect = autocorrect,
    lang = lang,
    username = username
  )
}

#' @rdname artist-methods
#' @export
raw_artist_get_similar <- function(artist = NULL, mbid = NULL, autocorrect = TRUE) {
  params <- sanitize_artist_search_parameters(artist, mbid)
  lastfmr(
    method = "artist.getSimilar",
    result_node = "similarartists",
    artist = params[["artist"]],
    mbid = params[["mbid"]],
    autocorrect = autocorrect
  )
}

#' @rdname artist-methods
#' @export
raw_artist_get_tags <- function(artist = NULL, mbid = NULL, autocorrect = TRUE, username = NULL) {
  params <- sanitize_artist_search_parameters(artist, mbid)
  lastfmr(
    method = "artist.getTags",
    artist = params[["artist"]],
    mbid = params[["mbid"]],
    autocorrect = autocorrect,
    user = username
  )
}

#' @rdname artist-methods
#' @export
raw_artist_get_top_albums <- function(artist = NULL, mbid = NULL, autocorrect = TRUE, .start_page = 1, .n_pages = NULL) {
  params <- sanitize_artist_search_parameters(artist, mbid)
  paginate(
    method = "artist.getTopAlbums",
    result_node = "topalbums",
    artist = params[["artist"]],
    mbid = params[["mbid"]],
    autocorrect = autocorrect,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

#' @rdname artist-methods
#' @export
raw_artist_get_top_tracks <- function(artist = NULL, mbid = NULL, autocorrect = TRUE, .start_page = 1, .n_pages = NULL) {
  params <- sanitize_artist_search_parameters(artist, mbid)
  paginate(
    method = "artist.getTopTracks",
    result_node = "toptracks",
    artist = params[["artist"]],
    mbid = params[["mbid"]],
    autocorrect = autocorrect,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}
