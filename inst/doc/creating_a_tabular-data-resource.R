## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(fr)

## -----------------------------------------------------------------------------
d <-
  tibble::tibble(
    id = c("A01", "A02", "A03"),
    date = as.Date(c("2022-07-25", "2018-07-10", "2013-08-15")),
    measure = c(12.8, 13.9, 15.6),
    rating = factor(c("good", "best", "best"), levels = c("good", "better", "best")),
    ranking = c(14, 17, 19),
    impt = c(FALSE, TRUE, TRUE)
  )

## -----------------------------------------------------------------------------
sapply(d, class)

d

## -----------------------------------------------------------------------------
d_tdr <-
  d |>
  as_fr_tdr(
    name = "types_example",
    version = "0.1.0",
    title = "Example Data with Types",
    homepage = "https://geomarker.io",
    description = "This is used as an example dataset in the {fr} package vignette on `Creating a tabular-data-resource`."
  )

## -----------------------------------------------------------------------------
d_tdr <-
  d_tdr |>
  update_field("id",
               title = "Identifier",
               description = "This is a unique identifier for each study participant.")

## -----------------------------------------------------------------------------
write_fr_tdr(d_tdr, dir = tempdir())

fs::dir_tree(fs::path(tempdir(), "types_example"))

