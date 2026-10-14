# R/plots_tables.R

# -------------------------------- Tables ------------------------------------ #

create_simple_table <- function(data, colnames) {
  kable(data,
        col.names = colnames,
        align = c('l', rep('c', times = length(colnames) - 1)),
        row.names = FALSE) %>%
    kable_styling(
      bootstrap_options = c("striped", "hover", "condensed"),
      full_width = FALSE, position = 'center') %>%
    row_spec(0, bold = TRUE)
}