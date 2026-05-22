#' @title Report download button
#'
#' @description Modifies [shiny::actionButton()] to generate and open an R Markdown report in a new window tab.
#'
#' @inheritParams shiny::actionButton
#'
#' @export
#'
#' @seealso [renderReport()]
#'
#' @import shiny
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
