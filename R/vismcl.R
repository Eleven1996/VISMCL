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
#' @export
#' @param filepath filepath of the output of MCL
#' @return a dataframe used for plotting.
#' @examples
#' cat("a aa\n",file = "A")
#' CreatDataFrame("A")

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
#' @param showName (optional)if shows the name of clusters,default is FALSE
#' @param color (optional)A color code:color fill the circle,default is grey
#' @param Clusternames (optional) a vector for user-defined clusternames,
#' order should be the same as the lines go.
#' @return a circle packing graph representing the information
#' @export
#' @import ggplot2
#' @import ggiraph
#' @import packcircles
#' @examples
#' cat("a aa\n b bbb b\n",file = "A")
#' vismcl("A")
#' vismcl("A",showName = TRUE,color = "red")
#' Clust_names<-c("a","b")
#' vismcl("A",showName = TRUE,Clusternames = Clust_names)

vismcl <- function(filepath,showName=FALSE,Clusternames=NULL,color="grey") {
  #for package checking
  x<- y<- id<-NULL
  input_df<-CreatDataFrame(filepath)

  #if user provide Cluster name list,substitue it to the dataframe.
  #but first error checking:
  #(1):if more cluster names provided than acutual numbers of cluster, then definitly wrong, stop and produce error messages.
  #(2):if not enough cluster names, produce a warning messege (in case user only intentionally do that,programe still produce the result),
  #    use automatically formed name as substitution.
  if (is.null(Clusternames) == FALSE){
    if (length(Clusternames)!=nrow(input_df)){
      if (length(Clusternames) > nrow(input_df)){
        stop("More Cluster names than number of clusters")
      }
      else if (length(Clusternames) < nrow(input_df)){
        warning("not enough cluster names provided, the rest will be substitue by automaticly formed names")
        names<-sprintf("cluster%d",1:length(nrow(input_df)-length(Clusternames)))
        Clusternames<-c(Clusternames,names)
      }
    }
    input_df$Name<-Clusternames
  }
  print(input_df)

  #genearte dataframe for the position and size of each circle
  packing <- circleProgressiveLayout(input_df$Area)
  dat.gg <- circleLayoutVertices(packing,npoints=50)
  gg<-ggplot(data = dat.gg) +
      geom_polygon_interactive(
      aes(x, y, group = id,tooltip = input_df$Element[id], data_id = id),
      fill=color,
      colour = "black",
      show.legend = FALSE
      ) +
      labs(title = "Hover over circle to display cluster elements") +
      theme(axis.title.x=element_blank(),
            axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            panel.border = element_rect(colour = "black", fill=NA, size=2),
            panel.background = element_blank()
            )+
      coord_equal()
  #if user want to display the name of cluster
  if(showName){
  gg<-gg+geom_text(data=packing,aes(x,y),label= input_df$Name)
  }
  res<-ggiraph(ggobj = gg, width_svg = 5, height_svg = 5)
  return(res)
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
