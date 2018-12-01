# vismcl(L).R
#
# Purpose:main functions of vismcl and vismclL
# Version:3.0.0
# Date:2018-11
# Author:Liwen Zhuang
#
# Input:text files path
# Output:circle packing graph
# Dependencies:ggplot2,ggiraph,packcircles
#
# ========
#' vismcl
#'
#' plot circle packing graph with given filepath,recommand vismclL for very large input data
#'
#' @param filepath the filepath of the output file of MCL
#' @param showName (optional)if shows the name of clusters,default is FALSE
#' @param color (optional)A color code:color fill the circle,default is grey
#' @param Clusternames (optional) a vector for user-defined clusternames,
#' order should be the same as the lines go.
#' @param HighlightByName (optional) a vector of cluster names which user wish to highlight.
#' @param HighlightFirstN (optional) an integer:highlight the first n largest cluster.
#' @param HighlightColor (optional) A color code: color used for highlight, default is green
#' @return a circle packing graph representing the information and print the dataframe in the console
#' @export
#' @import ggplot2
#' @import ggiraph
#' @import packcircles
#' @examples
#' cat("a aa\n b bbb b\n",file = "example")
#' vismcl("example",showName = TRUE,Clusternames=c("1","2"),color="white",HighlightByName="1",
#'        HighlightFirstN=1,HighlightColor="red")
vismcl <- function(filepath,showName=FALSE,Clusternames=NULL,
                   color="grey",HighlightByName=NULL,HighlightFirstN=0,HighlightColor="chartreuse1") {
  #create dataframe
  input_df<-CreatDataFrame(filepath)
  print(input_df)
  vismclDfDraw(input_df,showName,Clusternames,color,HighlightByName,HighlightFirstN,HighlightColor)
}

# vismclL.R
#' vismclL
#'
#' plot circle packing graph with given filepath,
#' with an extra filter attribute to only print the largest n clusters,
#' also will not print the processed data frame
#'
#' @param filepath the filepath of the output file of MCL
#' @param filterN the first n largest clusters will be plotted. if there are more than one
#' cluster with the cutoff size,vismclL will print all of them.
#' @param showName (optional)if shows the name of clusters,default is FALSE
#' @param color (optional)A color code:color fill the circle,default is grey
#' @param Clusternames (optional) a vector for user-defined clusternames,
#' order should be the same as the lines go.
#' @param HighlightByName (optional) a vector of cluster names which user wish to highlight.
#' @param HighlightFirstN (optional) an integer:highlight the first n largest cluster.
#' @param HighlightColor (optional) A color code: color used for highlight, default is green
#' @return a circle packing graph representing the information
#' @export
#' @import ggplot2
#' @import ggiraph
#' @import packcircles
#' @examples
#' cat("a aa\n b bbb b\n",file = "example")
#' vismclL("example")
vismclL <- function(filepath,filterN=0,showName=FALSE,Clusternames=NULL,
                    color="grey",HighlightByName=0,HighlightFirstN=0,HighlightColor="chartreuse1") {
  #create original dataframe
  input_df<-CreatDataFrame(filepath)
  #error checking
  if (!(filterN==0)){
    if( filterN > nrow(input_df)|| (filterN-round(filterN))!=0 ){
      stop("invalid filterN input: more than total number of clusters or not a integer")
    }
    else{
      cutoff<-sort(input_df$Area,TRUE)[filterN]
      NewDF<-input_df[input_df$Area >= cutoff,]
      vismclDfDraw(NewDF,showName,Clusternames,color,HighlightByName,HighlightFirstN,HighlightColor)
    }
  }
  else {
    vismclDfDraw(input_df,showName,Clusternames,color,HighlightByName,HighlightFirstN,HighlightColor)
  }
}


# [END]
