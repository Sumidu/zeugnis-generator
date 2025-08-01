# Debug the Male_Female template processing
source("R/helpers.R")

# Test a simple case
test_text <- "{Er_Sie} arbeitet gut."
replacements <- generate_template_replacements("Max", "Mustermann", "m")

cat("=== Debug Male_Female Template Processing ===\n")
cat(sprintf("Original text: %s\n", test_text))

# Test the regex pattern
male_female_pattern <- "\\{([A-Za-zÄÖÜäöüß]+)_([A-Za-zÄÖÜäöüß]+)\\}"
matches <- gregexpr(male_female_pattern, test_text, perl = TRUE)

cat(sprintf("Pattern: %s\n", male_female_pattern))
cat(sprintf("Match result: %s\n", matches[[1]][1]))

if (matches[[1]][1] != -1) {
  template_matches <- regmatches(test_text, matches)[[1]]
  cat(sprintf("Found templates: %s\n", paste(template_matches, collapse = ", ")))
  
  for (template in template_matches) {
    cat(sprintf("Processing template: %s\n", template))
    
    # Test the regex extraction
    parts <- regmatches(template, regexec("\\{([A-Za-zÄÖÜäöüß]+)_([A-Za-zÄÖÜäöüß]+)\\}", template, perl = TRUE))[[1]]
    cat(sprintf("Extracted parts: %s\n", paste(parts, collapse = " | ")))
    
    if (length(parts) == 3) {
      male_part <- parts[2]
      female_part <- parts[3]
      cat(sprintf("Male part: '%s', Female part: '%s'\n", male_part, female_part))
      
      replacement <- "Er"  # Test with male
      cat(sprintf("Would replace %s with %s\n", template, replacement))
    }
  }
} else {
  cat("No matches found!\n")
}

# Test the full function
cat("\n=== Testing full replace_templates function ===\n")
result <- replace_templates(test_text, replacements, "m")
cat(sprintf("Result: %s\n", result))
