test_that(".report_to_html correctly renders .Rmd and injects custom title", {
  temp_rmd <- tempfile(fileext = ".Rmd")
  writeLines(
    c("---",
      "title: 'Default Title'",
      "output: html_document",
      "---",
      "This is a test document."),
    temp_rmd
  )

  # clean up temp file
  on.exit(unlink(temp_rmd), add = TRUE)

  title <- "Report Title"
  result_html <- .report_to_html(
    rmd_file = temp_rmd,
    title = title
  )

  # verify output
  expect_type(result_html, "character")
  expect_true(nchar(result_html) > 0)

  # verify regex title swap
  title_tag <- sprintf("<title>%s</title>", title)
  expect_true(grepl(title_tag, result_html, fixed = TRUE))
})

test_that(".report_to_html handles invalid .Rmd paths", {
  result_html <- .report_to_html(
    rmd_file = "fake_file.Rmd",
    title = "Fake Report Title"
  )

  expect_null(result_html)
})
