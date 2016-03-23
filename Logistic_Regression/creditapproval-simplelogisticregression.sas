/* Logistic regressio model of "credit approval" */

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

* Define credit dataset for subsequent work;
* Binary response variable 1 = credit approved 0 = not approved;
DATA credit;
SET mydata.credit_approval;
RUN;

/* Discretize the continuous variables using quartile breakpoints 
Was aiming to get unbalanced splits in 0 vs 1 for the quartile buckets */
data credit;
	set mydata.credit_approval;
	if (A2 < 22) then A2_discrete=1;
	else if (A2 < 27.3) then A2_discrete=2;
	else if (A2 < 34.8) then A2_discrete=3;
	else A2_discrete=4;
run;

proc sgplot;
	scatter x=a2_discrete y=a16/ jitter;
run;

proc freq data=credit;
	tables a16*a2_discrete;
run;


proc sgplot;
	scatter x=a3 y=a16;
run;

data credit;
	set mydata.credit_approval;
	if (A3 < 0.84) then A3_discrete=1;
	else if (A3 < 2.21) then A3_discrete=2;
	else if (A3 < 5) then A3_discrete=3;
	else A3_discrete=4;
run;

proc sgplot;
	scatter x=a3_discrete y=a16/ jitter;
run;

proc freq data=credit;
	tables a16*a3_discrete;
run;

proc sgplot;
	scatter x=a8 y=a16;
run;

data credit;
	set mydata.credit_approval;
	if (a8 < 0.125) then a8_discrete=1;
	else if (a8 < 41.5) then a8_discrete=2;
	else if (a8 < 1.5) then a8_discrete=3;
	else a8_discrete=4;
run;

proc sgplot;
	scatter x=a8_discrete y=a16/ jitter;
run;

proc freq data=credit;
	tables a16*a8_discrete;
run;

proc sgplot;
	scatter x=a11 y=a16;
run;

data credit;
	set mydata.credit_approval;
	if (a11 < 0) then a11_discrete=1;
	else if (a11 < 1) then a11_discrete=2;
	else if (a11 < 2) then a11_discrete=3;
	else a11_discrete=4;
run;

proc sgplot;
	scatter x=a11_discrete y=a16/ jitter;
run;

proc freq data=credit;
	tables a16*a11_discrete;
run;

proc sgplot;
	scatter x=a14 y=a16;
run;

data credit;
	set mydata.credit_approval;
	if (a14 < 100) then a14_discrete=1;
	else if (a14 < 167.5) then a14_discrete=2;
	else if (a14 < 272) then a14_discrete=3;
	else a14_discrete=4;
run;

proc sgplot;
	scatter x=a14_discrete y=a16/ jitter;
run;

proc freq data=credit;
	tables a16*a14_discrete;
run;

proc sgplot;
	scatter x=a15 y=a16;
run;

data credit;
	set mydata.credit_approval;
	if (a15 < 0.5) then a15_discrete=1;
	else if (a15 < 1) then a15_discrete=2;
	else if (a15 < 67) then a15_discrete=3;
	else a15_discrete=4;
run;

proc sgplot;
	scatter x=a15_discrete y=a16 / jitter;
run;

proc freq data=credit;
	tables a16*a15_discrete;
run;

/* rework variables for more uneven split in the buckets */
data credit;
	set mydata.credit_approval;
	if (A2 < 22) then A2_discrete=1;
	else if (A2 < 25) then A2_discrete=2;
	else if (A2 < 45) then A2_discrete=3;
	else if (A2 < 58) then A2_discrete=4;
	else A2_discrete=5;
run;

proc sgplot;
	scatter x=a2_discrete y=a16/ jitter;
run;

proc freq data=credit;
	tables a16*a2_discrete;
run;


data credit;
	set mydata.credit_approval;
	if (a8 < 0.125) then a8_discrete=1;
	else if (a8 < .415) then a8_discrete=2;
	else if (a8 < 1.5) then a8_discrete=3;
	else a8_discrete=4;
run;

proc sgplot;
	scatter x=a8_discrete y=a16/ jitter;
run;

proc freq data=credit;
	tables a16*a8_discrete;
run;

proc sgplot;
	scatter x=a11 y=a16;
run;

data credit;
	set mydata.credit_approval;
	if (a11 < 2) then a11_discrete=1;
	else if (a11 < 6) then a11_discrete=2;
	else if (a11 <11) then a11_discrete=3;
	else a11_discrete=4;
run;

proc sgplot;
	scatter x=a11_discrete y=a16/ jitter;
run;

proc freq data=credit;
	tables a16*a11_discrete;
run;

/* Fix missing values, create dummy variables */
DATA credit;
	SET mydata.credit_approval;
	
	If ((a1=' ') or (a2='.') or (a14='.') or (a4=' ') or (a5=' ') or (a6=' ') or
(a7=' ')) then delete ;
	
if (A1='a') then A1_a=1;
else A1_a=0;

if A4 not in ('l' 'u' 'y') then call missing (A4_l,A4_u);
else if A4='l' then A4_l=1;
else A4_l=0;
if A4='u' then A4_u=1;
else A4_u=0;

if A5 not in ('g' 'gg' 'p') then call missing (A5_g,A5_gg);
else if A5='g' then A5_g=1;
else A5_g=0;
if A5='gg' then A5_gg=1;
else A5_gg=0;

if A6 not in ('aa' 'c' 'cc' 'd' 'e' 'ff' 'i' 'j' 'k' 'm' 'q' 'r' 'w' 'x')
then call missing
(A6_aa,A6_x,A6_cc,A6_d,A6_e,A6_ff,A6_i,A6_j,A6_k,A6_m,A6_q,A6_r,A6_w);
else if A6='aa' then A6_aa=1;
else A6_aa=0;
if A6='x' then A6_x=1;
else A6_x=0;
if A6='cc' then A6_cc=1;
else A6_cc=0;
if A6='d' then A6_d=1;
else A6_d=0;
if A6='e' then A6_e=1;
else A6_e=0;
if A6='ff' then A6_ff=1;
else A6_ff=0;
if A6='i' then A6_i=1;
else A6_i=0;
if A6='j' then A6_j=1;
else A6_j=0;
if A6='k' then A6_k=1;
else A6_k=0;
if A6='m' then A6_m=1;
else A6_m=0;
if A6='q' then A6_q=1;
else A6_q=0;
if A6='r' then A6_r=1;
else A6_r=0;
if A6='w' then A6_w=1;
else A6_w=0;

if A7 not in ('bb' 'dd' 'ff' 'h' 'j' 'n' 'o' 'v' 'z') then call missing
(A7_bb,A7_dd,A7_ff,A7_h,A7_j,A7_n,A7_o,A7_v);
else if A7='bb' then A7_bb=1;
else A7_bb=0;
if A7='dd' then A7_dd=1;
else A7_dd=0;
if A7='ff' then A7_ff=1;
else A7_ff=0;
if A7='h' then A7_h=1;
else A7_h=0;
if A7='j' then A7_j=1;
else A7_j=0;
if A7='n' then A7_n=1;
else A7_n=0;
if A7='o' then A7_o=1;
else A7_o=0;
if A7='v' then A7_v=1;
else A7_v=0;

if (A9='t') then A9_t=1; else A9_t=0;

if (A10='t') then A10_t=1; else A10_t=0;

if (A12='t') then A12_t=1; else A12_t=0;

if A13 not in ('g' 'p' 's') then call missing (A13_g,A13_p);
else if A13='g' then A13_g=1;
else A13_g=0;
if A13='p' then A13_p=1;
else A13_p=0;

y = a16;

RUN;

PROC CONTENTS DATA = credit;
RUN;

/* Create simple logistic model using single predictor variable */
PROC LOGISTIC  DESCENDING PLOTS=EFFECT PLOTS=ROC; 
MODEL Y = A8 ; 
RUN; quit;
/* Produces 71.6% concordant pairs 
ROC is 0.7267 */


PROC LOGISTIC data=credit DESCENDING PLOTS=EFFECT PLOTS=ROC; 
MODEL Y = a2 a3 a8 a11 a14 a15 a10_t a12_t a13_g a13_p a1_a a4_l a4_u a5_g a5_gg a6_cc a6_d a6_e a6_ff a6_i a6_j a6_k a6_m a6_q a6_r a6_w a6_x a7_bb a7_dd a7_ff a7_h a7_j a7_n a7_o a7_v a9_t  / selection=score best=1 start=1 stop=1; 
RUN;

quit;

PROC LOGISTIC  DESCENDING PLOTS=EFFECT PLOTS=ROC; 
MODEL Y = a9_t ; 
RUN;

quit;

* Make ROC curve with cut-points;
ods graphics on;
proc logistic data=credit descending plots(only)=roc(id=prob);
model Y = A9_t / outroc=roc1;
run;
ods graphics off;

proc print data=roc1; run;quit;


* Make ROC curve with cut-points;
ods graphics on;
proc logistic data=credit descending plots(only)=roc(id=prob);
model Y = A11 / outroc=roc1;
run;
ods graphics off;

proc print data=roc1; run;quit;