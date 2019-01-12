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
                    br(),
                    p('The first step is to normalise user input. This means, among other things, converting it to lower case, removing extra whitespace, numbers etc...'),
                    h4('Processed input'),
                    textOutput('processedInput'),
                    br(),
                    p('Once this is done, we match the new input against our reference table. We first try to find the longest possible match, and gradually remove words. Entries with a shorter match are penalised somewhat - but if they have a heavy enough weight, will end up scoring higher than an entry with a longer match.'),
                    h4('Top 20 scores'),
                    tableOutput('raw_data')
                    )
            )
        )
    )
))
