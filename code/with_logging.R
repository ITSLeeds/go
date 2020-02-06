# Check for Variables
if(!exists(pkgs_gh)){
  pkgs_gh <- NULL
}

if(!exists(rversion)){
  rversion <- 3.4
}

if(!exists(ram_warn)){
  ram_warn <- 4000
}

if(!exists(dir)){
  dir_use <- tempdir()
}

if(!exists(url)){
  url <- "https://github.com/ITSLeeds/go/archive/v0.2.zip"
}

if(!exists(tag)){
  tag <- "go-0.2"
}
# Download and Run
utils::download.file(url = url,
              destfile = file.path(dir_use,"ITSgo.zip"),
              quiet = TRUE)
utils::unzip(file.path(dir_use,"ITSgo.zip"),
             exdir = file.path(dir_use))
source(file.path(dir_use,tag,"code","setup_function.R"))
setup_R(pkgs = pkgs,
        pkgs_gh = pkgs_gh,
        rversion = rversion,
        ram_warn = ram_warn)

file.remove(file.path(dir_use,"ITSgo.zip"))
unlink(file.path(dir_use,tag), recursive = TRUE)
rm(setup_R, url, tag, dir_use, pkgs, pkgs_gh, rversion, ram_warn)