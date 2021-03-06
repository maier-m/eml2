
#' eml_get
#'
#' eml_get
#' @param x an EML object or child/descendant object
#' @param element name of the element to be extracted.
#' If multiple occurrences are found, will extract all
#' @param ... additional arguments
#' @examples \donttest{
#' f <- system.file("xsd/test", "eml-datasetWithUnits.xml", package = "EML")
#' eml <- read_eml(f)
#' eml_get(eml, "physical")
#' eml_get(eml, "attributeList")
#'
#' ## The first argument need not be an "eml" class, it could be a child element; e.g.
#' eml_get(eml$dataset$dataTable, "physical")
#' }
#' @export
#' @importFrom jqr jq combine
#' @importFrom emld as_json as_emld
#' @importFrom jsonlite fromJSON
eml_get <- function(x, element, ...){
  doc <- as.character(emld::as_json(emld::as_emld(x)))
  out <- jqr::jq(doc, paste0("..|.", element, "? // empty"))
  json <- jqr::combine(out)
  robj <- jsonlite::fromJSON(json, simplifyVector = FALSE)
  emld::as_emld(robj)
}
