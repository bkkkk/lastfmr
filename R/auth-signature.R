#' Request Signing
#' 
#' @description 
#' Requests against the last.fm API must be signed using the following algorithm
#' as described [in the API documenation](https://www.last.fm/api/desktopauth#_6-sign-your-calls).
#' 
#' A short description of the methodology is included here for completeness:
#' 
#' 1.   Sort query parameters by key
#' 2.   Create a single string with all parameters formatted as follows
#'      `<key><value>` using UTF-8 encoding,
#' 3.   Append the Client Secret value (without a key),
#' 4.   Hash the resulting string using a 32bit md5 hash
#' 
#' The signature is then added as extra parameter named `api_sig`.
#' 
#' These functions are not designed to be invoked directly. Requests are signed
#' by default when using [lastfm_api()] and all other dependent raw and tidy
#' endpoint functions.
#' 
#' *    [sign_request()] takes a list with request parameters and signs it by adding
#'      the `api_sig` element.
#' *    [create_signature()] performs steps 1, 2, and 3
#' *    [hash_signature()] performs step 4
#' 
#' @returns 
#' *    [sign_request()] returns a list
#' *    [create_signature()] and [hash_signature()] return strings
#' 
#' @param params Named list of query parameters
#' 
#' @name auth_signature
#' 
#' @keywords internal
NULL

#' @rdname auth_signature
sign_request <- function(params, client_secret = default_shared_secret()) {
  raw_signature <- create_signature(params, client_secret)
  params[["api_sig"]] <- hash_signature(raw_signature)
  params
}

#' @rdname auth_signature
create_signature <- function(params, client_secret = default_shared_secret()) {
  purrr::discard(params, is_not_signature_valid)
  ordered_params <- params[order(names(params))]
  signature_fragment <- paste(
    names(ordered_params),
    stringi::stri_enc_toutf8(ordered_params),
    sep = "", collapse = ""
  )
  paste(signature_fragment, client_secret)
}

is_not_signature_valid <- function(x) {
  x %in% c("format", "callback")
}

#' @rdname auth_signature
hash_signature <- function(raw_signature) {
  hashed_sig <- digest::digest(raw_signature, algo = "md5", serialize = FALSE)
  logger::log_info(hashed_sig)
  hashed_sig
}
