setup_R <- function(rversion = 4.0,
                    pkgs = c("sf"),
                    pkgs_gh = NULL,
                    ram_warn = 4000
){
  
  
  responce <- askYesNo(paste0("Welcome to Go: Easy set up for R courses from ITS \n",
                  "\n",
                  "This code will install packages and run tests to prepare your computer for an ITS Leeds R course. ",
                  "If this process is successful you will see the message: \n",
                  "\n",
                  "'You computer is ready for the ITS Leeds Course'\n",
                  "\n",
                  "Do you wish to begin?"))
  
  if(is.na(responce)){
    responce <- FALSE
  }
  
  if(!responce){
    stop("Process aborted by user")
  }
  
  responce <- askYesNo(paste0("Before running this script, make sure you have closed all other R sessions and have no packages loaded \n",
                              "\n",
                              "You can check that you have no packages loaded in RStudio by clicking Session > Restart R \n",
                              "You can then rerun this script"))
  
  if(is.na(responce)){
    responce <- FALSE
  }
  
  if(!responce){
    stop("Process aborted by user")
  }
  
  log <- " "
  
  message("Step 1 of 5: Pre Checks")
  pkgs <- unique(pkgs)
  pkgs_gh <- unique(pkgs_gh)
  
  if(length(pkgs_gh) > 0){
    pkgs_gh_nm = strsplit(pkgs_gh, "/")
    pkgs_gh_nm = sapply(pkgs_gh_nm, function(x){
      x[length(x)]
    })
    pkgs_gh_nm = strsplit(pkgs_gh_nm, "@")
    pkgs_gh_nm = sapply(pkgs_gh_nm, function(x){
      x[1]
    })
  } else {
    pkgs_gh_nm = NULL
  }
  
  
  if(any(pkgs_gh_nm %in% pkgs)){
    stop("Duplicated packages requested from CRAN and GitHub")
  }
  
  loaded_already <- loadedNamespaces()
  
  if(any(c(pkgs, pkgs_gh_nm) %in% loadedNamespaces())){
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
  
  # Check for Rlang
  if(!"rlang" %in% utils::installed.packages()[,"Package"]){
    utils::install.packages("rlang", quiet = TRUE)
  }
  
  if("rlang" %in% utils::installed.packages()[,"Package"]){
    message("    PASS: rlang is installed")
  }else{
    stop("    Unable to install rlang try running install.packages('rlang')")
  }
  
  # Check for RStudio
  if(!"rstudioapi" %in% utils::installed.packages()[,"Package"]){
    utils::install.packages("rstudioapi", quiet = TRUE)
  }
  
  if("rstudioapi" %in% utils::installed.packages()[,"Package"]){
    message("    PASS: rstudioapi is installed")
  }else{
    stop("    Unable to install rstudioapi try running install.packages('rstudioapi')")
  }
  
  if(rstudioapi::isAvailable()){
    message("    PASS: You are using RStudio") 
  }else{
    browseURL("https://www.rstudio.com/products/rstudio/download/")
    message("    WARN: You are not using RStudio, ITS Courses recommend R Studio, please download and install from https://www.rstudio.com/products/rstudio/download/")
  }
  
  # Check RAM
  get_os <- function(){
    sysinf <- Sys.info()
    if (!is.null(sysinf)){
      os <- sysinf['sysname']
      if (os == 'Darwin')
        os <- "osx"
    } else { ## mystery machine
      os <- .Platform$OS.type
      if (grepl("^darwin", R.version$os))
        os <- "osx"
      if (grepl("linux-gnu", R.version$os))
        os <- "linux"
    }
    tolower(os)
  }
  
  os <- get_os()
  if(os == "windows"){
    memfree <- try(as.numeric(system("wmic ComputerSystem get TotalPhysicalMemory", intern=TRUE)[2]) / (1024^2))
    if(class(memfree) == "try-error"){
      log <- c(log,paste0("WARN: RAM check failed, please check you have at least ",ram_warn," MB of RAM"))
      memfree <- ram_warn + 1
    }
    if(is.na(memfree)){
      log <- c(log,paste0("WARN: RAM check failed, please check you have at least ",ram_warn," MB of RAM"))
      memfree <- ram_warn + 1
    }
  } else if (os == "linux") {
    memfree <- try(as.numeric(system("awk '/MemFree/ {print $2}' /proc/meminfo", intern=TRUE)) / 1024)
    if(class(memfree) == "try-error"){
      log <- c(log,paste0("WARN: RAM check failed, please check you have at least ",ram_warn," MB of RAM"))
      memfree <- ram_warn + 1
    }
  } else {
    log <- c(log,paste0("WARN: RAM check failed, you may be on MAC please check you have at least ",ram_warn," MB of RAM"))
    memfree <- ram_warn + 1
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
  utils::update.packages(oldPkgs = pkgs, ask = FALSE, quiet = TRUE)
  
  # Install Packages Github
  if(length(pkgs_gh) > 0){
    for(i in seq(1, length(pkgs_gh))){
      remotes::install_github(pkgs_gh[i], quiet = TRUE, upgrade = "always")
    }
    
    if(all(pkgs_gh_nm %in% utils::installed.packages()[,"Package"])){
      message("    PASS: All GitHub packages installed")
    }else{
      warning(paste0("    Missing packages: ",paste(pkgs_gh_nm[!pkgs_gh_nm %in% utils::installed.packages()[,"Package"]]), collapse = ", "))
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
  if(all(c("cyclestreets") %in% utils::installed.packages()[,"Package"]  & 
         ("cyclestreets" %in% pkgs) )){
    if(nchar(Sys.getenv("CYCLESTREETS")) > 0){
      message("    PASS: Cyclestreets key found")
    }else{
      log <- c(log,"WARN: The cyclestreets package requires an API key, please sign up for one at https://www.cyclestreets.net/api/ then add it to your R environ file")
      message("    WARN: No cyclestreets API key found.")
    }
  }else{
    message("    SKIP: cyclestreets package not tested")
  }
  
  # opentripplanner package
  if("opentripplanner" %in% utils::installed.packages()[,"Package"]){
    java_version <- try(system2("java", "-version", stdout = TRUE, stderr = TRUE))
    if (class(java_version) == "try-error") {
      message("    WARN: Unable to detect a version of Java, to run a local version of OpenTripPlanner requires Java 8")
      log <- c(log,"WARN: You may not have the correct version of Java installed to use OpenTripPlanner locally")
      } else {
      java_version <- java_version[1]
      java_version <- strsplit(java_version, "\"")[[1]][2]
      java_version <- strsplit(java_version, "\\.")[[1]][1:2]
      java_version <- as.numeric(paste0(java_version[1], ".", java_version[2]))
      if (is.na(java_version)) {
        message("    WARN: Unable to detect a version of Java, to run a local version of OpenTripPlanner requires Java 8")
        log <- c(log,"WARN: You may not have the correct version of Java installed to use OpenTripPlanner locally")
      } else if (java_version < 1.8 | java_version >= 1.9) {
        message("    WARN: To run a local version of OpenTripPlanner requires Java 1.8, you have version ",java_version)
        log <- c(log,"WARN: You may not have the correct version of Java installed to use OpenTripPlanner locally")
      } else{
        message("    PASS: You have the correct version of Java for OpenTripPlanner")
      }
    }
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
  for(i in 1:500){
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

