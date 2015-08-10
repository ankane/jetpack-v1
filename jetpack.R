# jetpack 0.1.0

packages <- c()
repos <- c()

package <- function(package) {
  packages <<- append(packages, package)
}

repo <- function(repo) {
  repos <<- append(repos, repo)
}

source("packages.R")

# https support
options(download.file.method="libcurl")

if (length(repos) == 0) {
  repo("https://cran.r-project.org/")
}

packing <- identical(sub(".*=", "", commandArgs()[4]), "jetpack.R")

for(package in packages) {
  if (is.element(package, installed.packages()[,1])) {
    if (packing) {
      cat(paste0("Using ", package, " ", packageVersion(package), "\n"))
    } else {
      library(package, quiet=TRUE, character.only=TRUE)
    }
  } else {
    if (packing) {
      cat(paste0("Installing ", package))
      install.packages(package, dependencies=TRUE, repos=repos, quiet=TRUE)
      cat(paste0(" ", packageVersion(package), "\n"))
    } else {
      cat(paste0("Package not installed: ", package, ". Try running:\nRscript jetpack.R\n"))
      quit(status = 1)
    }
  }
}

rm(packages, package, repos, repo, packing)
