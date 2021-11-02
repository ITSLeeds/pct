## Changes

- Submission after it was taken down due to dependency on stplanr which was taken down without warning.
- Some vignettes no longer evaluate, which should save resources on CRAN, all URLs that were out of date have been updated and work according to check on Win-Build: https://win-builder.r-project.org/A60935OuuntU/

## Test environments
* local Ubuntu 20.04 install, R 4.1.1
* Ubuntu (other versions and various R releases), GH Actions
* Windows, GH Actions
* Mac, GH Actions
* cyclestreets dependency requires an API, so some tests will be skipped if not provided.

## R CMD check results
There were no ERRORs or WARNINGs. 

