# Test improved highlighting functionality
source("R/helpers.R")

# Test highlighting function with word boundaries
highlight_templates_improved <- function(original_text, replaced_text, replacements) {
  # Find all template variables in original text
  template_pattern <- "\\{([^}]+)\\}"
  matches <- gregexpr(template_pattern, original_text)
  
  if (matches[[1]][1] == -1) {
    return(list(
      original = original_text,
      replaced = replaced_text,
      has_templates = FALSE
    ))
  }
  
  # Extract template variables
  template_vars <- regmatches(original_text, matches)[[1]]
  
  # Create highlighted original text
  highlighted_original <- original_text
  for (var in template_vars) {
    var_name <- gsub("[{}]", "", var)
    highlighted_var <- paste0('[TEMPLATE:', var, ']')
    highlighted_original <- gsub(paste0("\\{", var_name, "\\}"), highlighted_var, highlighted_original, fixed = TRUE)
  }
  
  # Create highlighted replaced text with word boundaries
  highlighted_replaced <- replaced_text
  for (var in template_vars) {
    var_name <- gsub("[{}]", "", var)
    if (var_name %in% names(replacements)) {
      replacement_value <- replacements[[var_name]]
      highlighted_replacement <- paste0('[REPLACED:', replacement_value, ']')
      
      # Use word boundary regex to avoid partial matches
      pattern <- paste0("\\b", gsub("([.*+?^${}()|[\\]\\\\])", "\\\\\\1", replacement_value), "\\b")
      highlighted_replaced <- gsub(pattern, highlighted_replacement, highlighted_replaced, perl = TRUE)
    }
  }
  
  return(list(
    original = highlighted_original,
    replaced = highlighted_replaced,
    has_templates = TRUE,
    template_count = length(template_vars)
  ))
}

# Test with problematic cases
replacements <- generate_template_replacements("Max", "Mustermann", "m")

test_cases <- list(
  list(
    original = "{er_sie} arbeitet in der Firma.",
    description = "Should not highlight 'er' in 'der'"
  ),
  list(
    original = "{ANREDE} ist ein sehr guter Mitarbeiter.",
    description = "Should highlight 'Herr Max Mustermann' and 'er' without affecting 'der', 'sehr', 'Mitarbeiter'"
  ),
  list(
    original = "{sein_ihr} Verhalten war vorbildlich.",
    description = "Should highlight 'sein' without affecting other words"
  )
)

cat("=== Improved Highlighting Test ===\n")

for (i in seq_along(test_cases)) {
  test_case <- test_cases[[i]]
  original <- test_case$original
  replaced <- replace_templates(original, replacements)
  
  cat(sprintf("\n--- Test Case %d ---\n", i))
  cat(sprintf("Description: %s\n", test_case$description))
  cat(sprintf("Original: %s\n", original))
  cat(sprintf("Replaced: %s\n", replaced))
  
  highlight_info <- highlight_templates_improved(original, replaced, replacements)
  cat(sprintf("Highlighted Original: %s\n", highlight_info$original))
  cat(sprintf("Highlighted Replaced: %s\n", highlight_info$replaced))
}
