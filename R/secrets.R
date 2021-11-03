default_shared_secret <- function() {
  decrypt(lastfmr:::UW7Y2tEfiryZECpSEN1ShA)
}

default_api_key <- function() {
  decrypt(lastfmr:::oXEf0M3Wx5uvS8XzYmUIBQ)
}

decrypt <- function(x) {
  httr2::secret_decrypt(x[[1]], x[[2]])
}

#' @keywords internal
get_session_key <- function(auth = NULL) {
  if (is.null(.state$auth)) {
    cli::cli_warn("Session key is not set. Loading identity `{auth}`")
    auth_as(auth)
  } else {
    .state$auth$key
  }
}

#' @export
SessionKey <- function(resp) {
  structure(
    list(
      account_name = resp$session$name,
      key = Obfuscated(resp$session$key)
    ),
    class = "fm_session_key"
  )
}

#' @export
print.fm_session_key <- function(x) {
  cat(glue("Key for account: {x$account_name}"))
}

#' @export
Obfuscated <- function(x) {
  structure(
    list(value = x),
    class = "obfuscated"
  )
}

#' @export
deobfuscate <- function(x) {
  if (inherits(x, "obfuscated")) {
    x[["value"]]
  } else {
    x
  }
}

#' @export
print.obfuscated <- function(x) {
  cat("<OBFUSCATED>", sep = "\n")
}

#' @export
str.obfuscated <- function(x, ...) {
  cat("<OBFUSCATED>", sep = "\n")
}
