#http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know
setwd('c:/shared/datasciencecoursera/capstone/')
library('tm')
src <- DirSource(directory="c:/shared/datasciencecoursera/capstone/en_US", pattern="*sample.txt")
docs <- VCorpus(src)
docs <- tm_map(docs, content_transformer(function(x) iconv(x, to='ASCII//TRANSLIT')))
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, content_transformer(removePunctuation))
docs <- tm_map(docs, content_transformer(stripWhitespace))
docs <- tm_map(docs, content_transformer(removeNumbers))

tdm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
#v <- sort(rowSums(m),decreasing=TRUE)
#d <- data.frame(word = names(v),freq=v)

# dtms <- removeSparseTerms(dtm, 0.2) - matrix that's at most 20% sparse
# findFreqTerms(tdm, lowfreq = 1001) - occur at lest 1001 times

NgramTokenizer <- function(x, n) {
    unlist(lapply(ngrams(words(x), n), paste, collapse = " "), use.names = FALSE) }

BigramTokenizer <- function(x) {NgramTokenizer(x, 2)}
TrigramTokenizer <- function(x) {NgramTokenizer(x, 3)}

tdm_bi <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
tdm_tri <- TermDocumentMatrix(docs, control = list(tokenize = TrigramTokenizer))

foo <- function() {
library("tm")
data("crude")
tdmw <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
inspect(removeSparseTerms(tdm[, 1:10], 0.7))
myCorpus <- Corpus(VectorSource(a))
myTDM <- TermDocumentMatrix(myCorpus)
findFreqTerms(myTDM)
}