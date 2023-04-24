# R CMD BATCH --vanilla '--args HI CO' drop_locations.R

library(covidData)
library(tidyverse)

states_to_drop <- commandArgs(trailingOnly = TRUE)
print(states_to_drop)
fips_to_drop <- covidData::fips_codes %>%
    dplyr::filter(abbreviation %in% states_to_drop) %>%
    dplyr::pull(location)

latest_file <- max(Sys.glob('submissions/covid/UMass-gbq/*.csv'))

file.copy(
    latest_file,
    paste0(substr(latest_file, 1, nchar(latest_file) - 4), "-backup.csv")
)

fc <- readr::read_csv(latest_file) %>%
    dplyr::filter(!(location %in% fips_to_drop))

write.csv(fc, latest_file, row.names=FALSE)

