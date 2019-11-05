source("https://raw.githubusercontent.com/ITSLeeds/go/master/code/setup_function.R")
setup_R(pkgs = c("remotes",
                "sf",
                "tidyverse",
                "cyclestreets",
                "tmap",
                "pct",
                "stats19",
                "stplanr",
                "microbenchmark",
                "profvis",
                "dodgr",
                "geodist"),
        pkgs_gh = c("opentripplanner")
        ); rm(setup_R)