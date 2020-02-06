source("https://raw.githubusercontent.com/ITSLeeds/go/master/code/setup_function2.R")
setup_R(pkgs = c("sf",
                "tidyverse",
                "cyclestreets",
                "tmap",
                "pct",
                "stats19",
                "stplanr",
                "dodgr",
                "geodist",
                "opentripplanner"),
        pkgs_gh = c("ITSleeds/geofabrik")
        )
rm(setup_R)
