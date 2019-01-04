setwd('c:/shared/datasciencecoursera/capstone/')
library('tm')
library('data.table')
#src <- DirSource(directory='c:/shared/datasciencecoursera/capstone/en_US', pattern='chunk42')

NgramTokenizer <- function(x, n) {
  unlist(lapply(ngrams(words(x), n), paste, collapse = ' '), use.names = FALSE) }

UnigramTokenizer <- function(x) {NgramTokenizer(x, 1)}
BigramTokenizer <- function(x) {NgramTokenizer(x, 2)}
TrigramTokenizer <- function(x) {NgramTokenizer(x, 3)}
QuadgramTokenizer <- function(x) {NgramTokenizer(x, 4)}

getCorpus <- function(src) {
  docs <- VCorpus(src)
  docs <- tm_map(docs, content_transformer(function(x) iconv(x, to='ASCII//TRANSLIT')))
  docs <- tm_map(docs, content_transformer(tolower))
  docs <- tm_map(docs, content_transformer(removePunctuation))
  docs <- tm_map(docs, content_transformer(stripWhitespace))
  docs <- tm_map(docs, content_transformer(removeNumbers))
  docs
}

convertTdmToDF <- function(tdm, threshold=1) {
  # convert into a matrix, and sum up the occurrences across all documents
  # we can do this because our application won't context-sensitive (e.g. blog vs tweet)
  m <- as.matrix(tdm)
  rs <- rowSums(m)
  # remove anything that occurs less than the given threshold
  rs_trim <- rs[rs > threshold]
  data.frame(grams=names(rs_trim), counts=rs_trim)
}

joinDFs <- function(df1, df2) {
  d <- data.table(rbind(df1, df2))
  #d[,list(counts=sum(counts)), by=c('root','word')]
  d[,list(counts=sum(counts)), by=grams]
}

splitGramsIntoRootWord <- function(df) {
  d <- df %>%
    extract(grams, into=c('root','word'), regex='(.*) ([[:alnum:]]+)') %>%
    group_by(root) %>%
    mutate(prob=counts/sum(counts))
  d <- data.frame(d)
  rownames(d) <- rownames(df)
  d
}

splitGramsIntoRootWordDT <- function(df) {
  data.table(tidyr::extract(df, into=c('root','word'), regex='(.*) ([[:alnum:]]+)'))
}

df1 <- data.frame(root=c('the','the','the'), word=c('great','dog','next'), counts=c(2,3,10))
df2 <- data.frame(root=c('the','the','i','i'), word=c('great','cat','am','think'), counts=c(5,100,1,20))

processNgrams <- function(fn, src) {
  corpus <- getCorpus(src)
  if (is.null(fn)) {
    # we want words of 1 and more characters
    tdm <- TermDocumentMatrix(corpus, control = list(wordLengths=c(1, Inf)))
  } else {
    tdm <- TermDocumentMatrix(corpus, control = list(tokenize = fn))
  }
}

# sprintf('chunk%02d', seq(0,20))
bigLoop <- function(files,fn) {
  x <- data.frame()
  for (chunk in files) {
    print(paste('processing', chunk))
    src <- DirSource(directory='c:/shared/datasciencecoursera/capstone/en_US', pattern=chunk)
    tdm <- processNgrams(fn=fn, src=src)
    df <- convertTdmToDF(tdm)
    existing_num_rows = nrow(x)
    print(paste('number of rows so far', nrow(x)))
    #print(paste('number of rows in chunk', nrow(df)))
    if (nrow(x) == 0) { x <- df }
    else {
      x <- joinDFs(x, df)
      new_num_rows = nrow(x)
      delta = new_num_rows - existing_num_rows
      print(paste('after merge, added', delta, 'lines, an increase in ', sprintf('%02.f', delta/existing_num_rows*100), '%'))
    }
    rm(tdm)
    rm(df)
    rm(src)
  }
  x
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

# head(bbigram[order(-counts)])
# q <- bbigram[root == 'jumps', .(sum(counts)), by=root][1,'V1'][[1]]
suggest <- function(sentence) {
  roots <- stems(sentence, 3)
  root_bigram <- ''
  root_trigram <- ''
  root_quadgram <- ''
  suggestions <- head(dt[root==''], 5)
  l <- length(roots)
  # unigram case
  if (l > 0) {
    root_bigram <- roots[[1]]
    res <- dt[root==root_bigram]
    suggestions <- rbind(suggestions,res)
  }
  if (l > 1) {
    root_trigram <- roots[[2]]
    res <- dt[root==root_trigram]
    suggestions <- rbind(suggestions,res)  
  }
  if (l > 2) {
    root_quadgram <- roots[[3]]
    res <- dt[root==root_quadgram]
    suggestions <- rbind(suggestions,res)
  }
  print(head(suggestions[order(-score)], 10))
  head(unique(suggestions[order(-score)]$word), 5)
}

#load('grams_freqs')

transformAndCompute <- function(min_counts) {
  unigram <<- unigram[counts > min_counts]
  bigram <<- bigram[counts > min_counts]
  trigram <<- trigram[counts > min_counts]
  quadgram <<- quadgram[counts > min_counts]
  
  # make available in parent environment - usually global
  unigram <<- tidyr::extract(unigram, grams, into=c('root','word'), regex='()(.*)')
  bigram <<- tidyr::extract(bigram, grams, into=c('root','word'), regex='(.*) ([[:alnum:]]+)', remove=FALSE)
  trigram <<- tidyr::extract(trigram, grams, into=c('root','word'), regex='(.*) ([[:alnum:]]+)', remove=FALSE)
  quadgram <<- tidyr::extract(quadgram, grams, into=c('root','word'), regex='(.*) ([[:alnum:]]+)', remove=FALSE)

  # now for the scores
  t <- trigram[,c('grams','counts')]
  b <- bigram[,c('grams','counts')]
  
  quadgram <<- quadgram[t, on=c(root='grams')][,c('root','word','counts','i.counts')]
  quadgram <<- quadgram[,score:=counts/i.counts]
  trigram <- trigram[b, on=c(root='grams')][,c('root','word','counts','i.counts')]
  trigram <<- trigram[,score:=alpha*counts/i.counts]
  bigram <- bigram[unigram, on=c(root='word')][,c('root','word','counts','i.counts')]
  bigram <<- bigram[,score:=alpha*alpha*counts/i.counts]
  
  tot = sum(unigram$counts)
  unigram <<- unigram[,score:=alpha*alpha*alpha*counts/tot]
  
  b <- bigram[,-c('i.counts')]
  t <- trigram[,-c('i.counts')]
  q <- quadgram[,-c('i.counts')]
  x <- rbind(unigram,b,t,q)
}
f <- function() {
  trigram <<- tidyr::extract(trigram, grams, into=c('bigram'), regex='[[:alnum:]]{1} (.*)', remove=FALSE)
  quadgram <<- tidyr::extract(quadgram, grams, into=c('trigram'), regex='[[:alnum:]]{1} (.*)', remove=FALSE)
  
  alpha <- 0.4
  
  t <- trigram[,c('grams','counts')]
  quadgram <<- quadgram[t, on=c(trigram='grams')][,c('root','word','counts','i.counts')]
  quadgram <<- quadgram[!is.na(quadgram$root)] # filter out NAs from the full join
  quadgram <<- quadgram[,score:=counts/i.counts]
  
  b <- bigram[,c('grams','counts')]
  trigram <<- trigram[b, on=c(bigram='grams')][,c('root','word','counts','i.counts')]
  trigram <<- trigram[!is.na(trigram$root)]
  trigram <<- trigram[,score:=alpha*counts/i.counts]
  
  bigram <<- bigram[unigram, on=c(word='word')][,c('root','word','counts','i.counts')]
  bigram <<- bigram[!is.na(bigram$root)]
  bigram <<- bigram[,score:=alpha*alpha*counts/i.counts]
  
  tot = sum(unigram$counts)
  unigram <<- unigram[,score:=alpha*alpha*alpha*counts/tot]
  
  
  b <- bigram[,-c('i.counts')]
  t <- trigram[,-c('i.counts')]
  q <- quadgram[,-c('i.counts')]
  x <- rbind(unigram,b,t,q)
  #unigram[,freqs:=counts/sum(counts), by=root]
  #bigram[,freqs:=counts/sum(counts), by=root]
  #trigram[,freqs:=counts/sum(counts), by=root]
  #quadgram[,freqs:=counts/sum(counts), by=root]
}