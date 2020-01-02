library(tidyverse)
library(lubridate)

start <- as.Date("2020-01-01")
end <- as.Date("2020-05-08")

date <- seq(start,end,by = "days")

d <- as.data.frame(date) %>% 
  mutate(week = isoweek(date),
         nday = paste0("day",format(date, "%u")),
         long = format(date, "%A, %B %d"))

dw <- d %>% 
  pivot_wider(id_cols = "week", names_from = "nday", values_from = "long") %>%
  select(sort(names(.))) %>% 
  select(week,everything())


w <- d %>% 
  group_by(week) %>% 
  summarise(min = min(date),
            max = max(date)) %>% 
  mutate(lmin = format(min, "%B %d"),
         lmax = format(max, "%B %d")) %>% 
  mutate(mmin = str_pad(month(min),2,pad="0"),
         dmin = str_pad(day(min),2,pad="0"),
         mmax = str_pad(month(max),2,pad="0"),
         dmax = str_pad(day(max),2,pad="0"))

dat <- dw %>% 
  left_join(w) %>% 
  select(-c(min,max))

write.csv(dat, here::here("data","cal.csv"), row.names = F)

