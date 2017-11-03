STOP

********************************************************************************

* UKHLS Single Unit ??

********************************************************************************

* Directory Structure:
* !!!Remember you will have to change these locations to match the locations 
* of these folders on your computer!!!

global data "E:/QS904/DATA/"
global temp "E:/QS904/TEMP/"
global work "E:/QS904/WORK/"
global code "E:/QS904/CODE/"

* N.B. 
* On a mac you need forward slashes
* On a windows machine you can use either forward or backward slashes.





* Open Wave 1 UKHLS

use $data/UKHLS/a_indresp, clear

keep pidp a_hidp a_paygu_dv a_dvage a_psu a_indinus_xw a_strata a_gor_dv

* Create a country variable:

capture drop a_country
recode a_gor_dv 1/9=1 10=2 11=3 12=4, gen(a_country)
lab define a_country 1 "england" 2 "wales" 3 "scotland" 4 "northern ireland", replace
lab values a_country a_country
tab a_gor_dv a_country, m

numlabel, add

quietly mvdecode _all, mv(-9/-1)



* Look at Northern Ireland

tab a_strata if (a_country == 4)

tab a_psu if (a_country == 4)

set more on, perm

list a_strata a_psu if (a_country==4), sepby(a_hidp)

* Everyone in Northern Ireland is in the same strata, but each household has
* its own psu.




* Naive mean of monthly pay:

mean a_paygu_dv


* Adjusted mean of monthly pay (no single unit specified):

svyset a_psu [pweight = a_indinus_xw], strata(a_strata)

svy: mean a_paygu_dv

* No standard errors estimated !?


egen n_psu = count(a_psu), by(a_strata)
sort n_psu
browse

tab n_psu if (a_country==4)




* Adjusted mean of monthly pay (single unit specified):

svyset a_psu [pweight = a_indinus_xw], strata(a_strata) singleunit(scaled)

svy: mean a_paygu_dv

















********************************************************************************
* EOF
