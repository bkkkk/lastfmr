#' Search for album by name
#'
#' @param album Album name as a string
#' @inheritParams paginated-endpoint
#'
#' @return A vector of LastFM API objects
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

#' Get album information
#' 
#' The album can be retrieved by:
#'     1. Artist and album name OR
#'     2. MusicBrainz ID
#' 
#' One and only one of the above must be provided. If both are provided this
#' defaults to using the artist and album name.
#'
#' If the artist name provided is misspelled in the search query, this endpoint
#' returns the correct name by default. This can be overriden by calling the function
#' with function argument `autocorrect` set to `FALSE`.
#' 
#' Album play count is added to the result if the `username` argument is provided.
#' 
#' The biography language is English by default but can be changed using the `lang`
#' argument which accepts an [ISO 639-1 country code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes).
#'
#' @param artist Required unless mbid is provided. The artist name as a string.
#' @param album Required unless mbid is provided. The album name as a string.
#' @param mbid (Optional) MusicBrainz ID for the album as a string. Can be provided instead of artist and album names
#' @param autocorrect (Optional) Whether to correct the artist name. Defaults to TRUE if not provided.
#' @param username (Optional) Username as a string
#' @param lang (Optional) The language to return the biography in.
#' @inheritParams paginated-endpoint
#'
#' @return A vector of LastFM API objects
#' @export
raw_album_get_info <- function(artist = NULL, album = NULL, mbid = NULL, autocorrect = TRUE, username = NULL, lang = NULL, .start_page = 1, .n_pages = NULL) {
  params <- sanitize_raw_album_get_info_parameters(artist, album, mbid)

  paginate(
    method = "album.getInfo",
    !!!params,
    autocorrect = autocorrect,
    lang = lang,
    username = username,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}

sanitize_raw_album_get_info_parameters <- function(artist = NULL, album = NULL, mbid = NULL) {
  if (is.null(artist) && is.null(album) && is.null(mbid)) {
    abort("`raw_album_get_info` expects to get either an artist and album or the mbid. None were provided.")
  }
  
  if(!is.null(mbid)) {
    if (!is.null(artist) && !is.null(album)) {
      warn("`raw_album_get_info` got both artist/album names and mbid. The endpoint accepts one or the other. Defaulting to artist and album.")
      mbid <- NULL
    }
  }
  
  if(xor(!is.null(artist), !is.null(album))) {
    stop(glue("`raw_album_get_info` is missing either artist or album name. Provided artist={artist}, album={album}"))
  }

  list("artist"=artist, "album"=album, "mbid"=mbid)
}
