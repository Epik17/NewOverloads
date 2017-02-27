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
Get[NotebookDirectory[]<>"equations.m"]
Get[NotebookDirectory[]<>"pk_ErrorChecking.m"]
Get[NotebookDirectory[]<>"plots.m"]
Get[NotebookDirectory[]<>"helicopters.m"]
Get[NotebookDirectory[]<>"overloads.m"]
Get[NotebookDirectory[]<>"constants.m"]
Get[NotebookDirectory[]<>"kernel.m"]


(* ::Input::Initialization:: *)
ClearAll@nyruchkaVperedNazad
nyruchkaVperedNazad[ny0_,ny1_]:=Module[{k=1,T},
T=Abs[ny1-ny0]/k;
Piecewise[{{ny0+If[ny1>ny0,1,-1]k t,t<=T},{ny1,t>T}}]
]


(* ::Input::Initialization:: *)
ClearAll@nxZad
nxZad[nxzad_,helicopter_?helicopterQ,ny_,G_,temp_,hManevraCurrent_,V_]:=With[{nxaval=(*Echo[#,"1"]&@*)nxAvaliable[helicopter,ny,G,temp,hManevraCurrent,V,0]-0.001(*Echo[#,"2"]&@*)(*-nxAvaliable[helicopter,1,G,temp,hManevraCurrent,V0,0]*)},If[nxzad<=nxaval,nxzad,nxaval]]


(* ::Input::Initialization:: *)
ClearAll@stablePitchAndRoll
stablePitchAndRoll[prevmanevr_?manevrQ,Optional[name_String,"Stable"],event_,nxfun_,dnxa_:0]:=With[{laststate=lastState@prevmanevr},maneuver[name,"Classic",prevmanevr,laststate["\[Gamma]"],Cos[laststate["\[Theta]"]],nxZad[nxfun,prevmanevr["Helicopter"],Cos[laststate["\[Theta]"]],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]]-dnxa,event]]


(* ::Input::Initialization:: *)
ClearAll@joinEvent
joinEvent[arg_List,newevent_]:=arg~Join~newevent
joinEvent[arg_,newevent_]:={arg,newevent}


(* ::Input::Initialization:: *)
ClearAll@razgon
razgon::verror="V final is less or equal V initial";
razgon[prevmanevr_?manevrQ,Optional[name_String,"Razgon"],Vdesired_]:=If[Vdesired>(lastState@prevmanevr)["V"],stablePitchAndRoll[prevmanevr,name,joinEvent[V[t]==Vdesired,V'[t]<0.01],nxAvaliable[prevmanevr["Helicopter"],Cos[(lastState@prevmanevr)["ny"]],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t],0]],
(Message[razgon::verror];$Failed)
]
setConsistencyChecks[razgon]


(* ::Input::Initialization:: *)
ClearAll@razgonUpToVavaliable
razgonUpToVavaliable[prevmanevr_?manevrQ,Optional[name_String,"Razgon"]]:=razgon[prevmanevr,name,100500]


(* ::Input::Initialization:: *)
ClearAll@ruchkaOtSebya
ruchkaOtSebya[prevmanevr_?manevrQ,Optional[name_String,"ruchkaOtSebya"],nyzad_,delta\[Theta]_,nxfun_,dnxa_:0]:=maneuver[name,"Classic",prevmanevr,0,nyruchkaVperedNazad[(lastState@prevmanevr)["ny"],nyzad],nxZad[nxfun,prevmanevr["Helicopter"],nyruchkaVperedNazad[(lastState@prevmanevr)["ny"],nyzad],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]]-dnxa,\[Theta][t]<=(lastState@prevmanevr)["\[Theta]"] +delta\[Theta]] 


(* ::Input::Initialization:: *)
ClearAll@ruchkaNaSebya 
(* zad nx *)
ruchkaNaSebya[prevmanevr_?manevrQ,Optional[name_String,"ruchkaNaSebya"],nyzad_,delta\[Theta]_,nxfun_,dnxa_:0]:=maneuver[name,"Classic",prevmanevr,0,nyruchkaVperedNazad[(lastState@prevmanevr)["ny"],nyzad],(*Echo[#,"nxZad"]&@*)nxZad[nxfun,prevmanevr["Helicopter"],nyruchkaVperedNazad[(lastState@prevmanevr)["ny"],nyzad],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]]-dnxa,\[Theta][t]>(lastState@prevmanevr)["\[Theta]"] +delta\[Theta]] 


(* ::Input::Initialization:: *)
(*ClearAll@horizFlight
horizFlight[prevmanevr_?manevrQ,event_]:=If[Round[(lastState@prevmanevr)["\[Theta]"],0.0000001]\[Equal]0,stableState[prevmanevr,event],$Failed]*)


(* ::Input::Initialization:: *)
ClearAll@pikirovanie
pikirovanie[prevmanevr_?manevrQ,nyvvoda_,\[Theta]vvoda_,nyvyvoda_,vvyvoda_]:=myComposition[
ruchkaOtSebya[#,nyvvoda,\[Theta]vvoda,Sin[\[Theta][t]]]&,
razgon[#,vvyvoda]&,
ruchkaNaSebya[#,nyvyvoda,-\[Theta]vvoda,Sin[\[Theta][t]]]&,
prevmanevr]


(* ::Input::Initialization:: *)
ClearAll@gorka
gorka::noslope="Impossible to create rectilinear part of maneuver. Continuing without it";
gorka[prevmanevr_?manevrQ,nyvvoda_,\[Theta]vvoda_,nyvyvoda_,vvyvoda_]:=Module[
{dnxa=nxAvaliable[prevmanevr["Helicopter"],1,prevmanevr["Weight"],prevmanevr["Temperature"],(lastState@prevmanevr)["y"],(lastState@prevmanevr)["V"],0]},

myComposition[
ruchkaNaSebya[#,"Vvod v gorku",nyvvoda,\[Theta]vvoda,100500,dnxa]&,
If[(*Echo[#,"V",3.6#&]&@*)(lastState@#)["V"]>=vvyvoda,
stablePitchAndRoll[#,"Nakl. uchastok",V[t]<vvyvoda,100500,dnxa],
(Message[gorka::noslope];#)(* creates duplicate which will be deleted in myComposition *)]&,
ruchkaOtSebya[#,"Vyvod iz gorki",nyvyvoda,-\[Theta]vvoda,(*Sin[\[Theta][t]]+dnxa*)100500,dnxa]&,
prevmanevr,
"Gorka"]
]


(* ::Input::Initialization:: *)
ClearAll@pikirovanie
pikirovanie::noslope="Impossible to create rectilinear part of maneuver. Continuing without it";
pikirovanie[prevmanevr_?manevrQ,nyvvoda_,\[Theta]vvoda_,nyvyvoda_,vvyvoda_]:=Module[
{dnxa=nxAvaliable[prevmanevr["Helicopter"],1,prevmanevr["Weight"],prevmanevr["Temperature"],(lastState@prevmanevr)["y"],(lastState@prevmanevr)["V"],0]},

myComposition[
ruchkaOtSebya[#,"Vvod v pike",nyvvoda,-\[Theta]vvoda,(*Sin[\[Theta][t]]+dnxa*)100500,dnxa]&,
If[(*Echo[#,"V",3.6#&]&@*)(lastState@#)["V"]<=vvyvoda,
stablePitchAndRoll[#,"Nakl. uchastok",V[t]>=vvyvoda,100500,dnxa],
(Message[pikirovanie::noslope];#)(* creates duplicate which will be deleted in myComposition *)]&,
ruchkaNaSebya[#,"Vyvod iz pike",nyvyvoda,\[Theta]vvoda,100500,dnxa]&,
prevmanevr,
"Pikirovanie"]
]



