% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lastfm.R
\name{lastfm}
\alias{lastfm}
\title{Query a Last.FM endpoint.}
\usage{
lastfm(method, ..., .page = 1, result_node = NULL)
}
\arguments{
\item{method}{The name of the API method \href{https://www.last.fm/api}{found here}.}

\item{...}{named parameters to be passed to the endpoint}

\item{.page}{Page to query, by default query the first page}

\item{result_node}{The node in the response that contains the data.}
}
\value{
A \link{lastfm} API object.
}
\description{
Query a Last.FM endpoint.
}
