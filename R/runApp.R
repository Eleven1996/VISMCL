# runvismclApp.R

#' \code{runvismclApp} launch the shiny app distributed with this package framework
#'
#' \code{runvismclApp} launches the shiny app for which the code has been placed in  \code{./inst/shiny-scripts/vismclApp/}.
#' @export

runvismclApp <- function() {
  appDir <- system.file("shiny-scripts", "vismclApp", package = "VISMCL")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}

# [END]
