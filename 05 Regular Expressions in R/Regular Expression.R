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
lapply('alphabet begins with abc', gsub, pattern="xyz",replacement= "")
lapply('alphabet begins with abc', gsub, pattern="[^abc]",replacement= "")
lapply('alphabet begins with abc', gsub, pattern="^[abc]",replacement= "")
lapply('alphabet begins with --- abc', gsub, pattern="[a-e]",replacement= "")
lapply('alphabet begins with --- abc', gsub, pattern="[ae-]",replacement= "")
lapply('alphabet begins with \\\ abc', gsub, pattern="[ae\\]",replacement= "")
lapply('alphabet begins with [] abc', gsub, pattern="[ae[]",replacement= "")
lapply('alphabet begins with [] abc', gsub, pattern="[ae]]",replacement= "")
lapply('alphabet begins with [e] abc', gsub, pattern="[ae]]",replacement= "")
lapply('alphabet begins with [e] abc', gsub, pattern="[[ae]]",replacement= "")
lapply('alphabet begins with [e[] abc', gsub, pattern="[[ae]]",replacement= "")

lapply('alphabet begins with abc', gsub, pattern="ab?c",replacement= "")
lapply('alphabet begins with ac', gsub, pattern="ab?c",replacement= "")
lapply('alphabet begins with aabc', gsub, pattern="a*bc",replacement= "")
lapply('alphabet begins with bc', gsub, pattern="a*bc",replacement= "")
lapply('alphabet begins with aabc', gsub, pattern="a+bc",replacement= "")
lapply('alphabet begins with bc', gsub, pattern="a+bc",replacement= "")
lapply('alphabet begins with aabc', gsub, pattern="a+.c",replacement= "")
lapply('alphabet begins with aabc', gsub, pattern=".*",replacement= "")
lapply('alphabet begins with aaabc', gsub, pattern="a{2}bc",replacement= "")
lapply('alphabet begins with aaabc', gsub, pattern="a{4}bc",replacement= "")
lapply('alphabet begins with aaabc', gsub, pattern="(beg).*(abc)",replacement= "\\21234")

# Here's an interesting regular expression: gsub("(.*[^I]$)","\\1I", "B8")
# See Answer 3 at http://stackoverflow.com/questions/952275/regex-group-capture-in-r-with-multiple-capture-groups

tmp <- head(diamonds, 20)
tmp
tmp[1, c('carat', 'cut', 'color')] # Show the first row of tmp.
grep("Good", tmp$cut, perl=TRUE, value=FALSE)

grep("Good", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
grep(" +", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
grep("^G+", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
grep("^[^G+]", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
grep("^G..d", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
grep("^Go*d", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
grep("^G.*d", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
grep("^Go+d", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
grep("^[Gg]o+d", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
grep("^[Gg]o+d|Fair", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df
grep("((Very|Highly) Good)|Ideal", tmp$cut, perl=TRUE, value=FALSE) %>% tmp[., c('carat', 'cut', 'color')] %>% tbl_df

# Changing column values based upon a regular expression
# d <- with(diamonds, gsub("(Very|Highly) Good", "Great", cut)) %>% diamonds["cut", .]
