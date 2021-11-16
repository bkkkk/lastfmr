#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom glue glue
#' @importFrom httr BROWSE
#' @importFrom httr content
#' @importFrom httr GET
#' @importFrom httr modify_url
#' @importFrom httr2 obfuscated
#' @importFrom httr2 req_error
#' @importFrom httr2 req_perform
#' @importFrom httr2 req_url_query
#' @importFrom httr2 request
#' @importFrom httr2 resp_body_json
#' @importFrom logger log_debug
#' @importFrom logger log_info
#' @importFrom purrr compact
#' @importFrom purrr has_element
#' @importFrom purrr map
#' @importFrom purrr map_chr
#' @importFrom purrr map_dbl
#' @importFrom rlang %||%
#' @importFrom tibble tibble
#' @importFrom usethis ui_info
#' @importFrom usethis ui_yeah
## usethis namespace: end
NULL

# Used to track package-wide objects
.state <- new.env(parent = emptyenv())
