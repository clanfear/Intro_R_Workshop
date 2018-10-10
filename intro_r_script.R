# Introduction to R Workshop
# UW Tacoma, Autumn 2018

# This script is a companion file to the workshop slides found here:
# https://clanfear.github.io/Intro_R_Workshop/

# Overview

# 1. R and RStudio Orientation

# 2. Packages

# 3. Creating and Using Objects

# 4. Dataframes and Indexing

# 5. Basic Analyses

# 6. Resources for Further Learning

#####

# 1. R and RStudio Orientation

# R as a Calculator
     
# In the **console**, type `123 + 456 + 789` and hit `Enter`.
123 + 456 + 789

#  Now in your blank R document in the **editor**, try typing the line 
# sqrt(400) and either clicking *Run* or hitting `Ctrl+Enter` or `⌘+Enter`.

sqrt(400)

#     `sqrt()` is an example of a **function** in R.
   
#   If we didn't have a good guess as to what `sqrt()` will do, we can type `?sqrt` in the console
#   and look at the **Help** panel on the right.
   
?sqrt

#   **Arguments** are the *inputs* to a function. In this case, the only argument to `sqrt()`
#   is `x` which can be a number or a vector of numbers.
   
#   Help files provide documentation on how to use functions and what functions produce.
   

# Creating Objects
   
# R stores *everything* as an **object**, including data, functions, models, and output.
   
#   Creating an object can be done using the **assignment operator**: `<-` 

new.object <- 144

#   **Operators** like `<-` are functions that look like symbols but typically sit between their arguments 
#   (e.g. numbers or objects) instead of having them inside `()` like in `sqrt(x)`. 
   
#   .footnote[[1] We can actually call operators like other functions by stuffing them between backticks: <code>\`+\`(x,y)</code>]

#   We do math with operators, e.g., `x + y`. `+` is the addition operator!
   
# Calling Objects
   
#   You can display or "call" an object simply by using its name.
   
new.object


#   Object names can contain `_` and `.` in them, but cannot *begin* with numbers. Try
#   to be consistent in naming objects. RStudio auto-complete means *long names are better 
#   than vague ones*! 
   
#   *Good names<sup>1</sup> save confusion later.*
   
#   .footnote[[1] "There are only two hard things in Computer Science: cache invalidation and naming things." - Phil Karlton]
   
# Using Objects
   
#   An object's **name** represents the information stored in that **object**, so you can treat the object's name
#   as if it were the values stored inside.

new.object + 10
new.object + new.object
sqrt(new.object)

# Creating Vectors
   
# A **vector** is a series of **elements**, such as numbers. 


# You can create a vector and store it as an object in the same way. To do this, use the
# function `c()` which stands for "combine" or "concatenate".

new.object <- c(4, 9, 16, 25, 36)
new.object

# If you name an object the same name as an existing object, *it will overwrite it*.


# You can provide a vector as an argument for many functions.

sqrt(new.object)

# Character Vectors

# We often work with data that are categorical. To create a vector of text elements—**strings** in programming terms—we must place the text in quotes:

string.vector <- c("Atlantic", "Pacific", "Arctic")
string.vector

# Categorical data can also be stored as a **factor**, which has an underlying numeric representation. Models will convert factors to dummies.<sup>1</sup>

factor.vector <- factor(string.vector)
factor.vector

# .footnote[[1] Factors have **levels** which you can use to set a reference category in models using `relevel()`.]


# Saving and Loading Objects

# You can save an R object on your computer as a file to open later:
save(new.object, file="new_object.RData")

# You can open saved files in R as well:

load("new_object.RData")

# But where are these files being saved and loaded from?

# Working Directories

# R saves files and looks for files to open in your current **working directory**<sup>1</sup>. 
# You can ask R what this is:

getwd()

# Similarly, we can set a working directory like so:

setwd("C:/Users/cclan/Documents")

# More Complex Objects

# The same principles shown with vectors can be used with more complex objects 
# like **matrices**, **arrays**, **lists**, and **dataframes** (lists which look like matrices but can hold multiple data types at once).

# Most data sets you will work with will be read into R and stored as a **dataframe**, so the remainder of this workshop will mainly focus on using these objects.

# Loading Dataframes

# Delimited Text Files

# The easiest way to work with external data—that isn't in R format—is for it to be stored in a *delimited* text file, e.g. comma-separated values (**.csv**) or tab-separated values (**.tsv**). 

# R has a variety of built-in functions for importing data stored in text files, like `read.table()` and `read.csv()`.<sup>1</sup>
  
# .footnote[[1] Use "write" versions (e.g. `write.csv()`) to create these files from R objects.]

#  By default, these functions will read *character* (string) columns in as a *factor*.

# To disable this, use the argument `stringsAsFactors = FALSE`, like so:
  
new_df <- read.csv("some_spreadsheet.csv", stringsAsFactors = FALSE) # This will error since there is no spreadsheet here!

# Data from Other Software
  
#  Working with **Stata**, **SPSS**, or **SAS** users? You can use a **package** to bring in their saved data files:
  
#  * `foreign`
#+ Part of base R
#+ Functions: `read.spss()`, `read.dta()`, `read.xport()`
#+ Less complex but sometimes loses some metadata
#* `haven`
#+ Part of the `tidyverse` family
#+ Functions: `read_spss()`, `read_dta()`, `read_sas()`
#+ Keeps metadata like variable labels


# For less common formats, Google it. I've yet to encounter a data format without an 
# R package to handle it (or at least a clever hack).

# If you encounter an ambiguous file extension (e.g. `.dat`), try opening it with
# a good text editor first (e.g. Atom, Sublime); there's a good chance it is actually raw text
# with a delimiter or fixed format that R can handle!
  
# Installing Packages
  
# But what are packages? 
  
#  Packages contain functions (and sometimes data) created by the community. The real power of R is found in add-on packages!
#  For the remainder of this workshop, we will work with data from the `gapminder` package.

# These data are a panel data describing 142 countries observed every 5 years from 1952 to 2007.
# We can install `gapminder` from the Comprehensive R Archive Network (CRAN):
  
install.packages("gapminder")

# You only need to install a package **once** for any given version of R. You need to reinstall packages after upgrading R.
# Loading Packages
  
# To load a package, use `library()`:
  
library(gapminder)

# Once a package is loaded, you can call on functions or data inside it.

data(gapminder) # Places data in your global environment
head(gapminder) # Displays first six elements of an object

# Indexing and Subsetting

# Indices and Dimensions

# In base R, there are two main ways to access elements of objects: square brackets (`[]` or `[[]]`) and `$`. How you access an object depends on its *dimensions*.

# Dataframes have *2* dimensions: **rows** and **columns**. Square brackets allow us to numerically **subset** in the format of `object[row, column]`. Leaving the row or column place empty selects *all* elements of that dimension.

gapminder[1,] # First row
gapminder[1:3, 3:4] # First three rows, third and fourth column #<<


#    The **colon operator** (`:`) generates a vector using the sequence of integers from its first argument to its second. `1:3` is equivalent to `c(1,2,3)`.

# Dataframes and Names
  
#  Columns in dataframes can also be accessed using their names with the `$` extract operator. This will return the column as a vector:

gapminder$gdpPercap[1:10]

# Note here I *also* used brackets to select just the first 10 elements of that column.

# You can mix subsetting formats! In this case I provided only a single value (no column index) because **vectors** have *only one dimension* (length).

# If you try to subset something and get a warning about "incorrect number of dimensions", check your subsetting!

# Indexing by Expression
  
# We can also index using expressions—logical *tests*.

gapminder[gapminder$year==1952, ]

# How Expressions Work
  
#  What does `gapminder$year==1952` actually do? 
  
head(gapminder$year==1952, 50) # display first 50 elements

#  It returns a vector of `TRUE` or `FALSE` values.

# When used with the subset operator (`[]`), elements for which a `TRUE` is given are returned while those corresponding to `FALSE` are dropped.

# Logical Operators
  
#  We used `==` for testing "equals": `gapminder$year==1952`.
  
#  There are many other [logical operators](http://www.statmethods.net/management/operators.html):
  
#  * `!=`: not equal to
#  * `>`, `>=`, `<`, `<=`: less than, less than or equal to, etc.
#  * `%in%`: used with checking equal to one of several values

#  Or we can combine multiple logical conditions:
  
#  * `&`: both conditions need to hold (AND)
#  * `|`: at least one condition needs to hold (OR)
#  * `!`: inverts a logical condition (`TRUE` becomes `FALSE`, `FALSE` becomes `TRUE`)

# Logical operators are one of the foundations of programming. You should experiment with these to become familiar with how they work!

# Sidenote: Missing Values
  
#  Missing values are coded as `NA` entries without quotes:
  
vector_w_missing <- c(1, 2, NA, 4, 5, 6, NA)

# Even one `NA` "poisons the well": You'll get `NA` out of your calculations unless you remove them manually or use the extra argument `na.rm = TRUE` in some functions:

mean(vector_w_missing)
mean(vector_w_missing, na.rm=TRUE)

# Finding Missing Values

# **WARNING:** You can't test for missing values by seeing if they "equal" (`==`) `NA`:
  
vector_w_missing == NA

# But you can use the `is.na()` function:
  
is.na(vector_w_missing)

# We can use subsetting to get the equivalent of `na.rm=TRUE`:
  
mean(vector_w_missing[!is.na(vector_w_missing)]) #<<

#`!` *reverses* a logical condition. Read the above as "subset *not* `NA`"

  
# Multiple Conditions Example
  
#  Let's say we want observations from Oman after 1980 and through 2000.

gapminder[gapminder$country == "Oman" &
          gapminder$year > 1980 &
          gapminder$year <= 2000, ]

# Note we always need to use the full object name in each subseting argument, rather than just `country == "Oman"` alone. You can subset one object using another this way (e.g. `gapminder[other_data$some_variable == x, ]`).

# Saving a Subset

# If we think a particular subset will be used repeatedly, we can save it and give it a name like any other object:

China <- gapminder[gapminder$country == "China", ]
head(China, 4)

# Another Operator: `%in%`

# A common thing we may want to do is subset rows to things in some *set*.

# We can use `%in%` like `==` but it matches *any element* in the vector on its right. 

former_yugoslavia <- c("Bosnia and Herzegovina", "Croatia", 
                       "Macedonia", "Montenegro", "Serbia", "Slovenia")
yugoslavia <- gapminder[gapminder$country %in% former_yugoslavia, ]
head(yugoslavia)

# Create New Columns

# We can create new columns (variables) in a dataframe using the same subsetting functions.

yugoslavia$pop_million <- yugoslavia$pop / 1000000
yugoslavia$life_exp_past_40 <- yugoslavia$lifeExp - 40
head(yugoslavia)

# `ifelse()`

# A common function used in general in R programming is `ifelse()`. This returns a value depending on logical tests.

ifelse(test = x==y, yes = 1, no = 2) # This will error because it is just an example

# Output from `ifelse()`:
# * `ifelse()` returns the value assigned to `yes` (in this case, `1`) if `x==y` is `TRUE`.
# * `ifelse()` returns `no` (in this case, `2`) if `x==y` is `FALSE`.
# * `ifelse()` returns `NA` if `x==y` is neither `TRUE` nor `FALSE`.

# Note we can omit explicitly typing function arguments like `test = ` if we enter them in the order of arguments shown in the function's help page.

# `ifelse()` Example
  
yugoslavia$short_country <-  ifelse(yugoslavia$country == "Bosnia and Herzegovina",
                                        "B and H",
                                        as.character(yugoslavia$country))
yugoslavia[yugoslavia$year==1952, c(1,9)] # Selecting just columns 1 and 9

# Read this as "For each row, if `country` equals `"Bosnia and Herzegovina"`, 
# make `short_country` equal to `"B and H"`, otherwise make it equal to that row's 
# original value of `country` (as character, rather than factor, data)."

# This is a simple way to change some values but not others!
  
# Note that you can split arguments to a function into multiple lines for clarity, so long as lines end with an operator (like `+`) or comma (used to separate arguments).

# Analyses
## Basic Graphics and Models

# Histograms
  
#  We can use the `hist()` function to generate a histogram of a vector:
  
hist(gapminder$lifeExp,
     xlab = "Life Expectancy (years)", #<<
     main = "Observed Life Expectancies of Countries") #<<

# `xlab =` is used to set the label of the x-axis of a plot.
# `main = ` is used to set the title of a plot.
#    Use `?hist` to see additional options available for customizing a histogram.

# Scatter Plots
  
# RUN ALL THREE OF THESE FUNCTONS TO GET FULL PLOT: THEY STACK!
plot(lifeExp ~ gdpPercap, data = gapminder, #<<
     xlab = "ln(GDP per Capita)",
     ylab = "Life Expectancy (years)",
     main = "Life Expectancy and log GDP per Capita",
     pch = 16, log="x") # log="x" sets x axis to log scale!
abline(h = mean(gapminder$lifeExp), col = "firebrick") #<<
abline(v = mean(gapminder$gdpPercap), col = "cornflowerblue") #<<



# Note that `lifeExp ~ gdpPercap` is a **formula** of the type `y ~ x`. The first element (`dist`) gets plotted on the y-axis and the second (`speed`) goes on the x-axis.
            
# The `abline()` calls place horizontal (`h =`) or vertical (`v =`) lines at the means of the variables used in the plot. 

# Formulae
  
#  Most modeling functions in R use a common formula format—the same seen with the previous plot:
  
new_formula <- y ~ x1 + x2 + x3
new_formula
class(new_formula)

# The dependent variable goes on the left side of `~` and independent variables go on the right.

# See here for more on [formulae](https://www.datacamp.com/community/tutorials/r-formula-tutorial).

# Simple Tables
  
#  `table()` creates basic cross-tabulations of vectors.

table(mtcars$cyl, mtcars$am)

# Chi-Square
  
#  We can give the output from `table()` to `chisq.test()` to perform a Chi-Square test of assocation.

chisq.test(table(mtcars$cyl, mtcars$am))

# Note the warning here. You can use rescaled (`rescale.p=TRUE`) or simulated p-values (`simulate.p.value=TRUE`) if desired.

# T Tests
  
# T tests for mean comparisons are simple to do.

gapminder$post_1980 <- ifelse(gapminder$year > 1980, 1, 2)
t.test(lifeExp ~ post_1980, data=gapminder)

# Linear Models
  
#  We can run an ordinary least squares linear regression using `lm()`:
  
lm(lifeExp~pop + gdpPercap + year + continent, data=gapminder)

# Note we get a lot less output here than you may have expected! This is because
# we're only viewing a tiny bit of the information produced by `lm()`. We need to expore the object `lm()` creates!

# Model Summaries

# The `summary()` function provides Stata-like regression output:

lm_out <- lm(lifeExp~pop + gdpPercap + year + continent, data=gapminder)
summary(lm_out)

# Model Objects

# `lm()` produces a lot more information than what is shown by `summary()` however. We can see the **str**ucture of `lm()` output using `str()`:

str(lm_out)

#`lm()` actually has an enormous quantity of output! This is a type of object called a **list**.

# Model Objects

# We can access parts of `lm()` output using `$` like with dataframe names:

lm_out$coefficients

# We can also do this with `summary()`, which provides additional statistics:

summary(lm_out)$coefficients

# ANOVA

# ANOVAs can be fit and summarized just like `lm()`

summary(aov(lifeExp ~ continent, data=gapminder))

# More Complex Models

# R supports many more complex models, for example:

# * `glm()` has syntax similar to `lm()` but adds a `family =` argument to specify model families and link functions like logistic regression
# + ex: `glm(x~y, family=binomial(link="logit"))`

# * The `lme4` package adds hierarchical (multilevel) GLM models.

# * `lavaan` fits structural equation models with intuitive syntax.

# * `plm` and `tseries` fit time series models.

# Most of these other packages support mode summaries with `summary()` and all create output objects which can be accessed using `$`.

# Because R is the dominant environment for statisticians, the universe of modeling tools in R is *enormous*. If you need to do it, it is probably in a package somewhere.