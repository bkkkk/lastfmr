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
#' 3.   [fetch_auth_token()] fetches a session token to be used with all
#'      end-user requests. This is done by providing the application API key and
#'      the request token. The endpoint returns an encrypted session token that
#'      can be attached to all user requests.
#'
#' @param request_token String containing the request token obtained with [fetch_request_token()]
#'
#' @returns
#' * `fetch_request_token()` and `fetch_auth_token()` return strings
#' @name auth
#'
#' @aliases NULL
NULL

#' @param .skip_auth Whether to skip the user authorization request, FALSE by default.
#' @param .auth Name of authentication identity as a string, defaults to `default`
#'
#' @export
#' @rdname auth
lastfm_auth <- function(.skip_auth = FALSE, .auth = "default") {
  auth_client <- lastfm_auth_client()

  request_token <- fetch_request_token(auth_client)
  if (!.skip_auth) {
    request_user_auth(request_token, auth_client)
  }
  session_key <- fetch_auth_token(request_token, auth_client)

  auth_save(session_key, .auth)

  auth_as(.auth)
}

#' @rdname auth
#' @keywords internal
fetch_request_token <- function(auth_client) {
  query <- list(
    method = "auth.getToken", format = "json"
  )
  resp <- request(api_endpoint()) %>%
    req_url_query(!!!query) %>%
    auth_client_auth_request(auth_client) %>%
    req_perform()

  token <- resp_body_json(resp)
  token$token
}

#' @rdname auth
#' @keywords internal
request_user_auth <- function(request_token, auth_client) {
  params <- list(
    api_key = auth_client_api_key(auth_client),
    token = request_token,
    format = "json"
  )
  # Using httr here instead of httr2 since there is no
  # BROWSE in httr2 and no way afaik to get back
  # a full URL from an httr2 request object
  url <- modify_url(auth_url(), query = params)

  ui_info("Opening your browser to request authorization.")

  BROWSE(url)

  ui_yeah("Have you authorized lastfmr Access??", n_yes = 1, n_no = 1)
}

#' @rdname auth
#' @keywords internal
fetch_auth_token <- function(request_token, auth_client) {
  query <- list(
    method = "auth.getSession",
    token = request_token,
    format = "json"
  )

  resp_content <- request(api_endpoint()) %>%
    req_url_query(!!!query) %>%
    auth_client_auth_request(auth_client) %>%
    req_perform() %>%
    resp_body_json()

  usethis::ui_done("The authentication process is complete!")
  SessionKey(resp_content)
}
