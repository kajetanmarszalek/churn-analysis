# R/functions.R

# ------------------------------- Helpers ------------------------------------ #

# -- Labels for plots --
# Variable names in snake_case are convenient in code, but not readable on
# plot axes. Each variable gets a human-readable label (with units where
# relevant), which is used by the plotting functions in R/plots_tables.R.

quant_var_labels <- c(
  'tenure' = 'Tenure (months)',
  'monthly_charges' = 'Monthly Charges ($)',
  'total_charges' = 'Total Charges ($)',
  'n_services' = 'Number of Services',
  'avg_monthly_charge' = 'Average Monthly Charge ($)'
)

qual_var_labels <- c(
  'gender' = 'Gender',
  'senior_citizen' = 'Senior Citizen',
  'partner' = 'Partner',
  'dependents' = 'Dependents',
  'phone_service' = 'Phone Service',
  'multiple_lines' = 'Multiple Lines',
  'internet_service' = 'Internet Service',
  'online_security' = 'Online Security',
  'online_backup' = 'Online Backup',
  'device_protection' = 'Device Protection',
  'tech_support' = 'Tech Support',
  'streaming_tv' = 'Streaming TV',
  'streaming_movies' = 'Streaming Movies',
  'contract' = 'Contract Type',
  'paperless_billing' = 'Paperless Billing',
  'payment_method' = 'Payment Method',
  'churn' = 'Churn',
  'tenure_group' = 'Tenure Group (months)',
  'auto_payment' = 'Automatic Payment'
)

# returns the label associated with 'var' (key), falling back to the variable
# name if no matching label is found (so a missing label never breaks a plot)
get_label <- function(var) {
  labels <- c(quant_var_labels, qual_var_labels)

  if (var %in% names(labels)) {
    unname(labels[var])
  } else {
    var
  }
}
