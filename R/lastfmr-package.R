#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom cli cli_abort
#' @importFrom cli cli_warn
#' @importFrom digest digest
#' @importFrom dplyr arrange
#' @importFrom dplyr desc
#' @importFrom dplyr distinct
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
#' @importFrom magrittr %>%
#' @importFrom progress progress_bar
#' @importFrom purrr compact
#' @importFrom purrr has_element
#' @importFrom purrr map
#' @importFrom purrr map_chr
#' @importFrom purrr map_dbl
#' @importFrom purrr map_df
#' @importFrom purrr pluck
#' @importFrom rappdirs user_cache_dir
#' @importFrom rlang %||%
#' @importFrom rlang abort
#' @importFrom rlang arg_match
#' @importFrom stringi stri_enc_toutf8
#' @importFrom tibble tibble
#' @importFrom usethis ui_info
#' @importFrom usethis ui_yeah
#' @importFrom withr defer
## usethis namespace: end
NULL

# Used to track package-wide objects
.state <- new.env(parent = emptyenv())

#' Common parameters in API methods
#'
#' @section Language Setting:
#'
#' Biographies for albums and artists are returned in English by
#' default. To get the biography in other languages, provide a [ISO 639-1 country code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
#' via the `lang` argument of supporting functions.
#'
#' @section Name Autocorrection:
#'
#' Endpoints that take artist/track/album names try to auto-correct misspelled names
#' in the search query. This behaviour can be overriden by calling the function
#' with argument `autocorrect` set to `FALSE`.
#'
#' @param lang (Optional) The biography language.
#' @param autocorrect (Optional) Whether to correct the artist/album/track name names provided in the response. Defaults to TRUE if not provided.
#'
#' @name common-params
NULL
