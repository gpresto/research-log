library(tidyverse)
library(lubridate)

dat <- read.csv(here::here("data","cal.csv"),
                colClasses = c(mmin = "character",dmin = "character",mmax = "character",dmax = "character"))

week <- dat$week

reports <- tibble(
  output_file = stringr::str_c("output/",dat$mmin,dat$dmin,"-",dat$mmax,dat$dmax,".Rmd"),
  params = map(week, ~list(week = .))
)

reports %>%
  pwalk(rmarkdown::render, input = here::here("R","02_demo-log.Rmd"))
