NULL

#' Get a list of available Shiny apps
#'
#' Description of the prshiny function.
#'
#'
#' @param ... not used.
#'
#' @details
#' Need to provide details for the function.
#'
#' @return Returns a list of available Shiny apps.
#'
#' @seealso \code{\link{prshiny}}.
#'
#' @examples
#' # list available shiny apps
#' prshiny_apps()
#'
#' # run the basic app
#' # Not run
#' #prshiny("base_app")
#'
#' @name prshiny_apps
#' @docType methods
NULL

#' @export
prshiny_apps <- function(...) {
  # locate all the shiny apps that exist
  validapps <- list.files(system.file("shiny-apps", package = "prioritizrshiny"))
  
  paste0(
      "Valid apps are: '",
      paste(validapps, collapse = "', '"),
      "'")
}
