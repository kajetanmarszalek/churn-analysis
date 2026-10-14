# Project notes: log and plan

A twin analysis of the "Titanic Data Analysis" report (folder `wzorzec/`, outside this repo),
carried out on the Telco Customer Churn dataset. Everything is in English: report text (Quarto),
code, variable names, comments and these notes.

## Way of working
- I write the code myself, step by step; each step: explanation → my code → review and fixes.
- Every decision in the code gets a comment (what and why) — these become the report text.
- Commits are mine only (no co-author trailers).

## Required environment
R (≥ 4.5), RStudio (with bundled Quarto), packages:
`tidyverse here DataExplorer rcompanion corrplot caret cluster mclust pROC car ranger kernlab scales patchwork ggrepel factoextra viridis plotly RColorBrewer plot3D rpart.plot knitr kableExtra rmarkdown`

## Plan
- [x] 0. Setup: RStudio project, folder structure, git
- [x] 1. Import and data overview (`R/01_import.R`)
- [x] 2. Cleaning (`R/02_cleaning.R`)
- [x] 3. Feature engineering (`R/03_features.R`)
- [ ] 3.5. First report sections in `churn_data_analysis/churn_data_analysis.qmd`
  - [x] A. YAML header, setup chunk, first render
  - [x] B. Data Overview (raw variables table, `create_simple_table()` in `R/plots_tables.R`)
  - [ ] C. Introduction; Data Cleaning and Preparation (missing values, transformations, new features, clean variables table)
- [ ] 4. EDA (`R/04_eda.R`, `R/functions.R`, `R/plots_tables.R`): distributions, correlations (Spearman/Pearson, Cramér's V), variables vs churn, multivariate analysis
- [ ] 5. Dimensionality reduction: PCA, MDS (Gower) — with 7032 rows consider a random sample
- [ ] 6. Modeling (`R/modeling/`): 80/20 split, PAM, AGNES, logistic regression, k-NN, decision tree, Random Forest, SVM
- [ ] 7. Test-set evaluation, conclusions

## Data decisions
- `customerID` removed (unique identifier).
- 11 rows with `tenure = 0` removed: `TotalCharges` blank, all `Churn = No` — customers who have not yet had a chance to leave (censored observations).
- `SeniorCitizen` 0/1 → `No`/`Yes` (consistent with the other binary variables).
- "No internet service" / "No phone service" merged into "No" — structural information, already kept in `InternetService`/`PhoneService`.
- 22 duplicates after dropping the ID are kept — different customers with an identical profile (all `tenure = 1`).
- `contract` treated as ordinal (Month-to-month < One year < Two year); `churn` with levels `No`, `Yes`.
- Result: `churn_clean` 7032 × 24, 0 missing values; saved to `data/churn_clean.csv` and `data/churn_clean.rds` (RDS keeps factors).

## Observations for EDA
- Overall churn: 26.6%.
- `tenure_group`: 0–12 → 47.7%, 13–24 → 28.7%, 25–48 → 20.4%, 49–72 → 9.5%.
- `contract`: Month-to-month 42.7%, One year 11.3%, Two year 2.8%.
- `auto_payment`: Yes 16.0% vs No 34.7% (correlation, not causation).
- `n_services` is non-monotonic (1 service: 21.2%, 3 services: 36.5%, 8 services: 5.3%) — probably confounded by `internet_service`.
- `monthly_charges − avg_monthly_charge` is symmetric around 0, deviation in either direction ~34% churn — probably noise in synthetic data; verify, possibly drop the feature.
- `total_charges` ≈ `tenure × monthly_charges` (r ≈ 0.9996) — strong collinearity, keep in mind for modeling.
