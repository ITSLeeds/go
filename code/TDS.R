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
        pkgs_gh = c("ITSleeds/osmextract",
                    "luukvdmeer/sfnetworks"))
rm(setup_R)