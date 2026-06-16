#' @title Render report to a new window
#'
#' @description Server-side logic to compile .Rmd and send HTML to client.
#'
#' @param inputId The input slot that will be used to access the value.
#' @param title The title to label the report tab.
#' @param rmd_file The input file to be rendered (.Rmd).
#' @param params A list of named parameters that override custom params specified within the YAML front-matter.
#' @param envir The environment in which the code chunks are to be evaluated during knitting.
#'
#' @export
#'
#' @seealso [reportButton()]
#'
#' @import shiny
#' @importFrom rmarkdown render
renderReport <- function(inputId, title = "Report", rmd_file, params = NULL, envir = parent.frame()) {
  # listen to current session inputId
  session <- shiny::getDefaultReactiveDomain()

  shiny::observeEvent(session$input[[inputId]], {
    # evaluate the params list in reactive cases
    param_list <- if (is.function(params)) params() else params

    # create temporary file
    temp_html <- tempfile(fileext = ".html")

    # render report
    tryCatch(
      rmarkdown::render(
        rmd_file,
        output_file = temp_html,
        params = param_list,
        envir = envir,
        knit_root_dir = getwd(),
        quiet = TRUE
      ),
      error = function(e) {
        message(e)
        shiny::showNotification(
          "ERROR: Unable to render the report",
          type = "error"
        )
        NULL
      }
    )

    if (file.exists(temp_html)) {
      # read in content
      html_content <- readLines(temp_html, warn = FALSE)

      # swap title and format
      html_content <- gsub(
        "(?<=<title>)(.*?)(?=</title>)",
        title,
        html_content,
        perl = TRUE
      )
      html_string <- paste(html_content, collapse = "\n")

      # open new window
      session$sendCustomMessage(type = "openWindow", message = html_string)
    }
  }, ignoreInit = TRUE)
}
