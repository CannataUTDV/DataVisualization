# From ianmobbs/Regular Expression.R - https://gist.github.com/ianmobbs/36eab191e36286a437a78e41305c2ef0

#  A regular expression is a special text string for describing a search pattern. You can think of regular expressions as wildcards on steroids. You are probably familiar with wildcard notations such as *.txt to find all text files in a file manager. The regex equivalent is ^.*\.txt$.
#   The following special characters in a regular expression are often called "metacharacters". 
#   ?   The preceding item is optional and will be matched at most once.
#   *   The preceding item will be matched zero or more times.
#   +   The preceding item will be matched one or more times.
#   ^   Matches the beginning of a field or line. Or "not" if the patter begins with[^
#   $   Matches the end of a field or line.
#   .   Matches any character
#   |   or
#   ()  Grouping
#   []  Matches one character from the enclosed set of characters. [^something] not something
#   {n}   The preceding item is matched exactly n times.
#   {n,}  The preceding item is matched n or more times.
#   {n,m} The preceding item is matched at least n times, but not more than m times.
#   \     The following metacharacter losses it's special meaning.

lapply('alphabet begins with abc', gsub, pattern="[abc]",replacement= "")
# [1] "lphet egins with "
# [abc] will match one character from the enclosed set of characters, so it matched "a", "a", "b", "a", "b", "c"

lapply('alphabet begins with xyz', gsub, pattern="xyz",replacement= "")
# [1] "alphabet begins with "
# Not enclosing the "xyz" in any brackets meaning it looks for exact matches of "xyz"

lapply('alphabet begins with abc', gsub, pattern="[^ac]",replacement= "")
# [1] "aaac"
# The ^ at the beginning means it looks for anything that's NOT "a" or "c', leaving only a and c behind

lapply('alphabet begins with abc', gsub, pattern="^[abc]",replacement= "")
# [1] "lphabet begins with abc"
# ^ outside of [] indicates the beginning of the field, sothis will match 'a' 'b' or 'c' if it's the first letter in the field

lapply('alphabet begins with --- abc', gsub, pattern="[a-e]",replacement= "")
# [1] "lpht gins with --- "
# [a-e] matches any single character between a and e (same as [abcde])

lapply('alphabet begins with --- abc', gsub, pattern="[ae-]",replacement= "")
# [1] "lphbt bgins with  bc"
# [ae-] matches any single character 'a', 'e', or '-'

lapply('alphabet begins with \\\ abc', gsub, pattern="[ae\\]",replacement= "")
# [1] "lphbt bgins with  bc"
# Matches 'a', 'e', and '\'. Two '\' is an escape character, so you have to use the first '\' to escape the second '\'
# so it doesn't escape the ']' (or else you'll get an error that ']' isn't a special character, like '\n')

lapply('alphabet begins with [] abc', gsub, pattern="[ae[]",replacement= "")
# [1] "lphbt bgins with ] bc"
# Matches "a", "e", and "["

lapply('alphabet begins with [] abc', gsub, pattern="[ae]]",replacement= "")
# [1] "alphabet begins with [] abc"
# Matches 'a' or 'e' only if immediately followed by ']' (so it matches 'a]' and 'e]'

lapply('alphabet begins with [e] abc', gsub, pattern="[ae]]",replacement= "")
# [1] "alphabet begins with [ abc"
# Matches 'a' or 'e' only if immediately followed by ']' (so it matches 'a]' and 'e]'

lapply('alphabet begins with [e] abc', gsub, pattern="[[ae]]",replacement= "")
# [1] "alphabet begins with [ abc"
# Matches '[', 'a', 'e', only if immediately followed by ']' (so it matches '[]', 'a]', and 'e]'

lapply('alphabet begins with [e[] abc', gsub, pattern="[[ae]]",replacement= "")
# [1] "alphabet begins with [e abc"
# Matches '[', 'a', 'e', only if immediately followed by ']' (so it matches '[]', 'a]', and 'e]'

lapply('alphabet begins with abc', gsub, pattern="ab?c",replacement= "")
# [1] "alphabet begins with "
# Matches "abc" but b is optional, so "ac" or "abc" (but not "abbc")

lapply('alphabet begins with ac', gsub, pattern="ab?c",replacement= "")
# [1] "alphabet begins with "
# Matches "abc" but b is optional, so "ac" or "abc" (but not "abbc")

lapply('alphabet begins with aabc', gsub, pattern="a*bc",replacement= "")
# [1] "alphabet begins with "
# Matches any amount of a's (0 or more) if followed immediately by 'bc'

lapply('alphabet begins with bc', gsub, pattern="a*bc",replacement= "")
# [1] "alphabet begins with "
# Matches any amount of a's (0 or more) if followed immediately by 'bc'

lapply('alphabet begins with aabc', gsub, pattern="a+bc",replacement= "")
# [1] "alphabet begins with "
# Matches one or more a's immediately followed by 'bc'

lapply('alphabet begins with bc', gsub, pattern="a+bc",replacement= "")
# [1] "alphabet begins with bc"
# Matches one or more a's immediately followed by 'bc'

lapply('alphabet begins with aabc', gsub, pattern="a+.c",replacement= "")
# [1] "alphabet begins with "
# Matches one or more a's, followed by anything, up until the next 'c'. 'c' is required

lapply('alphabet begins with aabc', gsub, pattern=".*",replacement= "")
# [1] ""
# Matches any amount of any character

lapply('alphabet begins with aaabc', gsub, pattern="a{2}bc",replacement= "")
# [1] "alphabet begins with a"
# Matches 2 a's immediately followed by bc

lapply('alphabet begins with aaabc', gsub, pattern="a{4}bc",replacement= "")
# [1] "alphabet begins with aaabc"
# Matches 4 a's immediately followed by bc

lapply('alphabet begins with aaabc', gsub, pattern="(beg).*(abc)",replacement= "\\21234")
# [1] "alphabet abc1234"
# Matches all characters from 'beg' to 'abc'. '\\2' means "capture group 2", so it replaces the matches portion of the string
# with 'abc' (the second capture group), followed by '1234'

# Here's an interesting regular expression: gsub("(.*[^I]$)","\\1I", "B8")
# See Answer 3 at http://stackoverflow.com/questions/952275/regex-group-capture-in-r-with-multiple-capture-groups


# grep guide
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/grep.html

tmp <- head(diamonds, 20)
tmp

#    carat       cut color clarity depth table price     x     y     z
#    <dbl>     <ord> <ord>   <ord> <dbl> <dbl> <int> <dbl> <dbl> <dbl>
# 1   0.23     Ideal     E     SI2  61.5    55   326  3.95  3.98  2.43
# 2   0.21   Premium     E     SI1  59.8    61   326  3.89  3.84  2.31
# 3   0.23      Good     E     VS1  56.9    65   327  4.05  4.07  2.31
# 4   0.29   Premium     I     VS2  62.4    58   334  4.20  4.23  2.63
# 5   0.31      Good     J     SI2  63.3    58   335  4.34  4.35  2.75
# 6   0.24 Very Good     J    VVS2  62.8    57   336  3.94  3.96  2.48
# 7   0.24 Very Good     I    VVS1  62.3    57   336  3.95  3.98  2.47
# 8   0.26 Very Good     H     SI1  61.9    55   337  4.07  4.11  2.53
# 9   0.22      Fair     E     VS2  65.1    61   337  3.87  3.78  2.49
# 10  0.23 Very Good     H     VS1  59.4    61   338  4.00  4.05  2.39
# 11  0.30      Good     J     SI1  64.0    55   339  4.25  4.28  2.73
# 12  0.23     Ideal     J     VS1  62.8    56   340  3.93  3.90  2.46
# 13  0.22   Premium     F     SI1  60.4    61   342  3.88  3.84  2.33
# 14  0.31     Ideal     J     SI2  62.2    54   344  4.35  4.37  2.71
# 15  0.20   Premium     E     SI2  60.2    62   345  3.79  3.75  2.27
# 16  0.32   Premium     E      I1  60.9    58   345  4.38  4.42  2.68
# 17  0.30     Ideal     I     SI2  62.0    54   348  4.31  4.34  2.68
# 18  0.30      Good     J     SI1  63.4    54   351  4.23  4.29  2.70
# 19  0.30      Good     J     SI1  63.8    56   351  4.23  4.26  2.71
# 20  0.30 Very Good     J     SI1  62.7    59   351  4.21  4.27  2.66

tmp[1, c('carat', 'cut', 'color')] # Show the first row of tmp.
# # A tibble: 1 × 3
#   carat   cut color
#   <dbl> <ord> <ord>
# 1  0.23 Ideal     E

grep("Good", tmp$cut, perl=TRUE, value=FALSE)
# [1]  3  5  6  7  8 10 11 18 19 20

grep("Good", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
# # A tibble: 10 × 3
#    carat       cut color
#    <dbl>     <ord> <ord>
# 1   0.23      Good     E
# 2   0.31      Good     J
# 3   0.24 Very Good     J
# 4   0.24 Very Good     I
# 5   0.26 Very Good     H
# 6   0.23 Very Good     H
# 7   0.30      Good     J
# 8   0.30      Good     J
# 9   0.30      Good     J
# 10  0.30 Very Good     J

grep(" +", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
# # A tibble: 5 × 3
#   carat       cut color
#   <dbl>     <ord> <ord>
# 1  0.24 Very Good     J
# 2  0.24 Very Good     I
# 3  0.26 Very Good     H
# 4  0.23 Very Good     H
# 5  0.30 Very Good     J

grep("^G+", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
# # A tibble: 5 × 3
#   carat   cut color
#   <dbl> <ord> <ord>
# 1  0.23  Good     E
# 2  0.31  Good     J
# 3  0.30  Good     J
# 4  0.30  Good     J
# 5  0.30  Good     J

grep("^[^G+]", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
#    carat       cut color
#    <dbl>     <ord> <ord>
# 1   0.23     Ideal     E
# 2   0.21   Premium     E
# 3   0.29   Premium     I
# 4   0.24 Very Good     J
# 5   0.24 Very Good     I
# 6   0.26 Very Good     H
# 7   0.22      Fair     E
# 8   0.23 Very Good     H
# 9   0.23     Ideal     J
# 10  0.22   Premium     F
# 11  0.31     Ideal     J
# 12  0.20   Premium     E
# 13  0.32   Premium     E
# 14  0.30     Ideal     I
# 15  0.30 Very Good     J

grep("^G..d", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
# # A tibble: 5 × 3
#   carat   cut color
#   <dbl> <ord> <ord>
# 1  0.23  Good     E
# 2  0.31  Good     J
# 3  0.30  Good     J
# 4  0.30  Good     J
# 5  0.30  Good     J

grep("^Go*d", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
# # A tibble: 5 × 3
#   carat   cut color
#   <dbl> <ord> <ord>
# 1  0.23  Good     E
# 2  0.31  Good     J
# 3  0.30  Good     J
# 4  0.30  Good     J
# 5  0.30  Good     J

grep("^G.*d", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
# # A tibble: 5 × 3
#   carat   cut color
#   <dbl> <ord> <ord>
# 1  0.23  Good     E
# 2  0.31  Good     J
# 3  0.30  Good     J
# 4  0.30  Good     J
# 5  0.30  Good     J

grep("^Go+d", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
# # A tibble: 5 × 3
#   carat   cut color
#   <dbl> <ord> <ord>
# 1  0.23  Good     E
# 2  0.31  Good     J
# 3  0.30  Good     J
# 4  0.30  Good     J
# 5  0.30  Good     J

grep("^[Gg]o+d", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
# # A tibble: 5 × 3
#   carat   cut color
#   <dbl> <ord> <ord>
# 1  0.23  Good     E
# 2  0.31  Good     J
# 3  0.30  Good     J
# 4  0.30  Good     J
# 5  0.30  Good     J

grep("^[Gg]o+d|Fair", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
# # A tibble: 6 × 3
#   carat   cut color
#   <dbl> <ord> <ord>
# 1  0.23  Good     E
# 2  0.31  Good     J
# 3  0.22  Fair     E
# 4  0.30  Good     J
# 5  0.30  Good     J
# 6  0.30  Good     J

grep("((Very|Highly) Good)|Ideal", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
# # A tibble: 9 × 3
#   carat       cut color
#   <dbl>     <ord> <ord>
# 1  0.23     Ideal     E
# 2  0.24 Very Good     J
# 3  0.24 Very Good     I
# 4  0.26 Very Good     H
# 5  0.23 Very Good     H
# 6  0.23     Ideal     J
# 7  0.31     Ideal     J
# 8  0.30     Ideal     I
# 9  0.30 Very Good     J

#Unix example:
  #echo 'alphabet ;begins with [e[] abc' | tr ";" "\n" | sed "s/[[ae]]//"  

# For more examples see,
# http://www.endmemo.com/program/R/gsub.php

# Changing column values based upon a regular expression
# d <- with(diamonds, gsub("(Very|Highly) Good", "Great", cut)) %>% diamonds["cut", .]
