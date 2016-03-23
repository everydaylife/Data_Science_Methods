/* Simple Linear Regression Model */

libname mydata "/courses/d54816e5ba27fe300" access=readonly;

DATA build;
	set mydata.building_prices;
run;

/* Simple model using independent variable with the highest correlation to Y */
proc reg data = build;
	model price = rooms;
	title "Rooms as the Predictor";
run;
quit;

/* Full model build */
proc reg data = build;
	model price = rooms taxes bathrooms lotsize livingspace garagestalls bedrooms age fireplaces;
	title "Multivariate Equation with All Predictors";
run;
quit;

/* Model build optimizing for maximum R-Squared value */
ods graphics on;
proc reg data = build;
	model price = rooms taxes bathrooms lotsize livingspace garagestalls bedrooms age fireplaces/
	selection = rsquare cp adjrsq start=1 stop=1;
	title "RSquare";
run;
quit;
ods graphics off;

/* Model build with first variable selected by R-Square model selection */
ods graphics on;
proc reg data = build;
	model price = taxes;
	title "Taxes as the Predictor";
run;
quit;
ods graphics off;

/* Taxes does not make a good predictor as it's an outcome, not an input for this model */

ods graphics on;
proc reg data = build;
	model price = bathrooms;
	title "Bathrooms as the Predictor";
run;
quit;
ods graphics off;

/* A review of the diagnostic posts shows:
Homes with 1 bathrooms fit less well with this model (outside confidence intervale)
Residuals when the independent variable has a value at 1 shows some heteroscedasticity
Observation 17 shows a high Cook's Distance value and is influential in the model build*/

proc print data = build;
run;