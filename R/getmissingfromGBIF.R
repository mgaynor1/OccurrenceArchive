#' @title Download with recordset ID
#'
#' @description
#' @param synonyms.list A
#'
#' @importFrom dplyr distinct bind_rows
#' @importFrom utils write.csv
#' @importFrom magrittr "%>%"
#' @importFrom gatoRs fix_names correct_class


getmissingfromGBIF <- function(uuid){

  colNames <- c("data.dwc:scientificName",
              "data.dwc:genus",
              "data.dwc:specificEpithet",
              "data.dwc:infraspecificEpithet",
              "uuid",
              "data.dwc:occurrenceID",
              "data.dwc:basisOfRecord",
              "data.dwc:eventDate",
              "data.dwc:year",
              "data.dwc:month",
              "data.dwc:day",
              "data.dwc:institutionCode",
              "data.dwc:recordedBy",
              "data.dwc:country",
              "data.dwc:county",
              "data.dwc:stateProvince",
              "data.dwc:locality",
              "data.dwc:occurrenceRemarks",
              "data.dwc:verbatimLocality",
              "data.dwc:decimalLatitude",
              "data.dwc:verbatimLatitude",
              "data.dwc:decimalLongitude",
              "data.dwc:verbatimLongitude",
              "geopoint",
              "data.dwc:coordinateUncertaintyInMeters",
              "data.dwc:informationWithheld",
              "data.dwc:habitat")
  
    query_idigbio <- ridigbio::idig_search_records(rq=list("recordset"=uuid),
                                         fields = colNames, 
                                         limit = 100000)
    

   
    df2 <-   query_idigbio %>%
              dplyr::rename(scientificName = "data.dwc:scientificName",
                    genus = "data.dwc:genus",
                    specificEpithet = "data.dwc:specificEpithet",
                    infraspecificEpithet = "data.dwc:infraspecificEpithet",
                    ID = "uuid",
                    occurrenceID = "data.dwc:occurrenceID",
                    basisOfRecord =  "data.dwc:basisOfRecord",
                    eventDate = "data.dwc:eventDate",
                    year = "data.dwc:year",
                    month = "data.dwc:month",
                    day = "data.dwc:day",
                    institutionCode = "data.dwc:institutionCode",
                    recordedBy = "data.dwc:recordedBy",
                    country = "data.dwc:country",
                    county = "data.dwc:county",
                    stateProvince = "data.dwc:stateProvince",
                    locality = "data.dwc:locality",
                    occurrenceRemarks = "data.dwc:occurrenceRemarks",
                    verbatimLocality = "data.dwc:verbatimLocality",
                    latitude = "data.dwc:decimalLatitude",
                    verbatimLatitude = "data.dwc:verbatimLatitude",
                    longitude = "data.dwc:decimalLongitude",
                    verbatimLongitude = "data.dwc:verbatimLongitude",
                    coordinateUncertaintyInMeters = "data.dwc:coordinateUncertaintyInMeters",
                    informationWithheld = "data.dwc:informationWithheld",
                    habitat = "data.dwc:habitat") %>% 
      suppressWarnings(gatoRs::correct_class()) 
    df3 <- gatoRs::fix_columns(df2)
      df4 <- gatoRs::fix_names(df3)

  return(df4)
}
