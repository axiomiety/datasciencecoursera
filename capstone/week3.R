generateAndStoreTDMs <- function() {
  setwd('c:/shared/datasciencecoursera/capstone/')
  library('tm')
  src <- DirSource(directory="c:/shared/datasciencecoursera/capstone/en_US", pattern="*sample.txt")
  docs <- VCorpus(src)
  docs <- tm_map(docs, content_transformer(function(x) iconv(x, to='ASCII//TRANSLIT')))
  docs <- tm_map(docs, content_transformer(tolower))
  docs <- tm_map(docs, content_transformer(removePunctuation))
  docs <- tm_map(docs, content_transformer(stripWhitespace))
  docs <- tm_map(docs, content_transformer(removeNumbers))
  
  NgramTokenizer <- function(x, n) {
    unlist(lapply(ngrams(words(x), n), paste, collapse = " "), use.names = FALSE) }
  
  BigramTokenizer <- function(x) {NgramTokenizer(x, 2)}
  TrigramTokenizer <- function(x) {NgramTokenizer(x, 3)}
  
  tdm <- TermDocumentMatrix(docs)
  tdm_bi <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
  tdm_tri <- TermDocumentMatrix(docs, control = list(tokenize = TrigramTokenizer))
  save(tdm, )
}