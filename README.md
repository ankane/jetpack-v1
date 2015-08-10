# Jetpack

:fire: Simple package management for R

Specify all your packages in one place

```R
package("plyr")
package("reshape2")
```

Install them with a single command, and include them all at once - no need for `library` calls.

Jetpack is lightweight - under 50 lines of code - and uses a [secure CRAN mirror](https://cran.r-project.org/sources.html) by default.

## How to Use

Add Jetpack to your project

```sh
cd path/to/your/project
curl -LsO https://raw.github.com/ankane/jetpack/master/jetpack.R
```

Create `packages.R` and add your packages

```R
package("plyr")
package("reshape2")
```

Install packages

```sh
Rscript jetpack.R
```

**Optional:** Instead of including packages individually, you can add this line to the start of your scripts

```R
source("jetpack.R")
```

## Adding New Packages

Add the package to `packages.R`

```R
package("inTrees")
```

and run

```sh
Rscript jetpack.R
```

That’s all there is to it!

## A Few Notes

Be sure to check `jetpack.R` and `packages.R` into version control.

If deploying your project, you can run `Rscript jetpack.R` on every deploy to keep your servers up-to-date. This command is extremely fast if all packages are installed.

## More Notes

Jetpack is simple.

- No additional dependency resolution
- Libraries are installed globally
- Versioning is not supported

For more advanced projects, check out

- [Packrat](https://rstudio.github.io/packrat/)
- [rbundler](https://github.com/opower/rbundler)

## Reference

Specify a mirror in `packages.R` with

```sh
repo("https://cran.r-project.org/")
```

## Upgrading

Run

```sh
cd path/to/your/project
curl -LsO https://raw.github.com/ankane/jetpack/master/jetpack.R
```

## TODO

- Support packages from Github and other sources

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/jetpack/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/jetpack/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
