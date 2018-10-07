#test_AddToList.R

context("test_CreatDataFrame")

# ==== BEGIN SETUP AND PREPARE =================================================
#
#creat dataframe for MCL_example_output
cluster1<-c("sing","sang","sun","stain")
cluster2<-c("cat","hat","bat")
cluster3<-c("bit","fit")
cluster4<-c("happy","dupoy","abc","def","geee","gooo","cdf")
elements<-list(cluster1,cluster2,cluster3,cluster4)
Elements<-sapply(elements,paste0, collapse=",")
example_df<-data.frame("Name"=c("cluster1","cluster2","cluster3","cluster4"),"Element"=Elements,"Area"=c(4,3,2,7))

example_filepath<-sprintf("%s/R/MCL_example_output",getwd())
#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(CreatDataFrame(),"argument \"filepath\" is missing, with no default")
  expect_error(CreatDataFrame("wrong_path"), "filepath non-exist")
})

test_that("a sample input prouces the expected output",  {
  expect_equal(CreatDataFrame("MCL_example_output"), example_df)
})


# ==== BEGIN TEARDOWN AND RESTORE ==============================================
# Remove every persitent construct that the test has created, except for
# stuff in tempdir().
#
# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
