# Test comprehensive template system with declined possessive pronouns
library(here)

# Use here() to resolve paths from project root
source(here("R", "helpers.R"))
data <- load_category_data(here("data"))

# Test the new Fachkompetenz category with different genders
test_cases <- list(
  list(first_name = "Max", last_name = "Müller", gender = "m"),
  list(first_name = "Anna", last_name = "Schmidt", gender = "w"),
  list(first_name = "Taylor", last_name = "Kim", gender = "d")
)

for(test_case in test_cases) {
  first_name <- test_case$first_name
  last_name <- test_case$last_name
  gender <- test_case$gender
  
  cat('=== Testing', first_name, last_name, '(', gender, ') ===\n')
  
  # Test grade 1 sentence with declined possessive pronouns
  sentences <- data[['Fachkompetenz']][[1]]  # Grade 1 sentences
  if(length(sentences) > 0) {
    test_sentence <- sentences[1]
    replacements <- generate_template_replacements(first_name, last_name, gender)
    
    # Apply all replacements
    result <- test_sentence
    for(template_var in names(replacements)) {
      pattern <- paste0("\\{", template_var, "\\}")
      result <- gsub(pattern, replacements[[template_var]], result)
    }
    
    cat('Original:', test_sentence, '\n')
    cat('Result:  ', result, '\n\n')
  }
}
