#' Search for a track by track name. Returns track matches sorted by relevance.
#'
#' @param track The track name.
#' @param artist Narrow your search by specifying an artist.
#' @param page The page number ot fetch. Defaults to first page.
#'
#' @return Raw response object including results as dataframe
#' @export
fm_track_search <- function(track, artist = NULL, page = 1) {
  lastfm_api(lastfm_query(
    method = "track.search",
    track = track,
    artist = artist,
    page = page
  ))
}

# TODO track.getInfo
# TODO track.getSimilar
