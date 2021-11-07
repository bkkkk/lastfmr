lastfmr_default_options <- list(
  lastfmr.default_identity_name = "default",
  lastfmr.page_size = 50
)

.onLoad <- function(libname, pkgname) {
  op <- options()
  toset <- !(names(lastfmr_default_options) %in% names(op))
  if (any(toset)) options(lastfmr_default_options[toset])
  
  invisible()
}
