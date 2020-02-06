dir <- tempdir()
utils::download.file(url = "https://github.com/ITSLeeds/go/archive/v0.1.zip",
              destfile = file.path(dir,"ITSgo.zip"),
              quiet = TRUE)
utils::unzip(file.path(dir,"ITSgo.zip"))
source(file.path(dir,"ITSgo","code","setup_function2.R"))
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

file.remove(file.path(dir,"ITSgo.zip"))
unlink(file.path(dir,"ITSgo"), recursive = TRUE)
rm(setup_R)
rm(dir)