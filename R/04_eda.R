# R/04_eda.R

# -- Split variables by type --
# Quantitative and qualitative variables are analysed with different tools:
# - quantitative: summary statistics, boxplots, density plots and
#   Spearman/Pearson correlations,
# - qualitative: barplots and Cramer's V association matrix.

# selection of quantitative variables
# n_services is a discrete count (0-8), but it is ordered and has many
# levels, so it is treated as quantitative
quant_vars <- names(churn_clean)[sapply(churn_clean, is.numeric)]
data_quant <- select(churn_clean, all_of(quant_vars))

# selection of qualitative variables
# churn is kept here on purpose, so that its associations with the other
# qualitative variables appear in the Cramer's V matrix
qual_vars <- names(churn_clean[sapply(churn_clean, is.factor)])
data_qual <- churn_clean %>%
  select(all_of(qual_vars))
