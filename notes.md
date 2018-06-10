

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

And [this for data structures](http://adv-r.had.co.nz/Data-structures.html).
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

#### Bioconductor

```R
source("http://biconductor.org/biocLite.R"))
biocLite()
biocLite(c("GenomicFeatures","AnnotationDbi"))
```

### Working directory and loading files/functions/objects into the workspace:

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

### Types

* character
* numeric (real)
* integer
* complex
* logical (TRUE/FALSE - or T/F as shorthand)

To force an integer, suffix with 'L' like `2L`.

`vector()` for an empty vector, `vector("numberic", length=10)`. Need to watch out for type coercion. `c(1.7, "a")`.

 `1/0` is `Inf`.

Some types have attributes - use `attributes(obj)`.

`typeof(obj)` to get a string representation. Not sure how this differs from `class(obj)`.

Convert with `as.numeric`, `as.character` etc...

#### Lists

1-indexed! Note the funky behaviour with `-1` as an index.

```R
> x <- list(1, "a", T, 1+4i)
> x[-1]
[[1]]
[1] "a"

[[2]]
[1] TRUE

[[3]]
[1] 1+4i

> x[0]
list()
> x
[[1]]
[1] 1

[[2]]
[1] "a"

[[3]]
[1] TRUE

[[4]]
[1] 1+4i
```

#### Matrices


```R
> m <- matrix(nrow = 2, ncol=3)
> dim(m)
[1] 2 3
> attributes(m)
$`dim`
[1] 2 3

> m
     [,1] [,2] [,3]
[1,]   NA   NA   NA
[2,]   NA   NA   NA
```

Constructed columns-wise.

```R
> matrix(1:6, nrow = 2, ncol=3)
     [,1] [,2] [,3]
[1,]    1    3    5
[2,]    2    4    6
```

Can be formed from vectors.

```R
> m <- 1:6
> dim(m)
NULL
> dim(m) <- c(3,2)
> m
     [,1] [,2]
[1,]    1    4
[2,]    2    5
[3,]    3    6
```

Column & row binding.
