
#' return the context in which 'word' appears

#' Keyword-in-context function to return the 
#' context in which 'word' appears
#' 
#' 
#' @param corpus The corpus to be searched
#' @param word The keyword to look for
#' @param window The size of the context window (the
#'  number of words each side of keyword to return)
#'  the default is 5. 
#' @export
#' @examples
#' contexts <- kwic(corpus, keyword, window=6)

kwic <- function(text, word, window=5){
  UseMethod("kwic")
}


#' return the context in which 'word' appears

#' Keyword-in-context function to return the 
#' context in which 'word' appears
#' 
#' 
#' @param corpus The corpus to be searched
#' @param word The keyword to look for
#' @param window The size of the context window (the
#'  number of words each side of keyword to return)
#'  the default is 5. 
#' @export
#' @examples
#' contexts <- kwic(corpus, keyword, window=6)
kwic.character <- function(text, word, window=5){
  toks <- tokenize(text)
  matches = which(toks == word )
  contexts = vector()
  if(length(matches) == 0){return(NA)}
  contexts <- rep(NA, length(matches))
  for(m in 1:length(matches)){
    start <- matches[m] - window
    end <- matches[m] + window
    if(start < 0) start <- 0
    if(end > length(toks)) end <- length(toks)
    
    contexts[m] <- paste(toks[start:end], collapse=' ' )
    print(paste(toks[start:end], collapse=' ' ))
  }
  return(contexts)
}


#' return the context in which 'word' appears

#' Keyword-in-context function to return the 
#' context in which 'word' appears
#' 
#' 
#' @param corpus The corpus to be searched
#' @param word The keyword to look for
#' @param window The size of the context window (the
#'  number of words each side of keyword to return)
#'  the default is 5.
#' @export 
#' @examples
#' contexts <- kwic(corpus, keyword, window=6)
kwic.corpus <- function(corpus, word, window=5){
  contexts <- lapply(corpus$attribs$texts, kwic.character, word=word, window=window)
  names(contexts) <- row.names(corpus$attribs)
  return(contexts)
}