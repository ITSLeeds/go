dir <- tempdir()
url <- "https://github.com/ITSLeeds/go/archive/v0.1.zip"
tag <- "go-0.1"
utils::download.file(url = url,
              destfile = file.path(dir,"ITSgo.zip"),
              quiet = TRUE)
utils::unzip(file.path(dir,"ITSgo.zip"),
             exdir = file.path(dir))
source(file.path(dir,tag,"code","setup_function2.R"))
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
unlink(file.path(dir,tag), recursive = TRUE)
rm(setup_R, url, tag, dir)