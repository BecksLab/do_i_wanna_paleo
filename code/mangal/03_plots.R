library(tidyverse)

df <- read.csv("data/processed/mangal_summary.csv") %>% 
    pivot_longer(!id,
                names_to = "statistic",
                values_to = "val")

ggplot(df, aes(val)) +
    geom_density() +
    facet_wrap(vars(statistic),
                scales = "free") +
    theme_classic()