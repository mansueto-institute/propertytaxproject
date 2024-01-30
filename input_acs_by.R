# SET UP -------------------------------------

# renv::install("tidycensus")
# request census API key: https://api.census.gov/data/key_signup.html
# save census key as environmental variable in .env file
readRenviron(".env")
KEY = Sys.getenv("CENSUS_API_KEY")

# PULL RELEVANT CENSUS DATA -------------------

library(tidycensus)
library(tidyverse)
tidycensus::census_api_key(key=KEY, install=TRUE, overwrite=TRUE)

# explore what tables are available
# v20 <- tidycensus::load_variables(2020, "acs5", cache = TRUE)

import_acs_by = function(geography="msa", state=NA, year=2020, 
                         write_to_csv=TRUE, dir="data"){

  #list of census tables to pull
  VARS <- c("B02001_001", # total population
            "B02001_002", # white only population
            "B17001_001", # poverty status in past 12 months
            "B25007_002", # tenure by age of householder (owner occupied)
            "B25007_001", # tenure by age of householder (total)
            "B15003_001", # educational attainment for population 25+ (total)
            "B19301_001", # per-capita income in past 12 months in 2020 inflation-adjusted $
            "B01002_001", # median age by sex (total)
            "B25077_001", # median home value (dollars)
            "B01001H_001", # white alone (not hispanic or latino)
            "B25002_003", # occupancy status (vacant)
            "B25002_001", # occupancy status (total)
            "B25024_001", # total units in structure
            "B25024_002", # single units - detached
            "B25024_003", # single units - attached
            "B07001_017", # total in same house 1 year ago
            "B07011_001E", # median household income
            paste0("B15003_0",17:25) #educational attainment for pop 25+ (segmented by level)
  )
  
  # get acs tables based on geography input
  if(geography == "county"){
    table <- tidycensus::get_acs(geography = geography,
                                 state = state,
                                 variables = VARS,
                                 year = year
    )
    filepath = paste0(dir, "/", geography, "_", state, "_", year,".csv")
  } else if(geography == "msa") {
    geography <- "metropolitan statistical area/micropolitan statistical area"
    table <- tidycensus::get_acs(geography = geography,
                                 variables = VARS,
                                 year = year
    )
    filepath = paste0(dir, "/msa_", year, ".csv")
  } else {
    stop("ValueError: geography is not 'county' or 'msa'")
  }
  
  # write to csv in correct directory based on inputs
  if(write_to_csv == TRUE & file.exists(dir)){
    write_csv(table, filepath)
  } else if(write_to_csv == TRUE) {
    dir.create(dir)
    write_csv(table, filepath)
  }
  
  return(table)
}


# example calls
table1 = import_acs_by(geography="county", state="17")
table2 = import_acs_by(geography="msa")








