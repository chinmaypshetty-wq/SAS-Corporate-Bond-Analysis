FILENAME REFFILE FILESRVC
FOLDERPATH='/Users/chinmaypraveen.shetty@student.adelaide.edu.au'
FILENAME='Sample_a.csv';
PROC IMPORT DATAFILE=REFFILE
DBMS=CSV
OUT=WORK.IMPORT;
GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
FILENAME REFFILE FILESRVC
FOLDERPATH='/Users/chinmaypraveen.shetty@student.adelaide.edu.au'
FILENAME='Sample_b.csv';
PROC IMPORT DATAFILE=REFFILE
DBMS=CSV
OUT=WORK.IMPORT1;
GETNAMES=YES;
RUN;
proc sql ;
create table WORK.Bond_Price AS
select *
from WORK.IMPORT AS C inner join WORK.IMPORT1 AS S
on C.Bond_id = S.Bond_id;
quit;
/*2. Summary Statistics */
/* Calculate descriptive statistics for all numeric variables in the dataset */
proc summary data = Bond_Price n mean std min max skewness kurtosis;
var _numeric_;
output out = summary_all_numeric;
run;
proc univariate data= work.bond_price;
var _numeric_;
output out= advance_stats
kurtosis= Kurtosis
skewness= Skewness;
run;
21
proc print data = advance_stats;
run;
/*Calculate frequencies of all Categorical Variable*/
proc freq data = BOND_PRICE;
table
Sector
Issuer
Moodys_cred_rat
Market_of_Issue;
run;
/*Calculate relative frequencies of all Categorical Variable*/
proc freq data = bond_price;
tables
sector /nocum;
run;
proc freq data = bond_price;
tables
Moodys_cred_rat /nocum;
run;
proc freq data = bond_price;
tables
issuer /nocum;
run;
proc freq data = bond_price;
tables
Market_of_Issue /nocum;
run;
/*Co-relation matrix */
proc corr data = bond_price;
run;
/*3. Data Cleaning & Outliers*/
/* Calculate duplicate values */
proc sort data=WORK.BOND_PRICE out=BOND_PRICE nodupkey;
by _all_;
run;
data bOND_PRICE;
set BOND_PRICE;
drop Convertible Putable;
run;
22
data BOND_PRICE;
set work.BOND_PRICE;
if cmiss(of _all_) then delete;
run;
/*Identifying Outliers */
proc univariate data=WORK.BOND_PRICE;
var Coupon;
histogram Coupon;
run;
proc univariate data=WORK.BOND_PRICE;
var Yield;
histogram Yield;
run;
proc univariate data=WORK.BOND_PRICE;
var Amount_outstanding;
histogram Amount_outstanding;
run;
/*No Outliers DS*/
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
if Bond_id =3938 or
Bond_id =4027 or
Bond_id =3497 or
Bond_id =3498 or
Bond_id =3554 or
Bond_id =3499 or
Bond_id =3612 or
Bond_id =3767 or
Bond_id =3508 or
Bond_id =3509 or
Bond_id =3500 or
Bond_id =3675 or
Bond_id =4150 or
Bond_id =3806 or
Bond_id =3672 or
Bond_id =3937 or
Bond_id =4025 or
Bond_id =4026
then delete;
run;
23
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
where currency = 'US Dollar';
run;
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
maturity2 = (maturity - today()) / 365;
run;
/*Log conversion of amount outstanding*/
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
ln_amount = log(Amount_outstanding);
run;
proc univariate data=WORK.BOND_PRICE;
var ln_amount;
histogram ln_amount;
run;
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
if Callable = "TRUE" then callable_dummy = 1;
else callable_dummy = 0;
run;
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
if Seniority = "Senior Unsecured" then Seniority_Dummy = 1;
else Seniority_Dummy = 0;
run;
proc format;
value $Market_of_Issue_fmt
"Domestic (Other)" = 1
"Global (Other)" = 2
"Eurobond (Other)" = 3;
run;
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
Market_of_Issue_Code = put(Market_of_Issue,$Market_of_Issue_fmt.);
run;
24
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
Market_of_Issue_Code_num = input(Market_of_Issue_Code,best.);
run;
proc format;
value $Sector_fmt
"Service - Other"= 1
"Food Processors"= 2
"Home Builders"= 3
"Health Care Facilities"=4
"Metals/Mining"=5
"Pharmaceuticals"=6
"Electronics"=7
"Chemicals"=8
"Health Care Supply"=9
"Textiles/Apparel/Shoes"=10
"Leisure"=11
"Restaurants"=12
"Retail Stores - Food/Drug"=13
"Building Products"=14
"Conglomerate/Diversified Mfg"=15
"Industrials - Other"=16
"Gaming"=17
"Telecommunications"=18
"Transportation - Other"=19
"Information/Data Technology"=20
"Aerospace"=21
"Vehicle Parts"=22
"Retail Stores - Other"=23
"Automotive Manufacturer"=24
"Beverage/Bottling"=25
"Airline"=26
"Cable/Media"=27
"Lodging"=28
"Machinery"=29
"Consumer Products"=30
"Railroads"=31
"Publishing"=32
"Tobacco"=33
"Containers"=34;
run;
25
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
Sector_Code = put(Sector,$Sector_fmt.);
run;
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
Sector_Code_num = input(Sector_Code,best.);
run;
data WORK.BOND_PRICE;
set WORK.BOND_PRICE;
/* Dummy variable for Aaa rating */
aaa_d = 0;
if Moodys_cred_rat = "Aaa" then aaa_d = 1;
/* Dummy variable for Aa ratings */
aa_d = 0;
if Moodys_cred_rat in ("Aa1", "Aa2", "Aa3") then aa_d = 1;
/* Dummy variable for A ratings */
a_d = 0;
if Moodys_cred_rat in ("A1", "A2", "A3") then a_d = 1;
/* Dummy variable for Baa ratings */
baa_d = 0;
if Moodys_cred_rat in ("Baa1", "Baa2", "Baa3") then baa_d = 1;
/* Dummy variable for Ba ratings */
ba_d = 0;
if Moodys_cred_rat in ("Ba1", "Ba2", "Ba3") then ba_d = 1;
/* Dummy variable for B ratings */
b_d = 0;
if Moodys_cred_rat in ("B1", "B2", "B3") then b_d = 1;
/* Dummy variable for all other ratings */
c_d = 0;
if Moodys_cred_rat not in ("Aaa", "Aa1", "Aa2", "Aa3", "A1", "A2", "A3", "Baa1", "Baa2",
"Baa3", "Ba1", "Ba2", "Ba3", "B1", "B2", "B3") then c_d = 1;
run;
/* 4. Summary Statics 2*/
26
/* Calculate descriptive statistics for all numeric variables in the dataset */
proc summary data = Bond_Price;
var _numeric_;
output out = summary_all_numeric;
run;
proc univariate data= work.bond_price;
var _numeric_;
output out= advance_stats
kurtosis= Kurtosis
skewness= Skewness;
run;
proc print data = advance_stats;
run;
/*Calculate frequencies of all Categorical Variable*/
proc freq data = BOND_PRICE;
table
Sector
Issuer
Moodys_cred_rat
Market_of_Issue;
run;
/*Calculate relative frequencies of all Categorical Variable*/
proc freq data = bond_price;
tables
sector /nocum;
run;
proc freq data = bond_price;
tables
Moodys_cred_rat /nocum;
run;
proc freq data = bond_price;
tables
issuer /nocum;
run;
proc freq data = bond_price;
tables
Market_of_Issue /nocum;
run;
/*Co-relation matrix */
proc corr data = bond_price;
27
run;
/*5. Linear Regression Model & Tests */
/*Linear Regression Model - 1 */
proc reg data = WORK.BOND_PRICE;
model yield = maturity2 ln_amount;
run;
/*Linear Regression Model - 2 */
proc reg data = WORK.BOND_PRICE;
model yield = maturity2 ln_amount Coupon;
run;
/*Linear Regression Model - 3 */
proc reg data = WORK.BOND_PRICE;
model yield = maturity2 ln_amount Coupon callable_dummy Seniority_Dummy aaa_d aa_d a_d baa_d
ba_d b_d;
run;
/*Model testing*/
/*Variance Inflation Factor (VIF) Testing */
proc reg data = WORK.BOND_PRICE;
model yield = maturity2 ln_amount Coupon callable_dummy Seniority_Dummy aaa_d aa_d a_d ba_d
b_d/vif;
run;
/*Heteroscedasticity Test*/
proc reg data = WORK.BOND_PRICE;
model yield = maturity2 ln_amount Coupon callable_dummy Seniority_Dummy aaa_d aa_d a_d baa_d
ba_d b_d/spec;
run;
quit;
/*Usage of Linear Regression Model - 3 */
proc reg data = WORK.BOND_PRICE;
model yield = maturity2 ln_amount Coupon callable_dummy Seniority_Dummy aa_d
Sector_Code_num Market_of_Issue_Code_num;
run