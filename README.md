# gbq_operational

Operational code for forecasting infectious disease with gradient boosting. The code in this repository is currently very rough. The order of operations is:

1. Run `cache_data.R` to pull data for covid and influenza hospitalizations
2. Run `gbq.ipynb` to produce forecasts
3. Run `noncrossing.r` to deal with noncrossing. Ideally, this should really be done in the python notebook by taking a maximum with 0 before undoing the fourth root transformation.
4. Run `plot_gbq_forecasts.R` and `plot_gbq_forecasts_flu.R` to produce plots

Currently, `drop_locations.R` is not actually used -- but it may be used if we ever want to remove specific forecasts.

