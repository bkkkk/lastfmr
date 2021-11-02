fm_auth_endpoints <- function() {
  list(request = , authorize = , open_session = )
}

fetch_web_session <- function(token, api_key = NULL) {
  if (is.null(api_key)) {
    api_key <- fm_api_key()
  }
  
  query <- sign_request(list(
    api_key = api_key,
    method = "auth.getSession",
    token = token
  ))

  args <- append(list(req = httr2::request(api_endpoint())), query)

  req <- do.call(httr2::req_url_query, args)
  
  httr2::req_dry_run(req)

  resp <- httr2::req_perform(req)
  resp_content <- content(resp)
  resp_content
}

request_user_auth <- function(token, api_key = NULL) {
  if (is.null(api_key)) {
    api_key <- fm_api_key()
  }
  
  params <- list(
    api_key = api_key,
    token = token
  )
  
  url <- httr::modify_url(auth_url(), query = add_headers(params))
  httr::BROWSE(url)
}

fetch_request_token <- function(api_key = NULL) {
  if (is.null(api_key)) {
    api_key <- fm_api_key()
  }
  params <- sign_it(
    list(method = "auth.getToken")
  )
  url <- httr::modify_url(api_endpoint(), query = add_headers(params))
  resp <- httr::GET(url)
  token <- httr::content(resp)
}

create_signature <- function(params) {
  ordered_params <- params[order(names(params))]
  concatenated_string <- paste(names(ordered_params), ordered_params, sep = "", collapse = "")
  signatures <- openssl::md5(paste(concatenated_string, fm_shared_secret()))
}

sign_request <- function(params) {
  params[["api_sig"]] <- create_signature(params)
  params
}

fm_shared_secret <- function() {
  "7e57be7e1d1246099bedb96fc0cb9334"
}

fm_api_key <- function() {
  "96f7c58dc14f575249f97b5f01282316"
}
