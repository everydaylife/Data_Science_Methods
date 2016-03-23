/* Multiple Logistic Regressio Model */

TITLE "Credit Model";
TITLE2 "Data Read in from Credit Library"; 
ODS GRAPHICS ON;

libname mydata "/courses/d54816e5ba27fe300" access=readonly; 

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

data credit;
	set credit;
	u=uniform(123);
	if (u<0.7) then train=1; else train=0;
	/* train = 0 means part of test set */
	if (train=1) then Y_train=Y; else Y_train=.;	
run;

proc logistic data=credit descending;
model Y_train = A2 A3 A8 A11 A14 A15
	A1_a A4_u A5_g A6_k A6_m A6_q A6_w A6_x A7_bb A7_ff A7_h A7_v
	A9_t A10_t A12_t A13_g / selection=backward;
output out=model_data1 pred=yhat;
run;



DATA credit;
	set model_data1 ;
	if (yhat<0.5) then predgroup=0 ; else predgroup=1 ;
run ;

Proc sort DATA=credit ;
    by train ;

PROC FREQ DATA=credit ;
    TABLES  Y  predgroup   Y*predgroup ;
    by train ;
run ;
quit;

TITLE "Credit Model #2";
proc logistic data=credit descending;
model Y_train = A9_t A2 A3 ;
output out=model_data2 pred=yhat;
run;


DATA credit ;
	set model_data2 ;
	if (yhat<0.5) then predgroup=0 ; else predgroup=1 ;
run ;

Proc sort DATA=credit ;
    by train ;

PROC FREQ DATA=credit ;
    TABLES  Y  predgroup   Y*predgroup ;
    by train ;
run ;
quit;

TITLE "Credit Model #3";
proc logistic data=credit descending;
model Y_train = A2 A3 A8 A11 A14 A15
	A1_a A4_u A5_g A6_k A6_m A6_q A6_w A6_x A7_bb A7_ff A7_h A7_v
	A9_t A10_t A12_t A13_g / selection=stepwise;
output out=model_data3 pred=yhat;
run;

TITLE "Credit Model #4 drop A15";
proc logistic data=credit descending;
model Y_train = a8 a9_t a10_t ;
output out=model_data4 pred=yhat;
run;

TITLE "Credit Model #5 drop a15 add A11";
proc logistic data=credit descending;
model Y_train = a8 a9_t a10_t a11 ;
output out=model_data5 pred=yhat;
run;

TITLE "Credit Model #6 add A11";
proc logistic data=credit descending;
model Y_train = a8 a9_t a10_t a11 a15 ;
output out=model_data6 pred=yhat;
run;

TITLE "Credit Model #7 add A11 drop a10_t";
proc logistic data=credit descending;
model Y_train = a8 a9_t a11 a15 ;
output out=model_data7 pred=yhat;
run;

* The descending option assigns the highest model scores to the lowest score_decile;
proc rank data=model_data7 out=training_scores descending groups=10;
var yhat;
ranks score_decile;
where train=1;
run;

/* To create the lift chart*/
proc means data=training_scores sum;
class score_decile;
var Y;
output out=pm_out sum(Y)=Y_Sum;
run;

proc print data=pm_out; run;

data lift_chart;
	set pm_out (where=(_type_=1));
	by _type_;
	Nobs=_freq_;
	score_decile = score_decile+1;
	
	if first._type_ then do;
		cum_obs=Nobs;
		model_pred=Y_Sum;
	end;
	else do;
		cum_obs=cum_obs+Nobs;
		model_pred=model_pred+Y_Sum;
	end;
	retain cum_obs model_pred;
	
	* 203 represents the number of successes; 
	* This value will need to be changed with different samples;
	pred_rate=model_pred/205; 
	base_rate=score_decile*0.1;
	lift = pred_rate-base_rate;
	
	drop _freq_ _type_ ;
run;

proc print data=lift_chart; run;

ods graphics on;
title 'In-Sample Lift Chart';
symbol1 color=red interpol=join value=dot height=1;
symbol2 color=black interpol=join value=dot height=1;
proc gplot data=lift_chart;
plot pred_rate*base_rate base_rate*base_rate /overlay ;
run; quit;
ods graphics off;

DATA credit ;
	set model_data7 ;
	if (yhat<0.5) then predgroup=0 ; else predgroup=1 ;
run ;

Proc sort DATA=credit ;
    by train ;

PROC FREQ DATA=credit ;
    TABLES  Y  predgroup   Y*predgroup ;
    by train ;
run ;


TITLE "Descending Model 2";
proc logistic data=credit descending;
model Y_train = A9_t A2 A3 ;
output out=model_data2 pred=yhat;
run;


