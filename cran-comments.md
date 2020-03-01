This version addresses issues with tests on Solaris, stops warning versions due to conversion between sp and sf objects and does not download files to HD for the get_pct_* functions, which I think were in breach of CRAN policy on Internet access.

## Test environments
* local Ubuntu install, R 3.6.2
* ubuntu 14.04 (on travis-ci)
* cyclecstreets dependency requires an API, so some tests will be skipped if not provided.

## R CMD check results
There were no ERRORs or WARNINGs. 
