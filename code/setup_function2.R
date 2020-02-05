setup_R <- function(rversion = 3.4,
                    pkgs = c("sf"),
                    pkgs_gh = c(),
                    ram_warn = 4000
){
  
  message("")
  message("")
  message("Welcome to Go: Easy set up for R courses from ITS")
  message("")
  message("This code will install packages and run tests to prepare your computer for an ITS Leeds R course")
  message("If this process is successful you will see the message 'You computer is ready for the ITS Leeds Course'")
  message("")
  
  yn <- function(){
    resp <- readline(prompt = "Do you wish to continue? [Y/n]  ")
    if(tolower(resp) %in% c("y","yes") | (nchar(resp) == 0)){
      # Continute
    } else if (tolower(resp) %in% c("n","no")){
      stop("User aborted process")
    } else {
      message(class(resp))
      stop("Unknown input aborting process")
    }
  }
  
  yn()
  
  message("")
  message("Before running this script, make sure you have closed all other R sessions and have no packages loaded")
  message("You can check that you have no packages loaded in RStudio by clicking Session > Restart R")
  message("You can then rerun this script")
  message("")
  
  yn()
  
  log <- " "
  
  message("Step 1 of 5: Pre Checks")
  pkgs <- unique(pkgs)
  pkgs_gh <- unique(pkgs_gh)
  
  if(any(pkgs_gh %in% pkgs)){
    stop("    Duplicated package names requested from CRAN and GitHub")
  }
  
  loaded_already <- loadedNamespaces()
  
  if(any(c(pkgs, pkgs_gh) %in% loadedNamespaces())){
    stop("    Some packages that need updating are loaded, please restart R and run the setup again")
  }
  
  
  message("Step 2 of 5: Check the basics")
  Rv <- as.numeric(R.version$major) + as.numeric(R.version$minor) / 10 
  if(Rv >= rversion){
    message("    PASS: R Version Check")
  }else{
    browseURL("https://cran.r-project.org/")
    stop("    Your version of R is not up to date, go to https://cran.r-project.org/ and download the latest version of R")
    
  }
  
  # We need remotes to install github packages
  if(length(pkgs_gh) > 0){
    if(!"remotes" %in% utils::installed.packages()[,"Package"]){
      utils::install.packages("remotes", quiet = TRUE)
    }
    
    if("remotes" %in% utils::installed.packages()[,"Package"]){
      message("    PASS: remotes is installed")
    }else{
      stop("    Unable to install remotes try running install.packages('remotes')")
    }
  }
  
  # Check for Rtools
  if (.Platform$OS.type == "windows") { 
    if(!"pkgbuild" %in% utils::installed.packages()[,"Package"]){
      utils::install.packages("pkgbuild", quiet = TRUE)
    }
    
    if("pkgbuild" %in% utils::installed.packages()[,"Package"]){
      message("    PASS: pkgbuild is installed")
    }else{
      stop("    Unable to install pkgbuild try running install.packages('pkgbuild')")
    }
  
    if(pkgbuild::find_rtools()){
      message("    PASS: RTools is installed")
    }else{
      if(length(pkgs_gh) > 0){
        browseURL("https://cran.r-project.org/bin/windows/Rtools/")
        stop("    You need to install RTools https://cran.r-project.org/bin/windows/Rtools/ and download the latest stable version")
      }else{
        log <- c(log, "WARN: You don't have RTools installed, but have not requested any packages that require it")
        message("    PASS: RTools is not required")
      }
    }
  }else{
    message("    PASS: RTools is not required on your OS")
  }
  
  # Check for RStudio
  if(rstudioapi::isAvailable()){
    message("    PASS: You are using RStudio") 
  }else{
    browseURL("https://www.rstudio.com/products/rstudio/download/")
    stop("    You are not using RStudio, ITS Courses require R Studio, please download and install from https://www.rstudio.com/products/rstudio/download/")
  }
  
  # Check RAM
  if (.Platform$OS.type == "windows") { 
    memfree <- utils::memory.limit()
  }else{
    memfree <- try(as.numeric(system("awk '/MemFree/ {print $2}' /proc/meminfo", intern=TRUE)) / 1024)
    if(class(memfree) == "try-error"){
      log <- c(log,paste0("WARN: RAM check failed, you may be on MAC please check you have at least ",ram_warn," MB of RAM"))
      memfree <- ram_warn + 1
    }
  }
  
  if(memfree < 1000){
    stop("    You have less than 1 GB of RAM your computer is not suitable for the course")
  }else if(memfree < ram_warn){
    log <- c(log, "    Your computer is low on RAM, consider bringing a better laptop to the course")
    message("    PASS: Your computer has just enough RAM to run the course")
  }else{
    message("    PASS: Plenty of RAM")
  }
  
  
  message("Step 3 of 5: Install Packages")
  
  # Install Packages CRAN
  if(length(pkgs) > 0){
    new.packages <- pkgs[!(pkgs %in% utils::installed.packages()[,"Package"])]
    if(length(new.packages) > 0){
      message("    Installing ",length(new.packages)," packages")
      utils::install.packages(new.packages, verbose = FALSE, quiet = TRUE)
    } 
    
    if(all(pkgs %in% utils::installed.packages()[,"Package"])){
      message("    PASS: All CRAN packages installed")
    }else{
      warning(paste0("    Missing packages: ",paste(pkgs[!pkgs %in% utils::installed.packages()[,"Package"]]), collapse = ", "))
      stop("    Some CRAN packages did not install sucessfully")
    }
  }else{
    message("    PASS: No CRAN packages were requested")
  }
  message("    Updating any out of date packages")
  update.packages(oldPkgs = pkgs, ask = FALSE, quiet = TRUE)
  
  # Install Packages Github
  if(length(pkgs_gh) > 0){
    for(i in seq(1, length(pkgs_gh))){
      remotes::install_github(pkgs_gh[i], quiet = TRUE)
    }
    
    if(all(pkgs_gh %in% utils::installed.packages()[,"Package"])){
      message("    PASS: All GitHub packages installed")
    }else{
      warning(paste0("    Missing packages: ",paste(pkgs_gh[!pkgs_gh %in% utils::installed.packages()[,"Package"]]), collapse = ", "))
      stop("    Some GitHub packages did not install sucessfully")
    }
  }else{
    message("    PASS: No GitHub packages were requested")
  }
  
  # Check Geocomputation
  message("Step 4 of 5: Test geocomputation")
  
  # pct package
  if(all(c("sf","pct") %in% utils::installed.packages()[,"Package"] )){
    zones_all <- suppressWarnings(suppressMessages(try(pct::get_pct_zones("isle-of-wight"), silent = TRUE)))
    lines_all <- try(pct::get_pct_lines("isle-of-wight"), silent = TRUE)
    
    if(!"sf" %in% class(zones_all) | !"sf" %in% class(lines_all)){
      stop("Failed to get data from the pct package")
    }else{
      message("    PASS: Got data from the pct package")
    }
    
    plot(zones_all$geometry, main = "Test plot of desire lines on the Isle of Wight")
    plot(lines_all$geometry[lines_all$all > 300], col = "red", add = TRUE)
    
    message("    PASS: Basic Plotting")
  }else{
    message("    SKIP: pct package not tested")
  }
  
  # Cyclestreet package
  if(all(c("cyclestreets") %in% utils::installed.packages()[,"Package"] )){
    if(nchar(Sys.getenv("CYCLESTREETS")) > 0){
      message("    PASS: Cyclestreets key found")
    }else{
      log <- c(log,"WARN: The cyclestreets package requires an API key, please sign up for one at https://www.cyclestreets.net/api/ then add it to your R environ file")
      message("    WARN: No cyclestreets API key found.")
    }
  }else{
    message("    SKIP: cyclestreets package not tested")
  }
  
  
  # Unload the packages
  message("Step 5 of 5: Cleaning up")
  unload <- function(loaded_already, mode = "up"){
    pkgs_unload <- loadedNamespaces()
    pkgs_unload <- pkgs_unload[!pkgs_unload %in% loaded_already]
    
    
    if(length(pkgs_unload) > 1){
      if(mode == "down"){
        pkgs_unload <- pkgs_unload[length(pkgs_unload):1]
      } else if(mode == "random"){
        pkgs_unload <- pkgs_unload[sample(1:length(pkgs_unload))]
      }
      
      for(i in pkgs_unload){
        foo <- suppressWarnings(try(unloadNamespace(i), silent = TRUE))
      }
    }
  }
  
  # Won't do all first time so try multiple times
  unload(loaded_already, "down")
  unload(loaded_already, "up")
  for(i in 1:50){
    unload(loaded_already, "random")
  }
  
  
  # Report Results
  message(" ")
  message(" ")
  message("##############################################")
  message("You computer is ready for the ITS Leeds Course")  
  message("##############################################")
  
  for(i in seq(1, length(log))){
    message(log[i])
    message("______________")
  }
  
  
}

