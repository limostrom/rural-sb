/*
usda_public_summary.do

Just getting some basic summary statistics of the immediately available USDA
volumes of grants and loans 2017-2022 so I can have some motivating facts about
this program.


*/

global gitdir "/Users/laurenmostrom/Documents/GitHub/rural-sb/"
global filedir "/Users/laurenmostrom/Dropbox/Personal Document Backup/Booth/Second Year/Y2 Paper"

cd "$filedir"

import excel "Data/RD_GrantAwards_FY18.xls", clear first
	ren *, lower
	tempfile fy18
	save `fy18', replace
	
import excel "Data/RD_GrantAwards_FY19_final.xls", clear first
	drop H-IV
	ren *, lower
	tempfile fy19
	save `fy19', replace
	
import excel "Data/rd_grant_awards_fy20_final.xlsx", clear first
	ren *, lower
	ren states state
	ren counties county
	ren borrower recipientname
	ren reps repdistrict
	ren grantamount grant
	tempfile fy20
	save `fy20', replace

import excel "Data/RD_GrantAwards_FY21.xlsx", clear first
	drop H-IV
	ren *, lower
	ren states state
	ren counties county
	ren borrower recipientname
	ren reps repdistrict
	ren grantamount grant
	tempfile fy21
	save `fy21', replace

import excel "Data/rd_grantawards_fy22.xlsx", clear first case(lower)
	ren counties county
	ren borrower recipientname
	ren reps repdistrict
	ren grantamount grant
	append using `fy21'
	append using `fy20'
	append using `fy19'
	append using `fy18'
	gen year = substr(obligationdate,-4,.)
	destring year, replace
	
	
#delimit ;
keep if inlist(program, "ReConnect 100% Grant - CARES Act",
	"Community Connect Grants", "ReConnect Grant" /*,
	"ReConnect Loan and Grant Combination"*/);
#delimit cr

gen pilot = inrange(year, 2018, 2021)
egen states = tag(state pilot)
collapse (sum) grant states (count) n_proj = year, by(pilot)








	
	
	