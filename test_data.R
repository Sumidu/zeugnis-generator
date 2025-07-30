# Test script to verify data loading and access
source("R/helpers.R")

# Load data
categories_data <- load_category_data("data")
grade_names <- get_grade_names()

cat("=== Testing Data Structure ===\n")
cat("Categories loaded:", names(categories_data), "\n")
cat("Grade names:", names(grade_names), "\n")

# Test accessing sentences for each category and grade
for (category_name in names(categories_data)) {
  cat("\n--- Category:", category_name, "---\n")
  for (grade in names(grade_names)) {
    sentences <- categories_data[[category_name]][[grade]]
    if (!is.null(sentences) && length(sentences) > 0) {
      cat("Grade", grade, "has", length(sentences), "sentences\n")
      cat("First sentence:", substr(sentences[1], 1, 50), "...\n")
    } else {
      cat("Grade", grade, "has NO sentences\n")
    }
  }
}

cat("\n=== Test Complete ===\n")
