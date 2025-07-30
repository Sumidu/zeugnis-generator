# Helper functions for Zeugnis Generator

#' Load category data from files
#' @param data_dir Path to data directory
#' @return List of categories with sentences
load_category_data <- function(data_dir = "data") {
  category_files <- list.files(data_dir, pattern = "\\.txt$", full.names = TRUE)
  categories <- list()
  
  for (file in category_files) {
    category_name <- tools::file_path_sans_ext(basename(file))
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
