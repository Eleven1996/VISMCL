# VISMCL

## visualization of output of MCL

Welcome,
This is a package used to generate a graph to represent the information given by the output of MCL alogorithm files.

-----------------------------------------------

Note: make sure your input file is in the correct format:<br>
1.cluster elements seperated by tab<br>
2.clusters sepearted by newline<br>
3.no headings or tail<br>
4.must have a newline at the end of the file<br>

Instructions:<br>
this package contain three functions "vismcl","vismclL" and "runvismclAPP" <br>
both "vismcl" and "vismclL" have following parameters:<br>
1. filepath:(required) this is the filepath of MCL output file.<br>
2. showName:(optional) if argument is TRUE, the cluster name will show on the cycle.Default is FALSE<br>
3. Clusternames: (optional)user can define a vector containing the names of each cluster,the order of the name should be the same order of MCL output file(e.g first line->first cluster->first element in the vector).Defult is NULL. <br>
If the length of vector provided is less than the number of clusters, it will fill up the rest with automatically formed names and produce the result,and gives a warning. <br>
If the length of vector provided is more than the number of clusters, it will gives an error. <br>
4. color:(optional) the color of the circle. Default is grey.<br>
5. HighlightByName:(optional) The name of the clusters you want to highlight.
5. HighlightFirstN:(optional) a number n,it will highlight the first n largest cluster.
7. HighlightColor:(optional) color code used for highlighint.
vismclL has an extra parameter filterN: it will only show the largest N cluster in the result graph.

Example files:<br>
example files are in inst/exampleInput files, there are two example files:<br>
(1)example1 is a small example with only 3 clusters,the content are meaningless<br>
(2)5.group is a larger example,it is the actual result get from PorthoMC,which is the orthologous group
clusters for 5 genomes.<br>

Example:<br>
> path<-sprintf("%s/inst/exampleInput/example1",getwd())
> nametags<-c("1","2","3","4")
> vismcl(filepath=path,showName=TRUE,Clusternames=nametags,
                   color="grey",HighlightByName="1",HighlightColor="chartreuse1")
> vismclL(filepath=path,filterN=3,showName=TRUE,HighlightFirstN=1)

Example shiny usage:
> runvismclAPP()


-----------------------------------------------

Load the package (outside of this project) with:
    `devtools::install_github("Eleven1996/VISMCL")`

-----------------------------------------------
Citation:<br>
https://www.r-graph-gallery.com/circle-packing/ <br>
https://cran.r-project.org/web/packages/packcircles/vignettes/progressive_packing.html <br>
Hardley Wickham <R packages>

End
