# Settings - can be changed
source("https://github.com/ITSLeeds/go/releases/download/v0.4/setup_function.R")
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
                 "snakecase",
                 "sfnetworks",
                 "od"),
        pkgs_gh = c("nowosad/spDataLarge"),
        rversion = 4.0)
rm(setup_R)