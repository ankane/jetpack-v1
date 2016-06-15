# jetpack 0.1.2

jetpack.packages <- list()
jetpack.repos <- list()

package <- function(name, version = NULL, github = NULL, ref = NULL) {
  package <- list()
  package$name <- name
  package$github <- github
  package$version <- version
  package$ref <- ref
  jetpack.packages <<- c(jetpack.packages, list(package))
}

repo <- function(repo) {
  jetpack.repos <<- c(jetpack.repos, list(repo))
}

jetpack.propel <- function() {
  is.installed <- function(name) {
    is.element(name, installed.packages()[, 1])
  }

  install <- function(name, version = NULL, github = NULL, ref = NULL, dependencies = TRUE) {
    quiet <- nchar(Sys.getenv("VERBOSE")) == 0
    cat(paste0("Installing ", name, " "))
    if (!is.null(github)) {
      if (is.null(ref)) {
        ref <- "master"
      }
      cat(paste0("from ", github, " ", ref, " "))
      devtools::install_github(github, ref = ref, dependencies = dependencies, quiet = quiet)
    } else if (!is.null(version)) {
      tryCatch({
        devtools::install_version(name, version = version, dependencies = dependencies, repos = jetpack.repos, quiet = quiet, type = package.type())
      }, error = function (e) {
        if (length(grep("is invalid for package", e$message)) > 0) {
          devtools::install_version(name, version = gsub(".(\\d+)$", "-\\1", version), dependencies = dependencies, repos = jetpack.repos, quiet = quiet, type = package.type())
        } else {
          stop(e)
        }
      })
    } else {
      install.packages(name, dependencies = dependencies, repos = jetpack.repos, quiet = quiet)
    }
    if (is.installed(name)) {
      cat(paste0(packageVersion(name), "\n"))
    } else {
      quit(status = 1)
    }
  }

  uninstall <- function(name) {
    cat(paste0("Removing ", name, " ", packageVersion(name), "\n"))
    suppressMessages(remove.packages(name))
  }

  package.type <- function() {
    sysname <- unname(Sys.info()["sysname"])
    if (identical(sysname, "Darwin")) {
      c("mac.binary")
    } else {
      getOption("pkgType")
    }
  }

  find.package <- function(name) {
    for (package in jetpack.packages) {
      if (identical(package$name, name)) {
        return(package)
      }
    }
    NULL
  }

  if (!file.exists("packages.R")) {
    cat("Could not find packages.R\n")
    quit(status = 1)
  }
  source("packages.R")

  # https support
  options(download.file.method = "libcurl")

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
        quit(status = 1)
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

      if (!is.installed("devtools") || packageVersion("devtools") < "1.10.0") {
        install("devtools")
      }
      library(devtools)

      if (is.installed(name) && !is.null(version) && !identical(paste0(packageVersion(name)), version)) {
        uninstall(name)
      }

      if (is.installed(name)) {
        cat(paste0("Using ", name, " ", packageVersion(name), "\n"))
      } else {
        install(name, version = version, github = package$github, ref = package$ref)
      }
    } else {
      if (is.installed(name)) {
        suppressMessages(library(name, quiet = TRUE, character.only = TRUE))
      } else {
        cat(paste0("Package not installed: ", name, ". Try running:\nRscript jetpack.R\n"))
        quit(status = 1)
      }
    }
  }

  # second pass to correct versions
  for (package in packages) {
    name <- package$name
    version <- package$version

    if (!is.null(version) && !identical(paste0(packageVersion(name)), version)) {
      uninstall(name)
      install(name, version = version, github = package$github, ref = package$ref, dependencies = FALSE)
    }
  }
}

jetpack.propel()

rm(package, repo, jetpack.packages, jetpack.repos, jetpack.propel)
