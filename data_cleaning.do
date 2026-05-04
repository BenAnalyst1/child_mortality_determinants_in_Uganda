******Analysis of child mortality in Uganda******
*************Data Cleaning****************
*** Boro, Binya Benson Abe

* clear

clear all

* Set working directory
pwd // check current working directory

cd "/Users/benson/Desktop/econ_analysis/health_analysis" 

* Start log file 
log using "stata/data_cleaning", text replace 

* Load the dataset
use "raw_data/dhsKR_extrac.dta", clear

* check data descrption
describe 
* There are 1,436 observations and 19 variables. A need to rename variables and labels

*************** Rename variable ********************
rename v001 cluster_no
rename v002 household_No
rename b5 child_survived 
rename b4 gender
rename b8 child_age
rename v106 meduc
rename v190 wl_index
rename v025 resid_type
rename v024 region
rename v012 mage
rename v201 total_children
rename v113 water_source
rename bord birth_order
rename b11 birth_interval
rename v005 sample_weight
rename v021 psu_cluster  
rename v022 sample_strata

************** label variable ***********************
label variable child_survived "Child Survived Under 5 Mortality (1 = Alive, 0 = Dead)"
label variable gender "Gender of the Child (1 = Male, 0 = Female)"
label variable child_age "Age of the Child (In Months)"
label variable meduc "Mother's Highest Level of Education"
label variable wl_index "Household Wealth Index"
label variable resid_type "Place of Residence (1 = Urban, 2 = Rural)"
label variable region "Region"
label variable mage "Age of the Mother (Years)"
label variable total_children "Total No. of Children Born"
label variable water_source "Source of Drinking Water"
label variable birth_order "Birth Order"
label variable birth_interval "Preceding Birth Interval(in Months)"
label variable sample_weight "Sample Weight"
label variable psu_cluster "Primary Sampling Unit -  Cluster"
label variable sample_strata "Sample Strata"


*********** checking and handling missing observations ***********
* checking missing observations
foreach var of varlist child_survived gender child_age meduc wl_index ///
resid_type total_children water_source ///
birth_order birth_interval region ///
 mage {
	quietly count if missing(`var')
	local pct = round(`r(N)' / _N * 100, 0.1)
	di "`var': `r(N)' missing (`pct'%)"
} 
* Some variables have missing observations. They include: child_age(4.8%), water_source(0.1%), and birth_interval(20.2%)

* handling missing observations

generate age_missing = missing(child_age)
replace child_age = 0 if missing(child_age)
label variable age_missing "Child Age Missing"
* If the 4.8% missing observations in child age are dropped, all records of dead children in the child_survived variable also drops.
* The age_missing variable thus captures children whose current age is missing. 

drop if missing(water_source) // the small percentage of missing observations (0.1%) is neglible

generate birth_missing = missing(birth_interval)
replace variable birth_interval = 0 if missing(birth_interval)
label variable birth_interval "Birth Interval Missing"
* The 20.2% missing birth interval entries could be due to non-responses from women with no preceding birth. In this case, they might indicate first born children
* Thus, birth_missing = 1 could indicate first born children or merely missing birth intervals

******************* cleaning and recoding variables************
*** child_survived
tabulate child_survived // 1 = Alive, 0 = Dead

* recode
label define sur_lbl 1 "Alive" 0 "Dead" 
label values child_survived sur_lbl

*** gender
tabulate gender // 1= Boy and 2 = Girl

* record to male and female
replace gender = 0 if gender == 2

label define gend_lbl 0 "Female" 1 "Male"
label values gender gend_lbl


*** meduc - mother's educational level
tabulate meduc // 0 = no education, 1 = primary, 2 = Secondary, 3 = Higher

* recode values
replace meduc = 0 if meduc == 0
replace meduc = 1 if meduc == 1
replace meduc = 2 if meduc == 2
replace meduc = 3 if meduc == 3

label define meduc_lbl ///
0 "No education" ///
1 "Primary" ///
2 "Secondary" ///
3 "Higher"
label values meduc meduc_lbl

*** wl_index - wealth index
tabulate wl_index

* recode values
replace wl_index = 1 if wl_index == 1
replace wl_index = 2 if wl_index == 2
replace wl_index = 3 if wl_index == 3
replace wl_index = 4 if wl_index == 4
replace wl_index = 5 if wl_index == 5

* add labels
label define wl_ind 1 "Poorest" 2 "Poorer" 3 "Middle" 4 "Richer" 5 "Richest"
label values wl_index wl_ind

*** resid_type - type of place of residence
codebook resid_type

* recode values
replace resid_type = 0 if resid_type == 2

* add labels
label define resid_lbl 1 "Urban" 0 "Rural"
label values resid_type resid_lbl

*** region
tabulate region

* recode region
replace region = 1 if region == 0
replace region = 2 if region == 1
replace region = 3 if region == 3
replace region = 4 if region == 4
replace region = 5 if region == 5
replace region = 6 if region == 6
replace region = 7 if region == 7
replace region = 8 if region == 8
replace region = 9 if region == 9
replace region = 10 if region == 10
replace region = 11 if region == 11
replace region = 12 if region == 12
replace region = 13 if region == 13
replace region = 14 if region == 14

* add labels
label define reg_lb ///
 1 "Kampala" ///
 2 "Buganda" ///
 3 "Busoga" ///
 4 "Bukedi" ///
 5 "Bugisu" ///
 6 "Teso" ///
 7 "Karamoja" ///
 8 "Lango" ///
 9 "Acholi" ///
 10 "West nile" ///
 11 "Bunyoro" ///
 12 "Tooro" ///
 13 "Ankole" ///
 14 "Kigezi"

 label values region reg_lb
 
 *** water sources
codebook water_source

replace water_source = . if water_source == 96 // 96 is possibly a sentinel code

* recod
replace water_source = 0 if water_source == 11
replace water_source = 1 if water_source == 12
replace water_source = 2 if water_source == 13
replace water_source = 3 if water_source == 14
replace water_source = 4 if water_source == 21
replace water_source = 5 if water_source == 31
replace water_source = 6 if water_source == 32
replace water_source = 7 if water_source == 41
replace water_source = 8 if water_source == 42
replace water_source = 9 if water_source == 51
replace water_source = 10 if water_source == 61
replace water_source = 11 if water_source == 71
replace water_source = 12 if water_source == 81
replace water_source = 13 if water_source == 91
replace water_source = 14 if water_source == 92

* add labels
label define wat_lbl ///
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
label values water_source wat_lbl

*** save dataset
save "cleaned_data/dhsKR_cleaned.dta", replace

* close log
log close
