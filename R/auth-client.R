#' @export
lastfm_auth_client <- function(api_key = NULL, client_secret = NULL) {
  if (is.null(api_key) || is.null(client_secret)) {
    api_key = default_api_key()
    client_secret = default_shared_secret()
  }

  structure(
    list(
      api_key = api_key,
      client_secret = Obfuscated(client_secret)
    ),
    class = "lastfm_auth_client"
  )
}

is_lastfm_auth_client <- function(x) {
  inherits(x, "lastfm_auth_client")
}

#' @export
print.lastfm_auth_client <- function(x) {
  cli::cli_text(cli::style_bold("<", paste(class(x), collapse = "/"), ">"))
  args <- compact(x)
  args[["client_secret"]] <- NULL
  cli::cli_dl(args)
  invisible(x)
}

auth_client_api_key <- function(auth_client) {
  stopifnot(is_lastfm_auth_client(auth_client))
  
  auth_client$api_key
}

auth_client_secret <- function(auth_client) {
  stopifnot(is_lastfm_auth_client(auth_client))

  deobfuscate(auth_client$client_secret)
}

#' @rdname auth
auth_client_auth_request <- function(req, auth_client = lastfm_auth_client(), .sign = TRUE) {
  query <- req_query_as_list(req)
  query[["api_key"]] <- auth_client_api_key(auth_client)
  if (.sign) {
    query <- add_signature(query, auth_client)
  }
  req_url_query(req, !!!query)
}
