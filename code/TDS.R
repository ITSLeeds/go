# Settings - can be changed
source("https://github.com/ITSLeeds/go/releases/download/v0.3/setup_function.R")
setup_R(pkgs = c("sf",
                 "tidyverse",
                 "tmap",
                 "pct",
                 "stats19",
                 "stplanr",
                 "dodgr",
                 "geodist",
                 "opentripplanner",
                 "igraph",
                 "snakecase"),
        pkgs_gh = c("ropensci/osmextract",
                    "luukvdmeer/sfnetworks@v0.4.1"))
rm(setup_R)