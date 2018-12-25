library(dplyr)
library(tidyr)

convertTdm <- function(tdm, threshold=2) {
  # convert into a matrix, and sum up the occurrences across all documents
  # we can do this because our application won't context-sensitive (e.g. blog vs tweet)
  m <- as.matrix(tdm)
  rs <- rowSums(m)
  # remove anything that occurs less than the given threshold
  rs_trim <- rs[rs > threshold]
  d <- data.frame(grams=names(rs_trim), counts=rs_trim)
}

splitRootWord <- function(df) {
  #df %>% separate(grams, into=c('root','word'), sep=' ')
  df %>% extract(grams, into=c('root','word'), regex='(.*) ([[:alnum:]]+)')
}