# R/02_cleaning.R

churn_clean <- churn_raw

# -- Remove unnecessary columns -- 

not_needed_names <- c('customerID')

churn_clean <- churn_clean %>%
  select(-all_of(not_needed_names))

# -- Remove customers with tenure = 0 (11 rows) --
#  - A zero-tenure "No" isn't loyalty—they simply haven't had time to leave.

churn_clean <- churn_clean %>%
  filter(tenure > 0)

# -- Recode SeniorCitizen --
# SeniorCitizen is stored as integer 0/1, while other binary variables
# (Partner, Dependents, PhoneService, ...) use "No"/"Yes".
# We recode it to "No"/"Yes" for consistency; otherwise it would be
# treated as a quantitative variable in EDA (boxplots, Pearson correlation).

churn_clean <- churn_clean %>%
  mutate(
    SeniorCitizen = if_else(SeniorCitizen == 1, "Yes", "No")
  )

# -- Merge "No internet service" / "No phone service" into "No" --
# These levels are structural, not missing data: a customer without
# internet cannot have e.g. OnlineSecurity. The same information is
# already stored in InternetService (and PhoneService for MultipleLines),
# so keeping a separate level would duplicate it across 7 columns
# (redundancy -> perfect associations in Cramer's V, collinearity in models).

internet_services <- c("OnlineSecurity", "OnlineBackup", "DeviceProtection",
                       "TechSupport", "StreamingTV", "StreamingMovies")

churn_clean <- churn_clean %>%
  mutate(
    across(all_of(internet_services),
           ~ if_else(.x == "No internet service", "No", .x)),
    MultipleLines = if_else(MultipleLines == "No phone service", "No",
                            MultipleLines)
  )

# -- Rename columns to snake_case --
# Original names mix styles (CamelCase: SeniorCitizen, lowercase: tenure).
# We standardize them to snake_case for consistency and readability,
# following the tidyverse style guide (as in the reference analysis).

churn_clean <- churn_clean %>%
  rename(
    senior_citizen    = SeniorCitizen,
    partner           = Partner,
    dependents        = Dependents,
    phone_service     = PhoneService,
    multiple_lines    = MultipleLines,
    internet_service  = InternetService,
    online_security   = OnlineSecurity,
    online_backup     = OnlineBackup,
    device_protection = DeviceProtection,
    tech_support      = TechSupport,
    streaming_tv      = StreamingTV,
    streaming_movies  = StreamingMovies,
    contract          = Contract,
    paperless_billing = PaperlessBilling,
    payment_method    = PaymentMethod,
    monthly_charges   = MonthlyCharges,
    total_charges     = TotalCharges,
    churn             = Churn
  )

# -- Convert categorical attributes to factors --
# All remaining character columns are categorical (binary or nominal),
# so we convert them to factors. This lets R treat them as categories:
# summary() shows counts per level, and models create dummy variables
# automatically. Numeric columns (tenure, monthly_charges, total_charges)
# are left unchanged.

churn_clean <- churn_clean %>%
  mutate(across(where(is.character), as.factor))

# -- Fix factor levels --
# as.factor() orders levels alphabetically, which is not always meaningful.
# - contract: ordinal variable (increasing commitment); set the order
#   explicitly instead of relying on alphabetical order by coincidence.
# - churn: "No" first, "Yes" second, so that "Yes" is treated as the
#   positive class in modeling (as with `survived` in the reference analysis).

churn_clean <- churn_clean %>%
  mutate(
    contract = factor(contract,
                      levels = c("Month-to-month", "One year", "Two year")),
    churn = factor(churn, levels = c("No", "Yes"))
  )

# --------------------------------------------------------------------------- #

glimpse(churn_clean)
colSums(is.na(churn_clean))
summary(churn_clean)

# -- Duplicates check --
# After removing customerID some rows are identical, but customerID was
# unique, so these are different customers with the same profile
# (few categorical variables -> identical combinations are plausible).
# They are kept as valid, independent observations.
sum(duplicated(churn_clean))
