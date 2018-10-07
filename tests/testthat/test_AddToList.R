#test_AddToList.R

context("test_AddToList")

# ==== BEGIN SETUP AND PREPARE =================================================
#
nested_list<-list()
nested_list[[1]]<-c("sing","sang","sun","stain")
nested_list[[2]]<-c("cat","hat","bat")
nested_list[[3]]<-c("bit","fit")
nested_list[[4]]<-c("happy","dupoy","abc","def","geee","gooo","cdf")

example_filepath<-sprintf("%s/MCL_example_output",getwd())
#
# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(AddToList(),"argument \"filepath\" is missing, with no default")
  expect_error(AddToList("wrong_path"), "filepath non-exist")
})

test_that("a sample input prouces the expected output",  {
  expect_equal(AddToList("C:/Users/liwen/Desktop/410/VISMCL/R/MCL_example_output"), nested_list)
})


# ==== BEGIN TEARDOWN AND RESTORE ==============================================
# Remove every persitent construct that the test has created, except for
# stuff in tempdir().
#
# ==== END  TEARDOWN AND RESTORE ===============================================

# [END]
