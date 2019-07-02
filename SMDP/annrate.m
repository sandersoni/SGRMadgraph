(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
SetDirectory[NotebookDirectory[]];

input=Import["input"];
If[FileExistsQ["ann"],DeleteFile["ann"]]
build = input[[1,2]];
inm\[Chi]=input[[2,2]];
inmA=input[[3,2]];
inep=input[[5,2]];
in\[Alpha]\[Chi]=If[StringMatchQ[ToString[input[[4,2]]],"thermal"],0.035 inm\[Chi]/1000,input[[4,2]]];


k=2.5; (*See 1602.01465 Eq. 15/16 for what these constants are*)
u0 = 245 10^3; 
uS=233 10^3;
vgal = 550 10^3;(*Galactic escape velocity*)
SR=6.957 10^8;(*Solar radius*)
\[Rho]\[Chi]=0.3 10^6(*Local dark matter density; PDG says 0.3 GeV/c^2 per cm^-3 = 10^6*0.3 GeV/c^2 per m^-3 *);
Gconst=6.67408 10^-11;
SSM=Import["data/SSM.dat"];
(*The lighter elements seem to have density as a function of radius, so I pulled these functions from *)
(*NB These appear to be mass fractions, not fraction by number. If the second entry is divided by the mass number then it will be fraction by number.*)
Hab=Table[{SSM[[i,2]]*SR,SSM[[i,7]]},{i,2,Length[SSM]}];
He4ab=Table[{SSM[[i,2]]*SR,SSM[[i,8]](*/4*)},{i,2,Length[SSM]}];
He3ab=Table[{SSM[[i,2]]*SR,SSM[[i,9]](*/3*)},{i,2,Length[SSM]}];
C12ab=Table[{SSM[[i,2]]*SR,SSM[[i,10]](*/12*)},{i,2,Length[SSM]}];
N14ab=Table[{SSM[[i,2]]*SR,SSM[[i,11]](*/14*)},{i,2,Length[SSM]}];
O16ab=Table[{SSM[[i,2]]*SR,SSM[[i,12]](*/16*)},{i,2,Length[SSM]}];
Habf=Interpolation[Hab];
He4abf=Interpolation[He4ab];
He3abf=Interpolation[He3ab];
C12abf=Interpolation[C12ab];
N14abf=Interpolation[N14ab];
O16abf=Interpolation[O16ab];

(*Solar mass density importing data*)
SMD=Import["data/SolarMassDensity.csv"](*//ToExpression*)(*kg/m^3, r (m)*);
SMDtab=Table[{SMD[[i,1]]*SR,SMD[[i,2]]},{i,1,Length[SMD]}];
SMDi=Interpolation[SMDtab,InterpolationOrder->1];
SM=NIntegrate[SMDi[x]4\[Pi] x^2,{x,0,SR}];
(*Htnf is the total fraction by number of hydrogen in the sun*)
Htnf=0.912;
(*Htmf is the total fraction by mass of hydrogen in the sun*)
Htmf=0.710;
(*Total number of atoms in the sun*)
tn=(Htmf*SM)/(1.007825 au Htnf)/.{au->1.660539 10^-27(*kg*)};

(*The function ndtf takes the astrophysical parameter log\[Epsilon]X for a particular element in the sun and outputs the total number density fraction of the sun (e.g. what fraction of the sun is that element by number). The values are taken from 1405.0279 and 1405.0287*)
tnf[log\[Epsilon]X_]:=10^log\[Epsilon]X/10^12 Htnd;
log\[Epsilon]={(*Mg*) 7.59, (*Si*) 7.51, (*P*) 5.41, (*S*) 7.12, (*K*) 5.04, (*Ca*) 6.32, (*Sc*) 3.16, (*Ti*) 4.93, (*V*) 3.89, (*Cr*) 5.62, (*Mn*) 5.42, (*Fe*) 7.47, (*Co*) 4.93, (*Ni*) 6.20};
(*Table of constant number densities for heavier atoms, number/m^3*)
ndtab=Table[tnf[log\[Epsilon][[i]]],{i,1,Length[log\[Epsilon]]}]*tn/(4/3 \[Pi] SR^3);

(*These are number densities of atoms, number/m^3, radius dependent*)
Hnd[x_]:=SMDi[x]Habf[x]/Hmass/.{Hmass-> 1.007825 au}/.{au->1.660539 10^-27(*kg*)}
He4nd[x_]:=SMDi[x]He4abf[x]/Hmass/.{Hmass-> 4.002602 au}/.{au->1.660539 10^-27(*kg*)}
He3nd[x_]:=SMDi[x]He3abf[x]/Hmass/.{Hmass-> 3.0160293 au}/.{au->1.660539 10^-27(*kg*)}
C12nd[x_]:=SMDi[x]C12abf[x]/Hmass/.{Hmass-> 12 au}/.{au->1.660539 10^-27(*kg*)}
N14nd[x_]:=SMDi[x]N14abf[x]/Hmass/.{Hmass-> 14.003074 au}/.{au->1.660539 10^-27(*kg*)}
O16nd[x_]:=SMDi[x]O16abf[x]/Hmass/.{Hmass-> 15.994915 au}/.{au->1.660539 10^-27(*kg*)}
nd[y_,i_]:=Join[{Hold[Hnd[x]],Hold[He4nd[x]],Hold[He3nd[x]],Hold[C12nd[x]],Hold[N14nd[x]],Hold[O16nd[x]]},ndtab][[i]]/.{x-> y}//ReleaseHold;
(*These lists are for:
{1 H1, 2 He4, 3 He3, 4 C12, 5 N14, 6 O16, 7 Mg, 8 Si, 9 P, 10 S, 11 K, 12 Ca, 13 Sc, 14 Ti, 15 V, 16 Cr, 17 Mn, 18 Fe, 19 Co, 20 Ni}*)
ZN:={1,2,2,6,7,8,12,14,15,16,19,20,21,22,23,24,25,26,27,28};
mN:={1.007825 ,4.002602,3.0160293,12,14.003074,15.994915,24.305, 28.085,30.974,32.06,39.098,40.078,44.956,47.867,50.942,51.996,54.938,55.845,58.933,58.693}au/.{au-> 0.9314941 (*GeV*)};
AN:={1,4,3,12,14,16,24,28,31,32,39,40,45,48,51,52,55,56,59,59};
(*LogLogPlot[{Hnd[r],He4nd[r],He3nd[r],C12nd[r],N14nd[r],O16nd[r],Mgnd[r],Sind[r]},{r,0,SR}]*)


(* ::Input::Initialization:: *)
If[build==1,
Mtab=Table[{r,NIntegrate[SMDi[rp]4\[Pi] rp^2,{rp,0,r}]},{r,0,SR,SR/100.}];
Mi=Interpolation[Mtab,InterpolationOrder->1];
Export["data/Mass.csv",Mtab,"CSV"];
vetab= Table[{r,Sqrt[-2(NIntegrate[(Gconst Mi[rp])/rp^2,{rp,SR,r}]-(Gconst Mi[SR])/SR)]},{r,SR/100,SR,SR/100}];
vetab=Prepend[vetab,{0.0001,Sqrt[-2(NIntegrate[(Gconst Mi[rp])/rp^2,{rp,SR,0.001}]-(Gconst Mi[SR])/SR)]}];
Export["data/Escape.csv",vetab,"CSV"];]


(* ::Input::Initialization:: *)
If[build==1,
fnonorm[u_]:=(*norm*) (Exp[(vgal^2-u^2)/(k u0^2)]-1)^k HeavisideTheta[vgal-u];
(*normconstant=1/NIntegrate[fnonorm[Sqrt[x^2+y^2+z^2]],{x,0,vgal},{y,0,vgal},{z,0,vgal}]*)
normconstant=1/NIntegrate[4\[Pi] u^2 fnonorm[u],{u,0,vgal}];

f[u_]:=normconstant (Exp[(vgal^2-u^2)/(k u0^2)]-1)^k HeavisideTheta[vgal-u];
usolve=Solve[u^2+uS^2+2u uS c==vgal^2,u][[2]];
upint=u/.usolve/.{c->-1};
Export["data/upint.csv",upint,"CSV"];
fS[u_] := 1/2 NIntegrate[f[Sqrt[u^2+uS^2+2u uS c]],{c,-1,1}]
ftab=Table[{u,f[u]},{u,0.,upint,upint/1000}];
Export["data/f.csv",ftab,"CSV"];
fStab=Table[{u,fS[u]},{u,0.,upint,upint/1000}];
Export["data/fS.csv",fStab,"CSV"];]


(* ::Input::Initialization:: *)
If[build==1,
fStab=Import["data/fS.csv"]//ToExpression;
fSi=Interpolation[fStab];
vetab=Import["data/Escape.csv"]//ToExpression;
vei=Interpolation[vetab,InterpolationOrder->1];
nint1=NIntegrate[4\[Pi] u(u^2)fSi[u],{u,0,upint}];
Export["data/nint1.csv",nint1,"CSV"];
nint2=NIntegrate[4\[Pi] u fSi[u],{u,0,upint}];
Export["data/nint2.csv",nint2,"CSV"];
wint[r_]:=nint1+vei[r]^2 nint2;
wrint=NIntegrate[4 \[Pi] r^2 O16nd[r]wint[r],{r,0,SR}];
Export["data/wrint.csv",wrint,"CSV"];]


(* ::Input::Initialization:: *)
If[build==1,
Ea[z_]:=-NIntegrate[Exp[-t]/t,{t,-z,\[Infinity]}];
Etab=Table[{-Exp[lnz],Ea[-Exp[lnz]]},{lnz,-10,10,0.1}];
Export["data/Ei.csv",Etab,"CSV"];]


(* ::Input::Initialization:: *)
vetab=Import["data/Escape.csv"]//ToExpression;
vei=Interpolation[vetab,InterpolationOrder->1];
fStab=Import["data/fS.csv"]//ToExpression;
fSi=Interpolation[fStab];
ftab=Import["data/f.csv"]//ToExpression;
fi=Interpolation[ftab];
nint1=Import["data/nint1.csv"][[1,1]]//ToExpression;
nint2=Import["data/nint2.csv"][[1,1]]//ToExpression;
wrint=Import["data/wrint.csv"][[1,1]]//ToExpression;
upint=Import["data/upint.csv"][[1,1]]//ToExpression;
Etab=Import["data/Ei.csv"]//ToExpression;
Ei=Interpolation[Etab];
Mtab=Import["data/Mass.csv"]//ToExpression;
Mi=Interpolation[Mtab];
Emax[r_,u_,m\[Chi]_,mn_]:=(*1./GeV*)(*Desired units of GeV*)(2 (\[Mu]N^2)(*GeV^2/c^4*)( u^2+vei[r]^2)(*m^2/s^2*))/mn (*GeV/c^2*)  1/c^2/.{\[Mu]N-> (m\[Chi] mn)/(m\[Chi]+mn),c->3 10^8};
(*AbsoluteTiming[Emax[tr,tu,tm\[Chi],tmN]]*)
Emin[r_,u_,m\[Chi]_,mn_]:=(*1./GeV*)(*Desired units of GeV*)1/2 m\[Chi] 1(*GeV*)/c^2 u^2  (*m^2/s^2*)/.{c-> 3 10^8(*m/s*)};
(*AbsoluteTiming[Emin[tr,tu,tm\[Chi],tmN]]*)

(*This finds an upper limit on u based on the heaviside theta*)
(*Solve[Emax[0,u,m\[Chi],Nt]-Emin[0,u,m\[Chi],Nt]\[Equal]0,u]*)
(*/.{m\[Chi]\[Rule] inm\[Chi],Nt\[Rule] mNt}*)
upintHS[m\[Chi]_,mNu_]:=((0.` +8.439776214093713`*^6 ) Sqrt[m\[Chi]] Sqrt[mNu])/((m\[Chi]+mNu) Sqrt[9.`- (36.` m\[Chi] mNu)/(m\[Chi]+mNu)^2]);

EN[An_]:=(*1/GeV*)(*Desired units of GeV*)0.114/An^(5/3) (*GeV*);
t\[Sigma]SI = 7.542 10^-5 pb /.{pb-> 10^-36 cm^2};
t\[Sigma]SD = 0;
\[CapitalGamma]cap=1/s 5.9 10^22 ((100 GeV)/(tm\[Chi] GeV))^2 ((270 km/s)/(u0 m/s))^3 (t\[Sigma]SI 1200)/(10^-40 cm^2)/.{km->1000m};
(*tu=1/2.vgal;
tm\[Chi]=1000.;
tmN=1;
tAN=1;
tmA=0.5;
tr=1 10^6;
t\[Epsilon]=10^-8;
t\[Alpha]\[Chi]=0.035 tm\[Chi]/1000;*)
integrandr[r_,i_]:=4\[Pi] r^2 nd[r,i];
integrandu[r_,u_]:=4\[Pi] u(u^2+vei[r]^2)fSi[u];
d\[Sigma]dE[r_,u_,m\[Chi]_,mA_,\[Epsilon]_,\[Alpha]\[Chi]_,ER_,mn_,Zn_,En_]:= 8 \[Pi] \[Epsilon]^2 \[Alpha]\[Chi] \[Alpha] Zn^2 mn /((u^2+vei[r]^2)(2mn ER +mA^2)^2) Exp[-ER/En]\[HBar]^2 c^4/.{\[Alpha]-> 1/137.}/.{\[HBar]-> 6.582119 10^-22 0.001 }/.{c-> 3 10^8};
(*d\[Sigma]dE[tm\[Chi],tmN,tAN,tmA,t\[Epsilon],t\[Alpha]\[Chi],tr,tu,Emax[tu,tm\[Chi],tmN,tr]]10^-410^5*)
CNcap[m\[Chi]_,mA_,\[Epsilon]_,\[Alpha]\[Chi]_,i_]:=n\[Chi] Block[ {mNt,ZNt,ANt,ENt},
mNt=mN[[i]];
ZNt=ZN[[i]];
ANt=AN[[i]];
ENt=EN[ANt];
NIntegrate[
integrandr[r,i]integrandu[r,u]d\[Sigma]dE[r,u,m\[Chi],mA,\[Epsilon],\[Alpha]\[Chi],ER,mNt,ZNt,ENt]HeavisideTheta[Emax[r,u,m\[Chi],mNt]-Emin[r,u,m\[Chi],mNt]],
{r,0,SR},{u,0,(*upint*)2upintHS[m\[Chi],mNt]},{ER,Emin[r,u,m\[Chi],mNt],Emax[r,u,m\[Chi],mNt]},WorkingPrecision->4,Method-> {Automatic,"SymbolicProcessing"->0}]]/.{n\[Chi]-> \[Rho]\[Chi]/m\[Chi]};
(*AbsoluteTiming[CNcap[tm\[Chi],tmA,t\[Epsilon],t\[Alpha]\[Chi],1]]*)
CTcap[m\[Chi]_,mA_,\[Epsilon]_,\[Alpha]\[Chi]_]:=Sum[CNcap[m\[Chi],mA,\[Epsilon],\[Alpha]\[Chi],i],{i,1,Length[ZN]}];
(*AbsoluteTiming[CTcap[tm\[Chi],tmA,t\[Epsilon],t\[Alpha]\[Chi]]]*)
(*AbsoluteTiming[CNcap[tm\[Chi],tmA,t\[Epsilon],t\[Alpha]\[Chi],6]]*)
\[Sigma]vB[m\[Chi]_,mA_,\[Alpha]\[Chi]_]:=(\[Pi] \[Alpha]\[Chi]^2)/m\[Chi]^2 (1-mA^2/m\[Chi]^2)^(3/2)/(1-mA^2/(2m\[Chi]^2))^2 \[HBar]^2 c^3/.{\[HBar]-> 6.582119 10^-22 0.001}/.{c-> 3 10^8};
(*\[Sigma]vB[tm\[Chi],tmA,t\[Alpha]\[Chi]]*)
SE[m\[Chi]_,mA_,\[Alpha]\[Chi]_,v_]:=\[Pi]/a Sinh[2\[Pi] a c]/(Cosh[2 \[Pi] a c] - Cos[2\[Pi] Sqrt[c - a^2 c^2]])(*(\[Pi] \[Alpha]\[Chi]/v)/(1-Exp[-\[Pi] \[Alpha]\[Chi]/v])*)/.{a-> v/(2\[Alpha]\[Chi]),c-> (6 \[Alpha]\[Chi] m\[Chi])/(\[Pi]^2 mA)};
SEav[m\[Chi]_,mA_,\[Alpha]\[Chi]_]:=1/(2\[Pi] (5.1 10^-5 Sqrt[1000./m\[Chi]])^2)^(3/2) NIntegrate[4\[Pi] v^2 Exp[-1/2 v^2/(5.1 10^-5 Sqrt[1000./m\[Chi]])^2] SE[m\[Chi],mA,\[Alpha]\[Chi],v],{v,0,0.005},WorkingPrecision-> 5,Method-> {Automatic,"SymbolicProcessing"->0}]
\[Sigma]v[m\[Chi]_,mA_,\[Alpha]\[Chi]_]:=SEav[m\[Chi],mA,\[Alpha]\[Chi]] \[Sigma]vB[m\[Chi],mA,\[Alpha]\[Chi]]
GN=6.67408 10^-11 (*m^3/(kg s^2)*);
\[Rho]S=151  10^-3 10^6(*kg/m^3*);
TS=15.5 10^6 (*kelvin*);
\[Tau]S=(*1/s*)4.5 Gyr/.{Gyr-> 10^9 yr}/.{yr-> 365*24*60*60 (*s*)};
(*\[Sigma]vB[tm\[Chi],tmA,t\[Alpha]\[Chi]] m^3/s/.{m\[Rule] 10^2cm}*)
Cann[m\[Chi]_,mA_,\[Alpha]\[Chi]_]:=\[Sigma]v[m\[Chi],mA,\[Alpha]\[Chi]] ((GN m\[Chi] \[Rho]S)/(3 TS) 1/kB)^(3/2) 1/c^3/.{c-> 3 10^8}/.{kB-> 8.61733 10^-5  (10^-9) (*GeV*)/1(*kelvin*)}(*/.{GeV\[Rule] 1,s\[Rule] 1}*)
(*Cann[tm\[Chi],tmA,t\[Alpha]\[Chi]]*)
\[Tau][m\[Chi]_,mA_,\[Epsilon]_,\[Alpha]\[Chi]_]:=1/Sqrt[CTcap[m\[Chi],mA,\[Epsilon],\[Alpha]\[Chi]]Cann[m\[Chi],mA,\[Alpha]\[Chi]]]
\[Tau]rat[m\[Chi]_,mA_,\[Epsilon]_,\[Alpha]\[Chi]_]:=\[Tau][m\[Chi],mA,\[Epsilon],\[Alpha]\[Chi]]/\[Tau]S
N\[Chi][m\[Chi]_,mA_,\[Epsilon]_,\[Alpha]\[Chi]_]:=Sqrt[CTcap[m\[Chi],mA,\[Epsilon],\[Alpha]\[Chi]]/Cann[m\[Chi],mA,\[Alpha]\[Chi]]]Tanh[\[Tau]S/\[Tau][m\[Chi],mA,\[Epsilon],\[Alpha]\[Chi]]]
\[CapitalGamma]ann [m\[Chi]_,mA_,\[Epsilon]_,\[Alpha]\[Chi]_]:= 1/2 CTcap[m\[Chi],mA,\[Epsilon],\[Alpha]\[Chi]]Tanh[\[Tau]S/\[Tau][m\[Chi],mA,\[Epsilon],\[Alpha]\[Chi]]]^2
EDDmax[u_,m\[Chi]_,mn_]:=(*1./GeV*)(*Desired units of GeV*)(2 (\[Mu]N^2)(*GeV^2/c^4*)( u^2)(*m^2/s^2*))/mn (*GeV/c^2*)  1/c^2/.{\[Mu]N-> (m\[Chi] mn)/(m\[Chi]+mn),c->2.99792458 10^8};
d\[Sigma]DDdE[u_,m\[Chi]_,mA_,\[Epsilon]_,\[Alpha]\[Chi]_,ER_,mn_,Zn_,En_]:= 8 \[Pi] \[Epsilon]^2 \[Alpha]\[Chi] \[Alpha] Zn^2 mn /((u^2)(2mn ER +mA^2)^2) Exp[-ER/En]\[HBar]^2 c^4/.{\[Alpha]-> 1/137.}/.{\[HBar]-> 6.582119 10^-22 0.001 }/.{c-> 2.99792458 10^8};
integranduDD[u_]:=4\[Pi] (u^2)fSi[u];
\[Sigma]DD[m\[Chi]_,mA_,\[Epsilon]_,\[Alpha]\[Chi]_,mN_,ZN_,EN_]:=NIntegrate[
d\[Sigma]DDdE[u,m\[Chi],mA,\[Epsilon],\[Alpha]\[Chi],ER,mN,ZN,EN]integranduDD[u],{u,0,(*upint*)10upintHS[m\[Chi],mN]},
{ER,0,EDDmax[u,m\[Chi],mN]},WorkingPrecision->4,Method-> {Automatic,"SymbolicProcessing"->0}]/.{n\[Chi]-> \[Rho]\[Chi]/m\[Chi]}
mp=0.938272;
out\[Sigma]=\[Sigma]DD[inm\[Chi],inmA,inep,in\[Alpha]\[Chi],mp,1.,EN[1.]]10^4(*in cm^2*)(*m^2(1 pb)/(10^-40m^2)*);
out\[CapitalGamma]ann = \[CapitalGamma]ann[inm\[Chi],inmA,inep,in\[Alpha]\[Chi]];
out\[Tau]rat=\[Tau]rat[inm\[Chi],inmA,inep,in\[Alpha]\[Chi]];
Export["ann",{out\[CapitalGamma]ann,out\[Sigma],out\[Tau]rat},"Table"];



