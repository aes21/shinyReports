[![CRAN status](https://www.r-pkg.org/badges/version/shinyReports)](https://CRAN.R-project.org/package=shinyReports)
[![R-CMD-check](https://github.com/aes21/shinyReports/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/aes21/shinyReports/actions/workflows/R-CMD-check.yaml)


# shinyReports
> Render `.Rmd` reports directly in your browser from a [shiny](https://github.com/rstudio/shiny) application - no download required.

## Overview
This package adapts the Shiny -> R Markdown report generation workflow to remove the need to download a file and open it manually. `shinyReports` provides UI and server-side elements to knit the `.Rmd` file and automatically push the HTML content to a new browser tab.

## Installation
Install from CRAN with:

```r
install.packages("shinyReports")
```

Or install directly from GitHub with:

```r
# install.packages("remotes")
remotes::install_github("aes21/shinyReports")
```

## Usage

### 1. Prepare the R Markdown file
Ensure your R Markdown file sits within your app structure. The YAML heading of the R Markdown file must knit to a HTML document:

```rmd
---
title: ''
output: html_document
params:
  foo: NA
---
```

### 2. Add the UI element
The `reportButton()` function acts as a connection wrapper for `shiny::actionButton` to the report download in the UI.

```r
ui <- fluidPage(
  reportButton("knit_report", "Generate Report")
)
```

### 3. Server-side logic
The `renderReport()` function contains the server-side logic to compile a `.Rmd` file and load the HTML content to the client.

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

The `params` list is passed directly through to the `.Rmd` file, so you can populate reports with reactive values from your app.

## Demo
For an example `shinyReports` application, you can launch the demo directly from your R console:

```r
library(shinyReports)

# launch example app
shiny::runApp(system.file("examples", package = "shinyReports"))
```

> ![demo](man/figures/shinyReports_demo.gif)
