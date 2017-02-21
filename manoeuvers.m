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
nyruchkaVperedNazad[ny0_,ny1_]:=Module[{k=0.1,T},
T=Abs[ny1-ny0]/k;
Piecewise[{{ny0+If[ny1>ny0,1,-1]k t,t<=T},{ny1,t>T}}]
]


(* ::Input::Initialization:: *)
ClearAll@nxZad
nxZad[nxzad_,helicopter_?helicopterQ,ny_,G_,temp_,hManevraCurrent_,V_,Vy_:0]:=With[{nxaval=nxAvaliable[helicopter,ny,G,temp,hManevraCurrent,V,Vy]-0.01},If[nxzad<=nxaval,nxzad,nxaval]]


(* ::Input::Initialization:: *)
ClearAll@ruchkaNaSebya 
(* zad nx *)
ruchkaNaSebya[prevmanevr_?manevrQ,nyzad_,delta\[Theta]_,nxfun_]:=maneuver["ruchkaNaSebya","Classic",prevmanevr,0,nyruchkaVperedNazad[(lastState@prevmanevr)[[-2]],nyzad],nxZad[nxfun,prevmanevr["Helicopter"],nyruchkaVperedNazad[(lastState@prevmanevr)[[-2]],nyzad],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]],\[Theta][t]>(lastState@prevmanevr)[[4]] +delta\[Theta]] 

(* max nx *)
ruchkaNaSebya[prevmanevr_?manevrQ,nyzad_,delta\[Theta]_]:=ruchkaNaSebya[prevmanevr,nyzad,delta\[Theta],nxAvaliable[prevmanevr["Helicopter"],nyruchkaVperedNazad[(lastState@prevmanevr)[[-2]],nyzad],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]]-0.01]


(* ::Input::Initialization:: *)
ClearAll@stablePitchAndRoll
stablePitchAndRoll[prevmanevr_?manevrQ,event_,nxfun_]:=With[{laststate=lastState@prevmanevr},maneuver["Stable","Classic",prevmanevr,laststate[[7]],Cos[laststate[[4]]],nxZad[nxfun,prevmanevr["Helicopter"],Cos[laststate[[4]]],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]],event]]


(* ::Input::Initialization:: *)
ClearAll@stableState
stableState[prevmanevr_?manevrQ,event_]:=stablePitchAndRoll[prevmanevr,event,Sin[\[Theta][t]]]


(* ::Input::Initialization:: *)
ClearAll@joinEvent
joinEvent[arg_List,newevent_]:=arg~Join~newevent
joinEvent[arg_,newevent_]:={arg,newevent}


(* ::Input::Initialization:: *)
ClearAll@razgon
razgon::verror="V final is less or equal V initial";
razgon[prevmanevr_?manevrQ,Vdesired_]:=If[Vdesired>(lastState@prevmanevr)[[6]],stablePitchAndRoll[prevmanevr,joinEvent[V[t]==Vdesired,V'[t]<0.001],nxAvaliable[prevmanevr["Helicopter"],Cos[(lastState@prevmanevr)[[4]]],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]]-0.01],
(Message[razgon::verror];$Failed)
]
setConsistencyChecks[razgon]


(* ::Input::Initialization:: *)
ClearAll@razgonUpToVavaliable
razgonUpToVavaliable[prevmanevr_?manevrQ]:=razgon[prevmanevr,100500]


(* ::Input::Initialization:: *)
ClearAll@ruchkaOtSebya
ruchkaOtSebya[prevmanevr_?manevrQ,nyzad_,delta\[Theta]_,nxfun_]:=maneuver["ruchkaOtSebya","Classic",prevmanevr,0,nyruchkaVperedNazad[1,nyzad],nxZad[nxfun,prevmanevr["Helicopter"],nyruchkaVperedNazad[1,nyzad],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]],\[Theta][t]==(lastState@prevmanevr)[[4]] +delta\[Theta]] 

ruchkaOtSebya[prevmanevr_?manevrQ,nyzad_,delta\[Theta]_]:=ruchkaOtSebya[prevmanevr,nyzad,delta\[Theta],nxAvaliable[prevmanevr["Helicopter"],nyruchkaVperedNazad[(lastState@prevmanevr)[[-2]],nyzad],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]]]


(* ::Input::Initialization:: *)
ClearAll@horizFlight
horizFlight[prevmanevr_?manevrQ,event_]:=If[Round[(lastState@prevmanevr)[[4]],0.0000001]==0,stableState[prevmanevr,event],$Failed]



