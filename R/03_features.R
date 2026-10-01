# R/03_features.R

# -- Columns used to count services --
# Thanks to merging "No internet service" / "No phone service" into "No"
# in 02_cleaning.R, every service column is a simple No/Yes factor,
# so we can count the services just by counting "Yes" values.
service_cols <- c("phone_service", "multiple_lines", "online_security",
                  "online_backup", "device_protection", "tech_support",
                  "streaming_tv", "streaming_movies")

churn_clean <- churn_clean %>%
  mutate(
    # tenure groups follow contract lengths (1 and 2 years);
    # the first year is kept separate as the period of highest churn risk;
    # later groups are wider because behaviour changes more slowly
    tenure_group = case_when(
      tenure <= 12 ~ '0-12',
      tenure <= 24 ~ '13-24',
      tenure <= 48 ~ '25-48',
      TRUE ~ '49-72'),
    
    # number of services the customer uses (0-8);
    # more services = stronger tie to the provider
    n_services = rowSums(across(all_of(service_cols)) == "Yes"),
    
    # automatic payment (bank transfer or credit card);
    # the customer does not have to actively pay each month
    auto_payment = if_else(
      str_detect(as.character(payment_method), "automatic"), "Yes", "No"),
    
    # average historical monthly charge; if it is clearly lower than
    # the current monthly_charges, the price has gone up over time
    avg_monthly_charge = total_charges / tenure
  )


# -- fix levels --
churn_clean <- churn_clean %>%
  mutate(
    tenure_group = factor(tenure_group,
                          levels = c('0-12', '13-24', '25-48', '49-72')),
    auto_payment = factor(auto_payment, levels = c('No', 'Yes'))
  )


# -- export clean data file --
# CSV is plain text and loses factor types and level order;
# RDS is R's own format and keeps them
write_csv(churn_clean, here("data", "churn_clean.csv"))
saveRDS(churn_clean, here("data", "churn_clean.rds"))