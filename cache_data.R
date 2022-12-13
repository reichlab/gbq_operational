library(tidyverse)
library(covidData)

for (pathogen in c("covid", "flu")) {
    data <- covidData::load_data(
        spatial_resolution = c("state", "national"),
        temporal_resolution = "daily",
        drop_last_date = TRUE,
        measure = ifelse(pathogen == "covid",
                         "hospitalizations",
                         "flu hospitalizations")
    ) %>%
        dplyr::group_by(location) %>%
        dplyr::filter(date >= "2020-10-01", date < max(date)) %>%
        dplyr::transmute(location, date, hosps = inc) %>%
        dplyr::ungroup() %>%
        dplyr::arrange(location, date)
    
    data <- data %>%
        dplyr::left_join(
            covidData::fips_codes %>%
                dplyr::select(location, location_name, population),
            by = "location") %>%
        dplyr::mutate(
            pop100k = population / 100000,
            hosp_rate = hosps / pop100k
        )

    readr::write_csv(data, paste0("data/", pathogen, "_data_cached_", Sys.Date(), ".csv"))
}

# if (FALSE) {
#     deaths <- covidData::load_data(
#         spatial_resolution = c("state", "national"),
#         temporal_resolution = "daily",
#         measure = "deaths"
#     ) %>%
#         dplyr::filter(date >= "2020-10-01") %>%
#         dplyr::rename(deaths = inc)
#     data <- hosps %>%
#         dplyr::left_join(deaths %>% dplyr::select(location, date, deaths),
#                          by = c("location", "date"))
# } else {
#     data <- hosps
# }
