(* ::Package:: *)

ClearAll@myPlot
SetAttributes[myPlot,HoldFirst];
myPlot[fun_,limits_,opts:OptionsPattern[]]:=Plot[fun,limits,opts,GridLines->Automatic,
Frame->True,PlotStyle->Thick,PlotRange->Full,RotateLabel->False,
LabelStyle->{Directive[Black,Bold],12}]
