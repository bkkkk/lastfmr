default_shared_secret <- function() {
  decrypt(lastfmr:::UW7Y2tEfiryZECpSEN1ShA)
}

default_api_key <- function() {
  decrypt(lastfmr:::oXEf0M3Wx5uvS8XzYmUIBQ)
}

decrypt <- function(x) {
  httr2::secret_decrypt(x[[1]], x[[2]])
}
