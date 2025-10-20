# Helper functions for Zeugnis Generator

#' Load category data from files
#' @param data_dir Path to data directory
#' @return List of categories with sentences
load_category_data <- function(data_dir = "data") {
  category_files <- list.files(data_dir, pattern = "\\.txt$", full.names = TRUE)
  # Sort files by name to ensure proper ordering (numeric prefixes)
  category_files <- sort(category_files)
  categories <- list()
  
  for (file in category_files) {
    # file <- category_files[1]  # For debugging
    # Extract the full filename without extension
    full_name <- tools::file_path_sans_ext(basename(file))
    
    # Remove numeric prefix (XXX_) from category name for display
    # Pattern matches: 3 digits + underscore at start of string
    category_name <- gsub("^[0-9]{3}_", "", full_name)
    
    lines <- readLines(file, encoding = "UTF-8", warn = FALSE)
    
    # Parse sentences with grades
    sentences <- list()
    for (line in lines) {
      # line <- lines[1]  # For debugging
      if (nchar(trimws(line)) > 0) {
        # Extract grade (1-5) from beginning of line
        grade_match <- regexpr("^([1-5])\\s*-\\s*", line)
        if (grade_match > 0) {
          grade_text <- regmatches(line, grade_match) # get the matched text
          grade_text <- gsub("\\s*-\\s*", "", grade_text) # remove hyphen and spaces
          grade <- as.numeric(trimws(grade_text)) # convert to numeric
          sentence <- sub("^[1-5]\\s*-\\s*", "", line) # remove grade part from line
          
          if (is.null(sentences[[as.character(grade)]])) {
            sentences[[as.character(grade)]] <- c()
          }
          sentences[[as.character(grade)]] <- c(sentences[[as.character(grade)]], sentence)
        }
      }
    }
    
    categories[[category_name]] <- sentences
  }
  
  return(categories)
}

#' Replace template variables in text
#' @param text Text with template variables
#' @param replacements Named list of replacements
#' @return Text with replaced variables
replace_templates <- function(text, replacements) {
  result <- text
  for (var_name in names(replacements)) {
    pattern <- paste0("\\{", var_name, "\\}")
    result <- gsub(pattern, replacements[[var_name]], result)
  }
  return(result)
}

#' Generate final zeugnis text
#' @param selected_sentences List of selected sentences by category
#' @param replacements Named list of template replacements
#' @param gender Gender (m/w/d) for Male_Female template resolution
#' @return Combined zeugnis text
generate_zeugnis_text <- function(selected_sentences, replacements, gender = "m") {
  final_sentences <- c()
  
  for (category in names(selected_sentences)) {
    if (!is.null(selected_sentences[[category]]) && selected_sentences[[category]] != "") {
      sentence <- replace_templates(selected_sentences[[category]], replacements, gender)
      final_sentences <- c(final_sentences, sentence)
    }
  }
  
  return(paste(final_sentences, collapse = " "))
}

#' Get grade names in German
#' @return Named vector of grade names

get_grade_names <- function() {
  # flip name and label
  c("Sehr gut" = "1",
    "Gut" = "2",
    "Befriedigend" = "3",
    "Ausreichend" = "4",
    "Mangelhaft" = "5")
}

#' Generate gender-appropriate address
#' @param first_name First name
#' @param last_name Last name  
#' @param gender Gender (m/w/d)
#' @return Appropriate address form
generate_anrede <- function(first_name, last_name, gender) {
  if (tolower(gender) == "m") {
    return(paste("Herr", first_name, last_name))
  } else if (tolower(gender) == "w") {
    return(paste("Frau", first_name, last_name))
  } else {
    return(paste(first_name, last_name))
  }
}

#' Generate simple template replacements using Male_Female format
#' @param first_name First name
#' @param last_name Last name
#' @param gender Gender (m/w/d)
#' @return Named list of simple template replacements
generate_template_replacements <- function(first_name, last_name, gender) {
  gender_lower <- tolower(gender)
  
  # Basic name components
  full_name <- paste(first_name, last_name)
  
  # Formal address (Herr/Frau + Name)
  anrede <- if (gender_lower == "m") {
    paste("Herr", first_name, last_name)
  } else if (gender_lower == "w") {
    paste("Frau", first_name, last_name)
  } else {
    paste(first_name, last_name)
  }
  
  # Title only (Herr/Frau)
  titel <- if (gender_lower == "m") {
    "Herr"
  } else if (gender_lower == "w") {
    "Frau"
  } else {
    ""
  }
  
  # Return simple list of basic replacements
  list(
    # Basic information
    "ANREDE" = anrede,
    "TITEL" = titel,
    "VORNAME" = first_name,
    "NACHNAME" = last_name,
    "NAME" = full_name
  )
}

#' Replace Male_Female templates in text based on gender
#' @param text Text with Male_Female templates like {Er_Sie}, {sein_ihr}
#' @param replacements Named list of basic replacements (ANREDE, etc.)
#' @param gender Gender (m/w/d) to determine which part of Male_Female to use
#' @return Text with replaced variables
replace_templates <- function(text, replacements, gender = "m") {
  result <- text
  gender_lower <- tolower(gender)
  
  # First replace basic templates (ANREDE, NAME, etc.)
  for (var_name in names(replacements)) {
    pattern <- paste0("\\{", var_name, "\\}")
    result <- gsub(pattern, replacements[[var_name]], result)
  }
  
  # Then replace Male_Female templates
  # Find all {Word1_Word2} patterns
  male_female_pattern <- "\\{([A-Za-zÄÖÜäöüß]+)_([A-Za-zÄÖÜäöüß]+)\\}"
  matches <- gregexpr(male_female_pattern, result, perl = TRUE)
  
  if (matches[[1]][1] != -1) {
    # Extract all Male_Female templates
    template_matches <- regmatches(result, matches)[[1]]
    
    for (template in template_matches) {
      # Extract the male and female parts
      parts <- regmatches(template, regexec("\\{([A-Za-zÄÖÜäöüß]+)_([A-Za-zÄÖÜäöüß]+)\\}", template, perl = TRUE))[[1]] # Full match + 2 groups
      
      if (length(parts) == 3) {  # Full match + 2 groups
        male_part <- parts[2]
        female_part <- parts[3]
        
        # Choose based on gender
        replacement <- if (gender_lower == "m") {
          male_part
        } else if (gender_lower == "w") {
          female_part
        } else {
          female_part  # Default to female for diverse
        }
        
        # Replace the template with the chosen word using fixed string replacement
        result <- gsub(template, replacement, result, fixed = TRUE)
      }
    }
  }
  
  return(result)
}
