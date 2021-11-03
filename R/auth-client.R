#' @export
lastfm_auth_client <- function(api_key = default_api_key(),
                               client_secret = default_shared_secret()) {
  structure(
    list(
      api_key = api_key,
      client_secret = obfuscated(client_secret),
      auth_url = "http://www.last.fm/api/auth/",
      request_token_method = "auth.getToken",
      session_key_method = "auth.getSession"
    ),
    class = "lastfm_auth_client"
  )
}

is_lastfm_auth_client <- function(x) {
  inherits(x, "lastfm_auth_client")
}

auth_url <- function(auth_client) {
  stopifnot(is_lastfm_auth_client(auth_client))
  
  auth_client$auth_url
}

auth_api_key <- function(auth_client) {
  stopifnot(is_lastfm_auth_client(auth_client))
  
  auth_client$api_key
}

auth_client_secret <- function(auth_client) {
  stopifnot(is_lastfm_auth_client(auth_client))
  
  auth_client$client_secret
}