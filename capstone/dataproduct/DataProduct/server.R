#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)

getSanitisedInput <- function(src) {
    docs <- VCorpus(VectorSource(c(src)))
    docs <- tm_map(docs, content_transformer(function(x) iconv(x, to='ASCII//TRANSLIT')))
    docs <- tm_map(docs, content_transformer(tolower))
    docs <- tm_map(docs, content_transformer(removePunctuation))
    docs <- tm_map(docs, content_transformer(stripWhitespace))
    docs <- tm_map(docs, content_transformer(removeNumbers))
    docs[[1]]$content
}

shinyServer(function(input, output, session) {

   observe({
       
       userInput <- input$inText
       numSuggestions <- input$numSuggestions
       choices <- c(input$suggestionDropDown, userInput)
       sentence <- getSanitisedInput(userInput)
       
       getSuggestions <- reactive({
            
               roots <- stems(sentence, 3)
               root_bigram <- ''
               root_trigram <- ''
               root_quadgram <- ''
               suggestions <- head(dt[root==''], numSuggestions)
               l <- length(roots)
               # unigram case
               if (l > 0) {
                   root_bigram <- roots[[1]]
                   res <- dt[root==root_bigram]
                   suggestions <- rbind(suggestions,res)
               }
               if (l > 1) {
                   root_trigram <- roots[[2]]
                   res <- dt[root==root_trigram]
                   suggestions <- rbind(suggestions,res)  
               }
               if (l > 2) {
                   root_quadgram <- roots[[3]]
                   res <- dt[root==root_quadgram]
                   suggestions <- rbind(suggestions,res)
               }
               raw_data <- head(suggestions[order(-score)], 20)
               print(raw_data)
               candidates <- head(unique(suggestions[order(-score)]$word), numSuggestions)
               return(list(tbl=raw_data,suggestions=candidates))
           })
       
       algo_output <- getSuggestions()
       print(algo_output)
       updateSelectInput(session, 'suggestionDropDown', choices=algo_output$suggestions)
       output$processedInput <- if (sentence != '') {renderText(sentence)} else {renderText('Input is empty!')}
       output$raw_data <- renderTable(algo_output$tbl)
       #updateTextInput(session, 'inText', value = paste(input$inText, 'foo'))
   })

})
