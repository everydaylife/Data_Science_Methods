/* Exploratory data analysis of binary response variable, "credit approval" or A16
for use in a logistic regression model */

TITLE "Credit Model";
TITLE2 "Data Read in from Credit Library"; 
ODS GRAPHICS ON;

libname mydata "/courses/d54816e5ba27fe300" access=readonly; 

DATA credit;
SET mydata.credit_approval;
RUN;

PROC CONTENTS DATA = credit;
RUN;

PROC PRINT DATA = credit;
RUN;

* define credit dataset for subsequent work;
* binary response variable 1 = credit approved 0 = not approved;
DATA credit;
SET mydata.credit_approval;
RUN;

* show contents of the full data set prior to splitting;
PROC CONTENTS DATA = credit;
RUN;

* print first 20 observations checking values of all variables;
OPTIONS OBS = 20;
PROC PRINT DATA = credit;
VAR A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11 A12 A13 A14 A15 A16;
RUN;

OPTIONS OBS = MAX; * reset options to analyze and report on all data;

proc freq data = credit;
  tables a1 a4 a5 a6 a7 a9 a10 a11 a12 a13 a16 ;

proc freq data = credit ;
  tables a2 ;
  
proc univariate data=credit;
	histogram;
run;
/* Histogram of all variables shows A14 doesn't look predictive
Most values are in a single bin */

proc sgplot;
	vbar a1;
run;
	
proc sgplot;
	vbar a4;
run;

proc sgplot;
	vbar a5;
run;

proc sgplot;
	vbar a6;
run;

proc sgplot;
	vbar a7;
run;

proc sgplot;
	vbar a9;
run;

proc sgplot;
	vbar a10;
run;

proc sgplot;
	vbar a12;
run;

proc sgplot;
	vbar a13;
run;

proc freq data = credit;
	tables a1 * a16;
run;
/* Variable A1 doesn't look to be predictive
It's values are split evenly between 0 and 1 (credit approval vs disapproval) */

proc freq data = credit;
	tables a4 * a16;
run;

proc freq data = credit;
	tables a5 * a16;
run;

proc freq data = credit;
	tables a6 * a16;
run;

proc freq data = credit;
	tables a7 * a16;
run;

proc freq data = credit;
	tables a9 * a16;
run;

proc freq data = credit;
	tables a10 * a16;
run;

proc freq data = credit;
	tables a12 * a16;
run;

proc freq data = credit;
	tables a13 * a16;
run;

/* Point bi-serial correlations to show which variables look to be most predictive of Y*/
proc corr data=credit;
	var a2 a3 a8 a11 a14 a15;
	with a16;
	Title "Continuous with A16";
run;

proc freq data=credit;
tables A1 A4 A5 A6 A7 A9 A10 A12 A13 A16;
run;

proc means data=credit p5 p10 p25 p50 p75 p90 p95;
class A16;
var A2 A3 A8 A11 A14 A15;
run; 

proc sgplot;
	scatter x=a2 y=a16;
run;