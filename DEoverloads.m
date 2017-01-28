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
Get[NotebookDirectory[]<>"pk_ErrorChecking.m"]


(* ::Input::Initialization:: *)
Clear[t,x,y,z,\[Theta],\[Psi],V,\[Gamma],g]


(* ::Input::Initialization:: *)
ClearAll[equations,iequations]
iequations[gammafun_,nyfun_,nxfun_,g_]:={(* equations of motion *)
nxfun-Sin[\[Theta][t]]==V'[t]/g,
nyfun Cos[gammafun]-Cos[\[Theta][t]]==V[t]/g  \[Theta]'[t],
nyfun Sin[gammafun]==V [t]Cos[\[Theta][t]]/g (-\[Psi]'[t]),

(* kinematic relationships, which may be considered as a part of Eqs of M. *)
x'[t]==V[t]Cos[\[Theta][t]]Cos[\[Psi][t]],
y'[t]==V[t] Sin[\[Theta][t]],
z'[t]==-V[t] Sin[\[Psi][t]]Cos[\[Theta][t]]};

equations::usage="Helicopter equations of motion in overloads \n
equations[]: traditional form\n
equations[initialconditions:{x0_,y0_,z0_,\[Theta]0_,\[Psi]0_,V0_},gammafun_,nyfun_,nxfun_]\n
gammafun, nyfun, nxfun \[LongDash] numbers or functions like 0.058*t or Sin[\[Theta][t]]";

equations[]:=TableForm[TraditionalForm/@iequations[\[Gamma],"\!\(\*SubscriptBox[\(n\), \(y\)]\)","\!\(\*SubscriptBox[\(n\), \(x\)]\)",g]/.{arg_[t]:>arg}]

equations[initialconditions:{x0_,y0_,z0_,\[Theta]0_,\[Psi]0_,V0_},gammafun_,nyfun_,nxfun_]:=With[

{g=9.81},

(* equations of motion and kinematic relationships, which may be considered as a part of Eqs of M.*)
iequations[gammafun,nyfun,nxfun,g]~Join~{
(* initial conditions *)
x[0]==x0,y[0]==y0,z[0]==z0,
\[Theta][0]==\[Theta]0,  \[Psi][0]==\[Psi]0,V[0]==V0
}
]
ErrorChecking`setConsistencyChecks[equations,"Valid syntax:\n equations[initialconditions:{x0_,y0_,z0_,\[Theta]0_,\[Psi]0_,V0_},gammafun_,nyfun_,nxfun_]\n or equations[]"];


(* ::Input::Initialization:: *)
Clear@manevrQ
manevrQ[arg_]:=MatchQ[arg,{Rule[___,InterpolatingFunction[___][___]]..}]


(* ::Input::Initialization:: *)
Clear@initialConditionsQ
initialConditionsQ[arg_]:=MatchQ[arg,{__?NumericQ}]&&Length[arg]==6


(* ::Input::Initialization:: *)
ClearAll@functionslist
functionslist:=Module[{},
ClearAll[x,y,z,\[Theta],\[Psi],V];
{x,y,z,\[Theta],\[Psi],V}
];


(* ::Input::Initialization:: *)
Clear@joinedmanevrQ
joinedmanevrQ[arg_]:=MatchQ[arg,{Rule[___,_Piecewise]..}]


(* ::Input::Initialization:: *)
ClearAll@domain
domain[intfun_InterpolatingFunction]:=First@(intfun["Domain"])
domain[intfun:InterpolatingFunction[___][targ___]]:=domain[Head@intfun]+t-targ
domain[manevrresult_?manevrQ]:=domain[manevrresult[[1,2]]]
domain[joinedmanevr_?joinedmanevrQ]:={joinedmanevr[[1,2,1,1,2,1]],joinedmanevr[[1,2,1,-1,2,3]]}
ErrorChecking`setConsistencyChecks[domain,"Valid syntax:
domain[intfun_InterpolatingFunction] or
domain[intfun:InterpolatingFunction[___][targ___] or
domain[manevrresult_?manevrQ] or
domain[joinedmanevr_?joinedmanevrQ]"]


(* ::Input::Initialization:: *)
ClearAll@tStart
tStart[manevrresult_?manevrQ]:=First@domain@manevrresult
(*ConsistencyChecked*)


(* ::Input::Initialization:: *)
ClearAll@tFinal
tFinal[manevrresult_?manevrQ]:=Last@domain@manevrresult
(*ConsistencyChecked*)


(* ::Input::Initialization:: *)
Clear@appendt
appendt[funlist_List]:=#[t]&/@funlist


(* ::Input::Initialization:: *)
ClearAll@lastState
lastState[manevrresult_?manevrQ]:=
((appendt@functionslist)/.manevrresult)/.{t->tFinal[manevrresult]}

ErrorChecking`setConsistencyChecks[{tStart,tFinal,lastState},"Valid syntax:
tStart[manevrresult_?manevrQ]"];


(* ::Input::Initialization:: *)
ClearAll@maneuver
maneuver::usage="
Returns list of InterpolatingFunctions for x, y, z, \[Theta], \[Psi], V\n
maneuver[initialconditions_?initialConditionsQ,gammafun_,nyfun_,nxfun_,event_,t0_:0] calculates maneuver based on initial conditions; t0 (which is 0 by default) is used for correcting domains of resulting functions \n
maneuver[prevmaneuver_?manevrQ,gammafun_,nyfun_,nxfun_,event_] calculates maneuver based on previous maneuver
";
(*maneuver::msg1="1";
maneuver::msg2="2";*)

maneuver[initialconditions_?initialConditionsQ,gammafun_,nyfun_,nxfun_,event_,t0_:0]:=(
(*Message[maneuver::msg1];*)
(*Print[equations[initialconditions,gammafun,nyfun,nxfun]];*)
First@NDSolve[
equations[initialconditions,gammafun,nyfun,nxfun]~Join~{WhenEvent[event,{"StopIntegration"}]},
appendt@functionslist,
{t,0,Infinity},
EvaluationMonitor:>{
Sow[nyfun Cos[gammafun]-Cos[\[Theta][t]],\[Theta]dot],
Sow[N[gammafun/Degree],gam],
Sow[N@nyfun,ny],
Sow[t,tt],
Sow[-((9.81 nyfun Sin[gammafun])/(V [t]Cos[\[Theta][t]])),\[Psi]dot]
}
])/.{(fun:InterpolatingFunction[___])[t]:>fun[t-t0]} (* domain correction *) 

maneuver[prevmaneuver_?manevrQ,gammafun_,nyfun_,nxfun_,event_]:=(
(*Message[maneuver::msg2];*)
maneuver[lastState@prevmaneuver,gammafun,nyfun,nxfun,event,tFinal@prevmaneuver])

ErrorChecking`setConsistencyChecks[maneuver,"Valid syntax:\n maneuver[initialconditions_?initialConditionsQ,gammafun_,nyfun_,nxfun_,event_,t0_:0] \n or maneuver[prevmaneuver_?manevrQ,gammafun_,nyfun_,nxfun_,event_]"];


(* ::Input::Initialization:: *)
Clear@converter
converter[V]:=3.6
converter[\[Psi]|\[Theta]]:=1/Degree
converter[_]:=1


(* ::Input::Initialization:: *)
Clear@units
units[V]:="kph"
units[\[Psi]|\[Theta]]:="\[Degree]"
units[_]:="m"


(* ::Input::Initialization:: *)
ClearAll@plot
plot[{fun_,domain_,label_,converter_}]:=Plot[converter fun,Prepend[domain,t],Frame->True,GridLines->Automatic,PlotLabel->label,RotateLabel->False,LabelStyle->Directive[Bold],PlotStyle->Thick,PlotRange->Full]
plot[___]:=$Failed

ClearAll@plots
plots[arg_?(joinedmanevrQ[#]||manevrQ[#]&)]:=plot/@
({#[t]/.arg,domain[arg],(ToString@#)<>", "<>units[#],converter[#]}&/@functionslist)

plots[___]:=$Failed


(* ::Input::Initialization:: *)
ClearAll@trajectoryPlot

trajectoryPlot[funs_List,range_]:=ParametricPlot3D[funs,range,PlotRange->Full,AxesLabel->{"x","y","z"},PlotStyle->Thickness[0.0075]]

trajectoryPlot[arg_?(joinedmanevrQ[#]||manevrQ[#]&)]:=trajectoryPlot[(appendt@{x,y,z})/.arg,Prepend[domain@arg,t]]

trajectoryPlot[___]:=$Failed


(* ::Input::Initialization:: *)
ClearAll@inequality
inequality[domain_List]/;Length[domain]==2:=First@domain<=t<=Last@domain
inequality[___]:=$Failed


(* ::Input::Initialization:: *)
ClearAll@join
join[args:{InterpolatingFunction[___][___]..}]:=Piecewise[MapThread[List,{#&/@args,inequality/@(domain/@args)}]]

join[args_?manevrQ (* \:0432 \:0434\:0430\:043d\:043d\:043e\:043c \:0441\:043b\:0443\:0447\:0430\:0435, \:044d\:0442\:043e \:043d\:0435 \:043c\:0430\:043d\:0435\:0432\:0440, \:0430 \:0441\:043f\:0438\:0441\:043e\:043a \:043e\:0434\:043d\:043e\:0438\:043c\:0435\:043d\:043d\:044b\:0445 \:0438\:043d\:0442\:0435\:0440\:043f\:043e\:043b\:0438\:0440\:0443\:044e\:0449\:0438\:0445 \:0444\:0443\:043d\:043a\:0446\:0438\:0439 \:043e\:0442 \:043d\:0435\:0441\:043a\:043e\:043b\:044c\:043a\:0438\:0445 \:043c\:0430\:043d\:0435\:0432\:0440\:043e\:0432*)]:=args[[1,1]]->join[args[[All,2]]]

join[args_:{_?manevrQ..}]:=join/@Transpose[args]

join[___]:=$Failed


(* ::Input::Initialization:: *)
ClearAll[idetails,details]
SetAttributes[idetails,HoldFirst]
SetAttributes[details,HoldFirst]

idetails[man_,tags_]:=ReleaseHold[Flatten[(Reap[man;,tags])[[2]],1]]
details[man_maneuver,Optional[tags_,{tt,\[Theta]dot,\[Psi]dot,gam,ny}]]:=With[{completedtags=DeleteDuplicates@Prepend[tags,tt]},ReleaseHold[TableForm[Sort[{completedtags}~Join~Transpose[idetails[man,completedtags]],#1[[1]]<#2[[1]]&]]]]

ErrorChecking`setConsistencyChecks[details,"First argument must be an unevaluated maneuver: maneuver[initconds,gammafun,nyfun,nxfun,event]"];



