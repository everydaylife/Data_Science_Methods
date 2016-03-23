/* Exploratory data analysis of a dataset of building prices */

libname build "/courses/d54816e5ba27fe300" access=readonly; 

DATA temp; 
	set build.building_prices;
run;

/* Pearson correlation coefficients and scatterplot matrix of variables */
ods graphics on;
title 'Building Prices';
proc corr data=temp plot=matrix(histogram nvar=all);
run;
ods graphics off;

/* Build a variety of visuals */
ods graphics on;
title 'Scatterplot of Taxes';
proc corr data=temp plot= (scatter matrix);
	var taxes;
	with price;
	Title 'Scatterplot of Taxes';
run;
ods graphics off;

ods graphics on;
title 'Scatterplot of Building Bathrooms';
proc corr data=temp plot= (scatter matrix);
	var bathrooms;
	with price;
	Title 'Scatterplot of Building Bathrooms';
run;
ods graphics off;

ods graphics on;
proc sgplot data=temp;
	title "Age Boxplot";
	hbox price / category=age;
run;
ods graphics off;

ods graphics on;
title 'Comparison of Building Age to Price';
proc sgplot data=temp;
	scatter x = age y = price;
	title 'Comparison of Building Age to Price'
ods graphics off;

ods graphics on;
title 'Scatterplot of Building x';
proc corr data=temp plot= (scatter matrix);
	var bedrooms;
	with price;
	Title 'Scatterplot of Building x';
run;
ods graphics off;