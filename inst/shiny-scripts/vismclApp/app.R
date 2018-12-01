# app.R
# shiny script for vismcl
#
#
#=== load required packages===
if (! require(shiny, quietly=TRUE)) {
  install.packages("shiny")
  library(shiny)
}
if (! require(colourpicker, quietly=TRUE)) {
  install.packages("colourpicker")
  library(colourpicker)
}


# Define UI for my app
myUi <- fluidPage(

  titlePanel("Visualization of clusters"),

  sidebarLayout(position = "right",
                sidebarPanel(
                  fileInput(inputId = "inputfile",label = "Choose your input file"),
                  colourInput("col", "Select cluster color",value =  "white"),
                  checkboxInput("showName","Show the name of cluster",value=FALSE),
                  textInput("highlightName",label = "highlight cluster name",value = "name"),
                  colourInput("highlightcol","Select your highlight color","red"),
                  sliderInput("clusterN","choose the number of clusters you want to show",min = 0,max = 10,value = 1),
                  helpText("When choose 0 as number of clusters shown, it will show all the clusters.")
                ),
                mainPanel(
                  h3("Liwen Zhuang"),
                  h3("Highlight cluster by clicking on graph or type its name."),
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
    input_df<-CreatDataFrame(path)
    if (input$clusterN > nrow(input_df)){
      acturalclusterN<-nrow(input_df)
    }
    else{
      acturalclusterN<-input$clusterN
    }
    vismclL(path,filterN=acturalclusterN,color = input$col,HighlightColor = input$highlightcol,showName = input$showName,
           HighlightByName = input$highlightName)
  })

}

shinyApp(ui = myUi, server = myServer)

# [END]
