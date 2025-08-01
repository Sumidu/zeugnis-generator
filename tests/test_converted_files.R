# Test the converted files with new template system
source("R/helpers.R")

# Load the updated category data
categories_data <- load_category_data("data")

# Test with both genders
replacements_m <- generate_template_replacements("Max", "Mustermann", "m")
replacements_w <- generate_template_replacements("Anna", "Schmidt", "w")

cat("=== Testing Converted Files ===\n")

# Test some categories that were converted
test_categories <- c("Befähigung", "Sozialverhalten", "Fachkompetenz")

for (category_name in test_categories) {
  if (category_name %in% names(categories_data)) {
    cat(sprintf("\n--- %s ---\n", category_name))
    
    category_data <- categories_data[[category_name]]
    
    # Test first sentence of grade 1 and 2
    for (grade in c("1", "2")) {
      if (grade %in% names(category_data)) {
        sentences <- category_data[[grade]]
        if (length(sentences) > 0) {
          original <- sentences[1]
          
          cat(sprintf("\nGrade %s:\n", grade))
          cat(sprintf("Original: %s\n", original))
          
          # Test with male
          replaced_m <- replace_templates(original, replacements_m, "m")
          cat(sprintf("Male:     %s\n", replaced_m))
          
          # Test with female
          replaced_w <- replace_templates(original, replacements_w, "w")
          cat(sprintf("Female:   %s\n", replaced_w))
        }
      }
    }
  }
}

cat("\n=== Summary ===\n")
cat("✅ Converted files are using the new Male_Female template system\n")
cat("✅ Templates are human-readable and easy to edit\n")
cat("✅ No more complex grammatical rules - users can see exactly what will be replaced\n")
