#test_AddToList.R

context("test_CreatDataFrame")

# ==== BEGIN SETUP AND PREPARE =================================================
#
#creat dataframe for MCL_example_output
cluster1<-c("PtgICMP6369|prot5289","PtoMax13|prot4847","PtoMax13|prot5307","PtoMax13|prot5316","PtoMax13|prot3921")
cluster2<-c("PtgICMP6369|prot2819","PtoMax13|prot5307")
cluster3<-c("PtgICMP6369|prot1903")
cluster4<-c("PtgICMP6369|protssdd","PtoMax13|prot3345","PtoMax13|prot9700")
elements<-list(cluster1,cluster2,cluster3,cluster4)
Elements<-sapply(elements,paste0, collapse=",")
example_df<-data.frame("Name"=c("cluster1","cluster2","cluster3","cluster4"),"Element"=Elements,"Area"=c(5,2,1,3))


#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(CreatDataFrame(),"argument \"filepath\" is missing, with no default")
  expect_error(CreatDataFrame("wrong_path"), "filepath non-exist")
})

test_that("a sample input prouces the expected output",  {
  expect_equal(CreatDataFrame("testexample"), example_df)
})


# ==== BEGIN TEARDOWN AND RESTORE ==============================================
# Remove every persitent construct that the test has created, except for
# stuff in tempdir().
#
# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
