#test_AddToList.R

context("test_AddToList")

# ==== BEGIN SETUP AND PREPARE =================================================
#
nested_list<-list()
nested_list[[1]]<-c("PtgICMP6369|prot5289","PtoMax13|prot4847","PtoMax13|prot5307","PtoMax13|prot5316","PtoMax13|prot3921")
nested_list[[2]]<-c("PtgICMP6369|prot2819","PtoMax13|prot5307")
nested_list[[3]]<-c("PtgICMP6369|prot1903")
nested_list[[4]]<-c("PtgICMP6369|protssdd","PtoMax13|prot3345","PtoMax13|prot9700")

#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(AddToList(),"argument \"filepath\" is missing, with no default")
  expect_error(AddToList("wrong_path"), "filepath non-exist")
})

test_that("a sample input prouces the expected output",  {
  expect_equal(AddToList("testexample"), nested_list)
})


# ==== BEGIN TEARDOWN AND RESTORE ==============================================
# Remove every persitent construct that the test has created, except for
# stuff in tempdir().
#
# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
