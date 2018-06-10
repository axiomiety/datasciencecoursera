

## `git`

* `git add .` add all new files
* `git add -u` updates tracking for files that changed names/got deleted
* `git add -A` both of the above
* `git checkout -b <branchname>`
* `git branch` to display the active branch
* `git checkout master` to go back to the master branch
* `git push`
* `git pull`
* `git fetch`

## `R`

A dialect of `S`. "Programming with Data" by John Chambers, 1998.

### Documentation

[CRAN](https://cran.r-project.org/manuals.html) manuals. 'R Internals' looks pretty intimidating! 'Writing R Extensions' looks neat though.

### Install issues

I had issues installing the version shipped with Anaconda. Upon launching it kept asking to download a file, which is the behaviour described [here](https://stackoverflow.com/questions/50385198/failed-to-start-rstudio-installed-in-anaconda).

The workaround was to download the latest Windows build from https://dailies.rstudio.com/ and press Ctrl when launching the app (not through the start menu but from the installed location - like `C:\Program Files\RStudio\bin` to select the 32-bit version of R).

### Packages

```R
a <- available.packages()
head(rownames(a), 3)
```

```R
install.pacakges("slidify")`
install.packages(c("slidify","ggplot2","devtools"))
```

Working directory and loading files/functions/objects into the workspace:

```R
> getwd()
[1] "c:/shared/datasciencecoursera"
> setwd('c:/shared/datasciencecoursera/')
> ls()
character(0)
> dir()
[1] "HelloWorld.md" "mycode.R"      "notes.md"     
> source('mycode.R')
> ls()
[1] "myfunction"
```

RStudio supports tab completion! And you can put slashes the 'proper way'.

#### Bioconductor

```R
source("http://biconductor.org/biocLite.R"))
biocLite()
biocLite(c("GenomicFeatures","AnnotationDbi"))
```
