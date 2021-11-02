#' @keywords internal
handle_error <- function(resp) {
  if (!exists("error", resp)) {
    return(resp)
  }
  stop("Request failed with response: ", resp$message)
}
