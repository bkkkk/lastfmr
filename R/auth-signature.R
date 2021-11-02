#' Adds an encrypted signature to a query prior to request.
#'
#' This should not be invoked directly by end-users and instead prefer to use
#' [lastfm_api()] or one of the `raw` or `tidy data` functions.
#'
#' @param params Named list of query parameters
#'
#' @return String containing ordered key-value pairs of query parameters
#' 
#' @family auth_signature
sign_request <- function(params) {
  params[["api_sig"]] <- hash_signature(create_signature_fragment(params))
  params
}

#' Builds a signature fragment from a list of query parameters.
#' 
#' This should not be involved directly. Use `sign_request` to sign a request
#' all queries are automatically signed where appropriate.
#'
#' @param params Named list of query parameters
#'
#' @return String containing ordered key-value pairs of query parameters
#' 
#' @family auth_signature
create_signature_fragment <- function(params) {
  ordered_params <- purrr::compact(params[order(names(params))])
  paste(names(ordered_params), ordered_params, sep = "", collapse = "")
}

#' @family auth_signature
hash_signature <- function(signature_fragment, client_secret = fm_shared_secret()) {
  openssl::md5(paste(signature_fragment, client_secret))
}
