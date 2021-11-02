
# lastfmr - Work with Last.FM data from R

<!-- badges: start -->
<!-- badges: end -->

lastfmr simplifies the work of interacting with the last.fm API to get information about your favourite artists, albums, and collecting scrobbles in a tidy format. Pagination is taken care of for you and the data is organized with sensible column names and formatting.

## Installation

You can install the development version of lastfmr from [GitHub](https://github.com/) with:

``` r
devtools::install_github("bkkkk/lastfmr")
```

## Getting Started

``` r
library(lastfmr)
```

The package provides functions for each of the endpoints and a generic API function. For each of the endpoints there are 2 functions:

* A "raw" function that a `lastfm_api` object which contains the concatenate result as well as additional information on the request and response. The results here use the raw column names from the last.fm API, and nested data.
* A "tidy" function that returns a concatenated `tibble` with more sensible column names and flattened nested structures.

The function names are mapped directly from the endpoint name

Endpoints supported:

* `track.search`
* `user.getrecenttracks`
* `user.getTopAlbums`
* `user.getTopArtists`
* `user.getTopTracks`


