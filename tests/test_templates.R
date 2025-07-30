# Test the enhanced template system
library(here)

source(here("R", "helpers.R"))

# Test with different genders
test_cases <- list(
  list(first_name = "Max", last_name = "Mustermann", gender = "m"),
  list(first_name = "Anna", last_name = "Schmidt", gender = "w"),
  list(first_name = "Alex", last_name = "Weber", gender = "d")
)

for (case in test_cases) {
  cat("\n=== Testing:", case$first_name, case$last_name, "(", case$gender, ") ===\n")
  
  replacements <- generate_template_replacements(case$first_name, case$last_name, case$gender)
  
  # Test sentence with various template variables including declined possessives
  test_sentence <- "{ANREDE} zeigte großes Engagement. Wir schätzten {possessive_acc_m} Kollegen und {POSSESSIVE_ACC_FN} Zuverlässigkeit. {possessive_dat_f} Führung vertrauten alle."
  
  result <- replace_templates(test_sentence, replacements)
  cat("Input: ", test_sentence, "\n")
  cat("Output:", result, "\n")
  
  # Show all available replacements
  cat("\nVerfügbare Template-Variablen:\n")
  for (var in names(replacements)) {
    cat(sprintf("  {%s} -> '%s'\n", var, replacements[[var]]))
  }
}

cat("\n=== Test Complete ===\n")
