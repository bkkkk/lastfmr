#' Search for an artist by name
#' 
#' Returns artist matches sorted by relevance.
#'
#' @inherit paginated-endpoint params return
#'
#' @param artist Artist name as a string.
#'
#' @export
raw_artist_search <- function(track, .start_page = 1, .n_pages = NULL) {
  paginate(
    method = "artist.search",
    result_node = "results",
    artist = artist,
    .start_page = .start_page,
    .n_pages = .n_pages
  )
}


# TODO artist.getInfo
# TODO artist.getSimilar
# TODO artist.getTags
# TODO artist.getTopAlbums
# TODO artist.getTopTracks