setwd('c:/shared/datasciencecoursera/capstone/en_US/')
set.seed(20180101)

sampleFile <- function(fileName, newFileName, threshold) {
  con <- file(description = fileName, open = 'rb') # we read the file in binary so we ignore control characters like C-z
  file.create(newFileName)
  newFileCon <- file(description = newFileName, open = 'w')
  linesRead <- 0
  totalLines <- 0
  while (length(line <- readLines(con, n = 1, warn = FALSE, skipNul = TRUE)) > 0) {
    if (runif(1) < threshold) {
      linesRead <- linesRead + 1
      writeLines(line, con = newFileCon)
    }
    totalLines <- totalLines + 1
  }
  close(newFileCon)
  close(con)  
  print(paste('read',linesRead,'out of',totalLines,'lines from',fileName,'into',newFileName))
}

threshold = 0.005 #0.5%

sampleAll <- function () {
  
  s <- function(f_in) {
    f_out = sub('.txt','.sample.txt',f_in)
    sampleFile(f_in, f_out, threshold)
  }
  
  s('en_US.blogs.txt')
  s('en_US.news.txt')
  s('en_US.twitter.txt')
}


