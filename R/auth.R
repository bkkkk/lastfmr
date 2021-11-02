#' Access Token Management
#'
#' @description
#' lastfmr implements the desktop application authentication method specified
#' in the [API documentation](https://www.last.fm/api/desktopauth).
#'
#' # Authentication Workflow
#'
#' The authentication workflow is execute by a call to [lastfm_auth()] which invokes
#' the full workflow:
#'
#' 1.   [fetch_request_token()] creates a request token for the specific API request, this authenticates a
#'      particular API request and lasts for 60 minutes.
#' 2.   [request_user_auth()] launches a browser to request end-user authorization
#'      for access to user account data through the browser. The token created in
#'      the first step is provided as part of the user authorization request to
#'      associate the Application API Key with the user account providing
#'      authorization.
#' 3.   [fetch_web_session()] fetches a session token to be used with all
#'      end-user requests. This is done by providing the application API key and
#'      the request token. The endpoint returns an encrypted session token that
#'      can be attached to all user requests.
#' 
#' @param api_key Application API key, if not provided the package default is used.
#' @param request_token String containing the request token obtained with [fetch_request_token()]
#' @param .skip_auth Whether to skip the user authorization request, FALSE by default.
#' 
#' @returns
#' * `fetch_request_token()` and `fetch_web_session()` return strings
#' @name auth
#'
#' @aliases NULL
NULL

#' @export
#' @rdname auth
lastfm_auth <- function(api_key = default_api_key(), .skip_auth = FALSE, .wait_for_user = TRUE) {
  request_token <- fetch_request_token(api_key)
  if (!.skip_auth) {
    request_user_auth(request_token, api_key, .wait_for_user)  
  }
  session_key <- fetch_auth_token(request_token, api_key)
  session_key
}

#' @rdname auth
#' @keywords internal
fetch_request_token <- function(api_key = default_api_key()) {
  params <- list(method = "auth.getToken", api_key = api_key, format = "json")

  url <- httr::modify_url(api_endpoint(), query = params)
  resp <- httr::GET(url)
  token <- httr::content(resp)
  token$token
}

#' @rdname auth
#' @keywords internal
request_user_auth <- function(request_token, api_key = default_api_key(), .wait_for_user = TRUE) {
  params <- list(
    api_key = api_key,
    token = request_token,
    format = "json"
  )

  url <- httr::modify_url(auth_url(), query = params)

  usethis::ui_yeah("Is it ok if we take you to last.fm to authorize lastfmr. Once complete return here.", n_yes = 1, n_no = 1)

  httr::BROWSE(url)

  usethis::ui_yeah("Have you authorized lastfmr Access??", n_yes = 1, n_no = 1)
}

#' @rdname auth
#' @keywords internal
fetch_auth_token <- function(request_token, api_key = default_api_key()) {
  query <- sign_request(list(
    api_key = api_key,
    method = "auth.getSession",
    token = request_token,
    format = "json"
  ))
    
  url <- modify_url(api_endpoint(), query = query)
  resp_content <- content(httr::GET(url))
  resp <- handle_error(resp_content)
  cli::cli_alert_success("The authentication process is complete!")
  resp
}
