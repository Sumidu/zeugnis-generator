# Test new categories with template system
library(here)
source(here("R", "helpers.R"))

data <- load_category_data(here("data"))

# Test new categories
test_cases <- list(
  list(first_name = "Max", last_name = "Mustermann", gender = "m"),
  list(first_name = "Anna", last_name = "Schmidt", gender = "w")
)

categories_to_test <- c("Bereitschaft", "Befähigung", "Arbeitsweise", "Abschlussformel")

for(category in categories_to_test) {
  cat("\n=== Testing Category:", category, "===\n")
  
  for(test_case in test_cases) {
    first_name <- test_case$first_name
    last_name <- test_case$last_name
    gender <- test_case$gender
    
    cat("\n--- Testing", first_name, last_name, "(", gender, ") ---\n")
    
    # Test grade 1 sentence
    sentences <- data[[category]][[1]]
    if(length(sentences) > 0) {
      test_sentence <- sentences[1]
      replacements <- generate_template_replacements(first_name, last_name, gender)
      
      # Apply all replacements
      result <- test_sentence
      for(template_var in names(replacements)) {
        pattern <- paste0("\\{", template_var, "\\}")
        result <- gsub(pattern, replacements[[template_var]], result)
      }
      
      cat("Original:", test_sentence, "\n")
      cat("Result:  ", result, "\n")
    }
  }
}
