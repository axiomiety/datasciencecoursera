

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

```R
> cbind(1:3,4:6)
     [,1] [,2]
[1,]    1    4
[2,]    2    5
[3,]    3    6
```

#### Factors

Note the ordering of the levels following the `levels` attribute.

```R
> x <- factor(c("y","n","y"))
> x
[1] y n y
Levels: n y
> unclass(x)
[1] 2 1 2
attr(,"levels")
[1] "n" "y"
> x <- factor(c("y","n","y"), levels=c("y","n"))
> x
[1] y n y
Levels: y n
```

#### Dataframes

Coersing into a matrix will force objects to have a common type.

```R
> data.frame(col1=1:3,col2=c(T,F,T))
  col1  col2
1    1  TRUE
2    2 FALSE
3    3  TRUE
```

#### Names

This is cool!

```R
> x <- 1:3
> names(x) <- c('a','b','c')
> x
a b c 
1 2 3 
> x[2]
b 
2 
> attributes(x[2])
$`names`
[1] "b"
> x <- list(a=1,b=2)
> x$a
[1] 1
> m <- matrix(1:4, nrow=2)
> n
Error: object 'n' not found
> m
     [,1] [,2]
[1,]    1    3
[2,]    2    4
> dimnames(m) <- c(c('a','b'), c('c','d'))
Error in dimnames(m) <- c(c("a", "b"), c("c", "d")) : 
  'dimnames' must be a list
> dimnames(m) <- list(c('a','b'), c('c','d'))
> m
  c d
a 1 3
b 2 4
```

### Reading/writing data

`R` needs all the data to be held in memory (RAM). `read.table` assumes columns are space-separated. There are a number of optimisations that can be used to read data faster, such as specifying the (approximate) number of rows.

Use `dump` or `dput` to save data in a textual format (which can be edited).

`dump` takes a character vector with the names of the objects.

Use `rm` to delete an object.

Data is read using connection interfaces - e.g. `file`,`gzfile`,`bzfile`,`url`. E.g.

```R
conn <- gzFile('words.gz')
z <- readLines(conn, 10)
close(conn)
```

### Subsetting

`[]` always return the same type back. With `[[]]` the object that comes back may/may not be the same - same with `$` (though `$` requires a literal whereas `[[]]`` can use computed values).

```R
> x <- 1:10
> x[x > 5]
[1]  6  7  8  9 10
> u <- x > 5
> u
 [1] FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE
> x[u]
[1]  6  7  8  9 10
```

Partial matching is something that `$` does by default:

```R
> x <- list(aardvark = 1:5)
> x$a
[1] 1 2 3 4 5
> x[["a", exact=F]]
[1] 1 2 3 4 5
> x[["a"]]
NULL
```

Subsetting matrices:

```R
> x <- matrix(1:6,2,3)
> x[1,]
[1] 1 3 5
> x[,1]
[1] 1 2
> x
     [,1] [,2] [,3]
[1,]    1    3    5
[2,]    2    4    6
```
can add a `drop=FALSE` argument to the splicing to return something of the same dimension (as in, by default `drop` is TRUE).


To find out if a value is NA, use `is.na` which you can negate the selection with `!`. Use `complete.cases` to sort through data jointly:


```R
> x <- c("a", NA, "b")
> y <- c(NA, NA, "d")
> complete.cases(x,y)
[1] FALSE FALSE  TRUE
```

And this works equally well on dataframes.

### Loops

```R
> for (letter in c("a","b","c")) print(letter)
[1] "a"
[1] "b"
[1] "c"
```

Similarly with `while` - conditions are evaluated from left to right.

`repeat` runs until it hits a `break`. `next` moves to the next iteration.

### Scoping

`search()` returns the namespace order.

Some interesting bits about how lexical scoping works (e.g. free variables are searched for in the environment in which it was defined before rolling up to each parent environment). It can also be the body of another function.

You can explore a function's environment with `environment(fn)`, and pick out attributes with `get` - e.g. `get("n", environment(fn))`.

The parent frame is the environment in which a function was called.

A consequence of lexcial scoping is that all objects must be stored in memory.

### Dates and Times

`Date` for dates`, `POSIXct`/`POSIXlt`. Internally stored as epoch (1970-01-01).

```R
> x <- as.Date("1970-01-03")
> unclass(x)
[1] 2
```

The `lt` version of `POSIX` stores a list underneath and attributes can be accessed with `$`. Note year is stored as an offset since 1900. Weird...

```R
> x <- as.POSIXlt(Sys.time())
> names(unclass(x))
 [1] "sec"    "min"    "hour"   "mday"  
 [5] "mon"    "year"   "wday"   "yday"  
 [9] "isdst"  "zone"   "gmtoff"
> x$year
[1] 118
> x$mon
[1] 5
```
Usual `strptime` to parse a date and `strftime` .

You can do arithmetic on dates.

### `apply`

`lapply` - always returns a list:

```R
> lapply(list(c(1,3,NA),c(1,3)), mean, na.rm=T)
[[1]]
[1] 2

[[2]]
[1] 2
```
Anonymous functions are just defined on the spot:

```R
> lapply(1:3, function(x) x+1)
[[1]]
[1] 2

[[2]]
[1] 3

[[3]]
[1] 4
```

`sapply` will try tries to bunch everything into a vector.

`apply` - specify which dimension. E.g. passing a matrix with 2 allows you to collapse the rows. There are specific (optimised?) functions for operations on matrices - `rowSums,rowMeans,colSums,colMeans`.

`mapply` - multivariate apply. 

```R
> mapply(sum, 1:5,5:1)
[1] 6 6 6 6 6
```

It vectorises the arguments by default:

```R
> mapply(sum, 1:5, 1)
[1] 2 3 4 5 6
```

`tapply` - specify the indices on which to apply the function.

`split` seems to be more of a 'group by':

```R
> library(datasets)
> head(airquality)
  Ozone Solar.R Wind Temp Month Day
1    41     190  7.4   67     5   1
2    36     118  8.0   72     5   2
3    12     149 12.6   74     5   3
4    18     313 11.5   62     5   4
5    NA      NA 14.3   56     5   5
6    28      NA 14.9   66     5   6
> s <- split(airquality, airquality$Month)
> lapply(s, function(x) colMeans(x[,c("Ozone", "Solar.R", "Wind")]))
$`5`
   Ozone  Solar.R     Wind 
      NA       NA 11.62258 

$`6`
    Ozone   Solar.R      Wind 
...
```

The months have been turned into factors. Though for this, summarisation with `sapply` is neater:

```R
> sapply(s, function(x) colMeans(x[,c("Ozone", "Solar.R", "Wind")], na.rm=T))
                5         6          7          8         9
Ozone    23.61538  29.44444  59.115385  59.961538  31.44828
Solar.R 181.29630 190.16667 216.483871 171.857143 167.43333
Wind     11.62258  10.26667   8.941935   8.793548  10.18000
```

You can generate factors with `gl` - first 2 arguments are the number of levels and the number of occurrences:

```R
> gl(2,5)
 [1] 1 1 1 1 1 2 2 2 2 2
Levels: 1 2
> gl(5,2)
 [1] 1 1 2 2 3 3 4 4 5 5
Levels: 1 2 3 4 5
```

### Debug

3 levels: `message`,`warning`,`error` - only `error` is fatal.

Misc: `invisible(x)` prevents auto-printing in the REPL. `print` returns the value it printed.

Tools:
 * `traceback` - call stack
 * `debug(fn)` - enable step-through execution of the function
 * `browser` - stick that function in your code to start debugging at a particular line
 * `trace` - debugging code without modifying the executing code
 * `recover` - opens the browser when there's an error instead of returning to the shell

`browser` drops you in the function's R environment. `n` for the next line. They can nest too.

`options(error=recover)` stays live for the session.

Use `system.time` to time expressions.

`Rprof()`/`Rprof(NULL)`. `summaryRprof()` for summary. Sample interval is 0.02 seconds. C/Fortran code is *not* profiled.

### Misc

Clear the current environment with `rm(list=ls())`.

`str` vs `summary`.

```R
> str(1:100)
 int [1:100] 1 2 3 4 5 6 7 8 9 10 ...
> str(gl(10,5))
 Factor w/ 10 levels "1","2","3","4",..: 1 1 1 1 1 2 2 2 2 2 ...
> str(airquality)
'data.frame':	153 obs. of  6 variables:
 $ Ozone  : int  41 36 12 18 NA 28 23 19 8 NA ...
 $ Solar.R: int  190 118 149 313 NA NA 299 99 19 194 ...
 $ Wind   : num  7.4 8 12.6 11.5 14.3 14.9 8.6 13.8 20.1 8.6 ...
 $ Temp   : int  67 72 74 62 56 66 65 59 61 69 ...
 $ Month  : int  5 5 5 5 5 5 5 5 5 5 ...
 $ Day    : int  1 2 3 4 5 6 7 8 9 10 ...
```

`seq` can take either a `by` arg for increment size or `length` (it'll work out the increment itself).

### Random numbers

 * `rnorm` - N(mu, sigma)
 * `dnorm` - evaluate at given point/vector
 * `pnorm` - cumulative
 * `rpois` - Poisson at given rate

Nomenclature:ty
 * `r`: random (sample from)
 * `p`: cumulative
 * `q`: quantile

`sample`, `replace=T` for replacement.

### MySQL

```R
> library(RMySQL)
Loading required package: DBI
> ucscDb <- dbConnect(MySQL(),user="genome",host="genome-mysql.cse.ucsc.edu")
> result <- dbGetQuery(ucscDb,"show databases;")
> dbDisconnect(ucscDb)
[1] TRUE
```
You can do some basic SQL metadata queries too:

```R
> hg19 <- dbConnect(MySQL(fetch.default.rec = 10), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
> dbListFields(hg19, "affyU133Plus2")
 [1] "bin"         "matches"     "misMatches"  "repMatches"  "nCount"      "qNumInsert" 
 [7] "qBaseInsert" "tNumInsert"  "tBaseInsert" "strand"      "qName"       "qSize"      
[13] "qStart"      "qEnd"        "tName"       "tSize"       "tStart"      "tEnd"       
[19] "blockCount"  "blockSizes"  "qStarts"     "tStarts" 
```

Read in a whole table with `dbReadTable`, or from a SQL query:

```R
> hg19 <- dbConnect(MySQL(fetch.default.rec = 10), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
> q <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
There were 16 warnings (use warnings() to see them)
> a <- fetch(q)
> typeof(a)
[1] "list"
> length(a)
[1] 22
> a$bin
 [1] 585 586  73 587 587 587 588 588 589 589
> a2 <- fetch(q)
> a2$bin
 [1] 589 590 590 590  73 590 590 591 591 591
> length(a$bin)
[1] 10
```

So you need to fetch continuously until the data has been exhausted.

### HDF5

```R
> library(rhdf5)
> c = h5createFile("container.h5")
> h5createGroup("container.h5","foo")
[1] TRUE
> h5createGroup("container.h5","bar")
[1] TRUE
> h5createGroup("container.h5","foo/foobaa")
[1] TRUE
> h5ls()
Error in h5checktypeOrOpenLoc(file, readonly = TRUE, native = native) : 
  argument "file" is missing, with no default
> h5ls("container.h5")
  group   name     otype dclass dim
0     /    bar H5I_GROUP           
1     /    foo H5I_GROUP           
2  /foo foobaa H5I_GROUP           
> h5write(1:10, "container.h5", "foo/A")
> h5ls("container.h5")
  group   name       otype  dclass dim
0     /    bar   H5I_GROUP            
1     /    foo   H5I_GROUP            
2  /foo      A H5I_DATASET INTEGER  10
3  /foo foobaa   H5I_GROUP
```

And `h5read` to read it back - supports indexing to read a subset. `h5write` can also write a particular index - e.g. a set of columns/rows.

### HTML

Via the `httr` library + `htmlParse`. It supports authentication - use `handle` to essentially create and re-use sessions.
03JAN1990     23.4-0.4     25.1-0.3     26.6 0.0     28.6 0.3

### Files

Wrappers around OS functionality: `file.create,file.rename,file.copy,file.exists` ... Set `recursive=T` to create nested directorys with `dir.create`.

You can check file attributes with `file.info`.

Can use `download.file` to store it somewhere (e.g. with `tempfile()` to generate a random filename) or `url`, which seems to fetch the contents - can be used as an argument to the likes of `read.csv` etc...

There are libraries for XML and JSON - but it's not part of the core language.  
