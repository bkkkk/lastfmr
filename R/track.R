#' Search for a track by track name. Returns track matches sorted by relevance.
#'
#' @inheritParams paginated-endpoint
#' @param track The track name.
#' @param artist Narrow your search by specifying an artist, if not provided the
#'   endpoint searches across artists
#'
#' @return A list of lastfmr API objects
#'
#' @export
raw_track_search <- function(track, artist = NULL, .start_page = 1, .n_pages = NULL) {
  lastfmr(
    method = "track.search",
    result_node = c("results"),
    track = track,
    artist = artist,
    .start_page = .start_page,
    .n_pages = .n_pages
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

# TODO track.getInfo
# TODO track.getSimilar
