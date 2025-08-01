# Test debug app functionality
source("R/helpers.R")

# Load category data
categories_data <- load_category_data("data")

# Test template replacements
replacements <- generate_template_replacements("Max", "Mustermann", "m")

cat("=== Template Replacements ===\n")
for (name in names(replacements)) {
  cat(sprintf("%-20s = %s\n", name, replacements[[name]]))
}

cat("\n=== Sample Sentences with Replacements ===\n")

# Test a few sentences from different categories
for (category_name in names(categories_data)[1:3]) {  # Just first 3 categories
  cat(sprintf("\n--- %s ---\n", category_name))
  
  category_data <- categories_data[[category_name]]
  
  for (grade in names(category_data)[1:2]) {  # Just grades 1 and 2
    sentences <- category_data[[grade]]
    cat(sprintf("\nNote %s:\n", grade))
    
    for (i in seq_along(sentences)[1:2]) {  # Just first 2 sentences
      original <- sentences[i]
      replaced <- replace_templates(original, replacements)
      
      cat(sprintf("  Original: %s\n", original))
      cat(sprintf("  Replaced: %s\n\n", replaced))
    }
  }
}
