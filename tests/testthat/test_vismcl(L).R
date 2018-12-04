#test_vismcl(L).R

context("test_AddToList")
#mainly test the error checkings for vismcl and vismcl(L)
# ==== BEGIN SETUP AND PREPARE =================================================
CN<-c("a","b","c")
CN2<-c("a","b","c","d","e")
filterNumber<-10
HighlightN<-10

# ==== END SETUP AND PREPARE ===================================================

test_that("corrupt input generates errors",  {
  expect_error(vismcl(),"argument \"filepath\" is missing, with no default")
  expect_error(vismcl("wrong_path"), "filepath non-exist")
})

test_that("user given invalid clusternames",  {
  expect_warning(vismcl("testexample",Clusternames = CN ),
                 "not enough cluster names provided, the rest will be substitue by automaticly formed names" )
  expect_error(vismcl("testexample",Clusternames = CN2),"")
})

test_that("user given invalid HighlightFirstN number or invalid name for HighlightByName",  {
  expect_warning(vismcl("testexample",HighlightFirstN = HighlightN ),"invalid input:trying to highlight more than total number of clusters or number less than 0." )
  expect_warning(vismcl("testexample",HighlightByName = "not exist" ),"Invalid input: cluster name does not exist")
})

test_that("user given invalid filter number",  {
  expect_error(vismclL("testexample",filterN = filterNumber ),"" )
})


# [END]
