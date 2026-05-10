**** Determinants of child mortality in Uganda******
** Survey-weighed logistics regression analysis***
* Data: Sample extracted from Uganda 2022 Demographic and Health Survey (DHS)
* Boro, Binya Benson Abe, FAU Erlangen-Nürnberg

clear all

* Set working directory
pwd
cd "/Users/benson/Desktop/econ_analysis/health_analysis"

* Set log file
log using "Stata/multivariate_analysis", text replace

* Load data
use "cleaned_data/dhsKR_cleaned.dta", replace

* View data
describe
codebook

* Recode/create variables

* Generate child_dead variable from survival variable
generate child_dead = (child_survived == 0)
label define deadlbl 0 "Alive" 1 "Dead"
label values child_dead deadlbl
tabulate child_dead, nolabel // verify recode

* recode source of drinking water to "Improved" and "Unimproved" categories
generate water_access = .

* Improved water sources
replace water_access = 1 if inlist(water_source, ///
11, 12, 13, 14, 21, 31, 41, 51, 61, 71, 91, 92)
 
 
 * Unimproved water sources
 
replace water_access = 0 if inlist(water_source, ///
32, 42, 81, 96)

* labels

label define waterlbl 0 "Unimproved" 1 "Improved"
label values water_access waterlbl

* Recode birth order to categories
generate birth_order_cat = .
replace birth_order_cat = 1 if birth_order == 1
replace birth_order_cat = 2 if inlist(birth_order, 2, 3)
replace birth_order_cat = 3 if birth_order >= 4

label define birth_lbl ///
1 "1st" ///
2 "2nd - 3rd" ///
3 "4th+"

label values birth_order_cat birth_lbl

* recode birth interval

recode birth_interval ///
    (0/23 = 1 "<24 months") ///
    (24/47 = 2 "24-47 months") ///
    (48/max = 3 "48+ months"), ///
    gen(birthint_cat)
	
* recode education
generate meduc2 = .

replace meduc2 = 0 if meduc == 0
replace meduc2 = 1 if meduc == 1
replace meduc2 = 2 if inlist(meduc, 2,3)

label define meduc2_lbl ///
0 "No education" ///
1 "Primary" ///
2 "Secondary+"
label values meduc2 meduc2_lbl

* Declare survey design
generate weight = sample_weight/1000000
rename psu_cluster cluster
rename sample_strata strata

svyset cluster [pw = weight], strata(strata) singleunit(centered)


* Survey-weighted logistic regression analysis

* Outcome variable: child_dead (1 = dead, 0 = alive)

eststo clear

* socioeconomic
eststo mod1: svy: logistic child_dead ///
i.meduc2 ///
i.wl_index ///
i.resid_type, or

* deemographic vars
eststo mod2: svy: logistic child_dead ///
i.meduc2 ///
i.wl_index ///
i.resid_type ///
i.birthint_cat ///
c.total_children ///
c.mage, or

* add environmental factors
eststo mod3: svy: logistic child_dead ///
i.meduc2 ///
i.wl_index ///
i.resid_type ///
i.birthint_cat ///
c.mage ///
c.total_children ///
i.water_access, or

* Export to word
esttab mod1 mod2 mod3 using "result/Table7_multivariate_table.rtf", ///
replace ///
eform ///
b(2) ///
ci(2) ///
label ///
title("Table 7: Survey-weighted logistic regression of child mortality determinants") ///
mtitles("Model 1" "Model 2" "Model 3") ///
star(* 0.10 ** 0.05 *** 0.01) ///
stats(N, fmt(0) labels("Observations")) ///
compress ///
nonotes


log close


