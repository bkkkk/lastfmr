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
#' by default when using [lastfmr()] and all other dependent raw and tidy
#' endpoint functions.
#' 
#' *    [add_signature()] takes a list with request parameters and an auth_client
#'      signs it by adding the `api_sig` element.
#' *    [create_signature()] performs steps 1, 2, and 3
#' *    [hash_signature()] performs step 4
#' 
#' @returns 
#' *    [add_signature()] returns a list
#' *    [create_signature()] and [hash_signature()] return strings
#' 
#' @param params Named list of query parameters
#' 
#' @name auth_signature
#' 
#' @keywords internal
NULL

#' @rdname auth_signature
add_signature <- function(params, auth_client) {
  raw_signature <- create_signature(params, auth_client)
  params[["api_sig"]] <- hash_signature(raw_signature)
  params
}

#' @rdname auth_signature
create_signature <- function(params, auth_client) {
  params[["format"]] <- NULL
  ordered_params <- params[order(names(params))]
  signature_fragment <- paste(
    names(ordered_params),
    stringi::stri_enc_toutf8(ordered_params),
    sep = "", collapse = ""
  )
  paste0(signature_fragment, auth_client_secret(auth_client))
}

is_not_signature_valid <- function(x) {
  x %in% c("format", "callback")
}

#' @rdname auth_signature
hash_signature <- function(raw_signature) {
  digest::digest(raw_signature, algo = "md5", serialize = FALSE)
}
