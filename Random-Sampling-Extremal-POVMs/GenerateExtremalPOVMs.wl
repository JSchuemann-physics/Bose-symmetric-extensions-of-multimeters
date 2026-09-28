#!/usr/bin/env wolframscript
(* RANDOM SAMPLING OF EXTREMAL POVMS.

This implementation randomly samples extremal POVMs. We store the extremal POVMs in extremalList and fetch it in python
using the wolframclient package. This code is a refactoring by Jonathan Schuemann 2026.

The original script was written by Esteban Martínez Vargas which can be
found at https://github.com/estebanmv/Random-Sampling-Extremal-POVMs. Also see  .
Their implementation is based on "Decomposition of any quantum measurement into extremals", G. Sentís et. al.  J. Phys. A: Mat. 
Th. Vol 46  Num 37.

*)

(* Change the path to the Mathematica command, for UNIX-related systems the path normally is the following:
   #!/usr/bin/env wolframscript *)

Needs["extremallibrary`"]

(*It requires the Quantum.m package by Carlos Pineda (carlospgmat03): 
https://github.com/carlospgmat03/libs
*)
Needs["Quantum`"]

(*
   Usage examples:
   ./GenerateExtremalPOVMs.wl --Samplings 3 --HilbertDim 2 --Outcomedim 5 
*)

(* NOTE This program gives 2 warnings that I have not been able to eliminate. One is for Integral 
convergence and the other has to do with finding a Linear Program solution. Neither of them affect directly the result. 
*)
Off[NIntegrate::ncvb]
Off[NIntegrate::slwcon]
Off[Infinity::indet]
(*Defaults, If-case so we can set the variables in python*)
If[!ValueQ[Samplings], Samplings = 1];
If[!ValueQ[HilbertDim], HilbertDim = 2];
If[!ValueQ[Outcomedim], Outcomedim = 4];

(*Flags {{{*)
counterCommandLine = 2;
While[counterCommandLine <= Length[$ScriptCommandLine],
 Switch[$ScriptCommandLine[[counterCommandLine]],
  "-s" | "--Samplings", 
    Samplings = ToExpression[$ScriptCommandLine[[counterCommandLine+1]]]; counterCommandLine += 2,
  "-hD" | "--HilbertDim", 
    HilbertDim = ToExpression[$ScriptCommandLine[[counterCommandLine+1]]]; counterCommandLine += 2,
  "-od" | "--Outcomedim", 
    Outcomedim = ToExpression[$ScriptCommandLine[[counterCommandLine+1]]]; counterCommandLine += 2,
  _, 
    Print["Error in parameter line. Option \"", 
      $ScriptCommandLine[[counterCommandLine]] , "\" not found."];  Exit[1]
 ]
]; 

extremalList = {};
Do[
    (*Initialize several variables.*)
    prob = 0;
    Sol = {};
    H = CUEMember[Outcomedim*(HilbertDim)];
    unPOVM = Table[POVM[g,HilbertDim,Outcomedim,H], {g, 1, Outcomedim}];
    
    (*The algorithm runs until the probability of obtaining the current solution is almost 1.*)
    
    While[prob < 1.,

      (*Decomposition of the original randomly produced POVM into the matrix A.*)
      
      Quiet[ Check[ {A,b} = AConstruction[unPOVM,HilbertDim,Outcomedim]; ,Break[]]];
      
      (*Linear Programming to find a solution. We find the optimum with a random vector, therefore, 
      it is a random element of the polytope. We need to add a Break because sometimes a solution 
      cannot be found.*)
      
      Quiet[ Check[ Sol = LinearProg[A,b]; ,Break[]]];
      
      (*With the result of the Linear Program we construct the extremal POVM.*)
      
      Extremal = BuildExtremal[Sol,unPOVM];
      
      (*We calculate the constant probability p.*)

      {prob,avector} = CalculateP[Sol,unPOVM];

      (*We construct the auxiliar POVM and recall it unPOVM.*)
      
      otroPOVM = AuxiliarSol[prob, avector, Sol, unPOVM]; 

      unPOVM = otroPOVM;

      (*Append Extremal to extremal list*)
      AppendTo[extremalList, Extremal];
      ];

    (*Sampling number view.*)
    
    PrintTemporary[\[Kappa]];

    , {\[Kappa], Samplings}
];
