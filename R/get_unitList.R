#' get_unitList
#' @param x an emld object
#' @return a list with two data.frames: "units", a table defining unit names, types, and conversions to SI,
#' and "unitTypes", defining the type of unit. For instance, the unit table could define "Hertz" as a unit
#' of unitType frequency, and the unitType define frequency as a type whose dimension is 1/time.
#'
#' @details If no unitList is provided, the function reads in the eml-unitDictionary defining all standard
#' units and unitTypes.  This provides a convenient way to look up standard units and their EML-recognized names
#' when defining metadata, e.g. in the table passed to `set_attributes()`.
#' @export
#'
#' @examples
#'
#' # Read in additional units defined in a EML file
#' \donttest{
#' f <- system.file("xsd/test/eml-datasetWithUnits.xml", package = "EML")
#' eml <- read_eml(f)
#' unitList <- get_unitList(eml)
#'
#' ## Read in the definitions of standard units:
#' get_unitList()
#' }
#'
get_unitList <-
  function(x = NULL) {

    if(is.null(x)){
     unitList <- read_eml(system.file("xsd/eml-2.1.1/eml-unitDictionary.xml",
                         package = "EML"))
    } else {
      unitList <- eml_get(x, "unitList")
    }
    list(units = get_unit(unitList$unit),
         unitTypes = get_unitType(unitList$unitType))
  }



get_unit <- function(unit){
  ## Unnested structure, easy to rectangle
  fromJSON(toJSON(unit))
}

#' @importFrom jsonlite toJSON fromJSON
get_unitType <- function(unitType) {
  ## Nested data structure, rectangle via jq
    y <- toJSON(unitType)

    tmp <- jqr::jq(as.character(y), '.[] | {
            id,
            name,
            dimension: .dimension[].name?,
            power: .dimension[].power?
            }')
    fromJSON(jqr::combine(tmp))
}
