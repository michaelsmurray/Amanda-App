## http://shiny.rstudio.com/gallery/word-cloud.html
## https://github.com/dipanjanS/MyShinyApps/blob/master/twitter-analysis/server.r
## http://blog.dataweave.in/post/96618078833/building-a-twitter-sentiment-analysis-app-using-r

library(twitteR)
library(devtools)

setup_twitter_oauth("v9ZWJfjzpnTjsl5h8jUb37pws","bc9xO3GVqmw41sDQ7PXULDdPxV7STaQ6wuSagDHTOB5JxF4H2X", access_token= NULL, access_secret= NULL)
tweets <- searchTwitter('#rstats', n=10)
View(tweets)
head(tweets)

##Extract the text from the tweets in a vector
mach_text = sapply(mach_tweets, function(x) x$getText())

cran_tweets <- userTimeline('cranatic')
amanda.tweets <- userTimeline('AmandaBurnsFire',n = 3200, )
amanda.tweets2 <- userTimeline('AmandaBurnsFire',n = 3200)

df <- twListToDF(amanda.tweets)
