## Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

library (ini)
library(stringr)
library(dplyr)


rm(list = ls())

shaper <- function(db){
  colnames(db) <- c("Record","editor_formid","model")
  db_shaped <- db %>%
    mutate(
      editorid = str_remove(editor_formid, "\\[STAT:.*\\]"), 
      formid = str_extract(editor_formid, "(?<=STAT:)[^\\]]+"),
      .keep = "unused"
    )
    return(db_shaped)
}



db_skyrim <- read.csv(".\\Resources\\dbs\\db_STAT_skyrim.esm_v1.csv", sep =";")


db_skyrim_shaped <- shaper(db_skyrim)



db_skyrim_filt <- db_skyrim_shaped %>%
  filter(
    # Keep only Nordic and Cave walls
    str_detect(editorid, "(?i)^(Nor|CaveG|Dwe)"),
    
    # Keep only standard 1-4 way pieces
    str_detect(editorid, "(?i)[1-4]way|Boulder"),
    
  ) %>%
  # Get one example per model type
  distinct(model, .keep_all = TRUE) %>%
  # Sort by name for consistency
  arrange(editorid)

## write ini
formlist_content <- paste0(
  "FormList = _TF_WallList|",  # Base string with prefix
  paste(db_skyrim_filt$editorid, collapse = ",")  # Join all editorids with commas
)


ini_file_path <- ".\\TF_FLM.ini"

dir.create(dirname(ini_file_path), showWarnings = FALSE)

writeLines(formlist_content, ini_file_path)


## Dawnguard is not necessary

# db_dawnguard <- read.csv(".\\Resources\\dbs\\db_STAT_dawnguard.esm_v1.csv", sep =";")

# db_dawnguard_shaped <- shaper(db_dawnguard)



# db_dragonborn <- read.csv(".\\Resources\\dbs\\db_STAT_dragonborn.esm_v1.csv", sep =";")


# db_dragonborn_shaped <- shaper(db_dragonborn)
