library(tidyverse)
library(covidData)
library(covidHubUtils)
library(ggforce)

# forecast_date <- as.character(lubridate::floor_date(Sys.Date(), unit = "week") + 1)
forecast_date <- as.character(Sys.Date()-1)
reference_date <- as.Date(forecast_date) - 2

# load ensemble back in and bind with other baselines for plotting
forecasts <- covidHubUtils::load_forecasts_repo(
  file_path = 'submissions/covid/',
  models = 'UMass-gbq',
  forecast_dates = forecast_date,
  locations = NULL,
  types = NULL,
  targets = NULL,
  hub = "US",
  verbose = TRUE
)

truth_for_plotting <- covidHubUtils::load_truth(
  truth_source = "HealthData",
  target_variable = "inc hosp",
  data_location = "covidData"
)

# plot
plot_path <- paste0('plots/covid/', forecast_date, "-UMass-gbq.pdf")
p <- covidHubUtils::plot_forecasts(
    forecast_data = forecasts,
    facet = "~location",
    hub = "US",
    truth_data = truth_for_plotting,
    truth_source = "HealthData",
    fill_transparency = .5,
    top_layer = "forecast",
    subtitle = "none",
    title = "none",
    show_caption = FALSE,
    plot = FALSE
) +
scale_x_date(
    breaks = "1 month",
    date_labels = "%b-%y",
    limits = as.Date(c(
    reference_date - (7 * 32), reference_date + 28
    ), format = "%b-%y")
) +
theme_bw() +
theme_update(
    legend.position = "bottom",
    legend.direction = "vertical",
    legend.text = element_text(size = 8),
    legend.title = element_text(size = 8),
    axis.text.x = element_text(angle = 90),
    axis.title.x = element_blank()
) +
ggforce::facet_wrap_paginate(
    ~ location,
    scales = "free",
    ncol = 2,
    nrow = 3,
    page = 1
)
n <- n_pages(p)
pdf(
plot_path,
paper = 'A4',
width = 205 / 25,
height = 270 / 25
)
for (i in 1:n) {
suppressWarnings(print(
    p + ggforce::facet_wrap_paginate(
        ~ location,
        scales = "free",
        ncol = 2,
        nrow = 3,
        page = i
    ) +
    theme_bw() +
    theme(
        legend.position = "bottom",
        legend.direction = "vertical",
        legend.text = element_text(size = 8),
        legend.title = element_text(size = 8),
        axis.text.x = element_text(angle = 90),
        axis.title.x = element_blank()
    )
))
}
dev.off()
