## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(fr)

## -----------------------------------------------------------------------------
fs::dir_tree(fs::path_package("fr", "hamilton_poverty_2020"), recurse = TRUE)

## -----------------------------------------------------------------------------
d_fr <- read_fr_tdr(fs::path_package("fr", "hamilton_poverty_2020"))

## -----------------------------------------------------------------------------
d_fr

## -----------------------------------------------------------------------------
S7::prop(d_fr, "schema")

## -----------------------------------------------------------------------------
lm(fraction_poverty ~ year, data = d_fr)

## -----------------------------------------------------------------------------
head(d_fr$fraction_poverty)

## -----------------------------------------------------------------------------
d_fr |>
  dplyr::mutate(high_poverty = fraction_poverty > median(fraction_poverty))

## -----------------------------------------------------------------------------
d_fr |>
  tibble::as_tibble() |>
  dplyr::mutate(high_poverty = fraction_poverty > median(fraction_poverty)) |>
  as_fr_tdr(.template = d_fr)

## -----------------------------------------------------------------------------
d_fr |>
  fr_mutate(high_poverty = fraction_poverty > median(fraction_poverty)) |>
  fr_select(-year) |>
  fr_arrange(desc(fraction_poverty))

## -----------------------------------------------------------------------------
library(dplyr, warn.conflicts = FALSE)

d_fr <- update_field(d_fr, "fraction_poverty", description = "the poverty fraction")

d_extant <-
  d_fr |>
  fr_mutate(score = 1 + fraction_poverty) |>
  fr_select(-fraction_poverty, -year) |>
  as_tibble()

d_fr_new <-
  left_join(
    as_tibble(d_fr),
    d_extant,
    by = join_by(census_tract_id_2020 == census_tract_id_2020)
  ) |>
  as_fr_tdr(.template = d_fr) |>
  update_field("score", description = "the score")

d_fr_new

S7::prop(d_fr_new, "schema")

