There are a few improvements in this release.

Most important from CRAN's perspective relates to failing gracefully.

I've updated the functions and examples so they fail gracefully without internet access.

The following shows tests passing on my computer with the internet turned off:

devtools::check()
ℹ Updating pct documentation
ℹ Loading pct
── Building ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── pct ──
Setting env vars:
• CFLAGS    : -Wall -pedantic -fdiagnostics-color=always
• CXXFLAGS  : -Wall -pedantic -fdiagnostics-color=always
• CXX11FLAGS: -Wall -pedantic -fdiagnostics-color=always
• CXX14FLAGS: -Wall -pedantic -fdiagnostics-color=always
• CXX17FLAGS: -Wall -pedantic -fdiagnostics-color=always
• CXX20FLAGS: -Wall -pedantic -fdiagnostics-color=always
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
── R CMD build ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
✔  checking for file ‘/home/robin/github/itsleeds/pct/DESCRIPTION’ ...
─  preparing ‘pct’:
✔  checking DESCRIPTION meta-information ...
─  installing the package to build vignettes
✔  creating vignettes (5.2s)
─  checking for LF line-endings in source and make files and shell scripts
─  checking for empty or unneeded directories
─  building ‘pct_0.9.9.tar.gz’
   
── Checking ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── pct ──
Setting env vars:
• _R_CHECK_CRAN_INCOMING_USE_ASPELL_: TRUE
• _R_CHECK_CRAN_INCOMING_REMOTE_    : FALSE
• _R_CHECK_CRAN_INCOMING_           : FALSE
• _R_CHECK_FORCE_SUGGESTS_          : FALSE
• NOT_CRAN                          : true
── R CMD check ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
─  using log directory ‘/tmp/RtmpMVD4cD/pct.Rcheck’
─  using R version 4.3.0 (2023-04-21)
─  using platform: x86_64-pc-linux-gnu (64-bit)
─  R was compiled by
       gcc (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0
       GNU Fortran (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0
─  running under: Ubuntu 22.04.2 LTS
─  using session charset: UTF-8
─  using options ‘--no-manual --as-cran’
✔  checking for file ‘pct/DESCRIPTION’
─  checking extension type ... Package
─  this is package ‘pct’ version ‘0.9.9’
─  package encoding: UTF-8
✔  checking package namespace information
─  checking package dependencies ...Warning: unable to access index for repository https://cloud.r-project.org/src/contrib:
     cannot open URL 'https://cloud.r-project.org/src/contrib/PACKAGES'
    OK
✔  checking if this is a source package ...
✔  checking if there is a namespace ...
✔  checking for executable files (378ms)
✔  checking for hidden files and directories ...
✔  checking for portable file names
✔  checking for sufficient/correct file permissions
✔  checking whether package ‘pct’ can be installed (2.2s)
✔  checking installed package size ...
✔  checking package directory
N  checking for future file timestamps ...
   unable to verify current time
✔  checking ‘build’ directory
✔  checking DESCRIPTION meta-information ...
✔  checking top-level files
✔  checking for left-over files
✔  checking index information ...
✔  checking package subdirectories ...
✔  checking R files for non-ASCII characters ...
✔  checking R files for syntax errors ...
✔  checking whether the package can be loaded ...
✔  checking whether the package can be loaded with stated dependencies ...
✔  checking whether the package can be unloaded cleanly ...
✔  checking whether the namespace can be loaded with stated dependencies ...
✔  checking whether the namespace can be unloaded cleanly ...
✔  checking loading without being on the library search path ...
✔  checking dependencies in R code (1.2s)
✔  checking S3 generic/method consistency ...
✔  checking replacement functions ...
✔  checking foreign function calls ...
✔  checking R code for possible problems (3s)
✔  checking Rd files ...
✔  checking Rd metadata ...
✔  checking Rd line widths ...
✔  checking Rd cross-references ...
✔  checking for missing documentation entries ...
✔  checking for code/documentation mismatches (494ms)
✔  checking Rd \usage sections (496ms)
✔  checking Rd contents ...
✔  checking for unstated dependencies in examples ...
✔  checking contents of ‘data’ directory ...
✔  checking data for non-ASCII characters (467ms)
✔  checking LazyData
✔  checking data for ASCII and uncompressed saves ...
✔  checking installed files from ‘inst/doc’ ...
✔  checking files in ‘vignettes’ ...
✔  checking examples (3.9s)
✔  checking examples with --run-donttest (4.2s)
✔  checking for unstated dependencies in ‘tests’ ...
─  checking tests ...
─  Running ‘skip-heavy.R’
✔  Running ‘testthat.R’ (834ms)
✔  checking for unstated dependencies in vignettes ...
✔  checking package vignettes in ‘inst/doc’ ...
✔  checking re-building of vignette outputs (5.6s)
✔  checking for non-standard things in the check directory ...
✔  checking for detritus in the temp directory
   
   See
     ‘/tmp/RtmpMVD4cD/pct.Rcheck/00check.log’
   for details.
   
   
── R CMD check results ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── pct 0.9.9 ────
Duration: 28.9s

❯ checking for future file timestamps ... NOTE
  unable to verify current time

0 errors ✔ | 0 warnings ✔ | 1 note ✖

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
