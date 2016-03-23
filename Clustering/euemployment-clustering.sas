TITLE "European Employment";

ODS GRAPHICS ON; * to get scatterplots with high-resolution graphics out of SAS procedures;

libname mydata "/courses/d54816e5ba27fe300" access=readonly  ; 

DATA European;
SET mydata.european_employment ;

PROC print DATA = European;
RUN;

/* Create clusters algorithmically using 2 selected variables from EDA 
PROC CLUSTER performs hierarchical clustering, no need to specify number of clusters in advance*/
ods graphics on;
proc cluster data=European method=average outtree=tree4 pseudo ccc plots=all;
var fin ser;
id country;
run; quit;
ods graphics off;

/* Clustering Measures Explained
CCC: Cubic clustering criterion measures deviation of clusters from expected distribution if the data points were from a uniform distribution. 
Larger positive CC values are better but if variables are correlated CCC can be incorrect. In the example below, CC is optimized at 5 clusters.

Pseudo F: Ratio of the mean sum of squares between groups vs. mean sum of squares within a group. 
Measures the tightness of clusters and a larger value is better. The Pseudo F peaks at 5 clusters.

Pseudo T-Squared: The difference between two clusters that are merged at a specific step. 
If it jumps at k, then k+1 is the optimal selection. In the example below, there is a jump at 2 clusters meaning 3 is the optimal selection.


/* Use PROC TREE to assign observations to a set number of clusters */
ods graphics on;
proc tree data=tree4 ncl=4 out=_4_clusters; 
copy fin ser;
run; quit;

proc tree data=tree4 ncl=3 out=_3_clusters; 
copy fin ser;
run; quit;
ods graphics off;

/* Macro to make tables showing with observation goes with which cluster */
%macro makeTable(treeout,group,outdata);
data tree_data;
set &treeout.(rename=(_name_=country));
run;
proc sort data=tree_data; by country; run; quit;
data group_affiliation;
set &group.(keep=group country);
run;
proc sort data=group_affiliation; by country; run; quit;
data &outdata.;
merge tree_data group_affiliation;
by country;
run;
proc freq data=&outdata.;
table group*clusname / nopercent norow nocol;
run;
%mend makeTable;

/* Call macro */
%makeTable(treeout=_3_clusters,group=European,outdata=_3_clusters_with_labels);
%makeTable(treeout=_4_clusters,group=European,outdata=_4_clusters_with_labels);

* Plot the clusters visually;

ods graphics on;
proc sgplot data=_3_clusters_with_labels;
title 'Scatterplot of Raw Data';
scatter y=fin x=ser / datalabel=country group=clusname;
run; quit;
ods graphics off;

* Plot the clusters visually;
ods graphics on;
proc sgplot data=_4_clusters_with_labels;
title 'Scatterplot of Raw Data';
scatter y=fin x=ser / datalabel=country group=clusname;
run; quit;
ods graphics off;