TITLE "European Employment";

ODS GRAPHICS ON; * to get scatterplots with high-resolution graphics out of SAS procedures;

libname mydata "/courses/d54816e5ba27fe300" access=readonly  ; 

DATA European;
SET mydata.european_employment ;

PROC print DATA = European;
RUN;

ods graphics on;
title 'Euro';
proc corr data=European plot=matrix(histogram nvar=all);
run;
ods graphics off;

data temp;
set mydata.european_employment;
run;

ods graphics on;
proc sgplot data=temp;
title 'Scatterplot of Raw Data';
scatter y=man x=sps / datalabel=country group=group;
run; quit;
ods graphics off;
