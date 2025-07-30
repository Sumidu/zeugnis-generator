library(shiny)
library(shinydashboard)

# Helper function for null coalescing
`%||%` <- function(x, y) if (is.null(x) || length(x) == 0 || x == "") y else x

# Source helper functions
source("R/helpers.R")

# Load category data
categories_data <- load_category_data("data")
grade_names <- get_grade_names()

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Zeugnis Generator"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Zeugnis erstellen", tabName = "generator", icon = icon("edit")),
      menuItem("Hilfe", tabName = "help", icon = icon("question-circle"))
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
        .grade-select {
          margin-bottom: 10px;
        }
        .sentence-select {
          margin-bottom: 15px;
        }
        #final_text {
          min-height: 200px;
          font-family: 'Times New Roman', serif;
          line-height: 1.6;
        }
      ")),
      tags$script(HTML("
        Shiny.addCustomMessageHandler('updateTextarea', function(message) {
          $('#' + message.id).val(message.value);
        });
        
        Shiny.addCustomMessageHandler('copyToClipboard', function(message) {
          var textArea = document.getElementById(message.id);
          textArea.select();
          textArea.setSelectionRange(0, 99999);
          
          try {
            var successful = document.execCommand('copy');
            if (successful) {
              alert('Text wurde in die Zwischenablage kopiert!');
            } else {
              alert('Kopieren fehlgeschlagen. Bitte manuell kopieren.');
            }
          } catch (err) {
            alert('Kopieren nicht unterstützt. Bitte manuell kopieren.');
          }
        });
      "))
    ),
    
    tabItems(
      # Generator tab
      tabItem(tabName = "generator",
        fluidRow(
          # Personal information box
          box(
            title = "Persönliche Angaben", status = "primary", solidHeader = TRUE,
            width = 12, collapsible = TRUE,
            
            fluidRow(
              column(4,
                textInput("first_name", "Vorname:", value = "Max")
              ),
              column(4,
                textInput("last_name", "Nachname:", value = "Mustermann")
              ),
              column(4,
                selectInput("gender", "Geschlecht:", 
                           choices = c("Männlich" = "m", "Weiblich" = "w", "Divers" = "d"),
                           selected = "m")
              )
            )
          )
        ),
        
        fluidRow(
          # Categories box
          box(
            title = "Kategorien auswählen", status = "info", solidHeader = TRUE,
            width = 8, collapsible = TRUE,
            
            # Dynamic UI for categories will be generated here
            uiOutput("category_ui")
          ),
          
          # Preview box
          box(
            title = "Vorschau", status = "success", solidHeader = TRUE,
            width = 4,
            
            h4("Ausgewählte Kategorien:"),
            verbatimTextOutput("selected_categories"),
            
            br(),
            actionButton("generate", "Zeugnis generieren", 
                        class = "btn-success btn-lg",
                        style = "width: 100%;")
          )
        ),
        
        fluidRow(
          # Final text box
          box(
            title = "Generiertes Zeugnis", status = "warning", solidHeader = TRUE,
            width = 12, collapsible = TRUE,
            
            div(
              style = "margin-bottom: 10px;",
              actionButton("copy_text", "Text kopieren", 
                          class = "btn-primary",
                          icon = icon("copy"))
            ),
            
            tags$textarea(
              id = "final_text",
              class = "form-control",
              style = "width: 100%; min-height: 200px; resize: vertical;",
              placeholder = "Das generierte Zeugnis wird hier angezeigt..."
            )
          )
        )
      ),
      
      # Help tab
      tabItem(tabName = "help",
        fluidRow(
          box(
            title = "Anleitung", status = "info", solidHeader = TRUE,
            width = 12,
            
            h3("Wie funktioniert der Zeugnis Generator?"),
            
            h4("1. Persönliche Angaben"),
            p("Geben Sie Vor- und Nachname sowie das Geschlecht der Person ein. 
              Diese Informationen werden für die korrekte Anrede im Zeugnis verwendet."),
            
            h4("2. Kategorien auswählen"),
            p("Wählen Sie die Kategorien aus, die im Arbeitszeugnis erscheinen sollen. 
              Für jede Kategorie können Sie:"),
            tags$ul(
              tags$li("Eine Note von 1 (Sehr gut) bis 5 (Mangelhaft) auswählen"),
              tags$li("Einen spezifischen Satz aus den verfügbaren Optionen wählen")
            ),
            
            h4("3. Zeugnis generieren"),
            p("Klicken Sie auf 'Zeugnis generieren', um den finalen Text zu erstellen. 
              Der Text kann dann kopiert und in Word eingefügt werden."),
            
            h4("Verfügbare Kategorien:"),
            verbatimTextOutput("available_categories"),
            
            h4("Notensystem:"),
            tags$ul(
              tags$li("1 = Sehr gut"),
              tags$li("2 = Gut"), 
              tags$li("3 = Befriedigend"),
              tags$li("4 = Ausreichend"),
              tags$li("5 = Mangelhaft")
            )
          )
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Generate dynamic UI for categories
  output$category_ui <- renderUI({
    category_elements <- list()
    
    for (category_name in names(categories_data)) {
      category_elements[[length(category_elements) + 1]] <- 
        div(
          class = "panel panel-default",
          style = "margin-bottom: 15px; padding: 15px; border: 1px solid #ddd; border-radius: 4px;",
          
          h4(category_name, style = "margin-top: 0;"),
          
          fluidRow(
            column(6,
              checkboxInput(
                inputId = paste0("enable_", make.names(category_name)),
                label = paste("Kategorie", category_name, "verwenden"),
                value = FALSE
              )
            )
          ),
          
          conditionalPanel(
            condition = paste0("input.enable_", make.names(category_name)),
            
            fluidRow(
              column(6,
                selectInput(
                  inputId = paste0("grade_", make.names(category_name)),
                  label = "Note:",
                  choices = grade_names,
                  selected = "1",
                  width = "100%"
                )
              )
            ),
            
            fluidRow(
              column(12,
                uiOutput(paste0("sentence_", make.names(category_name)))
              )
            )
          )
        )
    }
    
    return(tagList(category_elements))
  })
  
  # Generate sentence selection UI for each category
  observe({
    for (category_name in names(categories_data)) {
      local({
        cat_name <- category_name
        safe_name <- make.names(cat_name)
        
        output[[paste0("sentence_", safe_name)]] <- renderUI({
          enable_input <- paste0("enable_", safe_name)
          grade_input <- paste0("grade_", safe_name)
          
          # Check if category is enabled and grade is selected
          req(input[[enable_input]])
          req(input[[grade_input]])
          
          selected_grade <- as.character(input[[grade_input]])
          
          # Get sentences for this category and grade
          sentences <- categories_data[[cat_name]][[selected_grade]]
          
          if (!is.null(sentences) && length(sentences) > 0) {
            # Create choices with option labels as names and sentences as values
            #option_labels <- paste0("Option ", seq_along(sentences))
            #choices <- setNames(sentences, option_labels)
            choices <- sentences
            selectInput(
              inputId = paste0("sentence_", safe_name),
              label = "Satz auswählen:",
              choices = choices,
              selected = sentences[1],
              width = "100%"
            )
          } else {
            p("Keine Sätze für diese Note verfügbar.", style = "color: red;")
          }
        })
      })
    }
  })
  
  # Show selected categories
  output$selected_categories <- renderText({
    selected <- c()
    for (category_name in names(categories_data)) {
      safe_name <- make.names(category_name)
      enable_input <- paste0("enable_", safe_name)
      
      if (!is.null(input[[enable_input]]) && input[[enable_input]]) {
        grade_input <- paste0("grade_", safe_name)
        if (!is.null(input[[grade_input]])) {
          grade_text <- grade_names[input[[grade_input]]]
          selected <- c(selected, paste0(category_name, ": ", grade_text))
        }
      }
    }
    
    if (length(selected) == 0) {
      return("Keine Kategorien ausgewählt")
    } else {
      return(paste(selected, collapse = "\n"))
    }
  })
  
  # Generate zeugnis text
  observeEvent(input$generate, {
    # Collect selected sentences
    selected_sentences <- list()
    
    for (category_name in names(categories_data)) {
      safe_name <- make.names(category_name)
      enable_input <- paste0("enable_", safe_name)
      sentence_input <- paste0("sentence_", safe_name)
      
      if (!is.null(input[[enable_input]]) && input[[enable_input]] &&
          !is.null(input[[sentence_input]])) {
        selected_sentences[[category_name]] <- input[[sentence_input]]
      }
    }
    
    # Prepare replacements
    anrede <- generate_anrede(input$first_name %||% "", 
                             input$last_name %||% "", 
                             input$gender %||% "m")
    
    replacements <- list(
      "ANREDE" = anrede,
      "VORNAME" = input$first_name %||% "",
      "NACHNAME" = input$last_name %||% "",
      "NAME" = paste(input$first_name %||% "", input$last_name %||% "")
    )
    
    # Generate final text
    final_text <- generate_zeugnis_text(selected_sentences, replacements)
    
    # Update textarea
    session$sendCustomMessage(type = 'updateTextarea', 
                             message = list(id = 'final_text', value = final_text))
  })
  
  # Copy text functionality
  observeEvent(input$copy_text, {
    session$sendCustomMessage(type = 'copyToClipboard', 
                             message = list(id = 'final_text'))
  })
  
  # Show available categories in help
  output$available_categories <- renderText({
    paste(names(categories_data), collapse = "\n")
  })
}

# Helper function for null coalescing
`%||%` <- function(x, y) if (is.null(x) || length(x) == 0 || x == "") y else x

# Run the application
shinyApp(ui = ui, server = server)
