******************************************************
***Kodierung der Missing Values in das STATA-Format***
******************************************************

/* Seit ALLBUS 2016 werden die fehlenden Werte nach einem neuen, 
   vereinheitlichten Schema codiert, das auf der Internetseite des ALLBUS 
   http://www.gesis.org/allbus) heruntergeladen werden kann.
   Hierbei sind Zahlenwerte < 0 für fehlende Werte reserviert. 
   In den SPSS-Datensätzen des ALLBUS sind diese Werte als fehlend vordefiniert. 
   In Stata ist es nicht möglich, einen Wertebereich einer Variable als fehlend 
   zu definieren. Stattdessen müssen Werte, die von der Analyse ausgeschlossen 
   werden sollen, auf systemdefiniert fehlende Werte kodiert werden.
   Um auch in den Stata Datensätzen des ALLBUS mit fehlenden Werten arbeiten zu 
   können, ist es nötig die Codes für fehlende Werte in die Stata eigene Missing
   Value Logik zu übersetzen. Dies wird mit diesem Do-File ermöglicht.
   
   Bei Fragen oder Problemen wenden Sie sich gerne an allbus@gesis.org 
   
   GESIS (April 2017) */
 *******************************************************
 
 ********************************
set more off

  
*** Verzeichnis festlegen
*cd "xxx"

*** Datensatz laden
*use "ZAXXXX_vX-X-X.dta"

********************************


foreach var of varlist _all {
	capture confirm numeric var `var'
	  if !_rc {
	 qui: summ `var' if `var' < 0
	  if `r(N)' !=0{
		qui: levelsof `var' if `var' < 0, local(mlist)
			foreach i in `mlist' {
			local content: label `var' `i', strict
			if `i' == -1 { 
			label define `var' .a  "`content'" , modify
			}
			if `i' == -6 { 
			label define `var' .b  "`content'" , modify
			}
			if `i' == -7 { 
			label define `var' .c "`content'" , modify
			}
			if `i' == -8 { 
			label define `var' .d  "`content'" , modify
			}
			if `i' == -9 {
		 	label define `var' .e   "`content'" , modify
			}
			if `i' == -10 {
			label define `var' .f   "`content'" , modify
			}
			if `i' == -11 {
			label define `var' .g   "`content'" , modify
			}
			if `i' == -12 { 
			label define `var' .h "`content'" , modify
			}	
			if `i' == -13 { 
			label define `var'   .i   "`content'" , modify
			}
			if `i' == -14 { 
			label define `var' .j  "`content'" , modify
			}
			if `i' == -15 {		 
			label define `var' .y  "`content'" , modify
			}
			if `i' == -32 { 
			label define `var'  .k   "`content'" , modify
			}	
			if `i' == -33 { 
			label define `var' .l   "`content'" , modify
			}
			if `i' == -34 { 
			label define `var' .m  "`content'" , modify
			}		
			if `i' == -41 { 
			label define `var' .n    "`content'" , modify
			}
			if `i' == -42 {
			label define `var' .z    "`content'", modify
			}
			if `i' == -50  {
			label define `var' .o "`content'" , modify
			}
			if `i' == -51  {
			label define `var' .p "`content'" , modify
			}
			if `i' == -52  {
			label define `var' .q "`content'" , modify
			}
			if `i' == -53  {
			label define `var' .r "`content'" , modify
			}
			if `i' == -54  {
			label define `var' .s "`content'" , modify
			}
			if `i' == -55  {
			label define `var' .t "`content'" , modify
			}
			if `i' == -56  {
			label define `var' .u "`content'" , modify
			}
			if `i' == -57  {
			label define `var' .v "`content'" , modify
			}
			if `i' == -58  {
			label define `var' .w "`content'" , modify
			}
			if `i' == -59  {
			label define `var' .x "`content'" , modify
			}
			}

			}	
qui:	mvdecode `var', mv(-1=.a \-6=.b	\-7=.c	\-8	=.d	\ -9=.e ///
	\ -10=.f \ -11=.g \-12 =.h\-13 =.i \ -14 =.j \ -15=.y ///
	\ -32=.k \ -33=.l \-34 =.m \ -41=.n \ -42=.z ///
	\ -50=.o \ -51=.p \-52 =.q  \ -53=.r\ -54=.s\ -55=.t \ -56=.u \-57=.v \ -58=.w	\ -59=.x)
}
}

exit

