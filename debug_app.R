library(shiny)
library(shinydashboard)
library(DT)

# Source helper functions from main app
source("R/helpers.R")

# Load category data
categories_data <- load_category_data("data")

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Template Debug Tool"),
  
  dashboardSidebar(
    sidebarMenu(
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
        .sentence-row {
          margin-bottom: 15px;
          padding: 10px;
          border: 1px solid #ddd;
          border-radius: 5px;
          background-color: white;
        }
        .category-header {
          background-color: #74b9ff;
          color: white;
          padding: 10px;
          margin: 10px 0;
          border-radius: 5px;
          font-weight: bold;
        }
      "))
    ),
    
    tabItems(
      tabItem(tabName = "debug",
        fluidRow(
          # Control panel
          box(
            title = "Einstellungen", status = "primary", solidHeader = TRUE,
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
          # Results display
          box(
            title = "Template-Ersetzungen", status = "success", solidHeader = TRUE,
            width = 12, collapsible = TRUE,
            
            div(id = "template_overview",
                h4("Template-Variablen für aktuelle Einstellungen:"),
                verbatimTextOutput("template_vars")
            ),
            
            hr(),
            
            div(id = "sentences_display",
                h4("Alle Sätze mit Ersetzungen:"),
                uiOutput("sentences_output")
            )
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
  
  # Reactive gender value
  current_gender <- reactive({
    input$gender %||% "m"
  })
  
  # Display current template variables
  output$template_vars <- renderText({
    replacements <- template_replacements()
    vars_text <- paste(names(replacements), "=", replacements, collapse = "\n")
    return(vars_text)
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
    
    for (category_name in names(categories_data)) {
      # Add category header
      output_elements[[length(output_elements) + 1]] <- 
        div(class = "category-header", paste("Kategorie:", category_name))
      
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
          replaced_sentence <- replace_templates(original_sentence, replacements, current_gender())
          
          # Get highlighting information
          highlight_info <- highlight_templates(original_sentence, replaced_sentence, replacements)
          
          # Create sentence display
          sentence_div <- div(
            class = "sentence-row",
            h6(paste("Satz", i), style = "color: #636e72; margin-bottom: 8px;"),
            
            if (highlight_info$has_templates) {
              tagList(
                p(strong("Original:"), br(), HTML(highlight_info$original)),
                p(strong("Ersetzt:"), br(), HTML(highlight_info$replaced)),
                p(em(paste("Anzahl Template-Variablen:", highlight_info$template_count)), 
                  style = "color: #636e72; font-size: 0.9em; margin-bottom: 0;")
              )
            } else {
              tagList(
                p(strong("Text (keine Templates):"), br(), original_sentence),
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
  
  # Refresh functionality
  observeEvent(input$refresh, {
    # Force reactive recalculation by invalidating the reactive
    # The sentences_output reactive will automatically update when inputs change
    # No need to duplicate the rendering logic here
  })
}

# Helper function for null coalescing
`%||%` <- function(x, y) if (is.null(x) || length(x) == 0 || x == "") y else x

# Run the application
shinyApp(ui = ui, server = server)
