Updated submission with fixed URLs

I'm not sure what was causing this url to fail, seems fine to me: 

https://www.statistics.digitalresources.jisc.ac.uk/dataset/wu03uk-2011-sms-merged-lala-location-usual-residence-and-place-work-method-travel-work-3

I've changed it to this, hope that fixes it: https://www.statistics.digitalresources.jisc.ac.uk/

## Test environments
* local Ubuntu 20.04 install, R 4.0.2
* Ubuntu (other versions and various R releases), GH Actions
* Windows, GH Actions
* Winbuild: https://win-builder.r-project.org/dC49Gns4r2ZX
* Mac, GH Actions
* cyclecstreets dependency requires an API, so some tests will be skipped if not provided.

## R CMD check results
There were no ERRORs or WARNINGs. 
