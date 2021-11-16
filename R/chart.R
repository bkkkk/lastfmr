#' Get list of top artists
#'
#' @inheritParams paginated-endpoint
#'
#' @return A vector of LastFM API objects
#'
#' @export
raw_chart_get_top_artists <- function(.start_page = 1, .n_pages = NULL) {
  paginate(method = "chart.getTopArtists", result_node = "artists", .start_page = .start_page, .n_pages = .n_pages)
}

#' Get list of top tags
#'
#' @inheritParams paginated-endpoint
#'
#' @return A vector of LastFM API objects
#'
#' @export
raw_chart_get_top_tags <- function(.start_page = 1, .n_pages = NULL) {
  paginate(method = "chart.getTopTags", result_node = "tags", .start_page = .start_page, .n_pages = .n_pages)
}

#' Get list of top tracks
#'
#' @inheritParams paginated-endpoint
#'
#' @return A vector of LastFM API objects
#'
#' @export
raw_chart_get_top_tracks <- function(.start_page = 1, .n_pages = NULL) {
  paginate(method = "chart.getTopTracks", result_node = "tracks", .start_page = .start_page, .n_pages = .n_pages)
}
