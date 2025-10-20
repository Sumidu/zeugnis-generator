# Test ordered categories with numbered files
library(here)
source(here("R", "helpers.R"))

# Load categories to test ordering
categories_data <- load_category_data(here("data"))

cat("🎯 Categories Load in Correct Order:\n")
for (i in seq_along(names(categories_data))) {
  cat(sprintf("%2d. %s\n", i, names(categories_data)[i]))
}


