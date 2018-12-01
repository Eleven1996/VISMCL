# app.R
# shiny script for vismcl
#
#

library(shiny)
library(colourpicker)

# Define UI for my app
myUi <- fluidPage(

  titlePanel("Visualization of clusters"),

  sidebarLayout(position = "right",
                sidebarPanel(
                  fileInput(inputId = "inputfile",label = "Choose your input file"),
                  colourInput("col", "Select cluster color", "grey"),
                  checkboxInput("showName","Show the name of cluster",value=FALSE),
                  textInput("highlightName",label = "highlight cluster name",value = "name"),
                  colourInput("highlightcol","Select your highlight color","red")
                ),
                mainPanel(
                  ggiraphOutput(outputId = "circular")
                )

  )
)

myServer <- function(input, output) {
  output$circular <-renderggiraph({
    # For initiation
    inFile<-input$inputfile
    if(is.null(inFile)){
      return(NULL)
    }
    # get path of the temp file
    path<-input$inputfile$datapath
    vismcl(path,color = input$col,HighlightColor = input$highlightcol,showName = input$showName,
           HighlightByName = input$highlightName)
  })
}

shinyApp(ui = myUi, server = myServer)

# [END]
