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

unigram <- function(df) {
  d <- df %>%
      mutate(root='', word=grams) %>%
      mutate(prob=counts/sum(counts)) %>%
      select(root, word, counts, prob)
  rownames(d) <- rownames(df) # should work as there was no group_by, so no tibble
  d
}

splitRootWord <- function(df) {
  d <- df %>%
    extract(grams, into=c('root','word'), regex='(.*) ([[:alnum:]]+)') %>%
    group_by(root) %>%
    mutate(prob=counts/sum(counts))
  d <- data.frame(d)
  rownames(d) <- rownames(df)
  d
}

foo <- function(sentence) {
  s <- stems(sentence, 4)
  a1 <- d[s[[1]],]
  a2 <- d[s[[2]],]
  a3 <- d[s[[3]],]
  a4 <- d[s[[4]],]
  
  a <- rbind(a1,a2,a3,a4)
  a[complete.cases(a),]
}

foo2 <- function(sentence, choices) {
  x = NULL
  for (ch in choices) {
    ss <- paste(sentence, ch)
    c <- foo(ss)
    if (is.null(x)) { x <- c }
    else { x <- rbind(x, c) }
  }
  print(x %>% arrange(desc(prob)))
}

stems <- function(w, maxStem) {
  elems <- words(w)
  l <- length(elems)
  idx <- seq(0, min(maxStem-1, l-1)) # in case we have less than maxStem
  vals <- list()
  for (i in idx) {
    vals[i+1] <- paste(elems[(l-i):l], collapse=' ')
  }
  vals
}

suggest <- function(sentence) {
  # check the length of the root
  stems(4)
}

doit <- function() {
  print('#9')
  foo2('and bruises from playing',c('daily','inside','weekly','outside'))
}