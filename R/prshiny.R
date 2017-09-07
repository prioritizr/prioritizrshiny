NULL

#' Run one of the Shiy apps for prioritizrshiny
#'
#' Set targets expressed as the actual value of features in the study area 
#' that need to be represented in the prioritization. The argument to 
#' \code{x} is treated the same as for \code{\link{add_relative_targets}}.
#' 
#' @param x string for the app directory object.
#'
#' @param ... not used.
#' 
#' @details
#' Targets are used to specify the minimum amount or proportion of a feature's
#' distribution that needs to be protected. All conservation planning problems require 
#' adding targets with the exception of the maximum cover problem 
#' (see \code{\link{add_max_cover_objective}}), which maximizes all features 
#' in the solution and therefore does not require targets. 
#'
#' @return Starts a Shiny app wrapper for prioritzr functions.
#'
#' @seealso \code{\link{problem}},  \code{\link{add_relative_targets}}, \code{\link{add_loglinear_targets}}.
#'
#' @examples
#' # list available shiny apps
#' prshiny()
#'
#' # run the basic app
#' prshiny("base_app")
#'
#' @aliases prioritizrshiny
#' 
#' @name prshiny
#' @docType methods
NULL

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