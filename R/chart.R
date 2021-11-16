
# TODO chart.getTopTags
# TODO chart.getTopTracks

#' Title
#'
#' @inheritParams paginated-endpoint
#'
#' @return A list of lastfm objects
#'
#' @export
raw_chart_get_top_artists <- function(.page = 1, .n_pages = NULL) {
  paginate(method = "chart.getTopArtists", result_node = "artists", .page = 1, .n_pages = NULL)
}

raw_chart_get_top_tags <- function(.page = 1, .n_pages = NULL) {
  paginate(method = "chart.getTopTags", result_node = "tags", .start_page = 1, .n_pages = NULL)
}
