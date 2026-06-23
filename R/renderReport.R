#' Helper function compiling R Markdowns to HTML strings
#'
#' @noRd
.report_to_html <- function(
  rmd_file,
  title,
  params = NULL,
  envir = parent.frame()
) {
  if (!file.exists(rmd_file)) {
    return(NULL)
  }

  # create temporary file
  temp_html <- tempfile(fileext = ".html")
  on.exit(unlink(temp_html), add = TRUE)

  render_result <- tryCatch(
    rmarkdown::render(
      rmd_file,
      output_file = temp_html,
      params = params,
      envir = envir,
      knit_root_dir = getwd(),
      quiet = TRUE
    ),
    error = function(e) {
      message("Rendering error: ", conditionMessage(e), "\n")
      NULL
    }
  )

  if (!is.null(render_result) && file.exists(temp_html)) {
    # read in content
    html_content <- readLines(temp_html, warn = FALSE)

    # swap title and format
    html_content <- gsub(
      "(?<=<title>)(.*?)(?=</title>)",
      title,
      html_content,
      perl = TRUE
    )

    return(paste(html_content, collapse = "\n"))
  }

  NULL
}

#' @title Render report to a new window
#'
#' @description Server-side logic to compile .Rmd and send HTML to client.
#'
#' @param inputId The input slot that will be used to access the value.
#' @param title The title to label the report tab.
#' @param rmd_file The input file to be rendered (.Rmd).
#' @param params A list of named parameters that override custom params
#'    specified within the YAML front-matter.
#' @param envir The environment in which the code chunks are to be evaluated
#'    during knitting.
#'
#' @return No return value, called for side effects. Registers a
#'    \code{shiny::observeEvent} that listens for the specified \code{inputId}
#'    button click and renders the given \code{.Rmd} file to a temporary HTML
#'    file, the content of which is sent to the client via a custom 'shiny'
#'    message (\code{"openWindow"}) to open a new browser tab/window. If the
#'    render fails, a 'shiny' error notification is displayed.
#'
#' @export
#'
#' @seealso [reportButton()]
#'
#' @import shiny
#' @importFrom rmarkdown render
#'
#' @examples
#' if (interactive()) {
#'   server <- function(input, output, session) {
#'     renderReport(
#'       inputId = "knit_report",
#'       title = "My Report",
#'       rmd_file = "report.Rmd",
#'       params = list(date = Sys.Date())
#'     )
#'   }
#' }
renderReport <- function(
  inputId, title = "Report",
  rmd_file, params = NULL,
  envir = parent.frame()
) {
  # listen to current session inputId
  session <- shiny::getDefaultReactiveDomain()

  shiny::observeEvent(session$input[[inputId]], {
    # evaluate the params list in reactive cases
    param_list <- if (is.function(params)) params() else params

    # call report HTML content builder
    html_string <- .report_to_html(
      rmd_file = rmd_file,
      title = title,
      params = param_list,
      envir = envir
    )

    if (!is.null(html_string)) {
      # open new window
      session$sendCustomMessage(type = "openWindow", message = html_string)
    } else {
      shiny::showNotification(
        "ERROR: Unable to render the report",
        type = "error"
      )
    }
  }, ignoreInit = TRUE)
}
