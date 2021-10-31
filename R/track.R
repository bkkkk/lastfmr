#' Title
#'
#' @param track
#' @param artist
#' @param page
#'
#' @return
#' @export
#'
#' @examples
track_search <- function(track, artist = NULL, page = 1) {
  lastfm_api(query = list(
    method = "track.search",
    track = track,
    artist = artist,
    page = page
  ))
}
