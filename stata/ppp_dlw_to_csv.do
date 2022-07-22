
// make sure you change to wherever the aux_cpi repo is stored in your machine
// In profile.do I set the global wb_dir in my computer for general use
global auxout c:\Users\wb327173\OneDrive - WBG\Downloads\ECA\GPWG\PIP_repo\
cd "${auxout}\aux_ppp\"
global dlw_dir "\\wbgfscifs01\GPWG-GMD\Datalib\GMD-DLW\Support\Support_2005_CPI\"

local pppdirs: dir "${dlw_dir}" dirs "*CPI_*_M", respectcase
local pppvins "0"
foreach pppdir of local pppdirs {
	if regexm("`pppdir'", "CPI_[Vv]([0-9]+)_M") local pppvin = regexs(1)
	local pppvins "`pppvins', `pppvin'"
}
local pppvin = max(`pppvins')
disp "`pppvin'"


use "${dlw_dir}/Support_2005_CPI_v0`pppvin'_M/Data/Stata/pppdata_allvintages.dta", clear

cap noi datasignature confirm using "ppp", strict
if (_rc) {
	datasignature set, reset saving("ppp", replace)
  export delimited  "ppp.csv" , replace
}


