library(tidyverse)
library(tidycensus)

# get crosswalk of all FIPS codes
fips_codes <- tidycensus::fips_codes %>% 
  mutate(combined_code = paste0(state_code,county_code))


process 


# 
