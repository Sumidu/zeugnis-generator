# Test final improved highlighting
source("R/helpers.R")

# Load some real data to test
categories_data <- load_category_data("data")
replacements <- generate_template_replacements("Max", "Mustermann", "m")

# Get the improved highlighting function from the debug app
highlight_templates <- function(original_text, replaced_text, replacements) {
  template_pattern <- "\\{([^}]+)\\}"
  matches <- gregexpr(template_pattern, original_text)
  
  if (matches[[1]][1] == -1) {
    return(list(
      original = original_text,
      replaced = replaced_text,
      has_templates = FALSE
    ))
  }
  
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
      escaped_value <- gsub("([.*+?^${}()|[\\]\\\\])", "\\\\\\1", replacement_value)
      pattern <- paste0("\\b", escaped_value, "\\b")
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

cat("=== Real Data Highlighting Test ===\n")

# Test with real sentences that had problems
problem_sentences <- list(
  "{er_sie} arbeitet sehr gut in der Firma.",
  "{ANREDE} ist ein sehr guter Mitarbeiter.",
  "{sein_ihr} Verhalten war vorbildlich und er zeigte große Bereitschaft.",
  "Mit {seinem_ihrem} fundierten Wissen unterstützte {PRONOUN} das gesamte Team."
)

for (i in seq_along(problem_sentences)) {
  original <- problem_sentences[[i]]
  replaced <- replace_templates(original, replacements)
  
  cat(sprintf("\n--- Test %d ---\n", i))
  cat(sprintf("Original: %s\n", original))
  cat(sprintf("Replaced: %s\n", replaced))
  
  highlight_info <- highlight_templates(original, replaced, replacements)
  cat(sprintf("Highlighted: %s\n", highlight_info$replaced))
  
  # Check for problematic highlights
  if (grepl("\\[REPLACED:er\\]", highlight_info$replaced) && grepl("der", highlight_info$replaced)) {
    if (grepl("d\\[REPLACED:er\\]", highlight_info$replaced)) {
      cat("❌ PROBLEM: 'er' highlighted inside 'der'\n")
    } else {
      cat("✅ GOOD: 'er' not highlighted inside 'der'\n")
    }
  }
}
