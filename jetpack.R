# jetpack 0.1.1

jetpack.packages <- list()
jetpack.repos <- list()

package <- function(name, github=NULL) {
  package <- list()
  package$name = name
  package$github = github
  jetpack.packages <<- c(jetpack.packages, list(package))
}

repo <- function(repo) {
  jetpack.repos <<- c(jetpack.repos, list(repo))
}

jetpack.propel <- function() {
  is.installed <- function(name) {
    return(is.element(name, installed.packages()[,1]))
  }

  install <- function(name) {
    install.packages(name, dependencies=TRUE, repos=jetpack.repos, quiet=TRUE)
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

    if (packing) {
      if (update) {
        if (is.installed(name)) {
          suppressMessages(remove.packages(name))
        }
      }

      if (is.installed(name)) {
        cat(paste0("Using ", name, " ", packageVersion(name), "\n"))
      } else {
        cat(paste0("Installing ", name, " "))
        github <- package$github
        if (!is.null(github)) {
          cat(paste0("from ", github, " "))
          if (!is.installed("devtools")) {
            install("devtools")
          }
          library(devtools)
          devtools::install_github(github, quiet=TRUE)
        } else {
          install(name)
        }
        cat(paste0(packageVersion(name), "\n"))
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
