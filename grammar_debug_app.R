library(shiny)
library(shinydashboard)
library(DT)

# Source helper functions from main app
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
  ),
  list(
    pattern = "\\{POSSESSIVE_ACC_M\\}\\s+Vorgesetzten",
    issue = "Check if 'Vorgesetzten' context requires accusative - might be nominative",
    suggestion = "Verify case context for 'Vorgesetzten'"
  ),
  list(
    pattern = "\\{possessive_acc_fn\\}\\s+guten\\s+",
    issue = "Adjective declension: 'guten' (masculine/accusative) with feminine/neuter possessive",
    suggestion = "Check gender agreement between possessive and adjective"
  ),
  list(
    pattern = "\\{[^}]*\\}\\s*[^A-ZÄÖÜ]",
    issue = "Template variable not followed by capitalized word - check sentence structure",
    suggestion = "Verify capitalization after template replacement"
  )
)

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "German Grammar Debug Tool"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Grammar Issues", tabName = "grammar", icon = icon("exclamation-triangle")),
      menuItem("Template Tester", tabName = "debug", icon = icon("bug"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper, .right-side {
          background-color: #f4f4f4;
        }
        .box {
          margin-bottom: 20px;
        }
        .template-variable {
          background-color: #ffeaa7;
          font-weight: bold;
          padding: 2px 4px;
          border-radius: 3px;
          color: #2d3436;
        }
        .replaced-text {
          background-color: #81ecec;
          font-weight: bold;
          padding: 2px 4px;
          border-radius: 3px;
          color: #2d3436;
        }
        .grammar-issue {
          background-color: #fab1a0;
          font-weight: bold;
          padding: 2px 4px;
          border-radius: 3px;
          color: #2d3436;
        }
        .sentence-row {
          margin-bottom: 15px;
          padding: 10px;
          border: 1px solid #ddd;
          border-radius: 5px;
          background-color: white;
          position: relative;
        }
        .issue-sentence {
          border-left: 4px solid #e17055;
          background-color: #ffeaa7;
        }
        .sentence-tooltip {
          position: absolute;
          top: -30px;
          right: 10px;
          background-color: #2d3436;
          color: white;
          padding: 4px 8px;
          border-radius: 4px;
          font-size: 0.8em;
          display: none;
          z-index: 1000;
        }
        .sentence-row:hover .sentence-tooltip {
          display: block;
        }
        .file-info {
          color: #636e72;
          font-size: 0.85em;
          font-style: italic;
          margin-bottom: 5px;
        }
        .category-header {
          background-color: #74b9ff;
          color: white;
          padding: 10px;
          margin: 10px 0;
          border-radius: 5px;
          font-weight: bold;
        }
        .issue-alert {
          background-color: #e17055;
          color: white;
          padding: 5px 10px;
          border-radius: 3px;
          margin-bottom: 5px;
          font-size: 0.9em;
        }
      "))
    ),
    
    tabItems(
      # Grammar Issues tab
      tabItem(tabName = "grammar",
        fluidRow(
          # Control panel for grammar checker
          box(
            title = "Grammar Analysis Settings", status = "primary", solidHeader = TRUE,
            width = 12,
            
            fluidRow(
              column(3,
                textInput("first_name_grammar", "Vorname:", value = "Max")
              ),
              column(3,
                textInput("last_name_grammar", "Nachname:", value = "Mustermann")
              ),
              column(3,
                selectInput("gender_grammar", "Geschlecht:", 
                           choices = c("Männlich" = "m", "Weiblich" = "w", "Divers" = "d"),
                           selected = "m")
              ),
              column(3,
                br(),
                actionButton("analyze_grammar", "Grammatik analysieren", 
                            class = "btn-warning", icon = icon("search"))
              )
            )
          )
        ),
        
        fluidRow(
          # Grammar issues display
          box(
            title = "Gefundene Grammatikprobleme", status = "warning", solidHeader = TRUE,
            width = 12, collapsible = TRUE,
            
            uiOutput("grammar_issues_output")
          )
        )
      ),
      
      # Template tester tab
      tabItem(tabName = "debug",
        fluidRow(
          # Control panel
          box(
            title = "Template Test Settings", status = "primary", solidHeader = TRUE,
            width = 12,
            
            fluidRow(
              column(3,
                textInput("first_name", "Vorname:", value = "Max")
              ),
              column(3,
                textInput("last_name", "Nachname:", value = "Mustermann")
              ),
              column(3,
                selectInput("gender", "Geschlecht:", 
                           choices = c("Männlich" = "m", "Weiblich" = "w", "Divers" = "d"),
                           selected = "m")
              ),
              column(3,
                br(),
                actionButton("refresh", "Aktualisieren", 
                            class = "btn-info", icon = icon("refresh"))
              )
            )
          )
        ),
        
        fluidRow(
          # Template variables display
          box(
            title = "Verfügbare Template-Variablen", status = "info", solidHeader = TRUE,
            width = 12, collapsible = TRUE,
            
            verbatimTextOutput("template_vars")
          )
        ),
        
        fluidRow(
          # Results display
          box(
            title = "Alle Sätze mit Template-Ersetzungen", status = "success", solidHeader = TRUE,
            width = 12, collapsible = TRUE,
            
            uiOutput("sentences_output")
          )
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive values for template replacements
  template_replacements <- reactive({
    generate_template_replacements(
      input$first_name %||% "Max", 
      input$last_name %||% "Mustermann", 
      input$gender %||% "m"
    )
  })
  
  # Reactive values for grammar analysis
  grammar_replacements <- reactive({
    generate_template_replacements(
      input$first_name_grammar %||% "Max", 
      input$last_name_grammar %||% "Mustermann", 
      input$gender_grammar %||% "m"
    )
  })
  
  # Display current template variables
  output$template_vars <- renderText({
    replacements <- template_replacements()
    vars_text <- paste(names(replacements), "=", replacements, collapse = "\n")
    return(vars_text)
  })
  
  # Grammar analysis
  output$grammar_issues_output <- renderUI({
    if (input$analyze_grammar == 0) {
      return(p("Klicken Sie auf 'Grammatik analysieren' um zu starten."))
    }
    
    isolate({
      replacements <- grammar_replacements()
      
      output_elements <- list()
      issues_found <- 0
      
      # Get filename mapping for categories
      data_files <- list.files("data", pattern = "\\.txt$", full.names = FALSE)
      filename_map <- list()
      for (file in data_files) {
        category_name <- gsub("^[0-9]{3}_", "", tools::file_path_sans_ext(file))
        filename_map[[category_name]] <- file
      }
      
      for (category_name in names(categories_data)) {
        category_issues <- list()
        filename <- filename_map[[category_name]] %||% paste0(category_name, ".txt")
        
        category_data <- categories_data[[category_name]]
        
        for (grade in names(category_data)) {
          sentences <- category_data[[grade]]
          
          grade_text <- switch(grade,
                              "1" = "Sehr gut",
                              "2" = "Gut", 
                              "3" = "Befriedigend",
                              "4" = "Ausreichend",
                              "5" = "Mangelhaft")
          
          for (i in seq_along(sentences)) {
            original_sentence <- sentences[i]
            
            # Check for grammar issues
            sentence_issues <- list()
            for (check in grammar_checks) {
              if (grepl(check$pattern, original_sentence)) {
                sentence_issues[[length(sentence_issues) + 1]] <- check
              }
            }
            
            if (length(sentence_issues) > 0) {
              issues_found <- issues_found + 1
              replaced_sentence <- replace_templates(original_sentence, replacements)
              
              # Create issue display
              issue_alerts <- lapply(sentence_issues, function(issue) {
                div(class = "issue-alert",
                    strong("Problem: "), issue$issue, br(),
                    strong("Vorschlag: "), issue$suggestion)
              })
              
              sentence_div <- div(
                class = "sentence-row issue-sentence",
                div(class = "sentence-tooltip", paste("Datei:", filename)),
                div(class = "file-info", paste("📁", filename, "• Zeile:", grade, "-", i)),
                h6(paste("Problem in", category_name, "- Note", grade, "- Satz", i), 
                   style = "color: #e17055; margin-bottom: 8px;"),
                
                do.call(tagList, issue_alerts),
                
                p(strong("Original:"), br(), 
                  code(original_sentence, style = "background-color: #f8f9fa; padding: 4px; border-radius: 3px;")),
                p(strong("Mit Ersetzungen:"), br(), 
                  code(replaced_sentence, style = "background-color: #e8f5e8; padding: 4px; border-radius: 3px;"))
              )
              
              category_issues[[length(category_issues) + 1]] <- sentence_div
            }
          }
        }
        
        if (length(category_issues) > 0) {
          output_elements[[length(output_elements) + 1]] <- 
            div(class = "category-header", paste("Probleme in Kategorie:", category_name, "(", filename, ")"))
          
          output_elements <- c(output_elements, category_issues)
          output_elements[[length(output_elements) + 1]] <- hr()
        }
      }
      
      if (issues_found == 0) {
        return(div(
          class = "alert alert-success",
          h4("Keine bekannten Grammatikprobleme gefunden!"),
          p("Alle Sätze scheinen grammatisch korrekt zu sein.")
        ))
      } else {
        summary_div <- div(
          class = "alert alert-warning",
          h4(paste("Insgesamt", issues_found, "potentielle Grammatikprobleme gefunden")),
          p("Bitte überprüfen Sie die unten aufgelisteten Sätze.")
        )
        
        return(tagList(summary_div, output_elements))
      }
    })
  })
  
  # Helper function to highlight template variables and replacements
  highlight_templates <- function(original_text, replaced_text, replacements) {
    # Find all template variables in original text
    template_pattern <- "\\{([^}]+)\\}"
    matches <- gregexpr(template_pattern, original_text)
    
    if (matches[[1]][1] == -1) {
      # No templates found
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
      highlighted_var <- paste0('<span class="template-variable">', var, '</span>')
      # Use fixed=TRUE to avoid regex interpretation
      highlighted_original <- gsub(paste0("\\{", var_name, "\\}"), highlighted_var, highlighted_original, fixed = TRUE)
    }
    
    # Create highlighted replaced text with word boundaries to avoid partial matches
    highlighted_replaced <- replaced_text
    for (var in template_vars) {
      var_name <- gsub("[{}]", "", var)
      if (var_name %in% names(replacements)) {
        replacement_value <- replacements[[var_name]]
        highlighted_replacement <- paste0('<span class="replaced-text">', replacement_value, '</span>')
        
        # Use word boundary regex to avoid partial matches like "er" in "der"
        # Escape special regex characters in the replacement value
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
  
  # Generate sentences output
  output$sentences_output <- renderUI({
    replacements <- template_replacements()
    
    output_elements <- list()
    
    # Get filename mapping for categories
    data_files <- list.files("data", pattern = "\\.txt$", full.names = FALSE)
    filename_map <- list()
    for (file in data_files) {
      category_name <- gsub("^[0-9]{3}_", "", tools::file_path_sans_ext(file))
      filename_map[[category_name]] <- file
    }
    
    for (category_name in names(categories_data)) {
      filename <- filename_map[[category_name]] %||% paste0(category_name, ".txt")
      
      # Add category header with filename
      output_elements[[length(output_elements) + 1]] <- 
        div(class = "category-header", paste("Kategorie:", category_name, "(", filename, ")"))
      
      category_data <- categories_data[[category_name]]
      
      for (grade in names(category_data)) {
        sentences <- category_data[[grade]]
        
        grade_text <- switch(grade,
                            "1" = "Sehr gut",
                            "2" = "Gut", 
                            "3" = "Befriedigend",
                            "4" = "Ausreichend",
                            "5" = "Mangelhaft")
        
        # Add grade subheader
        output_elements[[length(output_elements) + 1]] <- 
          h5(paste("Note", grade, "-", grade_text), style = "color: #0984e3; margin-top: 15px;")
        
        for (i in seq_along(sentences)) {
          original_sentence <- sentences[i]
          replaced_sentence <- replace_templates(original_sentence, replacements)
          
          # Get highlighting information
          highlight_info <- highlight_templates(original_sentence, replaced_sentence, replacements)
          
          # Create sentence display with filename info
          sentence_div <- div(
            class = "sentence-row",
            div(class = "sentence-tooltip", paste("Datei:", filename, "• Zeile:", grade, "-", i)),
            div(class = "file-info", paste("📁", filename, "• Zeile:", grade, "-", i)),
            h6(paste("Satz", i), style = "color: #636e72; margin-bottom: 8px;"),
            
            if (highlight_info$has_templates) {
              tagList(
                p(strong("Original:"), br(), 
                  code(HTML(highlight_info$original), style = "background-color: #f8f9fa; padding: 4px; border-radius: 3px; display: block;")),
                p(strong("Ersetzt:"), br(), 
                  code(HTML(highlight_info$replaced), style = "background-color: #e8f5e8; padding: 4px; border-radius: 3px; display: block;")),
                p(em(paste("Anzahl Template-Variablen:", highlight_info$template_count)), 
                  style = "color: #636e72; font-size: 0.9em; margin-bottom: 0;")
              )
            } else {
              tagList(
                p(strong("Text (keine Templates):"), br(), 
                  code(original_sentence, style = "background-color: #f8f9fa; padding: 4px; border-radius: 3px; display: block;")),
                p(em("Keine Template-Variablen gefunden"), 
                  style = "color: #636e72; font-size: 0.9em; margin-bottom: 0;")
              )
            }
          )
          
          output_elements[[length(output_elements) + 1]] <- sentence_div
        }
      }
      
      # Add separator between categories
      output_elements[[length(output_elements) + 1]] <- hr()
    }
    
    return(tagList(output_elements))
  })
  
  # Refresh functionality (automatically triggers when inputs change)
  observeEvent(c(input$first_name, input$last_name, input$gender), {
    # Reactive will automatically update
  })
}

# Helper function for null coalescing
`%||%` <- function(x, y) if (is.null(x) || length(x) == 0 || x == "") y else x

# Run the application
shinyApp(ui = ui, server = server)
