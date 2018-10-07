# vismcl
#
# Purpose:creating a circle packing graph for output of MCL (Markov Cluster Algorithm) files
# Version:1.0.0
# Date:2018-10
# Author:Liwen Zhuang
#
# Input:text files
# Output:circle packing graph
# Dependencies:ggplot2,ggiraph,packcircles
#
# ToDo:
# Notes:
#
# ==============================================================================

#setwd("<your/project/directory>")

# ====  PARAMETERS  ============================================================
# filepath: A MCL output files without head or tail
# color: the color filled in the circle
# showName: if to show the cluster name or not


# ====  PACKAGES  ==============================================================
# Load all required packages.
if (! require(ggplot2, quietly=TRUE)) {
  install.packages("ggplot2")
  library(ggplot2)
}
# Package information:
#  library(help = ggplot2)       # basic information
#  browseVignettes("ggplot2")    # available vignettes
#  data(package = "ggplot2")     # available datasets
if (! require(ggiraph, quietly=TRUE)) {
  install.packages("ggiraph")
  library(ggiraph)
}
# Package information:
#  library(help = ggiraph)       # basic information
#  browseVignettes("ggiraph")    # available vignettes
#  data(package = "ggiraph")     # available datasets
if (! require(packcircles, quietly=TRUE)) {
  install.packages("packcircles")
  library(packcircles)
}
# Package information:
#  library(help = packcircles)       # basic information
#  browseVignettes("packcircles")    # available vignettes
#  data(package = "packcircles")     # available datasets

# ====  FUNCTIONS  =============================================================


# AddToList.R
#' AddToList
#'
#' add the text file from output of MCL to a nested list.
#'
#'
#' Details.
#' @section purpose: preparation for create dataframe used for plotting.
#' @param filepath the filepath of output of MCL.
#' @return A nested list.
#' @examples
#' temp<-sprintf("%s/R/MCL_example_output",getwd())
#' AddToList(temp)
AddToList <- function(filepath) {
  if (file.exists(filepath)==FALSE) stop("filepath non-exist")
  res<-list()
  i<-1
  input = file(filepath, "r")
  while ( TRUE ) {
    line = readLines(input, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    res[i]<-strsplit(line, " ")
    i<-i+1
  }

  close(input)
  return(res)
}


# CreatDataFrame.R
#' CreatDataFrame
#'
#' creat dataframe used for plotting from nested list
#'
#' Details.
#' @param filepath filepath of the output of MCL
#' @return a dataframe used for plotting.
#' @examples
#' temp<-sprintf("%s/R/MCL_example_output",getwd())
#' CreatDataFrame(temp)
CreatDataFrame <- function(filepath) {
  Nested_list<-AddToList(filepath)
  elements<-sapply(Nested_list,paste0, collapse=",")
  #automatcally generated cluster name
  names<-sprintf("cluster%d",1:length(Nested_list))
  #area is the size of the circle on the plot,which is proportional to the cluster size
  area<-c()
  for (i in 1:length(Nested_list)){
    area[i]<-length(Nested_list[[i]])
  }

  input_df<-data.frame("Name"=names,"Element"=elements,"Area"=area)

  return(input_df)
}


# vismcl.R
#' vismcl
#'
#' plot circle packing graph
#'
#' @param filepath the filepath of the output file of MCL
#' @param showName if shows the name of clusters,default is FALSE
#' @param color A color code:color fill the circle,default is grey#'
#' @return a circle packing graph representing the information
#' @export
#' @import ggplot2
#' @import ggiraph
#' @import packcircles
#' @examples
#' temp<-sprintf("%s/R/MCL_example_output",getwd())
#' vismcl(temp)
#' vismcl(temp)


vismcl <- function(filepath,showName=FALSE,color="grey") {
  x<- y<- id<-NULL
  input_df<-CreatDataFrame(filepath)
  #genearte dataframe for the position and size of each circle
  packing <- circleProgressiveLayout(input_df)
  dat.gg <- circleLayoutVertices(packing,npoints=50)
  dat.gg
  if (showName){
    gg<-ggplot(data = dat.gg) +
      geom_polygon_interactive(
        aes(x, y, group = id,
            tooltip = input_df$Element[id], data_id = id),
        fill=color,
        colour = "black",
        show.legend = FALSE) +
      geom_text(data=packing,aes(x,y),label= input_df$Name)+
      scale_y_reverse() +
      labs(title = "Hover over circle to display cluster elements") +
      coord_equal()
    ggiraph(ggobj = gg, width_svg = 5, height_svg = 5)
  }
  else{
    gg<-ggplot(data = dat.gg) +
      geom_polygon_interactive(
        aes(x, y, group = id,
            tooltip = input_df$Element[id], data_id = id),
        fill=color,
        colour = "black",
        show.legend = FALSE) +
      scale_y_reverse() +
      labs(title = "Hover over circle to display cluster elements") +
      coord_equal()
    ggiraph(ggobj = gg, width_svg = 5, height_svg = 5)
  }
}


# [END]

# ====  PROCESS  ===============================================================
# Enter the step-by-step process of your project here. Strive to write your
# code so that you can simply run this entire file and re-create all
# intermediate results.

#step1: store input data in nested list
#step2: build dataframe for plotting
#step3: plott




# ====  TESTS  =================================================================
# Enter your function tests here...


# [END]
