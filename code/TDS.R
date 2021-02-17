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
                 "mapview",
                 "osmextract",
                 "nycflights13",
                 "snakecase"),
        pkgs_gh = c("luukvdmeer/sfnetworks@0.4.1",
                    "nowosad/spDataLarge",
                    "ITSLeeds/od",
                    "a-b-street/abstr"))
rm(setup_R)