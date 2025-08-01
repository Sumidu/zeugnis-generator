# Quick test of enhanced grammar debug functionality
source("R/helpers.R")

# Load category data
categories_data <- load_category_data("data")

# Test filename mapping
data_files <- list.files("data", pattern = "\\.txt$", full.names = FALSE)
filename_map <- list()
for (file in data_files) {
  category_name <- gsub("^[0-9]{3}_", "", tools::file_path_sans_ext(file))
  filename_map[[category_name]] <- file
}

cat("=== Filename Mapping ===\n")
for (category in names(filename_map)) {
  cat(sprintf("%-20s -> %s\n", category, filename_map[[category]]))
}

cat("\n=== Grammar Check Test ===\n")

# Enhanced grammar checks
grammar_checks <- list(
  list(
    pattern = "\\{POSSESSIVE_ACC_MN\\}\\s+Verhalten",
    issue = "POSSESSIVE_ACC_MN used with 'Verhalten' (neuter noun) - should be POSSESSIVE (nominative)",
    suggestion = "Use {POSSESSIVE} instead of {POSSESSIVE_ACC_MN} before 'Verhalten'"
  ),
  list(
    pattern = "Aufgrund\\s+\\{possessive_dat_mn\\}",
    issue = "Dative case used after 'Aufgrund' - should be genitive",
    suggestion = "Use {possessive_gen} instead of {possessive_dat_mn} after 'Aufgrund'"
  ),
  list(
    pattern = "\\{possessive_acc_fn\\}\\s+guten\\s+",
    issue = "Adjective declension: 'guten' (masculine/accusative) with feminine/neuter possessive",
    suggestion = "Check gender agreement between possessive and adjective"
  )
)

replacements <- generate_template_replacements("Max", "Mustermann", "m")

issues_found <- 0
for (category_name in names(categories_data)[1:3]) {  # Test first 3 categories
  filename <- filename_map[[category_name]]
  category_data <- categories_data[[category_name]]
  
  for (grade in names(category_data)) {
    sentences <- category_data[[grade]]
    
    for (i in seq_along(sentences)) {
      original_sentence <- sentences[i]
      
      for (check in grammar_checks) {
        if (grepl(check$pattern, original_sentence)) {
          issues_found <- issues_found + 1
          replaced_sentence <- replace_templates(original_sentence, replacements)
          
          cat(sprintf("\n📁 %s • Zeile: %s-%d\n", filename, grade, i))
          cat(sprintf("Problem: %s\n", check$issue))
          cat(sprintf("Original: %s\n", original_sentence))
          cat(sprintf("Replaced: %s\n", replaced_sentence))
        }
      }
    }
  }
}

cat(sprintf("\nFound %d issues in test\n", issues_found))
