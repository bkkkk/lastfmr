#' Simple caching mechanism for auth secrets
#'
#' Caching of authorization secrets relies on a simple rds file save/load mechanism.
#'
#' Users primarily interact with the [auth_as()] function to set the authentication
#' secrets for the session. Authentication identities are managed by the name `auth`.
#'
#' @param auth the authentication token as a string
#' @param name the name of the cache as a string
#'
#' @name auth_cache
NULL

default_cache_location <- function() {
  rappdirs::user_cache_dir("lastfmr")
}

#' @return The previous authentication identity invisibly
#'
#' @export
#' @rdname auth_cache
auth_as <- function(name = NULL) {
  old <- .state$auth
  .state$auth <- auth_load(name)
  invisible(old)
}

#' @export
#' @rdname auth_cache
auth_list <- function() {
  paths <- dir(auth_path(), pattern = "\\.rds$")
  tools::file_path_sans_ext(paths)
}

#' @keywords internal
auth_path <- function(...) {
  # Use private option to make testing easier
  path <- getOption("lastfmr:::cache_dir", default_cache_location())
  file.path(path, ...)
}

#' @return invisibly returns path as string
#'
#' @rdname auth_cache
#'
#' @keywords internal
auth_save <- function(auth, name) {
  path <- auth_path(paste0(name, ".rds"))
  cli::cli_inform(paste0("Saving auth to '", path, "'"))

  dir.create(auth_path(), showWarnings = FALSE, recursive = TRUE)
  saveRDS(auth, path)
  invisible(path)
}

#' @rdname auth_cache
#'
#' @keywords internal
auth_load <- function(name = NULL) {
  if (is.null(name)) {
    cli::col_silver("Loading default last.fm credentials.")
    name <- "default"
  }
  path <- auth_path(paste0(name, ".rds"))
  if (!file.exists(path)) {
    lastfm_auth()
  }

  invisible(readRDS(path))
}
