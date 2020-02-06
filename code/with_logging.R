# Check for Variables
if(!exists("pkgs")){
  pkgs <- NULL
}

if(!exists("pkgs_gh")){
  pkgs_gh <- NULL
}

if(!exists("rversion")){
  rversion <- 3.4
}

if(!exists("ram_warn")){
  ram_warn <- 4000
}

# Download and Run
# utils::download.file(url = url_use,
#               destfile = file.path(dir_use,"ITSgo.zip"),
#               quiet = TRUE)
# utils::unzip(file.path(dir_use,"ITSgo.zip"),
#              exdir = file.path(dir_use))
#source(file.path(dir_use,tag,"code","setup_function.R"))
source("https://github.com/ITSLeeds/go/releases/download/v0.2/setup_function.R")
setup_R(pkgs = pkgs,
        pkgs_gh = pkgs_gh,
        rversion = rversion,
        ram_warn = ram_warn)

# file.remove(file.path(dir_use,"ITSgo.zip"))
# unlink(file.path(dir_use,tag), recursive = TRUE)
#rm(setup_R, url_use, tag, dir_use, pkgs, pkgs_gh, rversion, ram_warn)
rm(setup_R, pkgs, pkgs_gh, rversion, ram_warn)
