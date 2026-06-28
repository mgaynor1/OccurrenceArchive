# Downloaded to Searchable
# 06-28-2026

## Load Packages
library(data.table)
library(arrow)
library(duckdb)

## Format the csv for parquet
allmissing <- fread("data/Combined_Missing_06282026.csv")
allmissing$basisOfRecord[which(allmissing$basisOfRecord %in% c("PreservedSpecimen", "Preserved specimen", "PreservedSpeci", "Preserved Specimen"))] <- "PreservedSpecimen"
allmissing$basisOfRecord[which(allmissing$basisOfRecord %in% c(NA, "pending review", "beard tongue" , "p", "Stage 2"))] <- NA
allmissing$month[which(allmissing$month == "[Redacted]" )] <- NA
allmissing$month <- as.numeric(allmissing$month)
allmissing$day[which(allmissing$day == "[Redacted]" )] <- NA
allmissing$day <- as.numeric(allmissing$day)
allmissing$latitude <- as.numeric(allmissing$latitude)
allmissing$longitude <- as.numeric(allmissing$longitude)
allmissing$verbatimLatitude<- as.numeric(allmissing$verbatimLatitude)
allmissing$verbatimLongitude <- as.numeric(allmissing$verbatimLongitude)
allmissing$geopoint.lon <- as.numeric(allmissing$geopoint.lon)
allmissing$geopoint.lat <- as.numeric(allmissing$geopoint.lat)
allmissing$coordinateUncertaintyInMeters <- as.numeric(allmissing$coordinateUncertaintyInMeters )

## Writing to parquet
schema <- schema(scientificName = large_utf8(),              
                genus = string(),                         
                specificEpithet = string(),             
                infraspecificEpithet = string(),       
                ID = string(),                  
                occurrenceID = string(),                      
                basisOfRecord = list_of(string()), 
                eventDate = string(),                        
                year = int32(),                        
                month =  int32(),                    
                day   =int32(),                            
                institutionCode = string(),                    
                recordedBy       = string(),                         
                country    = string(),                           
                county       = string(),                    
                stateProvince   = string(),                  
                locality   = string(),                      
                occurrenceRemarks = string(),                  
                verbatimLocality   = string(),               
                latitude  =int32(),                        
                verbatimLatitude    =int32(),          
                longitude =int32(),                        
                verbatimLongitude  =int32(),           
                geopoint.lon      =int32(),            
                geopoint.lat     =int32(),             
                coordinateUncertaintyInMeters  =int32(),   
                informationWithheld  = string(),          
                habitat = string(),                        
                recordset    = string()   
)
  


write_parquet(allmissing, 
              "data/iMFG_06282026.parquet", 
              compression = "gzip", 
              compression_level = 9)

# Practicing Queries before gatoRs integration
url <- "https://github.com/mgaynor1/OccurrenceArchive/raw/main/iMFG_06282026.parquet"
df <- arrow::read_parquet(url)

con <- dbConnect(duckdb::duckdb())
duckdb::dbWriteTable(con, "missing_view", df)

## Search set up
searched <- "Galax"

### FUZZY - levenshtein distance
query <- paste0("SELECT * FROM missing_view WHERE levenshtein(scientificName, '",searched, "') <= 3")
res <- dbGetQuery(con, query)

### FUZZY - rapidfuzz similarity
# 1. Install and load rapidfuzz
dbExecute(con, "INSTALL rapidfuzz FROM community;")
dbExecute(con, "LOAD rapidfuzz;")

query2 <- paste0("SELECT *, 
         rapidfuzz_partial_token_set_ratio(scientificName, '", searched, "') AS match_score 
  FROM missing_view
  WHERE rapidfuzz_partial_token_set_ratio(scientificName,'", searched, "') > 75")
res2 <- dbGetQuery(con, query2)


### EXACT Match
query3 <- paste0("SELECT * FROM missing_view WHERE scientificName = '",searched, "'")
exact_results <- dbGetQuery(con, query3)


