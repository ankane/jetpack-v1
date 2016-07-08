# Jetpack

:fire: Simple package manager for R

Specify all your packages in one place

```R
package("plyr")
package("reshape2", "1.4.0")
package("forecast", github="robjhyndman/forecast")
```

Install them with a single command, and include them all at once - no need for `library` calls.

Jetpack is lightweight and uses a [secure CRAN mirror](https://cran.r-project.org/sources.html) by default.

## How to Use

Add Jetpack to your project

```sh
cd path/to/your/project
curl -LsO https://raw.github.com/ankane/jetpack/master/jetpack.R
```

Create `packages.R` and add your packages

```R
package("plyr")
package("reshape2", "1.4.0")
package("forecast", github="robjhyndman/forecast")
```

Install packages

```sh
Rscript jetpack.R
```

**Optional:** Instead of including packages individually, you can add these lines to the start of your scripts

```R
source("jetpack.R")
jetpack.require()
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

## Heroku

Create an `init.r` with:

```R
source("jetpack.R")
jetpack.install()
```

The first deploy can take a few minutes, but future deploys should be very fast.

[Buildpack docs](https://github.com/virtualstaticvoid/heroku-buildpack-r)

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

Update packages

```sh
Rscript jetpack.R update
```

Update a single package

```sh
Rscript jetpack.R update plyr
```

More verbosity

```sh
VERBOSE=1 Rscript jetpack.R
```

Specify a mirror in `packages.R` with

```sh
repo("https://cran.r-project.org/")
```

## Upgrading

To get the latest version, run

```sh
cd path/to/your/project
curl -LsO https://raw.github.com/ankane/jetpack/master/jetpack.R
```

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/jetpack/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/jetpack/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
