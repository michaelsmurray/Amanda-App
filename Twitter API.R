## http://shiny.rstudio.com/gallery/word-cloud.html
## https://github.com/dipanjanS/MyShinyApps/blob/master/twitter-analysis/server.r
## http://blog.dataweave.in/post/96618078833/building-a-twitter-sentiment-analysis-app-using-r
## https://www.credera.com/blog/business-intelligence/twitter-analytics-using-r-part-2-create-word-cloud/
library(twitteR)
library(devtools)
library(magrittr)
library(tm)
library(wordcloud)

# Connect to Twitter API
setup_twitter_oauth("Ymh4NPPegflFdn2kkV1xLkE8p", 
                    "YjxuSCDNLq6pRTBbBhle8TkQdsrxl3ZYbhdquMhLNCCn38Je13",
                    "1226463924-T6FlKmRYdFzVChLKiDVPQawvpJZcRgsY5O1E5eN",
                    "JpNPprfhHlSx1YoKx67evZlR8jwwowFyAE5UBbZsRSjvP")  
# Get tweets from Amanda's timeline and put them in a vector
amanda.tweets <- userTimeline('AmandaBurnsFire',n = 3200,includeRts = FALSE)
amanda.tweets <- sapply(amanda.tweets, function(x) x$getText())

# don't know why piping shits the bed here
# amanda.tweets <- tolower(amanda.tweets) %>%
#   gsub("rt", "", amanda.tweets) %>%
#   gsub("@\\w+", "", amanda.tweets) %>%
#   gsub("[[:punct:]]", "", amanda.tweets) %>%
#   gsub("http\\w+", "", amanda.tweets) %>%
#   gsub("[ |\t]{2,}", "", amanda.tweets) %>%
#   gsub("^ ", "", amanda.tweets) %>%
#   gsub(" $", "", amanda.tweets)


# For the love of god why do you use so many emojis
amanda.tweets <- twListToDF(amanda.tweets)
amanda.tweets$text <- sapply(amanda.tweets$text,function(row) iconv(row, "latin1", "ASCII", sub=""))

# Replace blank space ("rt")
amanda.tweets <- gsub("rt", "", amanda.tweets)

# Replace @UserName
amanda.tweets <- gsub("@\\w+", "", amanda.tweets)

# Remove punctuation
amanda.tweets <- gsub("[[:punct:]]", "", amanda.tweets)

# Remove links
amanda.tweets <- gsub("http\\w+", "", amanda.tweets)

# Remove tabs
amanda.tweets <- gsub("[ |\t]{2,}", "", amanda.tweets)

# Remove blank spaces at the beginning
amanda.tweets <- gsub("^ ", "", amanda.tweets)

# Remove blank spaces at the end
amanda.tweets <- gsub(" $", "", amanda.tweets)

# Convert to lowercase
amanda.tweets <- tolower(amanda.tweets)

# create corpus and remove stopwords
amanda.tweets.corpus <- Corpus(VectorSource(amanda.tweets[1]))
amanda.tweets.corpus <-  tm_map(amanda.tweets.corpus, function(x)removeWords(x,stopwords()))


# generate wordcloud
wordcloud(amanda.tweets.corpus,min.freq = 2, scale=c(7,0.5),colors=brewer.pal(8, "Dark2"),  
          random.color= TRUE, random.order = FALSE, max.words = 150)






###################################################################
#                                                                 #  
#                     THE OTHER FUCKING CODE                      # 
#                                                                 #
#                                                                 #
###################################################################

amanda.tweets <- userTimeline('AmandaBurnsFire',n = 3200,includeRts = FALSE)
amanda.tweets = sapply(amanda.tweets, function(x) x$getText())

# create a corpus
amanda.corpus = Corpus(VectorSource(amanda.tweets))

# create document term matrix applying some transformations
tdm = TermDocumentMatrix(amanda.tweets,
                         control = list(removePunctuation = TRUE,
                                        stopwords = c("machine", "learning", stopwords("english")),
                                        removeNumbers = TRUE, tolower = TRUE))

# define tdm as matrix
m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)

# plot wordcloud
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))





