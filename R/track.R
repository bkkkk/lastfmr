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
raw_track_search <- function(track, artist = NULL, .start_page = 1, .n_pages = NULL, .limit = 50) {
  paginate(
    method = "track.search",
    track = track,
    artist = artist,
    .start_page = 1,
    .n_pages = .n_pages,
    .limit = .limit
  )
}

# TODO track.getInfo
# TODO track.getSimilar
