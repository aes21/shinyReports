# shinyReports
> Simplifies automatic HTML report rendering from .Rmd files in [shiny](https://github.com/rstudio/shiny).

## Overview
This package adapts the Shiny -> .Rmd report generation workflow to automatically push HTML content to the client and open a new browser tab.

## Installation
Install directly from GitHub with:

```r
# install.packages("remotes")
remotes::install_github("aes21/shinyReports")
```

## Usage
Ensure your R Markdown file sits within your app structure. The YAML heading of the R Markdown file must knit to a HTML document:

```rmd
---
title: ''
output: html_document
params:
  foo: NA
---
```

The `reportButton()` function acts as a connection wrapper for `shiny::actionButton` to the report download in the UI.

```r
ui <- fluidPage(
  reportButton("knit_report", "Generate Report")
)
```

The `renderReport()` function contains the server-side logic to compile a .Rmd file and load the HTML content to the client.

```r
server <- function(input, output, session) {
  renderReport(
    "knit_report",
    rmd_file = "path/to/rmarkdown.Rmd",
    title = "Report Title",
    params = list()
  )
}
```

For an example `shinyReports` application, you can launch the demo application directly from your R console:

```r
library(shinyReports)

# launch example app
shiny::runApp(system.file("examples", package = "shinyReports"))
```

### Demo

![demo](assets/shinyReports_demo.gif)
