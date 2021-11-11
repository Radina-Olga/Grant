*загружаем датасет
clear all
set excelxlsxlargefile on
import excel "/Users/stanislavradin/Downloads/other_1.xlsx", sheet("result") firstrow
des
duplicate drop 

*создаем подвыборку
sample 10 if poluch_dummy==0
sum

*Descriptive
tabstat SUB14 OR14 COST14 FA14 EMP14 TFP14 dummyokved1 reg1 reg2 reg3 reg4 size1 size2 size3 ruown, by(dummy14) stat(mean)
tabstat SUB15 OR15 COST15 FA15 EMP15 TFP15 dummyokved1 reg1 reg2 reg3 reg4 size1 size2 size3 ruown, by(dummy15) stat(mean)
tabstat SUB16 OR16 COST16 FA16 TFP16 EMP16 dummyokved1 reg1 reg2 reg3 reg4 size1 size2 size3 ruown, by(dummy16) stat(mean)
tabstat SUB17 OR17 COST17 FA17 TFP17 EMP17 dummyokved1 reg1 reg2 reg3 reg4 size1 size2 size3 ruown, by(dummy17) stat(mean)
tabstat SUB18 OR18 COST18 FA18 TFP18 EMP18 dummyokved1 reg1 reg2 reg3 reg4 size1 size2 size3 ruown, by(dummy18) stat(mean)
tabstat SUB19 OR19 COST19 FA19 TFP19 EMP19 dummyokved1 reg1 reg2 reg3 reg4 size1 size2 size3 ruown, by(dummy19) stat(mean)


*Оквэд
encode okved, gen(nokved)
gen first_two_digits = substr(okved, 1, 2)
gen first_three_digits = substr(okved, 1, 3)
gen dummyokved=.
replace dummyokved = 1 if first_two_digits == "21" | first_two_digits == "26" | first_two_digits == "20" | first_two_digits == "27"| first_two_digits == "28" | first_two_digits == "29" | first_two_digits == "30" | first_two_digits == "33"
replace dummyokved = 1 if first_two_digits == "50" | first_two_digits == "51" | first_two_digits == "61" | first_two_digits == "62"| first_two_digits == "63" | first_two_digits == "64" | first_two_digits == "65" | first_two_digits == "66" | first_two_digits == "69" | first_two_digits == "70" | first_two_digits == "71" | first_two_digits == "72" | first_two_digits == "75" | first_two_digits == "78" | first_two_digits == "85" | first_two_digits == "86" | first_two_digits == "87" | first_two_digits == "88"
replace dummyokved = 1 if first_three_digits== "303"| first_three_digits== "325"
replace dummyokved = 0 if dummyokved==.
rename dummyokved dummyokved1
rename dummyokved1 high_tech

gen agricultural=.
replace agricultural=0 if maincode!=""
replace agricultural=1 if maincode=="A"

gen mineral=.
replace mineral=0 if maincode!=""
replace mineral=1 if maincode=="B"

gen manufacture=.
replace manufacture=0 if maincode!=""
replace manufacture=1 if maincode=="C"

gen energy=.
replace energy=0 if maincode!=""
replace energy=1 if maincode=="D"

gen garbage=.
replace garbage=0 if maincode!=""
replace garbage=1 if maincode=="E"

gen building=.
replace building=0 if maincode!=""
replace building=1 if maincode=="F"

gen trade_repair=.
replace trade_repair=0 if maincode!=""
replace trade_repair=1 if maincode=="G"

gen trans=.
replace trans=0 if maincode!=""
replace trans=1 if maincode=="H"

gen hotel=.
replace hotel=0 if maincode!=""
replace hotel=1 if maincode=="I"

gen info=.
replace info=0 if maincode!=""
replace info=1 if maincode=="J"

gen science=.
replace science=0 if maincode!=""
replace science=1 if maincode=="M"

*регионы по отр. диверс. по 4 
//удаляем нулевые регионы
count if region=="0"
drop if region=="0"
gen reg_dum = 4
replace reg_dum = 1 if region == "99" | region == "77" | region == "78" | region == "86" | region == "89" | region == "50" |region == "65" | region == "72" | region == "14" | region == "11"
replace reg_dum = 2 if region == "16" | region == "66" | region == "47" | region == "2" | region == "63" | region == "31" | region == "24" | region == "59" | region == "52" | region == "48" | region == "61" | region == "74" | region == "42" | region == "35" | region == "54" | region == "38" | region == "51" | region == "55" | region == "70" | region == "76" | region == "53"
replace reg_dum = 3 if region == "5" | region == "28" | region == "49" | region == "20" | region == "75" | region == "87" | region == "1" | region == "9" | region == "8" | region == "7" | region == "4" | region == "6" | region == "17" | region == "79"
tabulate reg_dum

gen reg1=0
replace reg1=1 if reg_dum==1
gen reg2=0
replace reg2=1 if reg_dum==2
gen reg3=0
replace reg3=1 if reg_dum==3
gen reg4=0
replace reg4=1 if reg_dum==4

rename reg1 high_dev_region
rename reg2 dev_region
rename reg3 medium_dev_region
rename reg4 poorly_dev_region

*Возраст
gen age_1=0
replace age_1=1 if Age<=21
gen age_3=0
replace age_3=1 if Age>31
gen age_2=0
replace age_2=1 if age_1==0 & age_3==0
rename age_1 age_2000
rename age_2 age_1990_2000
rename age_3 age_1990

*Размер по выручке
gen size_or=.
replace size_or=1 if OR19<=800000000
replace size_or=2 if OR19>800000000 & OR19<=2000000000
replace size_or=3 if OR19>2000000000 
replace size_or=. if OR19==.

*Размер по кол-ву работников
gen size_emp=.
replace size_emp=1 if EMP19<=100
replace size_emp=2 if EMP19>100 & EMP19<=250
replace size_emp=3 if EMP19>250 & EMP19<=600
replace size_emp=4 if EMP19>600
replace size_emp=. if EMP19==.

gen small=0
replace small=1 if size_emp==1
replace small=. if size_emp==.

gen medium=0
replace medium=1 if size_emp==2
replace medium=. if size_emp==.

gen big=0
replace big=1 if size_emp==3
replace big=. if size_emp==.

gen giant=0
replace giant=1 if size_emp==4
replace giant=. if size_emp==.

*Доля субсдии от выручки
gen sub14 = SUB14/OR14
gen sub15 = SUB15/OR15
gen sub16 = SUB16/OR16
gen sub17 = SUB17/OR17

*log выручки
gen lnor14 = log(OR14)
gen lnor15 = log(OR15)
gen lnor16 = log(OR16)
gen lnor17 = log(OR17)
gen lnor18 = log(OR18)

*Логарифмы для регрессий
gen lnsub14 = log(sub14)
gen lnsub15 = log(sub15)
gen lnsub16 = log(sub16)
gen lnsub17 = log(sub17)

gen lntfp14 = log(TFP14)
gen lntfp15 = log(TFP15)
gen lntfp16 = log(TFP16)
gen lntfp17 = log(TFP17)
gen lntfp18 = log(TFP18)

gen lnemp14 = log(EMP14)
gen lnemp15 = log(EMP15)
gen lnemp16 = log(EMP16)
gen lnemp17 = log(EMP17)
gen lnemp18 = log(EMP18)

gen lntax14 = log(TAX14)
gen lntax15 = log(TAX15)
gen lntax16 = log(TAX16)
gen lntax17 = log(TAX17)
gen lntax18 = log(TAX18)

gen lnwage14 = log(WAGE2014)
gen lnwage15 = log(WAGE2015)
gen lnwage16 = log(WAGE2016)
gen lnwage17 = log(WAGE2017)
gen lnwage18 = log(WAGE2018)

gen lnrent14 = log(RENT14)
gen lnrent15 = log(RENT15)
gen lnrent16 = log(RENT16)
gen lnrent17 = log(RENT17)
gen lnrent18 = log(RENT18)


*создаем переменные роста выручки
gen gror1416 = (OR16-OR14)/OR14
gen gror1517 = (OR17-OR15)/OR15
gen gror1618 = (OR18-OR16)/OR16
gen gror1719 = (OR19-OR17)/OR17
**log от роста выручки
gen lngror1416 = log(gror1416)
gen lngror1517 = log(gror1517)
gen lngror1618 = log(gror1618)
gen lngror1719 = log(gror1719)
hist lngror1416

*Дамми по годам
gen dummy14=1
replace dummy14=0 if SUB14==0
replace dummy14=0 if SUB14==.

gen dummy15=1
replace dummy15=0 if SUB15==0
replace dummy15=0 if SUB15==.

gen dummy16=1
replace dummy16=0 if SUB16==0
replace dummy16=0 if SUB16==.
 
gen dummy17=1
replace dummy17=0 if SUB17==0
replace dummy17=0 if SUB17==.

gen dummy18=1
replace dummy18=0 if SUB18==0
replace dummy18=0 if SUB18==.

gen dummy19=1
replace dummy19=0 if SUB19==0
replace dummy19=0 if SUB19==.

rename dummy14 recipient14
rename dummy15 recipient15
rename dummy16 recipient16
rename dummy17 recipient17
rename dummy18 recipient18
rename dummy19 recipient19

*Создание переменной СФП
reshape long SUB OR EMP FA, i(TaxnumberINNTaxBIN) j(year)
xtset newid year
xtreg lnor lnfa lnemp
predict comb_res, ue
hist comb_res
reshape wide SUB OR EMP FA comb_res, i(TaxnumberINNTaxBIN) j(year)

gen tfp1416=(comb_res16-comb_res14)/comb_res14
gen tfp1517=(comb_res17-comb_res15)/comb_res15
gen tfp1618=(comb_res18-comb_res16)/comb_res16
gen tfp1719=(comb_res19-comb_res17)/comb_res17

gen TFP1416=(TFP16-TFP14)/TFP14
gen lntfp1416 = log(TFP1416)
gen TFP1517=(TFP17-TFP15)/TFP15
gen lntfp1517 = log(TFP1517)
gen TFP1618=(TFP18-TFP16)/TFP16
gen lntfp1618 = log(TFP1618)
gen TFP1719=(TFP17-TFP19)/TFP17
gen lntfp1719 = log(TFP1719)



/// PSM ///
//загружаем пакеты
findit pscore
findit psmatch2
//установка случайного поряжка наблюдений
set seed 123456
gen x=uniform()
sort x

**Dummy Export
gen dummyexp14=.
gen dummyexp15=.
gen dummyexp16=.
gen dummyexp17=.
replace dummyexp14=1 if EXP13>0 & EXP13!=. | EXP14>0 & EXP14!=.
replace dummyexp15=1 if EXP13>0 & EXP13!=. | EXP14>0 & EXP14!=. | EXP15>0 & EXP15!=.
replace dummyexp16=1 if EXP13>0 & EXP13!=. | EXP14>0 & EXP14!=. | EXP15>0 & EXP15!=. | EXP16>0 & EXP16!=.
replace dummyexp17=1 if EXP13>0 & EXP13!=. | EXP14>0 & EXP14!=. | EXP15>0 & EXP15!=. | EXP16>0 & EXP16!=. | EXP17>0 & EXP17!=.
replace dummyexp14=0 if dummyexp14==.
replace dummyexp15=0 if dummyexp15==.
replace dummyexp16=0 if dummyexp16==.
replace dummyexp17=0 if dummyexp17==.
gen dummyexp18=dummyexp17

**Рентабельность
gen RENT14= PROF14/OR14
gen RENT15= PROF15/OR15
gen RENT16= PROF16/OR16
gen RENT17= PROF17/OR17
gen RENT18= PROF18/OR18
gen RENT19= PROF19/OR19
**Growth RENT
gen grrent1416= (RENT16-RENT14)/RENT14
gen grrent1517= (RENT17-RENT15)/RENT15
gen grrent1618= (RENT18-RENT16)/RENT16
gen grrent1719= (RENT19-RENT17)/RENT17
**Log growth rent
gen lnrent1416=log(grrent1416)
gen lnrent1517=log(grrent1517)
gen lnrent1618=log(grrent1618)
gen lnrent1719=log(grrent1719)

**Wage
gen grwage1416 = (WAGE2016-WAGE2014)/WAGE2014
gen grwage1517 = (WAGE2017-WAGE2015)/WAGE2015
gen grwage1618 = (WAGE2018-WAGE2016)/WAGE2016
gen grwage1719 = (WAGE2019-WAGE2017)/WAGE2017
gen lnwage1416 = log(grwage1416)
gen lnwage1517 = log(grwage1517)
gen lnwage1618 = log(grwage1618)
gen lnwage1719 = log(grwage1719)

**Employees
gen gremp1416 = (EMP16-EMP14)/EMP14
gen gremp1517 = (EMP17-EMP15)/EMP15
gen gremp1618 = (EMP18-EMP16)/EMP16
gen gremp1719 = (EMP19-EMP17)/EMP17
gen lnemp1416 = log(gremp1416)
gen lnemp1517 = log(gremp1517)
gen lnemp1618 = log(gremp1618)
gen lnemp1719 = log(gremp1719)

**Taxes
gen grtax1416 = (TAX16-TAX14)/TAX14
gen grtax1517 = (TAX17-TAX15)/TAX15
gen grtax1618 = (TAX18-TAX16)/TAX16
gen grtax1719 = (TAX19-TAX17)/TAX17
gen lntax1416 = log(grtax1416)
gen lntax1517 = log(grtax1517)
gen lntax1618 = log(grtax1618)
gen lntax1719 = log(grtax1719)

/// ХЕКМАН ///
**3 периода
// ВЫРУЧКА//
eststo h1417: quietly heckman lngror1417 lnor14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form)
eststo h1518: quietly heckman lngror1518 lnor15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form)
eststo h1619: quietly heckman lngror1619 lnor16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form)
esttab h1417, se mtitles nogaps
esttab h1518, se mtitles nogaps
esttab h1619, se mtitles nogaps 

// TAXES//
eststo h1417: quietly heckman lntax1417 lntax14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form)
eststo h1518: quietly heckman lntax1518 lntax15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1619: quietly heckman lntax1619 lntax16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) 
esttab h1417, se mtitles nogaps
esttab h1518, se mtitles nogaps
esttab h1619, se mtitles nogaps

// Employees//
eststo h1417: quietly heckman lnemp1417 lnemp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1518: quietly heckman lnemp1518 lnemp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1619: quietly heckman lnemp1619 lnemp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1417, se mtitles nogaps
esttab h1518, se mtitles nogaps
esttab h1619, se mtitles nogaps

//Rent//
eststo h1417: quietly heckman lnrent1417 lnrent14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1518: quietly heckman lnrent1518 lnrent15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1619: quietly heckman lnrent1619 lnrent16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1417, se mtitles nogaps
esttab h1518, se mtitles nogaps
esttab h1619, se mtitles nogaps

//TFP//
eststo h1417: quietly heckman lntfp1417 lntfp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1518: quietly heckman lntfp1518 lntfp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1619: quietly heckman lntfp1619 lntfp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1417, se mtitles nogaps
esttab h1518, se mtitles nogaps
esttab h1619, se mtitles nogaps

//Wage//
eststo h1417: quietly heckman lnwage1417 lnwage14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1518: quietly heckman lnwage1518 lnwage15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1619: quietly heckman lnwage1619 lnwage16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1417, se mtitles nogaps
esttab h1518, se mtitles nogaps
esttab h1619, se mtitles nogaps

**4 периода
// ВЫРУЧКА//
eststo h1416: quietly heckman lngror1416 lnor14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1517: quietly heckman lngror1517 lnor15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1618: quietly heckman lngror1618 lnor16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1719: quietly heckman lngror1719 lnor17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1416, se mtitles nogaps
esttab h1517, se mtitles nogaps
esttab h1618, se mtitles nogaps 
esttab h1719, se mtitles nogaps

// TAXES//
eststo h1416: quietly heckman lntax1416 lntax14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1517: quietly heckman lntax1517 lntax15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1618: quietly heckman lntax1618 lntax16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1719: quietly heckman lntax1719 lntax17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1416, se mtitles nogaps
esttab h1517, se mtitles nogaps
esttab h1618, se mtitles nogaps
esttab h1719, se mtitles nogaps

// Employees//
eststo h1416: quietly heckman lnemp1416 lnemp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1517: quietly heckman lnemp1517 lnemp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1618: quietly heckman lnemp1618 lnemp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1719: quietly heckman lnemp1719 lnemp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1416, se mtitles nogaps
esttab h1517, se mtitles nogaps
esttab h1618, se mtitles nogaps
esttab h1719, se mtitles nogaps

//Rent//
eststo h1416: quietly heckman lnrent1416 lnrent14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1517: quietly heckman lnrent1517 lnrent15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1618: quietly heckman lnrent1618 lnrent16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1719: quietly heckman lnrent1719 lnrent17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1416, se mtitles nogaps
esttab h1517, se mtitles nogaps
esttab h1618, se mtitles nogaps
esttab h1719, se mtitles nogaps

//TFP//
eststo h1416: quietly heckman lntfp1416 lntfp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1517: quietly heckman lntfp1517 lntfp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1618: quietly heckman lntfp1618 lntfp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1719: quietly heckman lntfp1719 lntfp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1416, se mtitles nogaps
esttab h1517, se mtitles nogaps
esttab h1618, se mtitles nogaps
esttab h1719, se mtitles nogaps

//Wage//
eststo h1416: quietly heckman lnwage1416 lnwage14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1517: quietly heckman lnwage1517 lnwage15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1618: quietly heckman lnwage1618 lnwage16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1719: quietly heckman lnwage1719 lnwage17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1416, se mtitles nogaps
esttab h1517, se mtitles nogaps
esttab h1618, se mtitles nogaps
esttab h1719, se mtitles nogaps

**5 периода
// ВЫРУЧКА//
eststo h1415: quietly heckman lngror1415 lnor14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1516: quietly heckman lngror1516 lnor15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1617: quietly heckman lngror1617 lnor16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1718: quietly heckman lngror1718 lnor17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1819: quietly heckman lngror1819 lnor18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1415, se mtitles nogaps
esttab h1516, se mtitles nogaps
esttab h1617, se mtitles nogaps 
esttab h1718, se mtitles nogaps
esttab h1819, se mtitles nogaps

// TAXES//
eststo h1415: quietly heckman lntax1415 lntax14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1516: quietly heckman lntax1516 lntax15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1617: quietly heckman lntax1617 lntax16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form)  twostep
eststo h1718: quietly heckman lntax1718 lntax17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1819: quietly heckman lntax1819 lntax18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1415, se mtitles nogaps
esttab h1516, se mtitles nogaps
esttab h1617, se mtitles nogaps
esttab h1718, se mtitles nogaps
esttab h1819, se mtitles nogaps

// Employees//
eststo h1415: quietly heckman lnemp1416 lnemp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1516: quietly heckman lnemp1517 lnemp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1617: quietly heckman lnemp1618 lnemp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1718: quietly heckman lnemp1719 lnemp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1819: quietly heckman lnemp1719 lnemp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1415, se mtitles nogaps
esttab h1516, se mtitles nogaps
esttab h1617, se mtitles nogaps
esttab h1718, se mtitles nogaps
esttab h1819, se mtitles nogaps

//Rent//
eststo h1415: quietly heckman lnrent1415 lnrent14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1516: quietly heckman lnrent1516 lnrent15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1617: quietly heckman lnrent1617 lnrent16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1718: quietly heckman lnrent1718 lnrent17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1819: quietly heckman lnrent1819 lnrent18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1415, se mtitles nogaps
esttab h1516, se mtitles nogaps
esttab h1617, se mtitles nogaps
esttab h1718, se mtitles nogaps
esttab h1819, se mtitles nogaps

//TFP//
eststo h1415: quietly heckman lntfp1415 lntfp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1516: quietly heckman lntfp1516 lntfp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1617: quietly heckman lntfp1617 lntfp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1718: quietly heckman lntfp1718 lntfp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1819: quietly heckman lntfp1819 lntfp18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1415, se mtitles nogaps
esttab h1516, se mtitles nogaps
esttab h1617, se mtitles nogaps
esttab h1718, se mtitles nogaps
esttab h1819, se mtitles nogaps

//Wage//
eststo h1415: quietly heckman lnwage1415 lnwage14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1516: quietly heckman lnwage1516 lnwage15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1617: quietly heckman lnwage1617 lnwage16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1718: quietly heckman lnwage1718 lnwage17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo h1819: quietly heckman lnwage1819 lnwage18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, select(dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab h1415, se mtitles nogaps
esttab h1516, se mtitles nogaps
esttab h1617, se mtitles nogaps
esttab h1718, se mtitles nogaps
esttab h1819, se mtitles nogaps

/// PSM ///
// ВЫРУЧКА //
eststo psm2014_2016: quietly pscore recipient14 dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2014_2016, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient14, pscore(mypscore) outcome(lngror1416) common caliper(0.39) neighbor (1) ate
pstest dummyokved1 size1 size2  gos_form ruown dummyexp14, treated(dummy14) both graph
drop mypscore myblock comsup _est_psm2014_2016 logitpscore _pscore _treated _support _weight _lngror1416 _id _n1 _nn _pdif

eststo psm2015_2017: quietly pscore recipient15 dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2015_2017, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient15, pscore(mypscore) outcome(lngror1517) common caliper(0.37) neighbor (1) ate
drop mypscore myblock comsup _est_psm2015_2017 logitpscore _pscore _treated _support _weight _lngror1517 _id _n1 _nn _pdif

eststo psm2016_2018: quietly pscore recipient16 dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2016_2018, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient16, pscore(mypscore) outcome(lngror1618) common caliper(0.4) neighbor (1) ate
drop mypscore myblock comsup _est_psm2016_2018 logitpscore _pscore _treated _support _weight _lngror1618 _id _n1 _nn _pdif

eststo psm2017_2019: quietly pscore recipient17 dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2017_2019, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient17, pscore(mypscore) outcome(lngror1719) common caliper(0.44) neighbor (1) ate
drop mypscore myblock comsup logitpscore _pscore _treated _support _weight _lngror1719 _id _n1 _nn _pdif

// TFP //
eststo psm2014_2016: quietly pscore dummy14 dummyokved1 size1 size2  gos_form ruown dummyexp14 reg1 reg2 reg3, pscore(mypscore) blockid(myblock) comsup
esttab psm2014_2016, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 dummy14, pscore(mypscore) outcome(lntfp1416) common caliper(0.21) neighbor (1) ate
drop mypscore myblock comsup _est_psm2014_2016 logitpscore _pscore _treated _support _weight _lntfp1416 _id _n1 _nn _pdif

eststo psm2015_2017: quietly pscore dummy15 dummyokved1 size1 size2  gos_form ruown dummyexp15 reg1 reg2 reg3, pscore(mypscore) blockid(myblock) comsup
esttab psm2015_2017, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 dummy15, pscore(mypscore) outcome(lntfp1517) common caliper(0.16) neighbor (1) ate
drop mypscore myblock comsup _est_psm2015_2017 logitpscore _pscore _treated _support _weight _lntfp1517 _id _n1 _nn _pdif

eststo psm2016_2018: quietly pscore dummy16 dummyokved1 size1 size2  gos_form ruown dummyexp16 reg1 reg2 reg3, pscore(mypscore) blockid(myblock) comsup
esttab psm2016_2018, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 dummy16, pscore(mypscore) outcome(lntfp1618) common caliper(0.15) neighbor (1) ate
drop mypscore myblock comsup _est_psm2016_2018 logitpscore _pscore _treated _support _weight _lntfp1618 _id _n1 _nn _pdif

eststo psm2017_2019: quietly pscore dummy17 dummyokved1 size1 size2  gos_form ruown dummyexp17 reg1 reg2 reg3, pscore(mypscore) blockid(myblock) comsup
esttab psm2017_2019, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 dummy17, pscore(mypscore) outcome(lntfp1719) common caliper(0.13) neighbor (1) ate
drop mypscore myblock comsup logitpscore _pscore _treated _support _weight _lntfp1719 _id _n1 _nn _pdif

// TAX //
eststo psm2014_2016: quietly pscore recipient14 dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2014_2016, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient14, pscore(mypscore) outcome(lntax1416) common caliper(0.39) neighbor (1) ate
drop mypscore myblock comsup _est_psm2014_2016 logitpscore _pscore _treated _support _weight _lntax1416 _id _n1 _nn _pdif

eststo psm2015_2017: quietly pscore recipient15 dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2015_2017, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient15, pscore(mypscore) outcome(lntax1517) common caliper(0.37) neighbor (1) ate
drop mypscore myblock comsup _est_psm2015_2017 logitpscore _pscore _treated _support _weight _lntax1517 _id _n1 _nn _pdif

eststo psm2016_2018: quietly pscore recipient16 dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2016_2018, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient16, pscore(mypscore) outcome(lntax1618) common caliper(0.4) neighbor (1) ate
drop mypscore myblock comsup _est_psm2016_2018 logitpscore _pscore _treated _support _weight _lntax1618 _id _n1 _nn _pdif

eststo psm2017_2019: quietly pscore recipient17 dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2017_2019, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient17, pscore(mypscore) outcome(lntax1719) common caliper(0.44) neighbor (1) ate
drop mypscore myblock comsup logitpscore _pscore _treated _support _weight _lntax1719 _id _n1 _nn _pdif

// Employees //
eststo psm2014_2016: quietly pscore recipient14 dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2014_2016, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient14, pscore(mypscore) outcome(lnemp1416) common caliper(0.39) neighbor (1) ate
drop mypscore myblock comsup _est_psm2014_2016 logitpscore _pscore _treated _support _weight _lnemp1416 _id _n1 _nn _pdif

eststo psm2015_2017: quietly pscore recipient15 dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2015_2017, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient15, pscore(mypscore) outcome(lnemp1517) common caliper(0.37) neighbor (1) ate
drop mypscore myblock comsup _est_psm2015_2017 logitpscore _pscore _treated _support _weight _lnemp1517 _id _n1 _nn _pdif

eststo psm2016_2018: quietly pscore recipient16 dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2016_2018, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient16, pscore(mypscore) outcome(lnemp1618) common caliper(0.4) neighbor (1) ate
drop mypscore myblock comsup _est_psm2016_2018 logitpscore _pscore _treated _support _weight _lnemp1618 _id _n1 _nn _pdif

eststo psm2017_2019: quietly pscore recipient17 dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poorly_dev_region high_tech ruown gos_form, pscore(mypscore) blockid(myblock) comsup
esttab psm2017_2019, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 recipient17, pscore(mypscore) outcome(lnemp1719) common caliper(0.44) neighbor (1) ate
drop mypscore myblock comsup logitpscore _pscore _treated _support _weight _lnemp1719 _id _n1 _nn _pdif


// WAGE //
eststo psm2014_2016: quietly pscore dummy14 dummyokved1 size1 size2  gos_form ruown dummyexp14 reg1 reg2 reg3, pscore(mypscore) blockid(myblock) comsup
esttab psm2014_2016, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 dummy14, pscore(mypscore) outcome(lntfp1416) common caliper(0.21) neighbor (1) ate
drop mypscore myblock comsup _est_psm2014_2016 logitpscore _pscore _treated _support _weight _lntfp1416 _id _n1 _nn _pdif

eststo psm2015_2017: quietly pscore dummy15 dummyokved1 size1 size2  gos_form ruown dummyexp15 reg1 reg2 reg3, pscore(mypscore) blockid(myblock) comsup
esttab psm2015_2017, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 dummy15, pscore(mypscore) outcome(lntfp1517) common caliper(0.16) neighbor (1) ate
drop mypscore myblock comsup _est_psm2015_2017 logitpscore _pscore _treated _support _weight _lntfp1517 _id _n1 _nn _pdif

eststo psm2016_2018: quietly pscore dummy16 dummyokved1 size1 size2  gos_form ruown dummyexp16 reg1 reg2 reg3, pscore(mypscore) blockid(myblock) comsup
esttab psm2016_2018, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 dummy16, pscore(mypscore) outcome(lntfp1618) common caliper(0.15) neighbor (1) ate
drop mypscore myblock comsup _est_psm2016_2018 logitpscore _pscore _treated _support _weight _lntfp1618 _id _n1 _nn _pdif

eststo psm2017_2019: quietly pscore dummy17 dummyokved1 size1 size2  gos_form ruown dummyexp17 reg1 reg2 reg3, pscore(mypscore) blockid(myblock) comsup
esttab psm2017_2019, se pr2 mtitle 
gen logitpscore = ln(mypscore/ (1-mypscore))
sum logitpscore
psmatch2 dummy17, pscore(mypscore) outcome(lntfp1719) common caliper(0.13) neighbor (1) ate
drop mypscore myblock comsup logitpscore _pscore _treated _support _weight _lntfp1719 _id _n1 _nn _pdif

** etregress
*** 4 периода
// ВЫРУЧКА//
eststo e1416: quietly etreg lngror1416 lnor14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1517: quietly etreg lngror1517 lnor15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1618: quietly etreg lngror1618 lnor16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1719: quietly etreg lngror1719 lnor17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1416, se mtitles nogaps
esttab e1517, se mtitles nogaps
esttab e1618, se mtitles nogaps
esttab e1719, se mtitles nogaps

// TAXES//
eststo e1416: quietly etreg lntax1416 lntax14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1517: quietly etreg lntax1517 lntax15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1618: quietly etreg lntax1618 lntax16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1719: quietly etreg lntax1719 lntax17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1416, se mtitles nogaps
esttab e1517, se mtitles nogaps
esttab e1618, se mtitles nogaps
esttab e1719, se mtitles nogaps

//Rent//
eststo e1416: quietly etreg lnrent1416 lnrent14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1517: quietly etreg lnrent1517 lnrent15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1618: quietly etreg lnrent1618 lnrent16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1719: quietly etreg lnrent1719 lnrent17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1416, se mtitles nogaps
esttab e1517, se mtitles nogaps
esttab e1618, se mtitles nogaps
esttab e1719, se mtitles nogaps

//TFP//
eststo e1416: quietly etreg lntfp1416 lntfp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1517: quietly etreg lntfp1517 lntfp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1618: quietly etreg lntfp1618 lntfp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1719: quietly etreg lntfp1719 lntfp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1416, se mtitles nogaps
esttab e1517, se mtitles nogaps
esttab e1618, se mtitles nogaps
esttab e1719, se mtitles nogaps

//Wage//
eststo e1416: quietly etreg lnwage1416 lnwage14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1517: quietly etreg lnwage1517 lnwage15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1618: quietly etreg lnwage1618 lnwage16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1719: quietly etreg lnwage1719 lnwage17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1416, se mtitles nogaps
esttab e1517, se mtitles nogaps
esttab e1618, se mtitles nogaps
esttab e1719, se mtitles nogaps

// EMP //
eststo e1416: quietly etreg lnemp1416 lnemp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1517: quietly etreg lnemp1517 lnemp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1618: quietly etreg lnemp1618 lnemp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1719: quietly etreg lnemp1719 lnemp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1416, se mtitles nogaps
esttab e1517, se mtitles nogaps
esttab e1618, se mtitles nogaps
esttab e1719, se mtitles nogaps

*** 3 периода
// ВЫРУЧКА//
eststo e1417: quietly etreg lngror1417 lnor14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1518: quietly etreg lngror1518 lnor15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1619: quietly etreg lngror1619 lnor16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1417, se mtitles nogaps
esttab e1518, se mtitles nogaps
esttab e1619, se mtitles nogaps

// TAXES//
eststo e1417: quietly etreg lntax1417 lntax14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1518: quietly etreg lntax1518 lntax15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1619: quietly etreg lntax1619 lntax16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1417, se mtitles nogaps
esttab e1518, se mtitles nogaps
esttab e1619, se mtitles nogaps

//Rent//
eststo e1417: quietly etreg lnrent1417 lnrent14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1518: quietly etreg lnrent1518 lnrent15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1619: quietly etreg lnrent1619 lnrent16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1417, se mtitles nogaps
esttab e1518, se mtitles nogaps
esttab e1619, se mtitles nogaps

//TFP//
eststo e1417: quietly etreg lntfp1417 lntfp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1518: quietly etreg lntfp1518 lntfp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1619: quietly etreg lntfp1619 lntfp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1417, se mtitles nogaps
esttab e1518, se mtitles nogaps
esttab e1619, se mtitles nogaps

//Wage//
eststo e1417: quietly etreg lnwage1417 lnwage14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1518: quietly etreg lnwage1518 lnwage15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1619: quietly etreg lnwage1619 lnwage16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1417, se mtitles nogaps
esttab e1518, se mtitles nogaps
esttab e1619, se mtitles nogaps

// EMP //
eststo e1417: quietly etreg lnemp1417 lnemp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1518: quietly etreg lnemp1518 lnemp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1619: quietly etreg lnemp1619 lnemp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1417, se mtitles nogaps
esttab e1518, se mtitles nogaps
esttab e1619, se mtitles nogaps

*** 5 периода
// ВЫРУЧКА//
eststo e1415: quietly etreg lngror1415 lnor14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1516: quietly etreg lngror1516 lnor15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1617: quietly etreg lngror1617 lnor16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1718: quietly etreg lngror1718 lnor17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1819: quietly etreg lngror1819 lnor18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1415, se mtitles nogaps
esttab e1516, se mtitles nogaps
esttab e1617, se mtitles nogaps
esttab e1718, se mtitles nogaps
esttab e1819, se mtitles nogaps

// TAXES//
eststo e1415: quietly etreg lntax1415 lntax14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1516: quietly etreg lntax1516 lntax15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1617: quietly etreg lntax1617 lntax16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1718: quietly etreg lntax1718 lntax17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1819: quietly etreg lntax1819 lntax18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1415, se mtitles nogaps
esttab e1516, se mtitles nogaps
esttab e1617, se mtitles nogaps
esttab e1718, se mtitles nogaps
esttab e1819, se mtitles nogaps

//Rent//
eststo e1415: quietly etreg lnrent1415 lnrent14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1516: quietly etreg lnrent1516 lnrent15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1617: quietly etreg lnrent1617 lnrent16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1718: quietly etreg lnrent1718 lnrent17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1819: quietly etreg lnrent1819 lnrent18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1415, se mtitles nogaps
esttab e1516, se mtitles nogaps
esttab e1617, se mtitles nogaps
esttab e1718, se mtitles nogaps
esttab e1819, se mtitles nogaps

//TFP//
eststo e1415: quietly etreg lntfp1415 lntfp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1516: quietly etreg lntfp1516 lntfp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1617: quietly etreg lntfp1617 lntfp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1718: quietly etreg lntfp1718 lntfp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1819: quietly etreg lntfp1819 lntfp18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1415, se mtitles nogaps
esttab e1516, se mtitles nogaps
esttab e1617, se mtitles nogaps
esttab e1718, se mtitles nogaps
esttab e1819, se mtitles nogaps

//Wage//
eststo e1415: quietly etreg lnwage1415 lnwage14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1516: quietly etreg lnwage1516 lnwage15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1617: quietly etreg lnwage1617 lnwage16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1718: quietly etreg lnwage1718 lnwage17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1819: quietly etreg lnwage1819 lnwage18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1415, se mtitles nogaps
esttab e1516, se mtitles nogaps
esttab e1617, se mtitles nogaps
esttab e1718, se mtitles nogaps
esttab e1819, se mtitles nogaps

// EMP //
eststo e1415: quietly etreg lnemp1415 lnemp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient14 = dummyexp14 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1516: quietly etreg lnemp1516 lnemp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient15 = dummyexp15 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1617: quietly etreg lnemp1617 lnemp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient16 = dummyexp16 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1718: quietly etreg lnemp1718 lnemp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
eststo e1819: quietly etreg lnemp1819 lnemp18 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech, treat(recipient17 = dummyexp17 small medium big giant agricultural mineral manufacture energy garbage building trade_repair trans hotel info science age_2000 age_1990 age_1990_2000 high_dev_region dev_region medium_dev_region poor_dev_region high_tech ruown gos_form) twostep
esttab e1415, se mtitles nogaps
esttab e1516, se mtitles nogaps
esttab e1617, se mtitles nogaps
esttab e1718, se mtitles nogaps
esttab e1819, se mtitles nogaps
