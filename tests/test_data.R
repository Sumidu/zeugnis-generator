# Test script to verify data loading and access
library(here)

source(here("R", "helpers.R"))

# Load data
categories_data <- load_category_data(here("data"))
grade_names <- get_grade_names()

cat("=== Testing Data Structure ===\n")
cat("Categories loaded:", names(categories_data), "\n")
cat("Grade names:", names(grade_names), "\n")

# Test accessing sentences for each category and grade
for (category_name in names(categories_data)) {
  cat("\n--- Category:", category_name, "---\n")
  for (grade_num in names(categories_data[[category_name]])) {
    grade_name <- grade_names[[grade_num]]
    sentences <- categories_data[[category_name]][[grade_num]]
    if (!is.null(sentences) && length(sentences) > 0) {
      cat("Grade", grade_num, "(", grade_name, ") has", length(sentences), "sentences\n")
      cat("First sentence:", substr(sentences[1], 1, 50), "...\n")
    } else {
      cat("Grade", grade_num, "(", grade_name, ") has NO sentences\n")
    }
  }
}

cat("\n=== Test Complete ===\n")
