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
Get[(NotebookDirectory[]<>"pk_ErrorChecking.m")]


(* ::Input::Initialization:: *)
ClearAll@import
import[path_String]/;FileExistsQ[path]:=Import[path,"Data"][[1]]
ErrorChecking`setConsistencyChecks[import,"File not found or your path is not a string"];


(* ::Input::Initialization:: *)
path=NotebookDirectory[]<>"helicopters.xls";


(* ::Input::Initialization:: *)
ClearAll@correctlyimportedQ
correctlyimportedQ[arg_List]:=With[{dims=Dimensions@arg},Length[dims]==2&&Last@dims==15]
correctlyimportedQ[___]:=False


(* ::Input::Initialization:: *)
ClearAll@formatImported
formatImported[imp_?correctlyimportedQ]:=Transpose[MapAt[ToExpression,Transpose[imp],2;;-1]]
ErrorChecking`setConsistencyChecks[formatImported,"Your input have to be an 2-dimensional array with 15 columns"];


(* ::Input::Initialization:: *)
parameters={"Type","Fomet","Gnorm","TraspUZemli","nyMin","nyMax","ctgTotH","ctgNotH","Hst","Hdyn","Vmax","TemperCoeff","ParabolaCoeff","Gmin","Gmax"};


(* ::Input::Initialization:: *)
ClearAll@correctFormattedImportedRowQ
correctFormattedImportedRowQ[arg_List]:=StringQ[First@arg]&&AllTrue[Rest@arg,NumericQ]&&Length[arg]==15
correctFormattedImportedRowQ[___]:=False


(* ::Input::Initialization:: *)
ClearAll@formattedImportedQ
formattedImportedQ[arg_?correctlyimportedQ]:=With[{firstrow=arg[[1]]},StringQ[First@firstrow]&&AllTrue[Rest@firstrow,NumericQ]]
formattedImportedQ[___]:=False


(* ::Input::Initialization:: *)
ClearAll@formattedImportedQ
formattedImportedQ[arg_?correctlyimportedQ]:=With[{firstrow=arg[[1]]},correctFormattedImportedRowQ[firstrow]]
formattedImportedQ[___]:=False


(* ::Input::Initialization:: *)
ClearAll@createHelicoptersDatabase

createHelicoptersDatabase[formatted_?formattedImportedQ]:=Map[AssociationThread[parameters,#]&,formatted]

createHelicoptersDatabase[path_String]/;FileExistsQ[path]:=
Composition[
createHelicoptersDatabase,
formatImported,
import
][path]
ErrorChecking`setConsistencyChecks[createHelicoptersDatabase,"Your input have to be either 
1) helicopter parameters as 2-dimensional array with 15 columns; the first column has to contain only strings, the rest of columns have to contain numbers
2) path of .xls file containing helicopter parameters"];


(* ::Input::Initialization:: *)
ClearAll@databaseQ
databaseQ[arg:{_Association..}]:=Keys[First@arg]==parameters&&formattedImportedQ[Values@arg]
databaseQ[___]:=False


(* ::Input::Initialization:: *)
ClearAll@types
types[database_?databaseQ]:=#["Type"]&/@database


(* ::Input::Initialization:: *)
ClearAll@fromDatabase
fromDatabase::typenotfound="Helicopter type `1` is not found in the database";
fromDatabase[database_?databaseQ,type_String]/;MemberQ[types@database,type]:=With[{selected=Select[database,#["Type"]==type&]},If[Length@selected==1,First@selected,selected]]
fromDatabase[database_?databaseQ,type_String]:=(Message[fromDatabase::typenotfound,type])
ErrorChecking`setConsistencyChecks[fromDatabase,"Correct input: fromDatabase[database_?databaseQ,type_String]"];


(* ::Input::Initialization:: *)
Clear@helicopterQ
helicopterQ[arg_Association]:=Keys[arg]==parameters&&correctFormattedImportedRowQ[Values@arg]
helicopterQ[___]:=False
