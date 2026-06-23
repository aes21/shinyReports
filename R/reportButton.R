#' @title Report download button
#'
#' @description Modifies [shiny::actionButton()] to generate and open an R
#'    Markdown report in a new window tab.
#'
#' @inheritParams shiny::actionButton
#'
#' @return A \code{shiny.tag.list} object definition (from
#'    \code{\link[shiny]{tagList}}) containing two components:
#'    \itemize{
#'      \item A \code{\link[shiny]{singleton}} \code{<script>} tag, injected
#'        into the page \code{<head>}, that registers a custom 'shiny' message
#'        handler (\code{"openWindow"}) for opening the rendered report in a
#'        new browser tab/window.
#'      \item A \code{\link[shiny]{actionButton}} with the argument definitions
#'        of \code{inputId}, \code{label} and \code{icon}.
#'    }
#'    The return value should only be included under a
#'    \code{\link[shiny]{fluidPage}} 'shiny' definition.
#'
#' @export
#'
#' @seealso [renderReport()]
#'
#' @import shiny
#'
#' @examples
#' if (interactive()) {
#'   ui <- fluidPage(
#'     reportButton(
#'       inputId = "knit_report",
#'       label = "Generate Report"
#'     )
#'   )
#' }
reportButton <- function(inputId, label = "View Report", icon = NULL, ...) {
  open_window_js <- shiny::singleton(
    shiny::tags$head(
      shiny::tags$script(shiny::HTML(
        "Shiny.addCustomMessageHandler('openWindow', function(message) {
          var newWindow = window.open('', '_blank');
          newWindow.document.write(message);
          newWindow.document.close();
        });"
      ))
    )
  )

  shiny::tagList(
    open_window_js,
    shiny::actionButton(inputId, label, icon, ...)
  )
}
