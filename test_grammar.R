# Test grammar analysis functionality
source("R/helpers.R")

# Load category data
categories_data <- load_category_data("data")

# Define potential grammatical issues to check
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
    pattern = "\\{possessive_dat_mn\\}\\s+Bereich\\s+war",
    issue = "Dative possessive with nominative subject - inconsistent case",
    suggestion = "Use {POSSESSIVE} (nominative) for sentence subject"
  )
)

# Test template replacements including new genitive
replacements <- generate_template_replacements("Max", "Mustermann", "m")

cat("=== New Genitive Templates ===\n")
cat(sprintf("POSSESSIVE_GEN = %s\n", replacements[["POSSESSIVE_GEN"]]))
cat(sprintf("possessive_gen = %s\n", replacements[["possessive_gen"]]))

cat("\n=== Grammar Issues Found ===\n")

issues_found <- 0

for (category_name in names(categories_data)) {
  category_data <- categories_data[[category_name]]
  
  for (grade in names(category_data)) {
    sentences <- category_data[[grade]]
    
    for (i in seq_along(sentences)) {
      original_sentence <- sentences[i]
      
      # Check for grammar issues
      for (check in grammar_checks) {
        if (grepl(check$pattern, original_sentence)) {
          issues_found <- issues_found + 1
          replaced_sentence <- replace_templates(original_sentence, replacements)
          
          cat(sprintf("\n--- ISSUE %d ---\n", issues_found))
          cat(sprintf("Category: %s, Grade: %s, Sentence: %d\n", category_name, grade, i))
          cat(sprintf("Problem: %s\n", check$issue))
          cat(sprintf("Suggestion: %s\n", check$suggestion))
          cat(sprintf("Original: %s\n", original_sentence))
          cat(sprintf("Replaced: %s\n", replaced_sentence))
        }
      }
    }
  }
}

cat(sprintf("\n=== Summary ===\n"))
cat(sprintf("Total issues found: %d\n", issues_found))
