#' @title Read in local
#'
#' @description
#' @param synonyms.list A
#'
#' @importFrom dplyr select
#' @importFrom utils write.csv
#' @importFrom magrittr "%>%"
#' @importFrom gatoRs fix_names correct_class


getmanualdownload <- function(pathset ="data/manual_data"){

biglist <- list.files(path = pathset, 
                      recursive = FALSE, 
                      include.dirs = TRUE, 
                      full.names = TRUE)
recordsetnames <- gsub(paste0(pathset,"/"), "", biglist)
all <- c()
for(i in 1:length(biglist)){
  occurrence_raw <- read.csv(paste0(biglist[i], "/occurrence_raw.csv"))
  occurrence_raw <- occurrence_raw %>% 
                    dplyr::select("dwc.scientificName",
                           "dwc.genus",
                           "dwc.specificEpithet",
                           "dwc.infraspecificEpithet",
                           "coreid", #"uuid",
                           "dwc.occurrenceID",
                           "dwc.basisOfRecord",
                           "dwc.eventDate",
                           "dwc.year",
                           "dwc.month",
                           "dwc.day",
                           "dwc.institutionCode",
                           "dwc.recordedBy",
                           "dwc.country",
                           "dwc.county",
                           "dwc.stateProvince",
                           "dwc.locality",
                           "dwc.occurrenceRemarks",
                           "dwc.verbatimLocality",
                           "dwc.decimalLatitude",
                           "dwc.verbatimLatitude",
                           "dwc.decimalLongitude",
                           "dwc.verbatimLongitude",
                           #"geopoint",
                           "dwc.coordinateUncertaintyInMeters",
                           "dwc.informationWithheld",
                           "dwc.habitat") 
  
  ## Why idigbio.geoPoint = https://www.idigbio.org/ridigbio/articles/IDDataFlags.html
  occurrence <- read.csv(paste0(biglist[i], "/occurrence.csv"))
  occurrence <- occurrence %>% 
                dplyr::select("coreid","idigbio.geoPoint")
  geoPoints <- gsub(" ", "", gsub("}", "", gsub("\"", "", gsub("{\"", "", occurrence$idigbio.geoPoint, fixed = TRUE), fixed = TRUE), fixed = TRUE))
  geoPoints <-  as.data.frame(do.call(rbind, str_split( geoPoints , pattern = ",")))
  occurrence$geopoint.lat <- gsub("lat:", "", geoPoints$V1)
  occurrence$geopoint.lon <- gsub("lon:", "", geoPoints$V2)
  occurrence <- occurrence %>%
                dplyr::select("coreid", "geopoint.lat","geopoint.lon" )
  dfdown <- left_join(occurrence_raw, occurrence)
  
  
  
  dfdown <-   dfdown %>% 
              dplyr::rename(scientificName = "dwc.scientificName",
                                       genus = "dwc.genus",
                                       specificEpithet = "dwc.specificEpithet",
                                       infraspecificEpithet = "dwc.infraspecificEpithet",
                                       ID = "coreid",
                                       occurrenceID = "dwc.occurrenceID",
                                       basisOfRecord =  "dwc.basisOfRecord",
                                       eventDate = "dwc.eventDate",
                                       year = "dwc.year",
                                       month = "dwc.month",
                                       day = "dwc.day",
                                       institutionCode = "dwc.institutionCode",
                                       recordedBy = "dwc.recordedBy",
                                       country = "dwc.country",
                                       county = "dwc.county",
                                       stateProvince = "dwc.stateProvince",
                                       locality = "dwc.locality",
                                       occurrenceRemarks = "dwc.occurrenceRemarks",
                                       verbatimLocality = "dwc.verbatimLocality",
                                       geopoint.lat = "geopoint.lat",
                            latitude = "dwc.decimalLatitude",
                                       verbatimLatitude = "dwc.verbatimLatitude",
                            longitude = "dwc.decimalLongitude",
                            geopoint.lon = "geopoint.lon",
                                       verbatimLongitude = "dwc.verbatimLongitude",
                                       coordinateUncertaintyInMeters = "dwc.coordinateUncertaintyInMeters",
                                       informationWithheld = "dwc.informationWithheld",
                                       habitat = "dwc.habitat") %>% 
                        suppressWarnings(gatoRs::correct_class())
  dfdown <- gatoRs::fix_names(gatoRs::fix_columns(dfdown))
  dfdown$recordset <- recordsetnames[i]
  all[[i]] <- dfdown

}
out <- do.call(rbind, all)

 return(out)
  
}
