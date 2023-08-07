library(tidyverse)

forecast_date <- as.character(Sys.Date())

for (pathogen in 'covid') {
    file_path <- paste0('submissions/', pathogen, '/UMass-gbq/', forecast_date, '-UMass-gbq.csv')
    fc <- readr::read_csv(file_path)

    q_noncross_fc <- fc %>%
        dplyr::filter(type == "quantile", target != "0 wk ahead inc flu hosp") %>%
        dplyr::arrange(location, target_end_date, quantile) %>%
        dplyr::group_by(location, target_end_date, target) %>%
        dplyr::mutate(
            value = sort(value)
        )

    q_noncross_fc <- dplyr::bind_rows(
        q_noncross_fc,
        q_noncross_fc %>%
            dplyr::filter(quantile == 0.5) %>%
            dplyr::mutate(
                type = "point",
                quantile = NA
            )
    )

    readr::write_csv(q_noncross_fc, file=file_path)
}
