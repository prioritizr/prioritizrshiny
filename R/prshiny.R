prshiny <- function(app) {
  # locate all the shiny apps that exist
  validapps <- list.files(system.file("shiny-apps", package = "prioritzrshiny"))
  
  validappsMsg <-
    paste0(
      "Valid apps are: '",
      paste(validapps, collapse = "', '"),
      "'")
  
  # if an invalid app is given, throw an error
  if (missing(app) || !nzchar(app) ||
      !app %in% validapps) {
    stop(
      'Please run `runapp()` with a valid app app as an argument.\n',
      validappsMsg,
      call. = FALSE)
  }
  
  # find and launch the app
  appDir <- system.file("shiny-apps", app, package = "prioritzrshiny")
  shiny::runApp(appDir, display.mode = "normal")
}