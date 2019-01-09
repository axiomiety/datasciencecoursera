#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel('Data Science Capstone: Predictive Text Input'),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput('numSuggestions',
                        'Maximum number of suggestions',
                        min = 1,
                        max = 10,
                        value = 5),
            textInput('inText',label='Your input', placeholder='Tomorrow let\'s go and'),
            submitButton(text='Suggest')
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel('Main',
                    h2('Suggestion'),
                    selectInput('suggestionDropDown','Choices',choices=c())),
                tabPanel('Peek under the hood',
                    h4('Processed input'),
                    textOutput('processedInput'),
                    h4('Top 20 scores'),
                    tableOutput('raw_data')
                    )
            )
        )
    )
))
