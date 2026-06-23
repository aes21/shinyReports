test_that("reportButton generates required HTML components", {
  skip_if_not_installed("htmltools")

  res <- reportButton(inputId = "test_btn", label = "Test Label")

  # return type
  expect_s3_class(res, "shiny.tag.list")

  # process tag list for elements
  rendered <- htmltools::renderTags(res)

  # extract strings
  head_str <- rendered$head
  body_str <- rendered$html

  # check js inserted into header
  expect_true(grepl("Shiny.addCustomMessageHandler", head_str, fixed = TRUE))
  expect_true(grepl("openWindow", head_str, fixed = TRUE))

  # check actionButton attributes
  expect_true(grepl('id="test_btn"', body_str, fixed = TRUE))
  expect_true(grepl('Test Label', body_str, fixed = TRUE))
  expect_true(
    grepl('class="btn btn-default action-button"', body_str, fixed = TRUE)
  )
})
