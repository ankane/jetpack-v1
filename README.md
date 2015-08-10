# Jetpack

:fire: Simple package management for R

- specify all your packages in one place
- install them with a single command
- include them all at once - no need for `library` calls

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

Instead of including packages individually, add the following to the start of your scripts

```R
source("jetpack.R")
```

You can remove any `library` calls.

### Adding New Packages

Add the package to `packages.R`

```R
package("inTrees")
```

and run

```sh
Rscript jetpack.R
```

That’s all there is to it!

### A Few Notes

Jetpack is simple.

- No additional dependency resolution
- Libraries are installed globally
- Versioning is not supported

For more advanced projects, check out

- [Packrat](https://rstudio.github.io/packrat/)
- [rbundler](https://github.com/opower/rbundler)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/jetpack/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/jetpack/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
