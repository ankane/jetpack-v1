# jetpack 0.1.1

jetpack.packages <- list()
jetpack.repos <- list()

package <- function(name, version=NULL, github=NULL) {
  package <- list()
  package$name = name
  package$github = github
  package$version = version
  jetpack.packages <<- c(jetpack.packages, list(package))
}

repo <- function(repo) {
  jetpack.repos <<- c(jetpack.repos, list(repo))
}

jetpack.propel <- function() {
  is.installed <- function(name) {
    return(is.element(name, installed.packages()[,1]))
  }

  install <- function(name, version=NULL, github=NULL) {
    cat(paste0("Installing ", name, " "))
    if (!is.null(github)) {
      cat(paste0("from ", github, " "))
      devtools::install_github(github, quiet=TRUE)
    } else if (!is.null(version)) {
      install_version(name, version=version, dependencies=TRUE, repos=jetpack.repos, quiet=TRUE, type=packageType())
    } else {
      install.packages(name, dependencies=TRUE, repos=jetpack.repos, quiet=TRUE)
    }
    if (is.installed(name)) {
      cat(paste0(packageVersion(name), "\n"))
    } else {
      quit(status=1)
    }
  }

  uninstall <- function(name) {
    cat(paste0("Removing ", name, " ", packageVersion(name), "\n"))
    suppressMessages(remove.packages(name))
  }

  packageType <- function() {
    sysname <- unname(Sys.info()["sysname"])
    if(identical(sysname, "Darwin")) {
      return(c("mac.binary"))
    } else {
      return(getOption("pkgType"))
    }
  }

  find.package <- function(name) {
    for (package in jetpack.packages) {
      if (identical(package$name, name)) {
        return(package)
      }
    }
    return(NULL)
  }

  if (!file.exists("packages.R")) {
    cat("Could not find packages.R\n")
    quit(status=1)
  }
  source("packages.R")

  # https support
  options(download.file.method="libcurl")

  if (length(jetpack.repos) == 0) {
    repo("https://cran.r-project.org/")
  }

  packages <- jetpack.packages
  packing <- identical(sub(".*=", "", commandArgs()[4]), "jetpack.R")

  if (packing) {
    update <- identical(commandArgs()[6], "update")
    update.name <- commandArgs()[7]

    if (update && !is.na(update.name)) {
      package <- find.package(update.name)
      if (is.null(package)) {
        cat(paste0("Unknown package: ", update.name, "\n"))
        quit(status=1)
      }
      packages <- list(package)
    }
  }

  for (package in packages) {
    name <- package$name
    version <- package$version

    if (packing) {
      if (update) {
        if (is.installed(name)) {
          uninstall(name)
        }
      }

      if (!is.installed("devtools")) {
        install("devtools")
      }
      library(devtools)

      if (is.installed(name) && !is.null(version) && !identical(paste0(packageVersion(name)), version)) {
        uninstall(name)
      }

      if (is.installed(name)) {
        cat(paste0("Using ", name, " ", packageVersion(name), "\n"))
      } else {
        install(name, version=version, github=package$github)
      }
    } else {
      if (is.installed(name)) {
        suppressMessages(library(name, quiet=TRUE, character.only=TRUE))
      } else {
        cat(paste0("Package not installed: ", name, ". Try running:\nRscript jetpack.R\n"))
        quit(status=1)
      }
    }
  }
}

jetpack.propel()

rm(package, repo, jetpack.packages, jetpack.repos, jetpack.propel)
