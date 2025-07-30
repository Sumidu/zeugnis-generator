library(shiny)
library(shinydashboard)
library(here)

# Simple test app to debug the issue
source(here("R", "helpers.R"))
categories_data <- load_category_data(here("data"))
grade_names <- get_grade_names()

# Simple UI for testing
ui <- dashboardPage(
  dashboardHeader(title = "Test"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      box(
        title = "Test", width = 12,
        
        # Test for Sozialverhalten
        checkboxInput("enable_test", "Enable Sozialverhalten", FALSE),
        conditionalPanel(
          condition = "input.enable_test",
          selectInput("grade_test", "Grade:", choices = grade_names, selected = "1"),
          uiOutput("sentence_test")
        ),
        
        verbatimTextOutput("debug_output")
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$sentence_test <- renderUI({
    if (!is.null(input$enable_test) && input$enable_test && !is.null(input$grade_test)) {
        
      selected_grade <- as.character(input$grade_test)
      cat_name <- "Sozialverhalten"
      cat(selected_grade)
      if (cat_name %in% names(categories_data) && 
          selected_grade %in% names(categories_data[[cat_name]])) {
            cat("step2")
        sentences <- categories_data[[cat_name]][[selected_grade]]
        
        if (length(sentences) > 0) {
            cat()
          choices <- setNames(sentences, paste0("Option ", seq_along(sentences)))
          return(selectInput("sentence_selected", "Choose:", choices = choices))
        }
      }
      
      return(p("No sentences found", style = "color: red;"))
    }
    
    return(div())
  })
  
  output$debug_output <- renderText({
    if (!is.null(input$grade_test)) {
      selected_grade <- as.character(input$grade_test)
      paste0(
        "Grade selected: ", selected_grade, "\n",
        "Categories available: ", paste(names(categories_data), collapse = ", "), "\n",
        "Grades for Sozialverhalten: ", paste(names(categories_data[["Sozialverhalten"]]), collapse = ", "), "\n",
        "Grade exists: ", selected_grade %in% names(categories_data[["Sozialverhalten"]]), "\n",
        "Sentences count: ", length(categories_data[["Sozialverhalten"]][[selected_grade]])
      )
    } else {
      "No grade selected"
    }
  })
}

shinyApp(ui, server)
