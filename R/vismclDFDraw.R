# vismclprep
#
# Purpose:preparation for vismcl and vismclL
# Version:3.0.0
# Date:2018-11
# Author:Liwen Zhuang
#
# Input:text files path
# Output:circle packing graph
# Dependencies:ggplot2,ggiraph,packcircles
#
# ====  PARAMETERS  ============================================================
# filepath: A MCL output files,element seperated by tab
# input_df: A dataframe used for plotting
# color: the color filled in the circle
# showName: if to show the cluster name or not
# Clusternames: user defined cluster name vector
# HighlightByName: a cluster name string which user want to hightlight
# HighlightFirstN: a number, hightlight the largest n clusters
# HighlightColor: a string represent a code name,used for highlighting
# ====  FUNCTIONS  =============================================================

# AddToList.R
#' AddToList
#'
#' add the text file from output of MCL to a nested list.
#'
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
    res[i]<-strsplit(line, "\t")
    i<-i+1
  }

  close(input)
  return(res)
}


# CreatDataFrame.R
#' CreatDataFrame
#'
#' creat dataframe used for plotting from nested list
#' @param filepath filepath of the output of MCL
#' @return a basic dataframe used for plotting.

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


# vismclDfDraw.R
#' vismclDfDraw
#'
#' plot circle packing graph with data frame.
#'
#' @param input_df dataframe created by CreateDataFrame
#' @param showName (optional)if shows the name of clusters,default is FALSE
#' @param color (optional)A color code:color fill the circle,default is grey
#' @param Clusternames (optional) a vector for user-defined clusternames,
#' order should be the same as the lines go.
#' @param HighlightByName (optional) a vector of cluster names which user wish to highlight.
#' @param HighlightFirstN (optional) an integer:highlight the first n largest cluster.
#' @param HighlightColor (optional) A color code: color used for highlight, default is green
#' @import ggplot2
#' @return a circle packing graph representing the information

vismclDfDraw <- function(input_df,showName=FALSE,
                         Clusternames=NULL,color="grey",HighlightByName=NULL,
                         HighlightFirstN=0,HighlightColor="chartreuse1") {
  #for package checking
  x<- y<- id<-NULL

  #add Color column
  colors<-c()
  for (i in 1:nrow(input_df)){
    colors[i]=color
  }
  input_df$Color<-colors
  #change Color to Highlight color if user gives cluster name
  #findName are used for error checking
  findName<-0
  if (!is.null(HighlightByName)){
    for (i in 1:nrow(input_df)){
      if (input_df$Name[i] %in% HighlightByName){
        input_df$Color[i]<-HighlightColor
        findName<-1
      }
    }
    if (findName==0){
      warning("Invalid input: cluster name does not exist")
    }

  }

  #Highlight First N
  #cutoff is the nth largest area size
  #change all the cluster with area larger than cutoff to highlight color
  if (!(HighlightFirstN==0)){
    #error checking
    if (HighlightFirstN > nrow(input_df)|| HighlightFirstN < 0){
      warning("invalid input:trying to highlight more than total number of clusters or number less than 0.")
    }
    else if ((HighlightFirstN-round(HighlightFirstN))!=0){
      warning("invalid input: input is not an integer")
    }
    else{
      cutoff<-sort(input_df$Area,TRUE)[HighlightFirstN]
      cat(sprintf("highlight cluster with more than %d elements.\n",cutoff))
      for (i in 1:nrow(input_df)){
        if (input_df$Area[i]>=cutoff){
          input_df$Color[i]<-HighlightColor
        }
      }
    }
  }

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

  #draw according to the dataframe
  packing <- packcircles::circleProgressiveLayout(input_df$Area)
  dat.gg <- packcircles::circleLayoutVertices(packing,npoints=50)
  gg<-ggplot(data = dat.gg) +
    ggiraph::geom_polygon_interactive(
      aes(x, y, group = id,fill= factor(id),tooltip = input_df$Element[id], data_id = id),
      colour = "black",
      show.legend = FALSE
    ) +
    scale_fill_manual(values = input_df$Color)+
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
  res<-ggiraph::ggiraph(ggobj = gg, width_svg = 5, height_svg = 5,selection_type = 'multiple',
               hover_css = "cursor:pointer;fill:orange;stroke:black;")
  return(res)
}



# ====  PROCESS  ===============================================================
# Enter the step-by-step process of your project here. Strive to write your
# code so that you can simply run this entire file and re-create all
# intermediate results.

#step1: store input data in nested list
#step2: build dataframe for plotting
#step3: modification of the dataframe
#step3: error checking and plott


# [END]
