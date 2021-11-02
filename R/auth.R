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
#' @returns 
#' * `fetch_request_token()` and `fetch_web_session()` return strings
#' @name auth
#' 
#' @aliases NULL
NULL

#' Authorize lastfmr
#' 
#' By default, you are directed to a web browser, asked to sign in to your last.fm
#' account, and to grant lastfmr permissions to operate on your behalf.
#'
#' @export
#'
#' @examples
#' 
#' @family auth
#' @rdname auth
lastfm_auth <- function(api_key = fm_api_key()) {
  request_token <- fetch_request_token(api_key)
  request_user_auth(request_token, api_key)
  session_key <- fetch_web_session(request_token, api_key)

  save_cache(session_key)
}

#' Fetch request Token
#'
#' The 1st part of the user authentication process. This token expires after
#' 60 minutes.
#'
#' @param api_key (optional) Application API Key
#'
#' @return Request token
#'
#' @family auth
#' @rdname auth
fetch_request_token <- function(api_key = fm_api_key()) {
  params <- sign_request(
    list(method = "auth.getToken")
  )
  url <- httr::modify_url(api_endpoint(), query = add_headers(params))
  resp <- httr::GET(url)
  token <- httr::content(resp)
  token$token
}

#' Launch browser to request end-user authorization to their account.
#'
#' @param request_token String containing the request token obtained with [fetch_request_token()]
#' @inheritParams fetch_request_token
#' 
#' @rdname auth
request_user_auth <- function(request_token, api_key = fm_api_key()) {
  params <- list(
    api_key = api_key,
    token = token
  )
  
  url <- httr::modify_url(auth_url(), query = add_headers(params))
  httr::BROWSE(url)
}

#' Fetch a web session key to be used with end-user requests.
#'
#' @inheritParams request_user_auth
#'
#' @return 
#'
#' @family auth
#' 
#' @rdname auth
fetch_web_session <- function(token, api_key = fm_api_key()) {
  query <- sign_request(add_headers(list(
    api_key = api_key,
    method = "auth.getSession",
    token = token
  )))
  
  url <- httr::modify_url(api_endpoint(), query = query)
  
  resp <- httr::GET(url)
  handle_error(content(resp))
}
