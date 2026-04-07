******Analysis of child mortality in Uganda******
****Data Cleaning***

pwd // check current working directory

cd "/Users/benson/Desktop/econ_analysis/health_analysis" // Sets a working directory 

log using "output/dt_cleaning", text replace // Creates a log file

*** Load the dataset
use "data/dhs_raw_extrac.dta", clear

browse // Quick view of the dataset
describe // Check dataset size and variable descriptions
* The dataset has 3609 observations and 17 variables. There is a need to rename the variables, clean sentinel codes, recode some observations, and create rename lables.

drop birth_slot // The birth_slot variable does not exist in the original DHS data file. It was created during the data extraction phase to ease reshaping and merging.


*** Rename the variables to meaningful names
rename v001 cluster_no
rename v002 hs_no
rename v003 Resp_line
rename child_sex gender
rename birth_order birthr
rename v025 location
rename v190 wealth_index
rename v113 water_source
rename v012 mage
rename v106 meduc


*** Change variable labels
label variable child_alive "Child is Alive"
label variable gender "Gender"
label variable birthr "Birth Order"
label variable bweight "Birth Weight(in grams)"
label variable ch_discarge "Child Health Checked Before Discharge"
label variable ch_residence "Child'Lives With Whom?"
label variable location "location"
label variable mage "Mother's current age"
label variable meduc "Mother's Level of Education"
label variable wealth_index "Household Wealth Index"


*** Checking missing observations

foreach var of varlist child_alive gender birthr ///
anc_visits bweight ch_discarge ///
bflength ch_residence location ///
wealth_index mage water_source meduc {
	quietly count if missing(`var')
	local pct = round(`r(N)' / _N * 100, 0.1)
	di "`var': `r(N)' missing (`pct'%)"
}
* Most variables have a huge percentage of missing observations.

misstable summarize // Returns a tabular presentation of missing observations.


*** Cleaning and recoding variables

* anc_visits - numbeer of antenatal visits during pregnancy

tabulate anc_visits // Returns a table that enables easy detection of sentinel code. For example, 98 in anc_visits is a code for "Don't know"

replace anc_visits = . if anc_visits == 98 // Replaces the sentinel code with missing

* Create a categorical variable from anc_visits following World Health Organisation (WHO) recommendation of at least 4 antenatal visits.

generate anc_cat = . // generates a variable anc_cat
replace anc_cat = 0 if anc_visits == 0 
replace anc_cat = 1 if anc_visits >= 1 & anc_visits <= 3 
replace anc_cat = 2 if anc_visits >= 4 & anc_visits <= 10 
replace anc_visits = . if anc_visits > 10

label define anc_labels /// 
0 "No visits" 1 "1-3 Visits (Inadequate)" 2 "4+ Visits (Adequate)" // defines labels
label values anc_cat anc_labels // adds the labels to anc_cat variable
label variable anc_cat "Antenatal visits (0 = No visits)" // adds variable labels
tab anc_visits anc_cat, missing // verifies if recoding is successful. Variable recoded successfully.

* Create a binary variable out of the anc_cat variable. Antenatal visits below 3 are recoded as inadequate and beyond 4 as adequate. WHO recommends at least 4 antenatal visits during pregnancy.
generate anc_inad = . // generates a variable anc_inad
replace anc_inad = 0 if anc_visits >= 0 & anc_visits <= 3
replace anc_inad = 1 if anc_visits >= 4 & anc_visits <= 10

label define anc_lbl 0 "Inadequate visits (<4)" 1 "Adequate visits (4+)"
label values anc_inad anc_lbl
tab anc_visits anc_inad, missing // Recoding is successful
label variable anc_inad "Antenatal visits (0 = Inadequate visits)"


*** Cleaning and recoding the child_alive variable

tabulate child_alive // Variable recoded as 0 = No and 1 = Yes. 

* Create a new variable "child_died" recorded as 0 = Alive and 1 = Died
generate child_died = . // generates a variable child_died
replace child_died = 1 if child_alive == 0 
replace child_died = 0 if child_alive == 1

label define died_lbl 0 "Alive" 1 "Died" // defines variable labels
label values child_died died_lbl
tabulate child_alive child_died, missing // verifies recoding success: Recoding successful
label variable child_died "Child Died (0 = Died, 1 = Alive)" // adds a variable label


*** Cleaning and recoding the gender variable

tabulate gender // variables recoded as 1. Boy and 2.Girl. Recoded to 1 = Boy and 0 = Girl.
generate child_sex = . // generates new variable child_sex
replace child_sex = 1 if gender == 1
replace child_sex = 0 if gender == 2

label define chil_lbl 0 "Girl" 1 "Boy" // defines variable labels
label values child_sex chil_lbl // adds labels
tab gender child_sex, missing // verifies recode success: Recode successful
label variable child_sex "Child's Gender (1 = Boy, 0 = Girl)"


*** Cleaning and recoding birth weight variable

tabulate bweight // It contains sentinel codes: 9998 (don't know) and 9996 (not weighted at birth). These are recoded to missing observations below:
replace bweight = . if bweight == 9996
replace bweight = . if bweight == 9998

* Create a birth weight categorical variable, following WHO's child's weight categories
generate bweight_cat = . // generates a variable bweight_cat
* recode observations
replace bweight_cat = 1 if bweight < 2500 & !missing(bweight)
replace bweight_cat = 2 if bweight >= 2500 & bweight < 4000
replace bweight_cat = 3 if bweight >= 4000 & !missing(bweight)

* define variable labels
label define b_lbl ///
1 "Low birthweight (< 2500)" 2 "Normal (2500 - 3999)" 3 "High (>4000)"
label values bweight_cat b_lbl // adds label values

* verify:
tabulate bweight bweight_cat, missing
* add variable labels
label variable bweight_cat "Birth Weight (1 = low birthweight)"


*** Cleaning and recoding ch_discarge variable

codebook ch_discarge // there is a sentinel code 8 = Don't know.
replace ch_discarge = . if ch_discarge == 8 // recodes sentinel code 8 to a missing


*** Cleaning and recoding bflength

codebook bflength // variable observations depicts status of breastfeeding not duration

rename bflength bf_status // bf_status stands for status of breastfeeding
label variable bf_status "Breastfeeding status" // adds a meaningful label

* Create a new categorical variable "bf_cat"
generate bf_cat = . // generates bf_cat variable
replace bf_cat = 0 if bf_status == 94
replace bf_cat = 1 if bf_status == 93
replace bf_cat = 2 if bf_status == 95

* define bf_cat labels
label define bf_lb ///
0 "Never breastfed" 1 "Ever breastfed, not currently breastfeeding" 2 "Still breastfeeding"
label values bf_cat bf_lb // adds variable values
label variable bf_cat "Breastfeeding Status" // adds labels

*** Cleaning and recoding ch_residence (child's residence) variable

tabulate ch_residence // where the child lives is coded as 0 = respondent and 4 = elsewhere
generate child_resid = . // generates child_resid variable

* replace entries with responses between 0 and 1
replace child_resid = 0 if ch_residence == 0
replace child_resid = 1 if ch_residence == 4

* define labels and add label values
label define resid_lbl 0 "Mother" 1 "Elsewhere"
label values child_resid resid_lbl
label variable child_resid "Who Does the Child Live With?"
* verify whether recoding is successful
tabulate ch_residence child_resid, missing // recoding is successful


*** Cleaning and recoding the "location" variable

codebook location // coded as 1. Urban and 2. Rural. Recoded to 1 = Urban and 0 = Rural
generate flocation = . // generates new variable flocation

* recode observations
replace flocation = 1 if location == 1
replace flocation = 0 if location == 2

* create and add label values
label define floc_lbl 1 "Urban" 0 "Rural"
label values flocation floc_lbl

* verify whether recoding is successful
tabulate location flocation, missing // recoding successful
* add labels
label variable flocation "Famly Location (1 = Urban, 0 = Rural)"


*** Cleaning and recoding wealth index variable

codebook wealth_index // checking wealth index details

generate wl_index = . // generates a new wealth variable
replace wl_index = 1 if wealth_index == 1
replace wl_index = 2 if wealth_index == 2
replace wl_index = 3 if wealth_index == 3
replace wl_index = 4 if wealth_index == 4
replace wl_index = 5 if wealth_index == 5

* create and add labels
label define wl_lbl 1 "Lowest" 2 "Second" 3 "Middle" 4 "Fourth" 5 "Highest"
label values wl_index wl_lbl

* add a label to wl_index
label variable wl_index "Family's Wealth Index"

* verify if recoding is successful
tabulate wealth_index wl_index, missing // recoding successful


*** Cleaning and recoding the water source variable
tabulate water_source // check code details. There is a sentinal code 96 = Other, recoded to missing
replace water_source = . if water_source == 96

generate wat_srce = . // generates a new water source variable 

* recode original entries
replace wat_srce = 0 if water_source == 11
replace wat_srce = 1 if water_source == 12
replace wat_srce = 2 if water_source == 13
replace wat_srce = 3 if water_source == 14
replace wat_srce = 4 if water_source == 21
replace wat_srce = 5 if water_source == 31
replace wat_srce = 6 if water_source == 32
replace wat_srce = 7 if water_source == 41
replace wat_srce = 8 if water_source == 42
replace wat_srce = 9 if water_source == 51
replace wat_srce = 10 if water_source == 61
replace wat_srce = 11 if water_source == 71
replace wat_srce = 12 if water_source == 81
replace wat_srce = 13 if water_source == 91
replace wat_srce = 14 if water_source == 92

* Create and add label values
label define watr_lbl ///
0 "Piped into dwelling" ///
1 "Piped to plot" ///
2 "Piped to neigbor" ///
3 "Public tap" ///
4 "Borehole" ///
5 "Protected well" ///
6 "Unprotected well" ///
7 "Protected spring" ///
8 "Unprotected spring" ///
9 "Rainwater" ///
10 "Tanker truck" ///
11 "Bicycle with jerrycans" ///
12 "Surface water (river, dam, lake, pond)" ///
13 "Bottled water" ///
14 "Sachet water"
label values wat_srce watr_lbl // adds label values

* add variable labels
label variable wat_srce "Source of Water"

* verify if recoding is successful
tabulate water_source wat_srce, missing // recoding successful

*** Cleaning and recoding meduc - mother's education
codebook meduc

generate medu_level = . // generates a new variable for mother's level of education

* recode values
replace medu_level = 0 if meduc == 0
replace medu_level = 1 if meduc == 1
replace medu_level = 2 if meduc == 2
replace medu_level = 3 if meduc == 3

* create and add label values
label define meduc_lbl ///
0 "No education" ///
1 "Primary" ///
2 "Secondary" ///
3 "Higher"
label values medu_level meduc_lbl // adds variable values

* add a variable labels
label variable medu_level "Mother's Educational Level"

* verify if recoding is successful
tabulate meduc medu_level, missing // recoding is successful

*** Deleting variables that are recoded to new variables
drop anc_visits child_alive gender bweight bf_status ch_residence location wealth_index water_source meduc

*** save dataset
save "output/dhs_cleaned.dta", replace

log close // close the log file
