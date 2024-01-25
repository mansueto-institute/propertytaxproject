# ENV SET UP -----------------------------------------------
# install.packages("renv")
# renv::init()

# renv::install("devtools")
# renv::install("tidyverse")
# devtools::install_github("cmf-uchicago/cmfproperty")

# renv::snapshot()

# DUMMY PROJECT --------------------------------------------


library(cmfproperty)
library(tidyverse)

df <- cmfproperty::example_data
# contains PIN, SALE_YEAR, SALE_PRICE, ASSESSED_VALUE for 2015-2019

# example file structure
write_csv(df, "input_data/IL_031/2015-2019.csv")

#read in each data set from file structure
df <- read_csv("input_data/IL_031/2015-2019.csv")

#compute small data cleaning, transformations
ratios <-
  cmfproperty::reformat_data(
    df,
    sale_col = "SALE_PRICE",
    assessment_col = "ASSESSED_VALUE",
    sale_year_col = "SALE_YEAR",
  )
# ADDS: TAX_YEAR (XXXX), RATIO (0-1), arms_length_transaction (bool), 
  # SALE_PRICE_ADJ, and ASSESSED_VALUE_ADJ

# create report
cmfproperty::make_report(ratios, 
                         jurisdiction_name = "Cook County, Illinois",
                         output_dir = paste0(getwd(),"/output_reports/IL_031")) 


