/* Multiple Linear Regression */

libname mydata "/courses/d54816e5ba27fe300" access=readonly;

DATA build;
	set mydata.building_prices;
run;

/* Part 1: Select Baseline Model */
ods graphics on;
proc reg data = build;
	model price = rooms taxes bathrooms lotsize livingspace garagestalls bedrooms age fireplaces/
	selection = rsquare cp adjrsq start=1 stop=1;
	title "RSquare";
run;
quit;
ods graphics off;

/* Part 2: Forward Selection */
ods graphics on;
proc reg data = build plots(only) = (rsquare adjrsq cp);
	model price = lotsize livingspace age /
	selection = forward;
	title "Forward";
run;
quit;
ods graphics off;

/* Part 3a: Backward Selection  */
ods graphics on;
proc reg data = build plots(only) = (rsquare adjrsq cp);
	model price = lotsize livingspace age /
	selection = backward;
	title "Backward";
run;
quit;
ods graphics off;

/* Part 3b: Backward and Stepwise Selection  */
ods graphics on;
proc reg data = build plots(only) = (rsquare adjrsq cp);
	model price = lotsize livingspace age /
	selection = stepwise;
	title "Stepwise";
run;
quit;
ods graphics off;

/* Forward and stepwise selection choose the same variables 
Also have the best Mallows' criteria score of 4
The C(p) should be less than or equal to number of parameters in the model 
Examine model diagnostics and variance inflation factors (VIF) */

ods graphics on;

proc reg data = build plots(unpack) = (diagnostics residualplot);
	model price = taxes livingspace /
    selection = rsquare cp adjrsq;
	title "Multiple Regression Model";
run;
quit;
ods graphics off;

ods graphics on;
proc reg data = build plots(unpack) = (diagnostics residualplot);
	model price = lotsize livingspace age /
	selection = forward;
	title "Forward Selection Plots";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(unpack) = (diagnostics residualplot);
	model price = lotsize livingspace age /
    selection =forward vif tol;
	title "Multiple Regression Model with VIF";
run;
quit;
ods graphics off;

/* Model fit is okay; predicting a bit low for higher value homes
VIF is 2 so no evidence of multicollinearity */

/* Introduce dummy variables for discrete values to treat as categorical */

data build;
	set mydata.building_prices;	
	if (bedrooms=2) then bed2_dummy=1;
		else bed2_dummy=0;
	if (bedrooms=3) then bed3_dummy=1;
	else bed3_dummy=0;
	if (bedrooms=4) then bed4_dummy=1;
	else bed4_dummy=0;
run;

ods graphics on;

proc reg data = build;
	model price = bed2_dummy bed3_dummy bed4_dummy;
	title "All Bedrooms Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build;
	model price = bed3_dummy bed4_dummy;
	title "2 Variable Bedrooms Dummy Model";
run;
quit;
ods graphics off;

proc sort data = build out=bedroomsbuild;
	by bedrooms;
run;

proc means data = bedroomsbuild;
	by bedrooms;
	var price;
	title "Bedrooms Mean Price";
run;
quit;

/* The mean of each dummy variable is reflected in its coefficient */

/* Code dummy variables for all categorical varaibles in the dataset
Regenerate models using variety of forward, backward, stepwise, adj. r-squared selection */

data build;
	set mydata.building_prices;	
	if (bedrooms=2) then bed2_dummy=1;
		else bed2_dummy=0;
	if (bedrooms=3) then bed3_dummy=1;
		else bed3_dummy=0;
	if (bedrooms=4) then bed4_dummy=1;
		else bed4_dummy=0;

	if (bathrooms=1) then bath1_dummy=1;
		else bath1_dummy=0;
	if (bathrooms=1.5) then bath15_dummy=1;
		else bath15_dummy=0;

	if (garagestalls=1) then gs2_dummy=1;
		else gs2_dummy=0;
	if (garagestalls=1.5) then gs3_dummy=1;
		else gs3_dummy=0;
	if (garagestalls=2) then gs4_dummy=1;
		else gs4_dummy=0;

	if (fireplaces=0) then fp0_dummy=1;
		else fp0_dummy=0;
	if (fireplaces=1) then fp1_dummy=1;
		else fp1_dummy=0;

	if (rooms=5) then rooms5_dummy=1;
		else rooms5_dummy=0;
	if (rooms=6) then rooms6_dummy=1;
		else rooms6_dummy=0;
	if (rooms=7) then rooms7_dummy=1;
		else rooms7_dummy=0;
	if (rooms=8) then rooms8_dummy=1;
		else rooms8_dummy=0;

run;

ods graphics on;

proc reg data = build;
	model price = lotsize livingspace age bed2_dummy -- rooms8_dummy;
	title "All Bedrooms Dummy Model";
run;
quit;
ods graphics off;

proc reg data = build plots(unpack) = (diagnostics residualplot);
	model price = lotsize livingspace age bed2_dummy -- rooms8_dummy/
    selection = rsquare cp adjrsq;
	title "Adjusted R-Squared Multiple Regression Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(only) = (rsquare adjrsq cp);
	model price = lotsize livingspace age bed2_dummy -- rooms8_dummy /
	selection = forward;
	title "Forward All Bedrooms Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(only) = (rsquare adjrsq cp);
	model price = lotsize livingspace age bed2_dummy -- rooms8_dummy /
	selection = backward;
	title "Backward All Bedrooms Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(only) = (rsquare adjrsq cp);
	model price = lotsize livingspace age bed2_dummy -- rooms8_dummy /
	selection = stepwise;
	title "Stepwise All Bedrooms Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build;
	model price = lotsize bed4_dummy bath15_dummy gs3_dummy gs4_dummy
	/ vif tol;
	title "Other Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build;
	model price = lotsize bath15_dummy gs3_dummy gs4_dummy
	/ vif tol;
	title "Four Variable Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(unpack) = (diagnostics residualplot);
	model price = lotsize bed4_dummy bath15_dummy gs3_dummy gs4_dummy
	/ vif tol;
	title "Other Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(unpack) = (diagnostics residualplot);
	model price = lotsize bath15_dummy gs3_dummy gs4_dummy
	/ vif tol;
	title "Four Variable Dummy Model";
run;
quit;
ods graphics off;

/* A five variable model gives better metrics and residuals */

/* Repeat modelling steps, but using taxes instead of price as the independent variable */
ods graphics on;

proc reg data = build;
	model taxes = price lotsize livingspace age bed2_dummy -- rooms8_dummy;
	title "All Bedrooms Dummy Model";
run;
quit;
ods graphics off;

proc reg data = build plots(unpack) = (diagnostics residualplot);
	model taxes = price lotsize livingspace age bed2_dummy -- rooms8_dummy/
    selection = rsquare cp adjrsq;
	title "Adjusted R-Squared Multiple Regression Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(only) = (rsquare adjrsq cp);
	model taxes = price lotsize livingspace age bed2_dummy -- rooms8_dummy /
	selection = forward;
	title "Forward All Bedrooms Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(only) = (rsquare adjrsq cp);
	model taxes = price lotsize livingspace age bed2_dummy -- rooms8_dummy /
	selection = backward;
	title "Backward All Bedrooms Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(only) = (rsquare adjrsq cp);
	model price = lotsize livingspace age bed2_dummy -- rooms8_dummy /
	selection = stepwise;
	title "Stepwise All Bedrooms Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build;
	model taxes = price age rooms6_dummy rooms8_dummy
	/ vif tol;
	title "Four Variable R Square Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build;
	model taxes = price age bed2_dummy rooms6_dummy rooms7_dummy
	/ vif tol;
	title "Backward Variable Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build;
	model taxes = lotsize bed4_dummy bath15_dummy gs3_dummy gs4_dummy
	/ vif tol;
	title "Stepwise Variable Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(unpack) = (diagnostics residualplot);
	model taxes = price age rooms6_dummy rooms8_dummy
	/ vif tol;
	title "Four Variable R Square Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(unpack) = (diagnostics residualplot);
	model taxes = price age bed2_dummy rooms6_dummy rooms7_dummy
	/ vif tol;
	title "Backward Variable Dummy Model";
run;
quit;
ods graphics off;

ods graphics on;

proc reg data = build plots(unpack) = (diagnostics residualplot);
	model taxes = lotsize bed4_dummy bath15_dummy gs3_dummy gs4_dummy
	/ vif tol;
	title "Stepwise Variable Dummy Model";
run;
quit;
ods graphics off;