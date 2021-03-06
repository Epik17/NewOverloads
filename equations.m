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
Get[NotebookDirectory[]<>"constants.m"]


(* ::Input::Initialization:: *)
Clear[t,x,y,z,\[Theta],\[Psi],V,\[Gamma],nya,nxa,g]


(* ::Input::Initialization:: *)
(* formatting *)
ClearAll@bracketedEquations
(* http://mathematica.stackexchange.com/questions/33804/how-to-typeset-a-system-of-equations *)
bracketedEquations/:MakeBoxes[bracketedEquations[eqs_,Alignment->True],TraditionalForm]:=RowBox[{"\[Piecewise]",MakeBoxes[#,TraditionalForm]&@Grid[{#1,"=",#2}&@@@{##}&@@eqs,Alignment->{{Right,Center,Left}}]}]


(* ::Input::Initialization:: *)
ClearAll@formQ
formQ[arg_]:=MatchQ[arg,"Classic"|"Custom"]


(* ::Input::Initialization:: *)
ClearAll[equations,iequations]
iiequations[gammafun_,nyfun_,nxfun_,g_]:={(* equations of motion *)
nxfun-Sin[\[Theta][t]]==V'[t]/g,
nyfun Cos[gammafun]-Cos[\[Theta][t]]==V[t]/g  \[Theta]'[t],
nyfun Sin[gammafun]==V [t]Cos[\[Theta][t]]/g (-\[Psi]'[t]),

(* kinematic relationships, which may be considered as a part of Eqs of M. *)
x'[t]==V[t]Cos[\[Theta][t]]Cos[\[Psi][t]],
y'[t]==V[t] Sin[\[Theta][t]],
z'[t]==-V[t] Sin[\[Psi][t]]Cos[\[Theta][t]]};

iequations["Classic",gammafun_,nyfun_,nxfun_,g_]:=iiequations[gammafun,nyfun,nxfun,g]
iequations["Custom",gammafun_,nyfun_,nxfun_,g_]:=iiequations[gammafun,nyfun Cos[\[Theta][t]]-nxfun Sin[\[Theta][t]],nyfun Sin[\[Theta][t]]+nxfun Cos[\[Theta][t]],g]

equations[form_?formQ,"TraditionalForm"]:=TraditionalForm[bracketedEquations[iequations[form,\[Gamma],"\!\(\*SubscriptBox[\(n\), \(y\)]\)","\!\(\*SubscriptBox[\(n\), \(x\)]\)",g]/.{arg_[t]:>arg},Alignment->True]](*TableForm[TraditionalForm/@iequations[form,\[Gamma],"Subscript[n, y]","Subscript[n, x]",g]/.{arg_[t]\[RuleDelayed]arg}]*)

equations[form_?formQ]:=iequations[form,\[Gamma],nya,nxa,g]/.{arg_[t]:>arg}

equations[form_?formQ,"t"]:=iequations[form,\[Gamma],nya,nxa,g]

equations[form_?formQ,initialconditions:{x0_,y0_,z0_,\[Theta]0_,\[Psi]0_,V0_},gammafun_,nyfun_,nxfun_]:=With[

{g=globalg},

(* equations of motion and kinematic relationships, which may be considered as a part of Eqs of M.*)
iequations[form,gammafun,nyfun,nxfun,g]~Join~{
(* initial conditions *)
x[0]==x0,y[0]==y0,z[0]==z0,
\[Theta][0]==\[Theta]0,  \[Psi][0]==\[Psi]0,V[0]==V0
}
]
ErrorChecking`setConsistencyChecks[equations,"Valid syntax:\n equations[initialconditions:{x0_,y0_,z0_,\[Theta]0_,\[Psi]0_,V0_},gammafun_,nyfun_,nxfun_]\n or equations[]"];

equations::usage="Helicopter equations of motion (in overloads)
They may have two forms: \"Classic\", when pitch is approximately equal to trajectory slope angle, and \"Custom\", when pitch as the same as in horizontal flight

equations[form_]: may be used for symbolic calculations\n
equations[form_,\"t\"]: may be used for symbolic calculations, all functions are completed with [t]\n
equations[form_,\"TraditionalForm\"]: beautifully formatted equations \n
equations[form_,initialconditions:{x0_,y0_,z0_,\[Theta]0_,\[Psi]0_,V0_},gammafun_,nyfun_,nxfun_]: used for numerical solving
  gammafun, nyfun, nxfun \[LongDash] numbers or functions like 0, 0.058*t or Sin[\[Theta][t]]"; 


(* ::Input::Initialization:: *)
ClearAll@solvefor
solvefor[eqs_,fun_]:=solvefor[eqs,fun]=With[{eqNorule={V'[t]->1,Derivative[1][\[Theta]][t]->2,\[Psi]'[t]->3}},fun/.(Solve[eqs[[fun/.eqNorule]],fun][[1]])]



