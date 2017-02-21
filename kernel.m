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


(* ::Input::Initialization:: *)
Clear[t,x,y,z,\[Theta],\[Psi],V,\[Gamma],nya,nxa,g,tadd,gamadd,nyadd,nxadd,tt,VV,gam]


(* ::Input::Initialization:: *)
Clear@interpolFunListQ
interpolFunListQ[arg_]:=MatchQ[arg,{Rule[___,InterpolatingFunction[___][___]]..}]


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
Clear@joinedinterpolFunListQ
joinedinterpolFunListQ[arg_]:=MatchQ[arg,{Rule[___,_Piecewise]..}]


(* ::Input::Initialization:: *)
ClearAll@domain
domain[intfun_InterpolatingFunction]:=First@(intfun["Domain"])
domain[intfun:InterpolatingFunction[___][targ___]]:=domain[Head@intfun]+t-targ
domain[manevrresult_?interpolFunListQ]:=domain[manevrresult[[1,2]]]
domain[interpolFunList_?joinedinterpolFunListQ]:={interpolFunList[[1,2,1,1,2,1]],interpolFunList[[1,2,1,-1,2,3]]}
domain[manevr_?manevrQ]:=domain[manevr["Interpolating functions"]]
ErrorChecking`setConsistencyChecks[domain,"Valid syntax:
domain[intfun_InterpolatingFunction] or
domain[intfun:InterpolatingFunction[___][targ___] or
domain[manevrresult_?interpolFunListQ] or
domain[interpolFunList_?joinedinterpolFunListQ] or 
domain[manevr_?manevrQ]"]


(* ::Input::Initialization:: *)
ClearAll@tStart
tStart[manevrresult_?interpolFunListQ]:=First@domain@manevrresult
(*ConsistencyChecked*)


(* ::Input::Initialization:: *)
ClearAll@tFinal
tFinal[manevrresult_?interpolFunListQ]:=Last@domain@manevrresult
(*ConsistencyChecked*)


(* ::Input::Initialization:: *)
Clear@appendt
appendt::tencountered="t encountered in the list of functions' symbols was omitted";

appendt[funlist:{Except[t,_Symbol]..}]:=Module[{},
ClearAll[t];
#[t]&/@funlist]

appendt[funlist:{_Symbol..}]:=Module[{},
ClearAll[t];
Message[appendt::tencountered];
appendt@DeleteCases[funlist,t]]

ErrorChecking`setConsistencyChecks[appendt,"Functions symbols list must contain nothing but clear symbols"];


(* ::Input::Initialization:: *)
ClearAll@manevrQ
manevrQ[arg_Association]:=AnyTrue[arg,interpolFunListQ]&&Length[arg["Interpolating functions"]]==Tally[domain/@arg["Interpolating functions"][[All,2]]][[1,2]]
manevrQ[___]:=False


(* ::Input::Initialization:: *)
ClearAll@lastState
lastState[manevrresult_?interpolFunListQ]:=
((appendt@(functionslist~Join~{\[Gamma],nyy,nxx}))/.manevrresult)/.{t->tFinal[manevrresult]}

lastState[manevr_?manevrQ]:=lastState@manevr["Interpolating functions"]

ErrorChecking`setConsistencyChecks[{tStart,tFinal,lastState},"Valid syntax:
fun[manevrresult_?interpolFunListQ]"];


(* ::Input::Initialization:: *)
ClearAll@imaneuver
imaneuver::vmax="Maximal velocity `1` kph reached for `2` at local time = `3` s";
imaneuver::vzero="Velocity has become less than zero at local time = `1` s";
imaneuver::nymax="Maximal \!\(\*SubscriptBox[\(n\), \(y\)]\) = `1` reached for `2` at local time = `3` s, y = `4` m, V = `5` kph";
imaneuver::nxmax="Maximal \!\(\*SubscriptBox[\(n\), \(x\)]\) = `1` reached for `2` at local time = `3` s when \!\(\*SubscriptBox[\(n\), \(y\)]\) = `4`";
imaneuver[helicopter_,form_,initialconditions_,G_,temp_,gammafun_,nyfun_,nxfun_,event_,t0_]:=Module[
{gammafunnyfunnxfunRule={\[Gamma]->gammafun,nya->nyfun,nxa->nxfun,g->globalg},allgood},

(First@NDSolve[
equations[form,initialconditions,gammafun,nyfun,nxfun]
~Join~
{WhenEvent[event,{Print["main event; exiting.."];"StopIntegration"}]}
~Join~
{WhenEvent[{AllTrue[{t>0.01,V[t]*globalmps>helicopter["Vmax"]},TrueQ]},{Message[imaneuver::vmax,helicopter["Vmax"],helicopter["Type"],Round[t,0.001]];"StopIntegration"}]}
~Join~
{WhenEvent[{AllTrue[{t>0.01,V[t]<0},TrueQ]},{Message[imaneuver::vzero,Round[t,0.001]];"StopIntegration"}]}
~Join~
{WhenEvent[{AllTrue[{t>0.01,nyfun>nyAvaliable[helicopter,G,temp,y[t],V[t]]},TrueQ]},{Message[imaneuver::nymax,Round[nyAvaliable[helicopter,G,temp,y[t],V[t]],0.001],helicopter["Type"],Round[t,0.001],Round[y[t],0.001],Round[V[t]globalmps,0.001]];"StopIntegration"}]}
~Join~
{WhenEvent[{AllTrue[{t>0.01,nxfun>nxAvaliable[helicopter,nyfun,G,temp,y[t],V[t]]},TrueQ]},{Message[imaneuver::nxmax,Round[nxAvaliable[helicopter,nyfun,G,temp,y[t],V[t]],0.001],helicopter["Type"],Round[t,0.001],Round[nyfun,0.001]];"StopIntegration"}]},

appendt@functionslist,

{t,0,Infinity},

EvaluationMonitor:>{
(* for additional interpolation functions *)
Sow[t,tadd],
Sow[N[gammafun],gamadd],
Sow[N@nyfun,nyadd],
Sow[N@nxfun,nxadd],

(*for details*)
Sow[solvefor[equations[form,"t"],Derivative[1][\[Theta]][t]]/.gammafunnyfunnxfunRule,\[Theta]dot],
Sow[N[gammafun]/Degree,gam],
Sow[N@nyfun,ny],
Sow[N@nyAvaliable[helicopter,G,temp,y[t],V[t]],nyavaliable],
Sow[N@nxfun,nx],
Sow[N@nxAvaliable[helicopter,nyfun,G,temp,y[t],V[t]],nxavaliable],
Sow[3.6V[t],VV],
Sow[t,tt],
Sow[solvefor[equations[form,"t"],Derivative[1][\[Psi]][t]]/.gammafunnyfunnxfunRule,\[Psi]dot]
}
])/.{(fun:InterpolatingFunction[___])[t]:>fun[t-t0]}] (* domain correction *) 

ErrorChecking`setConsistencyChecks[imaneuver]


(* ::Input::Initialization:: *)
ClearAll@correctVQ
correctVQ::verror="Velocity of `1` has to belong to the interval (0; `2`] kph. Input velocity is `3` kph";
correctVQ[helicopter_?helicopterQ,V_?NumericQ]:=If[0<V&&V*globalmps<=helicopter["Vmax"],True,(Message[correctVQ::verror,helicopter["Type"],helicopter["Vmax"],Round[V*globalmps,0.001]];False)]
correctVQ[___]:=False


(* ::Input::Initialization:: *)
ClearAll@correctTQ
correctTQ::tError="Temperature interval is from -40 to 40\[Degree]C. Input temperature is `1`\[Degree]C";
correctTQ[temp_?NumericQ]:=If[-40<=temp<=40,True,(Message[correctTQ::tError,Round[temp,0.001]];False)]
correctTQ[___]:=False


(* ::Input::Initialization:: *)
ClearAll@correctGQ
correctGQ::verror="Weight of `1` has to belong to the interval from `2` to `3` kg. Input weight is `4` kg";
correctGQ[helicopter_?helicopterQ,G_?NumericQ]:=If[helicopter["Gmin"]<=G<=helicopter["Gmax"],True,(Message[correctGQ::verror,helicopter["Type"],helicopter["Gmin"],helicopter["Gmax"],G];False)]
correctGQ[___]:=False


(* ::Input::Initialization:: *)
ClearAll@allGood
allGood[helicopter_?helicopterQ,V_,G_,temp_]:=AllTrue[{correctVQ[helicopter,V],correctGQ[helicopter,G],correctTQ[temp]},TrueQ]
allGood[___]:=False


(* ::Input::Initialization:: *)
(*ClearAll@maneuver

maneuver::usage="
Returns an Association containing Maneuver type, Helicopter, Weight, Temperature, Interpolating functions for x, y, z, \[Theta], \[Psi], V}\n
maneuver[Optional[name_String,\"Unknown\"],helicopter_?helicopterQ,form_?formQ,initialconditions_?initialConditionsQ,G_,temp_,gammafun_,nyfun_,nxfun_,event_,t0_:0] calculates maneuver based on initial conditions; t0 (which is 0 by default) is used for correcting domains of resulting functions \n
maneuver[Optional[name_String,\"Unknown\"],form_?formQ,prevmaneuver_?manevrQ,gammafun_,nyfun_,nxfun_,event_] calculates maneuver based on previous maneuver";

maneuver::integrationerror="Integration error during execution of maneuver `1`. Result: `2`";
maneuver::initconderror="Invalid initial conditions encountered during execution of maneuver `1`";
maneuver::prevmanerror="Can't calculate maneuver `1` because of an error occurred during calculation of previous maneuver";

maneuver[Optional[name_String,"Unknown"],helicopter_?helicopterQ,form_?formQ,initialconditions_?initialConditionsQ,G_,temp_,gammafun_,nyfun_,nxfun_,event_,t0_:0]:=Module[{result},

If[allGood[helicopter,Last@initialconditions,G,temp],
result=Check[imaneuver[helicopter,form,initialconditions,G,temp,gammafun,nyfun,nxfun,event,t0],$Failed];
If[interpolFunListQ[result],
AssociationThread[{"Maneuver type","Helicopter","Weight","Temperature","Interpolating functions"},{name,helicopter,G,temp,result}],
(Message[maneuver::integrationerror,name,result];$Failed)],
(Message[maneuver::initconderror,name];$Failed)
]
]

maneuver[Optional[name_String,"Unknown"],form_?formQ,prevmaneuver_?manevrQ,gammafun_,nyfun_,nxfun_,event_]:=maneuver[name,prevmaneuver["Helicopter"],form,lastState@prevmaneuver["Interpolating functions"],prevmaneuver["Weight"],prevmaneuver["Temperature"],gammafun,nyfun,nxfun,event,tFinal@prevmaneuver["Interpolating functions"]]

maneuver[Optional[name_String,"Unknown"],form_?formQ,prevmaneuver:$Failed,gammafun_,nyfun_,nxfun_,event_]:=(Message[maneuver::prevmanerror,name];$Failed)

ErrorChecking`setConsistencyChecks[maneuver,"Valid syntax:
maneuver[Optional[name_String,\"Unknown\"],helicopter_?helicopterQ,form_?formQ,initialconditions_?initialConditionsQ,G_,temp_,gammafun_,nyfun_,nxfun_,event_,t0_:0] or
maneuver[Optional[name_String,\"Unknown\"],form_?formQ,prevmaneuver_?manevrQ,gammafun_,nyfun_,nxfun_,event_]"]*)


(* ::Input::Initialization:: *)
ClearAll@maneuver

maneuver::usage="
Returns an Association containing Maneuver type, Helicopter, Weight, Temperature, Interpolating functions for x, y, z, \[Theta], \[Psi], V}\n
maneuver[Optional[name_String,\"Unknown\"],helicopter_?helicopterQ,form_?formQ,initialconditions_?initialConditionsQ,G_,temp_,gammafun_,nyfun_,nxfun_,event_,t0_:0] calculates maneuver based on initial conditions; t0 (which is 0 by default) is used for correcting domains of resulting functions \n
maneuver[Optional[name_String,\"Unknown\"],form_?formQ,prevmaneuver_?manevrQ,gammafun_,nyfun_,nxfun_,event_] calculates maneuver based on previous maneuver";

maneuver::integrationerror="Integration error during execution of maneuver `1`. Result: `2`";
maneuver::initconderror="Invalid initial conditions encountered during execution of maneuver `1`";
maneuver::prevmanerror="Can't calculate maneuver `1` because of an error occurred during calculation of previous maneuver";

maneuver[Optional[name_String,"Unknown"],helicopter_?helicopterQ,form_?formQ,initialconditions_?initialConditionsQ,G_,temp_,gammafun_,nyfun_,nxfun_,event_,t0_:0]:=Module[{result,mainfunctions,additionalfunctions,joined,tfin},

If[allGood[helicopter,Last@initialconditions,G,temp],

result=Check[Reap[imaneuver[helicopter,form,initialconditions,G,temp,gammafun,nyfun,nxfun,event,t0],{tadd,gamadd,nyadd,nxadd}],$Failed];
If[Length[result]>1&&interpolFunListQ[result[[1]]],
mainfunctions=result[[1]];

tfin=Last@domain@mainfunctions[[1,2]]-t0;

additionalfunctions=MapThread[Rule,{{\[Gamma][t],nyy[t],nxx[t]},With[{times=#[[1]]},Interpolation[#,InterpolationOrder->1][mainfunctions[[1,2,1]]]&@DeleteDuplicatesBy[#,First]&@With[{last=SelectFirst[#,#[[1]]>=tfin&]},Select[#,#[[1]]<tfin&]~Join~{last}]&@(*Select[#,#[[1]]<=tfin&]&@*)DeleteDuplicatesBy[#,First]&@(Transpose[{times,#}])&/@#[[2]]]&@({#[[1]],Rest@#}&@Transpose[Sort[Transpose[Flatten[result[[2]],1]],#1[[1]]<#2[[1]]&]])}];
joined=mainfunctions~Join~additionalfunctions;

AssociationThread[{"Maneuver type","Helicopter","Weight","Temperature","Interpolating functions"},{name,helicopter,G,temp,joined}],
(Message[maneuver::integrationerror,name,joined];$Failed)],
(Message[maneuver::initconderror,name];$Failed)
]
]


maneuver[Optional[name_String,"Unknown"],form_?formQ,prevmaneuver_?manevrQ,gammafun_,nyfun_,nxfun_,event_]:=maneuver[name,prevmaneuver["Helicopter"],form,Take[lastState@prevmaneuver,6],prevmaneuver["Weight"],prevmaneuver["Temperature"],gammafun,nyfun,nxfun,event,tFinal@prevmaneuver["Interpolating functions"]]

maneuver[Optional[name_String,"Unknown"],form_?formQ,prevmaneuver:$Failed,gammafun_,nyfun_,nxfun_,event_]:=(Message[maneuver::prevmanerror,name];$Failed)

ErrorChecking`setConsistencyChecks[maneuver,"Valid syntax:
maneuver[Optional[name_String,\"Unknown\"],helicopter_?helicopterQ,form_?formQ,initialconditions_?initialConditionsQ,G_,temp_,gammafun_,nyfun_,nxfun_,event_,t0_:0] or
maneuver[Optional[name_String,\"Unknown\"],form_?formQ,prevmaneuver_?manevrQ,gammafun_,nyfun_,nxfun_,event_]"]


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
Clear@domainQ
domainQ[{x_?NumericQ,y_?NumericQ}]:=y>x
domainQ[___]:=False


(* ::Input::Initialization:: *)
ClearAll@plot
plot[{fun_,domain_?domainQ,label_String,converter_?NumericQ}]:=myPlot[converter fun,Prepend[domain,t],PlotLabel->label,LabelStyle->{Directive[Black,Bold],10}](*Plot[converter fun,Prepend[domain,t],Frame\[Rule]True,GridLines\[Rule]Automatic,PlotLabel\[Rule]label,RotateLabel\[Rule]False,LabelStyle\[Rule]Directive[Bold],PlotStyle\[Rule]Thick,PlotRange\[Rule]Full]*)

ErrorChecking`setConsistencyChecks[plot,"Valid syntax:\n plot[{fun_Interpolating,domain_,label_,converter_}]"];

ClearAll@plots
plots::internalerror="Some plots have invalid format";
plots[arg_?(joinedinterpolFunListQ[#]||interpolFunListQ[#]&)]:=Module[
{result=plot/@
({#[t]/.arg,domain[arg],(ToString@#)<>", "<>units[#],converter[#]}&/@(functionslist~Join~{\[Gamma],nxx,nyy}))},
If[Not@MemberQ[result,$Failed],result,(Message[plots::internalerror];$Failed)]
]

plots[arg_?manevrQ]:=plots[arg["Interpolating functions"]]

ErrorChecking`setConsistencyChecks[plots,"Valid syntax:\n plots[arg_?(joinedinterpolFunListQ[#]||interpolFunListQ[#]&)]"];


(* ::Input::Initialization:: *)
ClearAll@trajectoryPlot

trajectoryPlot[funs_List,range_]:=ParametricPlot3D[funs,range,PlotRange->Full,AxesLabel->{"x","y","z"},PlotStyle->Thickness[0.0075]]

trajectoryPlot[arg_?(joinedinterpolFunListQ[#]||interpolFunListQ[#]&)]:=trajectoryPlot[(appendt@{x,y,z})/.arg,Prepend[domain@arg,t]]

trajectoryPlot[arg_?manevrQ]:=trajectoryPlot[arg["Interpolating functions"]]

ErrorChecking`setConsistencyChecks[trajectoryPlot,"Valid syntax:\n trajectoryPlot[arg_?(joinedinterpolFunListQ[#]||interpolFunListQ[#]&)] or
trajectoryPlot[funs_List,range_]"];


(* ::Input::Initialization:: *)
ClearAll@inequality
inequality[domain_List]/;Length[domain]==2:=First@domain<=t<=Last@domain
inequality[___]:=$Failed


(* ::Input::Initialization:: *)
ClearAll@domainsjoinableQ
domainsjoinableQ[args:{_?manevrQ..}]:=Length[DeleteDuplicates@Flatten[domain/@args]]==Length[args]+1


(* ::Input::Initialization:: *)
ClearAll@margins
margins[args_?interpolFunListQ (* \:0441\:043f\:0438\:0441\:043e\:043a \:043e\:0434\:043d\:043e\:0438\:043c\:0435\:043d\:043d\:044b\:0445 \:0438\:043d\:0442\:0435\:0440\:043f\:043e\:043b\:0438\:0440\:0443\:044e\:0449\:0438\:0445 \:0444\:0443\:043d\:043a\:0446\:0438\:0439 \:043e\:0442 \:043d\:0435\:0441\:043a\:043e\:043b\:044c\:043a\:0438\:0445 \:043c\:0430\:043d\:0435\:0432\:0440\:043e\:0432*)]:=Select[Tally[Flatten[domain[#[[2]]]&/@args]],#[[2]]==2&][[All,1]]


(* ::Input::Initialization:: *)
ClearAll@pairs
pairs[args_?interpolFunListQ (* \:0441\:043f\:0438\:0441\:043e\:043a \:043e\:0434\:043d\:043e\:0438\:043c\:0435\:043d\:043d\:044b\:0445 \:0438\:043d\:0442\:0435\:0440\:043f\:043e\:043b\:0438\:0440\:0443\:044e\:0449\:0438\:0445 \:0444\:0443\:043d\:043a\:0446\:0438\:0439 \:043e\:0442 \:043d\:0435\:0441\:043a\:043e\:043b\:044c\:043a\:0438\:0445 \:043c\:0430\:043d\:0435\:0432\:0440\:043e\:0432*)]:=Partition[args[[All,2]],2,1]


(* ::Input::Initialization:: *)
ClearAll@maneuversjoinableQ
maneuversjoinableQ::domainserror="Unjoinable domains encountered";
maneuversjoinableQ::continuityerror="Result seems to include discontinious functions";
maneuversjoinableQ[args:{_?manevrQ..}]:=
If[domainsjoinableQ@args,
With[
{allintfuns=Select[#,Head[#[[1,1]]]==x||Head[#[[1,1]]]==y||Head[#[[1,1]]]==z||Head[#[[1,1]]]==\[Theta]||Head[#[[1,1]]]==\[Psi]||Head[#[[1,1]]]==V&||Head[#[[1,1]]]==\[Gamma]&]&@Transpose[#["Interpolating functions"]&/@args]},
allintfuns1=allintfuns;
If[AllTrue[AllTrue[MapThread[#1/.{t->#2}&,{pairs[allintfuns[[#]]],margins[allintfuns[[#]]]}],#[[1]]==#[[2]]&]&/@Range[Length@allintfuns],TrueQ],
True,
(Message[maneuversjoinableQ::continuityerror];False)]
],
(Message[maneuversjoinableQ::domainserror];False)
]


(* ::Input::Initialization:: *)
ClearAll@join

join::notallcorrect="Incorrect maneuver(s) encountered. Only `1` first maneuvers will be joined";
join::firstincorrect="First manoeuver is incorrect. Joining canceled";

join[args:{InterpolatingFunction[___][___]..}]:=Piecewise[MapThread[List,{#&/@args,inequality/@(domain/@args)}]]

join[args_?interpolFunListQ (* \:0441\:043f\:0438\:0441\:043e\:043a \:043e\:0434\:043d\:043e\:0438\:043c\:0435\:043d\:043d\:044b\:0445 \:0438\:043d\:0442\:0435\:0440\:043f\:043e\:043b\:0438\:0440\:0443\:044e\:0449\:0438\:0445 \:0444\:0443\:043d\:043a\:0446\:0438\:0439 \:043e\:0442 \:043d\:0435\:0441\:043a\:043e\:043b\:044c\:043a\:0438\:0445 \:043c\:0430\:043d\:0435\:0432\:0440\:043e\:0432*)]:=args[[1,1]]->join[args[[All,2]]]

join[args:{_?interpolFunListQ..}]:=join/@Transpose[args]

join[args:{_?manevrQ..}]:=If[maneuversjoinableQ@args,join[#["Interpolating functions"]&/@args],$Failed]

join[args:{_?(manevrQ[#]||#==$Failed&)..}]:=With[{lastCorrectManPosition=First@FirstPosition[args,$Failed]-1},
If[lastCorrectManPosition>0,(Message[join::notallcorrect,lastCorrectManPosition];join@Take[args,lastCorrectManPosition]),
(Message[join::firstincorrect];$Failed)]]

ErrorChecking`setConsistencyChecks[join,"Valid syntax for public version of the function 'join':\n join[args:{_?manevrQ..}]"];


(* ::Input::Initialization:: *)
ClearAll[idetails,details]
SetAttributes[idetails,HoldFirst]
SetAttributes[details,HoldFirst]

idetails[man_,tags_]:=ReleaseHold[Flatten[(Reap[man;,tags])[[2]],1]]
details[man_maneuver,Optional[tags_,{tt,\[Theta]dot,\[Psi]dot,gam,ny,nyavaliable,nx,nxavaliable,VV}]]:=With[{completedtags=DeleteDuplicates@Prepend[tags,tt]},ReleaseHold[Sort[{completedtags}~Join~Transpose[idetails[man,completedtags]],#1[[1]]<#2[[1]]&]]]
ErrorChecking`setConsistencyChecks[details,"First argument must be an unevaluated maneuver: maneuver[initconds,gammafun,nyfun,nxfun,event]"];


(* ::Input::Initialization:: *)
ClearAll@myComposition
SetAttributes[myComposition,HoldFirst]
myComposition[maneuver__,initial_?(initialConditionsQ[#]||manevrQ[#]&)]:=join@Rest@ComposeList[{maneuver},initial]
(*myComposition[maneuver__,prevmanevr_?manevrQ]:=join@Rest@ComposeList[{maneuver},prevmanevr]*)



