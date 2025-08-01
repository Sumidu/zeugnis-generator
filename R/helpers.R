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
    # Extract the full filename without extension
    full_name <- tools::file_path_sans_ext(basename(file))
    
    # Remove numeric prefix (XXX_) from category name for display
    # Pattern matches: 3 digits + underscore at start of string
    category_name <- gsub("^[0-9]{3}_", "", full_name)
    
    lines <- readLines(file, encoding = "UTF-8", warn = FALSE)
    
    # Parse sentences with grades
    sentences <- list()
    for (line in lines) {
      if (nchar(trimws(line)) > 0) {
        # Extract grade (1-5) from beginning of line
        grade_match <- regexpr("^([1-5])\\s*-\\s*", line)
        if (grade_match > 0) {
          grade_text <- regmatches(line, grade_match)
          grade_text <- gsub("\\s*-\\s*", "", grade_text)
          grade <- as.numeric(trimws(grade_text))
          sentence <- sub("^[1-5]\\s*-\\s*", "", line)
          
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
#' @return Combined zeugnis text
generate_zeugnis_text <- function(selected_sentences, replacements) {
  final_sentences <- c()
  
  for (category in names(selected_sentences)) {
    if (!is.null(selected_sentences[[category]]) && selected_sentences[[category]] != "") {
      sentence <- replace_templates(selected_sentences[[category]], replacements)
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

#' Generate comprehensive template replacements
#' @param first_name First name
#' @param last_name Last name
#' @param gender Gender (m/w/d)
#' @return Named list of all template replacements
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
  
  # Pronouns - Nominative case (Er/Sie)
  pronoun_nom <- if (gender_lower == "m") {
    "Er"
  } else if (gender_lower == "w") {
    "Sie"
  } else {
    "Sie"  # Default to Sie for diverse
  }
  
  # Pronouns - lowercase nominative (er/sie)
  pronoun_nom_lower <- if (gender_lower == "m") {
    "er"
  } else if (gender_lower == "w") {
    "sie"
  } else {
    "sie"
  }
  
  # Pronouns - Accusative case (Ihn/Sie)
  pronoun_acc <- if (gender_lower == "m") {
    "Ihn"
  } else if (gender_lower == "w") {
    "Sie"
  } else {
    "Sie"
  }
  
  # Pronouns - lowercase accusative (ihn/sie)
  pronoun_acc_lower <- if (gender_lower == "m") {
    "ihn"
  } else if (gender_lower == "w") {
    "sie"
  } else {
    "sie"
  }
  
  # Pronouns - Dative case (Ihm/Ihr)
  pronoun_dat <- if (gender_lower == "m") {
    "Ihm"
  } else if (gender_lower == "w") {
    "Ihr"
  } else {
    "Ihnen"  # Respectful form for diverse
  }
  
  # Pronouns - lowercase dative (ihm/ihr)
  pronoun_dat_lower <- if (gender_lower == "m") {
    "ihm"
  } else if (gender_lower == "w") {
    "ihr"
  } else {
    "ihnen"
  }
  
  # Possessive pronouns - Nominative (Sein/Ihr)
  possessive_nom <- if (gender_lower == "m") {
    "Sein"
  } else if (gender_lower == "w") {
    "Ihr"
  } else {
    "Ihr"  # Default to Ihr for diverse
  }
  
  # Possessive pronouns - lowercase nominative (sein/ihr)
  possessive_nom_lower <- if (gender_lower == "m") {
    "sein"
  } else if (gender_lower == "w") {
    "ihr"
  } else {
    "ihr"
  }
  
  # Possessive pronouns - Accusative masculine (seinen/ihren)
  possessive_acc_m <- if (gender_lower == "m") {
    "Seinen"
  } else if (gender_lower == "w") {
    "Ihren"
  } else {
    "Ihren"
  }
  
  possessive_acc_m_lower <- if (gender_lower == "m") {
    "seinen"
  } else if (gender_lower == "w") {
    "ihren"
  } else {
    "ihren"
  }
  
  # Possessive pronouns - Accusative feminine/neuter (seine/ihre)
  possessive_acc_fn <- if (gender_lower == "m") {
    "Seine"
  } else if (gender_lower == "w") {
    "Ihre"
  } else {
    "Ihre"
  }
  
  possessive_acc_fn_lower <- if (gender_lower == "m") {
    "seine"
  } else if (gender_lower == "w") {
    "ihre"
  } else {
    "ihre"
  }
  
  # Possessive pronouns - Dative masculine/neuter (seinem/ihrem)
  possessive_dat_mn <- if (gender_lower == "m") {
    "Seinem"
  } else if (gender_lower == "w") {
    "Ihrem"
  } else {
    "Ihrem"
  }
  
  possessive_dat_mn_lower <- if (gender_lower == "m") {
    "seinem"
  } else if (gender_lower == "w") {
    "ihrem"
  } else {
    "ihrem"
  }
  
  # Possessive pronouns - Dative feminine (seiner/ihrer)
  possessive_dat_f <- if (gender_lower == "m") {
    "Seiner"
  } else if (gender_lower == "w") {
    "Ihrer"
  } else {
    "Ihrer"
  }
  
  possessive_dat_f_lower <- if (gender_lower == "m") {
    "seiner"
  } else if (gender_lower == "w") {
    "ihrer"
  } else {
    "ihrer"
  }
  
  # Return comprehensive list of replacements
  list(
    # Basic information
    "ANREDE" = anrede,
    "TITEL" = titel,
    "VORNAME" = first_name,
    "NACHNAME" = last_name,
    "NAME" = full_name,
    
    # Pronouns - Nominative (Er/Sie, er/sie)
    "PRONOUN" = pronoun_nom,
    "pronoun" = pronoun_nom_lower,
    "ER_SIE" = pronoun_nom,
    "er_sie" = pronoun_nom_lower,
    
    # Pronouns - Accusative (Ihn/Sie, ihn/sie)
    "PRONOUN_ACC" = pronoun_acc,
    "pronoun_acc" = pronoun_acc_lower,
    "IHN_SIE" = pronoun_acc,
    "ihn_sie" = pronoun_acc_lower,
    
    # Pronouns - Dative (Ihm/Ihr, ihm/ihr)
    "PRONOUN_DAT" = pronoun_dat,
    "pronoun_dat" = pronoun_dat_lower,
    "IHM_IHR" = pronoun_dat,
    "ihm_ihr" = pronoun_dat_lower,
    
    # Possessive pronouns - Nominative (Sein/Ihr, sein/ihr)
    "POSSESSIVE" = possessive_nom,
    "possessive" = possessive_nom_lower,
    "SEIN_IHR" = possessive_nom,
    "sein_ihr" = possessive_nom_lower,
    
    # Possessive pronouns - Accusative masculine (Seinen/Ihren, seinen/ihren)
    "POSSESSIVE_ACC_M" = possessive_acc_m,
    "possessive_acc_m" = possessive_acc_m_lower,
    "SEINEN_IHREN" = possessive_acc_m,
    "seinen_ihren" = possessive_acc_m_lower,
    
    # Possessive pronouns - Accusative feminine/neuter (Seine/Ihre, seine/ihre)
    "POSSESSIVE_ACC_FN" = possessive_acc_fn,
    "possessive_acc_fn" = possessive_acc_fn_lower,
    "SEINE_IHRE" = possessive_acc_fn,
    "seine_ihre" = possessive_acc_fn_lower,
    
    # Possessive pronouns - Dative masculine/neuter (Seinem/Ihrem, seinem/ihrem)
    "POSSESSIVE_DAT_MN" = possessive_dat_mn,
    "possessive_dat_mn" = possessive_dat_mn_lower,
    "SEINEM_IHREM" = possessive_dat_mn,
    "seinem_ihrem" = possessive_dat_mn_lower,
    
    # Possessive pronouns - Dative feminine (Seiner/Ihrer, seiner/ihrer)
    "POSSESSIVE_DAT_F" = possessive_dat_f,
    "possessive_dat_f" = possessive_dat_f_lower,
    "SEINER_IHRER" = possessive_dat_f,
    "seiner_ihrer" = possessive_dat_f_lower
  )
}
