handle_error <- function(resp) {
  error_msg <- resp_body_json(resp)$message
  error_code <- resp_body_json(resp)$error

  glue::glue("Error #{error_code} - {error_msg}")
}
