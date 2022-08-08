
// make sure you change to wherever the aux_cpi repo is stored in your machine
// In profile.do I set the global wb_dir in my computer for general use

//========================================================
//  Set up
//========================================================

// Set according to username
if ("`c(username)'" == "wb384996") {
	cd "${wb_dir}\DECDG\PIP\aux_data\aux_ppp\"
}
else if ("`c(username)'" == "wb327173") {
	global auxout c:\Users\wb327173\OneDrive - WBG\Downloads\ECA\GPWG\PIP_repo\
	cd "${auxout}\aux_ppp\"		
}
else {
	
}


//========================================================
//  Official PPP
//========================================================

// Datalibweb folder
global dlw_dir "\\wbgfscifs01\GPWG-GMD\Datalib\GMD-DLW\Support\Support_2005_CPI\"


// get more rence version
local pppdirs: dir "${dlw_dir}" dirs "*CPI_*_M", respectcase
local pppvins "0"
foreach pppdir of local pppdirs {
	if regexm("`pppdir'", "CPI_[Vv]([0-9]+)_M") local pppvin = regexs(1)
	local pppvins "`pppvins', `pppvin'"
}
local pppvin = max(`pppvins')
disp "`pppvin'"


// Sign and save
use "${dlw_dir}/Support_2005_CPI_v0`pppvin'_M/Data/Stata/pppdata_allvintages.dta", clear

cap noi datasignature confirm using "ppp", strict
if (_rc) {
	datasignature set, reset saving("ppp", replace)
  export delimited  "ppp.csv" , replace
}


//========================================================
// PPP Vintage
//========================================================

qui ds ppp*
local pppv = "`r(varlist)'"

drop _all 
gen version = ""
local i = 1

foreach v of local pppv {
	if (regexm("`v'", "^ppp.*v[1-9]$")) {
		set obs `i'
		replace version = "`v'" in `i'
		local ++i
	}
}

split version, parse("_")
local ppp_vars "ppp_year ppp_rv ppp_av"
rename (version2 version3 version4) (`ppp_vars')
keep `ppp_vars'
sort `ppp_vars'

cap noi datasignature confirm using "ppp_vintage", strict
if (_rc) {
	datasignature set, reset saving("ppp_vintage", replace)
  export delimited  "ppp_vintage.csv" , replace
}

exit



