#' Chart Methods
#' 
#' @description 
#' 
#' Get last.fm overall chart rankings for tags, tracks, and artists.
#' 
#' [raw_chart_get_top_artists()], [raw_chart_get_top_tags()],
#' and [raw_chart_get_top_tracks()] retrieve the overall top artists, tags, and tracks, respectively.
#' 
#' @inheritParams paginated-endpoint
#' 
#' @returns 
#' 
#' * All raw endpoints return a list of lastfmr objects.
#' * All tidy endpoints return a Tibble.
#' 
#' @name chart-methods
NULL

#' @rdname chart-methods
#' @export
raw_chart_get_top_artists <- function(.start_page = 1, .n_pages = NULL) {
  paginate(method = "chart.getTopArtists", result_node = "artists", .start_page = .start_page, .n_pages = .n_pages)
}

#' @rdname chart-methods
#' @export
chart_get_top_artists <- function(.start_page = 1, .n_pages = NULL) {
  raw_responses <- raw_chart_get_top_artists(.start_page, .n_pages)
  
  tidy_raw_response(raw_responses, function(record) {
    tibble(
      name = map_chr(record, "name"),
      playcount = as.integer(map_chr(record, "playcount")),
      listeners = as.integer(map_chr(record, "listeners")),
      mbid = map_chr(record, "mbid"),
      streamable = as.integer(map_chr(record, "streamable")),
      url = map_chr(record, "url")
    )
  }, .path = "artist") %>%
    arrange(desc(playcount))
}


#' @rdname chart-methods
#' @export
raw_chart_get_top_tags <- function(.start_page = 1, .n_pages = NULL) {
  paginate(method = "chart.getTopTags", result_node = "tags", .start_page = .start_page, .n_pages = .n_pages)
}

#' @rdname chart-methods
#' @export
raw_chart_get_top_tracks <- function(.start_page = 1, .n_pages = NULL) {
  paginate(method = "chart.getTopTracks", result_node = "tracks", .start_page = .start_page, .n_pages = .n_pages)
}
