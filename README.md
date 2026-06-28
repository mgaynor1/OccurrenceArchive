# Occurrence Archive

In 2026, [iDigBio moved to a GBIF hosted portal](https://idigbio.gbif.us/en/faq/) due to the end of its funding. A small subset of data providers did not move their recordsets over to the new hosted portal. This ended up including about 1.7 million records. 

In preparation for the end of the iDigBio API, we downloaded these records and modified the [gatoRs R package](https://github.com/nataliepatten/gatoRs), specifically the `gators_downloads()` to search this GitHub-hosted archive. To create this archive, we first downloaded all recordsets that have not moved over to the GBIF-hosted portal (00_downloadiDigBioOnly.R), then we formatted this dataset into a parquet file (iMFG_06282026.parquet) that is easy to search with duckDB (01_TestingFormattingGo.R). Due to CRAN requirements on data size, this dataset cannot be hosted with our package, so I created this repository to document and host the archived data. The download of these recordsets occurred on June 28th, 2026 based on a database shared by the wonderful [Cat Chapman](https://www.linkedin.com/in/cat-chapman-219706124/)!

We hope you can continue to use gatoRs!
