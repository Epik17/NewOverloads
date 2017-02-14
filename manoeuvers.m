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
nxZad[nxzad_,helicopter_?helicopterQ,ny_,G_,temp_,hManevraCurrent_,V_,Vy_:0]:=With[{nxaval=nxAvaliable[helicopter,ny,G,temp,hManevraCurrent,V,Vy]},If[nxzad<=nxaval,nxzad,nxaval]]


(* ::Input::Initialization:: *)
ClearAll@ruchkaNaSebya (* max nx *)
ruchkaNaSebya[prevmanevr_?manevrQ,nyzad_,delta\[Theta]_]:=maneuver["ruchkaNaSebya","Classic",prevmanevr,0,nyruchkaVperedNazad[1,nyzad],nxAvaliable[prevmanevr["Helicopter"],nyruchkaNaSebya[(lastState@prevmanevr)[[-2]],nyzad],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]]-0.01,\[Theta][t]==(lastState@prevmanevr)[[4]] +delta\[Theta]] 


(* ::Input::Initialization:: *)
ClearAll@ruchkaNaSebya (* zad nx *)
ruchkaNaSebya[prevmanevr_?manevrQ,nyzad_,delta\[Theta]_]:=maneuver["ruchkaNaSebya","Classic",prevmanevr,0,nyruchkaNaSebya[(lastState@prevmanevr)[[-2]],nyzad],nxZad[Sin[\[Theta][t]],prevmanevr["Helicopter"],nyruchkaNaSebya[(lastState@prevmanevr)[[-2]],nyzad],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]],\[Theta][t]==(lastState@prevmanevr)[[4]] +delta\[Theta]] 


(* ::Input::Initialization:: *)
ClearAll@ruchkaNaSebya (* zad nx *)
ruchkaNaSebya[prevmanevr_?manevrQ,nyzad_,delta\[Theta]_]:=maneuver["ruchkaNaSebya","Classic",prevmanevr,0,1.1,0,\[Theta][t]>delta\[Theta]] 


(* ::Input::Initialization:: *)
ClearAll@ruchkaOtSebya
ruchkaOtSebya[prevmanevr_?manevrQ,nyzad_,delta\[Theta]_]:=maneuver["ruchkaNaSebya","Classic",prevmanevr,0,nyruchkaVperedNazad[1,nyzad],nxZad[Sin[\[Theta][t]],prevmanevr["Helicopter"],nyruchkaNaSebya[1,nyzad],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]],\[Theta][t]==(lastState@prevmanevr)[[4]] +delta\[Theta]] 


(* ::Input::Initialization:: *)
ClearAll@stableState
stableState[prevmanevr_?manevrQ,event_]:=With[{laststate=lastState@prevmanevr},maneuver["Stable","Classic",prevmanevr,laststate[[7]],Cos[laststate[[4]]],nxZad[Sin[\[Theta][t]],prevmanevr["Helicopter"],Cos[laststate[[4]]],prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]],event]]


(* ::Input::Initialization:: *)
ClearAll@horizFlight
horizFlight[prevmanevr_?manevrQ,event_]:=With[{laststate=lastState@prevmanevr},maneuver["Stable","Classic",prevmanevr,laststate[[7]],1.,nxZad[0,prevmanevr["Helicopter"],1.,prevmanevr["Weight"],prevmanevr["Temperature"],y[t],V[t]],event]]


