# Notatki projektu: dziennik i plan

Bliźniacza analiza do raportu „Titanic Data Analysis” (folder `wzorzec/`, poza tym repo),
wykonana na danych Telco Customer Churn. Raport (Quarto) po polsku, kod i nazwy zmiennych po angielsku.

## Sposób pracy
- Kod piszę samodzielnie, krok po kroku; każdy krok: wyjaśnienie → mój kod → przegląd i poprawki.
- Każdą decyzję w kodzie opisuję komentarzem (co i dlaczego) — z tego powstaje tekst raportu.
- Commity tylko moje (bez dopisków o współautorach).

## Wymagane środowisko
R (≥ 4.5), RStudio (z wbudowanym Quarto), pakiety:
`tidyverse here DataExplorer rcompanion corrplot caret cluster mclust pROC car ranger kernlab scales patchwork ggrepel factoextra viridis plotly RColorBrewer plot3D rpart.plot knitr kableExtra rmarkdown`

## Plan
- [x] 0. Setup: projekt RStudio, struktura folderów, git
- [x] 1. Import i przegląd danych (`R/01_import.R`)
- [x] 2. Czyszczenie (`R/02_cleaning.R`)
- [x] 3. Nowe cechy (`R/03_features.R`)
- [ ] 3.5. Pierwsze sekcje raportu `churn_data_analysis/churn_data_analysis.qmd`: blok setup, Wstęp, Przegląd danych, Przygotowanie danych
- [ ] 4. EDA (`R/04_eda.R`, `R/functions.R`, `R/plots_tables.R`): rozkłady, korelacje (Spearman/Pearson, V Craméra), zmienne vs churn, analiza wielowymiarowa
- [ ] 5. Redukcja wymiarów: PCA, MDS (Gower) — przy 7032 wierszach rozważyć próbę losową
- [ ] 6. Modelowanie (`R/modeling/`): podział 80/20, PAM, AGNES, regresja logistyczna, k-NN, drzewo, Random Forest, SVM
- [ ] 7. Ocena na zbiorze testowym, wnioski

## Decyzje dotyczące danych
- `customerID` usunięty (unikalny identyfikator).
- 11 wierszy z `tenure = 0` usunięte: `TotalCharges` puste, wszyscy `Churn = No` — klienci, którzy nie mieli jeszcze szansy odejść (obserwacje cenzurowane).
- `SeniorCitizen` 0/1 → `No`/`Yes` (spójność z innymi zmiennymi binarnymi).
- „No internet service” / „No phone service” scalone z „No” — informacja strukturalna, zachowana w `InternetService`/`PhoneService`.
- 22 duplikaty po usunięciu ID zostają — różni klienci z identycznym profilem (wszyscy `tenure = 1`).
- `contract` jako zmienna porządkowa (Month-to-month < One year < Two year); `churn` z poziomami `No`, `Yes`.
- Wynik: `churn_clean` 7032 × 24, 0 braków; zapis do `data/churn_clean.csv` i `data/churn_clean.rds` (RDS zachowuje factory).

## Obserwacje do EDA
- Churn ogółem: 26,6%.
- `tenure_group`: 0–12 → 47,7%, 13–24 → 28,7%, 25–48 → 20,4%, 49–72 → 9,5%.
- `contract`: Month-to-month 42,7%, One year 11,3%, Two year 2,8%.
- `auto_payment`: Yes 16,0% vs No 34,7% (korelacja, nie przyczynowość).
- `n_services` niemonotoniczne (1 usługa: 21,2%, 3 usługi: 36,5%, 8 usług: 5,3%) — prawdopodobnie zakłócane przez `internet_service`.
- `monthly_charges − avg_monthly_charge` symetryczne wokół 0, odchylenie w obie strony ~34% churnu — prawdopodobnie szum w danych syntetycznych; sprawdzić, ewentualnie usunąć cechę.
- `total_charges` ≈ `tenure × monthly_charges` (r ≈ 0,9996) — silna współliniowość, uwzględnić przy modelowaniu.
