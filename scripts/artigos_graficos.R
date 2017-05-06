library("dplyr")
library("ggplot2")
library("tm")
library("SnowballC")
library("wordcloud")
library("readr")

WordCount <- function(text) {
  docs <- Corpus(VectorSource(text))
  # Convert the text to lower case
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove english common stopwords
  docs <- tm_map(docs, removeWords, stopwords("english"))
  docs <- tm_map(docs, removeWords, stopwords("portuguese"))
  # Remove your own stop word
  # specify your stopwords as a character vector
  docs <- tm_map(docs, removeWords, c("blabla1", "blabla2"))
  # Remove punctuations
  docs <- tm_map(docs, removePunctuation, preserve_intra_word_dashes = T)
  # Eliminate extra white spaces
  docs <- tm_map(docs, stripWhitespace)
  # Text stemming
  #docs <- tm_map(docs, stemDocument)

  dtm <- TermDocumentMatrix(docs)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  return(d)
}

artigos <- read.csv("dados/artigos.csv") %>%
  mutate(titulo = as.character(titulo),
         periodo = ifelse(ano <= 2005, "1995 - 2005", "2006 - 2016"))

word_count <- artigos %>%
  group_by(periodo) %>%
  do(WordCount(.$titulo)) %>%
  group_by(periodo, word) %>%
  summarise(freq = sum(freq))

file <- "wordcloud lsd.png"
png(file, width = 1000, height = 500)
par(mfrow=c(1,2))
for (per in unique(word_count$periodo)) {
  #file <- paste("wordcloud ", per, ".png", sep = "")
  with(filter(word_count, periodo == per),
    wordcloud(words = word, freq = freq, min.freq = 1,
            max.words=150, random.order=FALSE, rot.per=0.35,
            colors=brewer.pal(8, "Dark2")))
  
}
dev.off()