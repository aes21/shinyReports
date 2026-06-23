## Resubmission
This is a resubmission. In this version, I have addressed the feedback provided by the CRAN reviewer regarding the previous submission (1.0.2).

### Changes
* **Added automated tests:** Extracted internal rendering logic and implemented a `testthat` folder to automatically verify the compilation of `.Rmd` files and the correct generation of HTML/JavaScript components.
* **Updated examples:** Wrapped interactive 'shiny' UI examples in `if (interactive()) { ... }` blocks to comply with CRAN policies.
* **Improved documentation:** Explicitly documented the return values for all exported functions using the `@return` tag.

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
  New submission — This note is expected, as the package has not yet been published to the live CRAN repository.
  
## Test environments

* Local: Windows 11, R 4.5.2
* Windows Server 2022, R 4.6.0 release (via devtools::check_win_release())
* Windows Server 2022, R Under development (via devtools::check_win_devel())
