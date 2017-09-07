prshiny <- function(app) {
  # locate all the shiny apps that exist
  validapps <- list.files(system.file("shiny-apps", package = "prioritizrshiny"))
  
  validappsMsg <-
    paste0(
      "Valid apps are: '",
      paste(validapps, collapse = "', '"),
      "'")
  
  # if an invalid app is given, throw an error
  if (missing(app) || !nzchar(app) ||
      !app %in% validapps) {
    stop(
      'Please run `prshiny()` with a valid app as an argument.\n',
      validappsMsg,
      call. = FALSE)
  }
  
  # find and launch the app
  appDir <- system.file("shiny-apps", app, package = "prioritizrshiny")
  shiny::runApp(appDir, display.mode = "normal")
}