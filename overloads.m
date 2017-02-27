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
ClearAll@diapason
diapason::verror="Velocity of `1` has to belong to the the interval from 0 to `2` kph. Input velocity is `3` kph";
diapason[helicopter_?helicopterQ,V_]:=Module[{allgood},

(*If[allGood[helicopter,V],*)
helicopter["Hdyn"]-(V*globalmps-helicopter["ParabolaCoeff"]*helicopter["Vmax"])^2*(helicopter["Hdyn"]-helicopter["Hst"])/(helicopter["ParabolaCoeff"]*helicopter["Vmax"])^2(*,$Failed]*)]

diapason[helicopter_?helicopterQ,G_?NumericQ,temp_?NumericQ,V_]:=Module[
{normT=15,groundT,T,dH,H1,allgood},

(*If[allGood[helicopter,V,G,temp],*)

H1=diapason[helicopter,0];
groundT=helicopter["TraspUZemli"];
T=(groundT-H1*helicopter["ctgTotH"])*(G/helicopter["Gnorm"]);If[temp>normT, groundT=groundT-helicopter["TemperCoeff"]*(temp-normT)];
dH=(groundT-T)/helicopter["ctgTotH"]-H1;
diapason[helicopter,V]+dH(*,$Failed]*)
]

ErrorChecking`setConsistencyChecks[diapason,"Your input has to be diapason[helicopter_?helicopterQ,V_?NumericQ] or diapason[helicopter_?helicopterQ,G_?NumericQ,temp_?NumericQ,V_?NumericQ]"];


(* ::Input::Initialization:: *)
ClearAll@nyAvaliable
nyAvaliable::denominatorerror="Can't calculate avaliable ny";
nyAvaliable[helicopter_?helicopterQ,G_?NumericQ,temp_?NumericQ,H_,V_]:=Module[

{allgood,denominator},

(*If[allGood[helicopter,V,G,temp,H],*)

denominator=helicopter["TraspUZemli"]/helicopter["ctgTotH"]-diapason[helicopter,G,temp,V];

(*If[Abs[denominator]>0.00001,*)(helicopter["TraspUZemli"]/helicopter["ctgTotH"]-H)/denominator(*,(Message[nyAvaliable::denominatorerror];$Failed)]*)(*,

Print["FUUU"];$Failed]*)
]

ErrorChecking`setConsistencyChecks[nyAvaliable,"Your input has to be nyAvaliable[helicopter_?helicopterQ,G_?NumericQ,temp_?NumericQ,H_,V_]"];


(* ::Input::Initialization:: *)
ClearAll@airDensity
airDensity[H_]:=(*If[H\[GreaterEqual]0,*)0.125*(20-H/1000)/(20+H/1000)(*]*)
ErrorChecking`setConsistencyChecks[airDensity,"Your input has to be airDensity[H_]"];


(* ::Input::Initialization:: *)
ClearAll@nxAvaliable
nxAvaliable::Verror="Velocity has to be greater than zero. Encountered value: `1` globalmps";
nxAvaliable[helicopter_?helicopterQ,ny_,G_,temp_,hManevraCurrent_,V_,Vy_]:=Module[{tempV,Cx=0.0115},
tempV:=3.6*V;
(540/helicopter["Gnorm"])*((helicopter["TraspUZemli"]*(1-ny)/helicopter["ctgTotH"]+diapason[helicopter,G,temp,V]*ny-hManevraCurrent)*helicopter["ctgNotH"]-0.0066*G*Vy(*/2*))/tempV-Cx*helicopter["Fomet"]*airDensity[hManevraCurrent]*V^2/2/G]

(* c \:043f\:043e\:043f\:0440\:0430\:0432\:043a\:043e\:0439 \:043d\:0430 \:0448\:0430\:0433 *)
(*nxAvaliable[helicopter_?helicopterQ,ny_,G_,temp_,hManevraCurrent_,V_,Vy_,V0_]:=nxAvaliable[helicopter,ny,G,temp,hManevraCurrent,V,Vy]-nxAvaliable[helicopter,1,G,temp,hManevraCurrent,V0,Vy]*)

ErrorChecking`setConsistencyChecks[nxAvaliable,"Your input has to be nxAvaliable[helicopter_?helicopterQ,ny_,G_,temp_,hManevraCurrent_,V_,Optional[Vy_,0]]"];



