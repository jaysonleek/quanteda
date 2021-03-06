% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/textstat_simil.R
\name{textstat_simil}
\alias{textstat_simil}
\alias{textstat_dist}
\alias{as.list.textstat_proxy}
\alias{as.data.frame.textstat_proxy}
\title{Similarity and distance computation between documents or features}
\usage{
textstat_simil(
  x,
  y = NULL,
  selection = NULL,
  margin = c("documents", "features"),
  method = c("correlation", "cosine", "jaccard", "ejaccard", "dice", "edice", "hamman",
    "simple matching"),
  min_simil = NULL,
  ...
)

textstat_dist(
  x,
  y = NULL,
  selection = NULL,
  margin = c("documents", "features"),
  method = c("euclidean", "manhattan", "maximum", "canberra", "minkowski"),
  p = 2,
  ...
)

\method{as.list}{textstat_proxy}(x, sorted = TRUE, n = NULL, diag = FALSE, ...)

\method{as.data.frame}{textstat_proxy}(
  x,
  row.names = NULL,
  optional = FALSE,
  diag = FALSE,
  upper = FALSE,
  ...
)
}
\arguments{
\item{x, y}{a \link{dfm} objects; \code{y} is an optional target matrix matching
\code{x} in the margin on which the similarity or distance will be computed.}

\item{selection}{(deprecated - use \code{y} instead).}

\item{margin}{identifies the margin of the dfm on which similarity or
difference will be computed:  \code{"documents"} for documents or
\code{"features"} for word/term features.}

\item{method}{character; the method identifying the similarity or distance
measure to be used; see Details.}

\item{min_simil}{numeric; a threshold for the similarity values below which similarity
values will not be returned}

\item{...}{unused}

\item{p}{The power of the Minkowski distance.}

\item{sorted}{sort results in descending order if \code{TRUE}}

\item{n}{the top \code{n} highest-ranking items will be returned.  If n is
\code{NULL}, return all items.}

\item{diag}{logical; if \code{FALSE}, exclude the item's comparison with itself}

\item{row.names}{\code{NULL} or a character vector giving the row
    names for the data frame.  Missing values are not allowed.}

\item{optional}{logical. If \code{TRUE}, setting row names and
    converting column names (to syntactic names: see
    \code{\link[base]{make.names}}) is optional.  Note that all of \R's
    \pkg{base} package \code{as.data.frame()} methods use
    \code{optional} only for column names treatment, basically with the
    meaning of \code{\link[base]{data.frame}(*, check.names = !optional)}.
    See also the \code{make.names} argument of the \code{matrix} method.}

\item{upper}{logical; if \code{TRUE}, return pairs as both (A, B) and (B, A)}
}
\value{
A sparse matrix from the \pkg{Matrix} package that will be symmetric
unless \code{y} is specified.

These can be transformed easily into a list format using \code{as.list()}, which
returns a list for each unique element of the second of the pairs,
\code{as.dist()} to be transformed into a \link[stats:dist]{dist} object, or
\code{as.matrix()} to convert it into an ordinary matrix.

\code{as.data.list} for a \code{textstat_simil} or
\code{textstat_dist} object returns a list equal in length to the columns of the
simil or dist object, with the rows and their values as named  elements.  By default,
this list excludes same-time pairs (when \code{diag = FALSE}) and sorts the values
in descending order (when \code{sorted = TRUE}).

\code{as.data.frame} for a \code{textstat_simil} or
\code{textstat_dist} object returns a data.frame of pairwise combinations
and the and their similarity or distance value.
}
\description{
These functions compute matrixes of distances and similarities between
documents or features from a \code{\link[=dfm]{dfm()}} and return a matrix of
similarities or distances in a sparse format.  These methods are fast
and robust because they operate directly on the sparse \link{dfm} objects.
The output can easily be coerced to an ordinary matrix, a data.frame of
pairwise comparisons, or a \link[stats:dist]{dist} format.
}
\details{
\code{textstat_simil} options are: \code{"correlation"} (default),
\code{"cosine"}, \code{"jaccard"}, \code{"ejaccard"}, \code{"dice"},
\code{"edice"}, \code{"simple matching"}, and \code{"hamman"}.

\code{textstat_dist} options are: \code{"euclidean"} (default),
\code{"manhattan"}, \code{"maximum"}, \code{"canberra"},
and \code{"minkowski"}.
}
\note{
If you want to compute similarity on a "normalized" dfm object
(controlling for variable document lengths, for methods such as correlation
for which different document lengths matter), then wrap the input dfm in
\verb{[dfm_weight](x, "prop")}.
}
\examples{
# similarities for documents
dfmat <- dfm(corpus_subset(data_corpus_inaugural, Year > 2000),
             remove_punct = TRUE, remove = stopwords("english"))
(tstat1 <- textstat_simil(dfmat, method = "cosine", margin = "documents"))
as.matrix(tstat1)
as.list(tstat1)
as.list(tstat1, diag = TRUE)

# min_simil
(tstat2 <- textstat_simil(dfmat, method = "cosine", margin = "documents", min_simil = 0.6))
as.matrix(tstat2)

# similarities for for specific documents
textstat_simil(dfmat, dfmat["2017-Trump", ], margin = "documents")
textstat_simil(dfmat, dfmat["2017-Trump", ], method = "cosine", margin = "documents")
textstat_simil(dfmat, dfmat[c("2009-Obama", "2013-Obama"), ], margin = "documents")

# compute some term similarities
tstat3 <- textstat_simil(dfmat, dfmat[, c("fair", "health", "terror")], method = "cosine",
                         margin = "features")
head(as.matrix(tstat3), 10)
as.list(tstat3, n = 6)


# distances for documents
(tstat4 <- textstat_dist(dfmat, margin = "documents"))
as.matrix(tstat4)
as.list(tstat4)
as.dist(tstat4)

# distances for specific documents
textstat_dist(dfmat, dfmat["2017-Trump", ], margin = "documents")
(tstat5 <- textstat_dist(dfmat, dfmat[c("2009-Obama" , "2013-Obama"), ], margin = "documents"))
as.matrix(tstat5)
as.list(tstat5)

\dontrun{
# plot a dendrogram after converting the object into distances
plot(hclust(as.dist(tstat4)))
}
}
\seealso{
\code{\link[stats:dist]{stats::as.dist()}}
}
\keyword{textstat}
