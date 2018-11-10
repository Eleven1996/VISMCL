# VISMCL

## visualization of output of MCL

Welcome,
This is a package used to generate a graph to represent the information given by the output of MCL alogorithm files.

-----------------------------------------------

Note: make sure your input file is in the correct format:<br>
1.cluster elements seperated by white space<br>
2.clusters sepearted by newline<br>
3.no headings or tail<br>
4.must have a newline at the end of the file<br>

Instructions:<br>
this package only contain one function "vismcl"<br>
it has four argument,except the first one, the rest are optional:<br>
1. filepath: this is the filepath of MCL output file.<br>
2. showName: if argument is TRUE, the cluster name will show on the cycle.Default is FALSE<br>
3. Clusternames: user can define a vector containing the names of each cluster,the order of the name should be the same order of MCL output file(e.g first line->first cluster->first element in the vector).Defult is NULL. <br>
If the length of vector provided is less than the number of clusters, it will fill up the rest with automatically formed names and produce the result,and gives a warning. <br>
If the length of vector provided is more than the number of clusters, it will gives an error. <br>
4. color: the color of the circle. Default is grey.<br>

Example:
path<-sprintf("%s/inst/exampleInput/example1",getwd())
nametags<-c("1","2","3","4","6")
vismcl(path,TRUE,nametags,"blue")

-----------------------------------------------

Load the package (outside of this project) with:
    `devtools::install_github("Eleven1996/VISMCL")`

-----------------------------------------------
Citation:<br>
https://www.r-graph-gallery.com/circle-packing/ <br>
https://cran.r-project.org/web/packages/packcircles/vignettes/progressive_packing.html <br>
Hardley Wickham <R packages>

End
