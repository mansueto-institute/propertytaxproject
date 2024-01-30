library(tidyverse)
library(tidycensus)
library(cmfproperty)

# get crosswalk of all FIPS codes
fips_codes <- tidycensus::fips_codes %>% 
  mutate(combined_code = paste0(state_code,county_code))

#inputs 
geography = "county"
data_dir = "data/"
fips = "01001"
output_dir = "output/2020"


generate_report_for <- function(geography, fips, data_dir, output_dir){
  
  fip_info <- fips_codes %>% 
    filter(combined_code == fips)
  
  csv_file = list.files("data/",pattern=fips)
  filepath = paste0(data_dir, "/", csv_file)
  prop_data = read_csv(filepath)
  
  name = paste(fip_info['county'], ",", fip_info['state_name'])
  
  ratios <-
    cmfproperty::reformat_data(
      prop_data,
      sale_col = "SaleAmt",
      assessment_col = "AssdTotalValue",
      sale_year_col = "AssdYear",
    )
  
  if (file.exists(output_dir)){
    #nothing
  } else {
    dir.create(output_dir)
  }
  
  output_filepath = paste0(output_dir, "/", geography, "/", fips)
  dir.create(output_filepath)
  
  # create report
  cmfproperty::make_report(ratios, 
                           jurisdiction_name = name,
                           output_dir = paste0(getwd(), "/", output_filepath))
  
}

generate_report_for("county", "01001", "data", "output/2020")


