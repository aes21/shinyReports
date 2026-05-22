library(shiny)
library(shinyReports)

ui <- fillPage(
  titlePanel("Report Generator"),
  selectInput("foo", "Select a variable", choices = c("A", "B", "C")),
  reportButton("knit_report", "Generate Report")
)

server <- function(input, output, session) {
  renderReport(
    "knit_report",
    rmd_file = "tempReport.Rmd",
    title = "Example Report Generator",
    params = reactive({
      list(foo = input$foo)
    })
  )
}

shinyApp(ui, server)
