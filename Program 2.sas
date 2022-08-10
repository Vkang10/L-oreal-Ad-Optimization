libname proj2 '/home/u59289493/BUMK742/Project 2';

data temp;    /* You can give any name for the temporary data file */
set proj2.printads;

/* create a dummy variable for the L'Oreal ad */
if brand='LOreal' then loreal=1;
else loreal=0;

/* create a variable for brand length */
brandlength=length(brand);
run;

*means;
proc means;
var brand_fix pic_fix;
class page_pos;
run;

proc means;
var recall_accu;
class page_pos;
run;

proc means;
var brand_fix pic_fix page_num;
class recall_accu;
run;

proc means;
 var recall_time;
run;

/*distribution*/
PROC UNIVARIATE DATA=temp  PLOT;
	VAR page_num;
RUN;
PROC sgplot DATA=temp;
	histogram page_num;
RUN;

PROC UNIVARIATE DATA=temp  PLOT;
	VAR brand_size;
RUN;
PROC sgplot DATA=temp;
	histogram brand_size;
RUN;

PROC UNIVARIATE DATA=temp  PLOT;
	VAR pic_size;
RUN;
PROC sgplot DATA=temp;
	histogram pic_size;
RUN;

*correlation;
proc corr;
var brand_fix brand_size page_num;
run;

proc corr;
var pic_fix pic_size page_num;
run;

/*means between loreal and other brand*/
proc means;
var brand_fix brand_size pic_fix pic_size page_num page_pos recall_time recall_accu brandlength;
class loreal;
run;

/* Poisson Regression Models */

/* For BRAND_FIX: fixation counts of the brand element */ 
proc genmod data=temp;
     model brand_fix=brand_size page_pos page_num loreal brandlength/
           dist=poisson link=log;
     title 'Poission Regression for brand fixation count';

/* For PIC_FIX: fixation counts of the pictorial element */ 
proc genmod data=temp;
     model pic_fix=pic_size page_pos page_num loreal/
           dist=poisson link=log;
     title 'Poission Regression for pictorial fixation count';

/* Binary Logit Model */
proc genmod data=temp descending;
     model recall_accu=brand_fix pic_fix page_pos page_num loreal brandlength RECALL_TIME brandlength*RECALL_TIME/
	       dist=binomial link=logit;
     title 'Binary Logit Model for Recall Accuracy = 1';
run;

proc genmod data=temp descending;
     model recall_accu=brand_fix pic_fix page_pos page_num loreal brandlength RECALL_TIME RECALL_TIME*RECALL_TIME brandlength*RECALL_TIME/
	       dist=binomial link=logit;
     title 'Binary Logit Model for Recall Accuracy = 1';
run;

proc genmod data=temp descending;
     model recall_accu=brand_fix pic_fix page_pos page_num loreal RECALL_TIME/
	       dist=binomial link=logit;
     title 'Binary Logit Model for Recall Accuracy = 1';
run;

