### SERVER

library(twitteR)
library(devtools)
library(magrittr)
library(tm)
library(wordcloud)

# Example Wordcloud
function(input, output, session) {
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    # Get tweets from Amanda's timeline and put them in a vector
    amanda.tweets <- userTimeline('AmandaBurnsFire',n = 3200,includeRts = FALSE)
    
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
    wordcloud(amanda.tweets.corpus,min.freq = 2, scale = c(4,2),colors=brewer.pal(8, "Dark2"),  
              random.color= TRUE, random.order = FALSE, max.words = 150)
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(4,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
}
## keep the streak alive