#' Vector-based data for use as prioritzrshiny example
#'
#' A dataset containing the values, conservation status, and features for 1130 planning units 
#' in Tasmania.
#'
#' @format A SpatialPolygonsDataFrame with 1130 planning units and 67 variables:
#' \describe{
#'   \item{id}{Planning unit id}
#'   \item{cost}{Unimproved land values}
#'   \item{status}{Current protection status of a planning unit}
#'   \item{locked_in}{Vector of planning units to lock into a solution}
#'   \item{locked_out}{Vector of planning units to lock out of a solution}
#'   \item{layer_1 - layer_63}{Distribution of vegetation classes in Tasmania}
#'   ...
#' }
#' @source \url{https://prioritizr.net/articles/tasmania.html}
"tas"



#' Raster data for use as prioritzrshiny example
#'
#' This data set contains one raster stack. planning unit layer where each one hectare pixel represents a planning unit and contains its corresponding cost (BC Assessment 2015). Second, a raster stack containing ecological community feature data. Field and remote sensed data were used to calculate the probability of occurrence of five key ecological communities found on Salt Spring island. Each layer in the stack represents a different community type. In order these are; Old Forest, Savannah, Wetland, Shrub, and a layer representing the inverse probability of occurrence of human commensal species. For a given layer, the cell value indicates the composite probability of encountering the suite of bird species most commonly associated with that community type.
#'
#' @format A RasterStack with 51300 cells and 6 layers:
#' \describe{
#'   \item{cost}{Averaged assessed land value per hectare}
#'   \item{Old_Forest}{Old Forest community feature.}
#'   \item{Savannah}{Savannah community feature.}
#'   \item{Wetland}{Wetland community feature.}
#'   \item{Shrub}{Shrub community feature.}
#'   \item{Human_negative}{Inverse probability of occurrence of human commensal species community feature.}
#'   ...
#' }
#' @source \url{https://prioritizr.net/articles/saltspring.html}
"salt"
