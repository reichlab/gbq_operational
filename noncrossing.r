library(tidyverse)

for (pathogen in c('covid', 'flu')) {
    file_path <- paste0('submissions/', pathogen, '/UMass-gbq/2022-12-04-UMass-gbq.csv')
    fc <- readr::read_csv(file_path)

    q_noncross_fc <- fc %>%
        dplyr::filter(type == "quantile") %>%
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
