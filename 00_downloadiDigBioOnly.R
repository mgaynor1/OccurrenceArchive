## Downloading data
# 06-28-2026

## Load Packages
library(tidyverse)
library(ridigbio)
library(gatoRs)
library(readr)

## Load Functions
lapply(list.files(path = "R/", full.names = TRUE), source)

## Load Recordset IDs for missing from GBIF - Cat Chapman, May 29th 2026
listit <- read.csv("ref/GBIF_nonresponders.csv")
listit$recordset <- gsub("https://www.idigbio.org/portal/recordsets/", "", listit$URL)

# Remove if >100000 records
listit$X..Records..outdated. <- gsub(",", "", listit$X..Records..outdated.)
listit$X..Records..outdated. <- as.numeric(listit$X..Records..outdated.)
listit <- listit[which(listit$X..Records..outdated. < 100000), ]

## Download the smaller sets via R
allgbifmissing <- c()
for(x in 1:nrow(listit)){
  allgbifmissing[[x]] <- getmissingfromGBIF(listit$recordset[x])
}

for(x in 1:nrow(listit)){
  allgbifmissing[[x]]$recordset <- listit$recordset[x]
}

alldownloaded <- do.call(rbind, allgbifmissing)
write.csv(alldownloaded, "data/RbasedMissing.06282026.csv", row.names = FALSE)


### Read in manual download - downloaded via iDigBio Portal
manualdd <- getmanualdownload()

## Combined
allmissing <- rbind(alldownloaded, manualdd)
write.csv(allmissing, "data/Combined_Missing_06282026.csv", row.names = FALSE)
