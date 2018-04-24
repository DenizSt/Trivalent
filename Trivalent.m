(* The Trivalent package by Deniz Stiegemann. *)
BeginPackage["Trivalent`"]

Unprotect[AdjMtx,b,d,dimC4,ReduceDiagram,ReduceSquares,t,ConnectAt,DiagramCompose,DiagramConjugate,DiagramFlipH,DiagramMoveDown,DiagramMoveUp,DiagramNorm,DiagramOrthogonalization,DiagramRotate,DiagramScalar,DiagramTensor,DiagramTrace,Bilinearize,ConjugateLinearize,Linearize,MakeGraphs,Sesquilinearize,AppendToLibrary,ClearLibrary,Description,JoinWithLibrary,LoadLibrary,Retrieve];

Retrieve::usage=
"Retrieve[item,opts] gives the value of item in the current library.";
Description::usage=
"Description[item] gives the description of item in the library.";
LoadLibrary::usage=
"LoadLibrary[file] adds the contents of file to the library.";
AppendToLibrary::usage=
"AppendToLibrary[r] adds a single item to the library, given by the rule r.";
JoinWithLibrary::usage=
"JoinWithLibrary[a] adds the contents of the association a to the library.";
ClearLibrary::usage=
"ClearLibrary[] deletes all entries from the library.";


Linearize::usage="Linearize[f] makes the function f linear, in its first argument, with respect to expressions with head AdjMtx. f can allow more than one argument.";
ConjugateLinearize::usage=
"ConjugateLinearize[f] makes the function f linear, in its first argument, with respect to expressions with head AdjMtx. f can allow more than one argument.";
Bilinearize::usage="Bilinearize[f] makes the function f linear, in its first argument, with respect to expressions with head AdjMtx. f can allow more than one argument.";
Sesquilinearize::usage="Sesquilinearize[f] makes the function f linear, in its first argument, with respect to expressions with head AdjMtx. f can allow more than one argument.";


d::usage="d represents the formal loop parameter of a trivalent category. It is also an option of functions such as ReduceDiagram, having the symbol d as its default value.";
b::usage="b represents the formal bigon parameter of a trivalent category. It is also an option of functions such as ReduceDiagram, having the symbol b as its default value.";
t::usage="t represents the formal triangle parameter of a trivalent category. It is also an option of functions such as ReduceDiagram, having the symbol t as its default value.";
ReduceSquares::usage="ReduceSquare is an option for ReduceDiagram that specifies whether squares should be reduced.";
dimC4::usage="dimC4 represents the dimension of Subscript[C, 4] of a trivalent category, the linear space of diagrams with fours external legs. It is an option of functions such as ReduceDiagram, where it is relevant for substituting squares. In this case, the default value is 4.";
AdjMtx::usage="AdjMtx[adj,in,out] represents a diagram with adjacency matrix a, ingoing legs in, and outgoing legs out.";
ReduceDiagram::usage="ReduceDiagram[adj, opts] reduces the diagram adj. Possbile options are d, b, t, dimC4, ReduceSquares. ReduceDiagram is linear in adj.";


DiagramTensor::usage="DiagramTensor[adj1, adj2] gives the tensor product of the diagrams adj1 and adj2. DiagramTensor is bilinear.";
ConnectAt::usage="ConnectAt[a1, a2, legs1, legs2] is a low-level function and gives the adjacency matrix obtained by connecting the legs legs1 of a1 to the legs legs2 of a2.";
DiagramCompose::usage="DiagramCompose[adj1, adj2] gives the diagram obtained from composing adj1 and adj2. DiagramCompose is bilinear.";
DiagramTrace::usage="DiagramTrace[adj] gives the trace of adj. DiagramTrace is linear.";
DiagramOrthogonalization::usage="DiagramOrthogonalization[vectors, opts] takes the list vectors of diagrams and returns the coefficients of Gram-Schmidt performed on these. Options for d, b, t, dimC4 can be specified.";
DiagramFlipH::usage=
"DiagramFlipH[adj] gives the diagram adj flipped horizontally, by exchanging the lists of in and out vertices.";
DiagramConjugate::usage=
"DiagramConjugate[adj] gives the diagram adj flipped horizontally, by exchanging the lists of in and out vertices. DiagramConjugate is conjugate-linear.";
DiagramRotate::usage="DiagramRotate[adj] gives the diagram adj rotated by 180 degrees, i.e. the lists for in and out legs are swapped and both reversed. DiagramRotate is linear.";
DiagramScalar::usage="DiagramScalar[adj1, adj2] gives the scalar product of adj1 and adj2. DiagramScalar is bilinear.";
DiagramNorm::usage=
"DiagramNorm[adj] gives the norm of the diagram adj.";
DiagramMoveUp::usage="DiagramMoveUp[adj, n] takes the n rightmost in legs of adj and makes them out legs in reverse order. DiagramMoveUp is linear.";
DiagramMoveDown::usage="DiagramMoveDown[adj,n] takes the n rightmost out legs of adj and makes them in legs in reverse order. DiagramMoveDown is linear.";
MakeGraphs::usage=
"MakeGraphs[expr] gives a list of all graphs corresponding to adjcacency matrices occuring in expr.";

Begin["`Private`"]

ParameterOptions={d->d,b->b,t->t,dimC4->4};
ReduceOptions=Append[ParameterOptions,ReduceSquares->True];
Options[Retrieve]=ParameterOptions;
Set[Options@#,ReduceOptions]&/@
{SquareCoefficients,ReduceDiagram,DiagramOrthogonalization,DiagramNorm};

library=<||>;
Retrieve[item_,opts:OptionsPattern[]]:=Module[
{value},
value=library[item,"value"];
If[KeyExistsQ[library[item],"attributes"],
If[MemberQ[library[item,"attributes"],"releasehold"],
Return[ReleaseHold[value/.{d->OptionValue@d,b->OptionValue@b,t->OptionValue@t,dimC4->OptionValue@dimC4}]];
];
];
Return[value/.{d->OptionValue@d,b->OptionValue@b,t->OptionValue@t,dimC4->OptionValue@dimC4}];
];
Description[item_]:=library[item,"description"];
LoadLibrary[file_]:=(library=Join[library,Get@file];Return[]);
JoinWithLibrary[a_]:=(library=Join[library,a];Return[])
AppendToLibrary[item_]:=AppendTo[library,item];
ClearLibrary[]:=library=<||>;

Linearize[f_]:=(
f[x_+y_,args___]:=f[x,args]+f[y,args];
f[c_*adj_AdjMtx,args___]:=c*f[adj,args];
f[c_*x_/;FreeQ[c,_AdjMtx],args___]:=c*f[x,args];
);

ConjugateLinearize[f_]:=(
f[x_+y_,args___]:=f[x,args]+f[y,args];
f[c_*adj_AdjMtx,args___]:=Conjugate@c*f[adj,args];
f[c_*x_/;FreeQ[c,_AdjMtx],args___]:=Conjugate@c*f[x,args];
);

Bilinearize[f_]:=(
f[c_*adj_AdjMtx,z_]:=c*f[adj,z];
f[x_,c_*adj_AdjMtx]:=c*f[x,adj];
f[c_*x_/;FreeQ[c,_AdjMtx],z_]:=c*f[x,z];
f[x_,c_*z_/;FreeQ[c,_AdjMtx]]:=c*f[x,z];
f[x_+y_,z_]:=f[x,z]+f[y,z];
f[x_,y_+z_]:=f[x,y]+f[x,z];
);

Sesquilinearize[f_]:=(
f[c_*adj_AdjMtx,z_]:=Conjugate@c*f[adj,z];
f[x_,c_*adj_AdjMtx]:=c*f[x,adj];
f[c_*x_/;FreeQ[c,_AdjMtx],z_]:=Conjugate@c*f[x,z];
f[x_,c_*z_/;FreeQ[c,_AdjMtx]]:=c*f[x,z];
f[x_+y_,z_]:=f[x,z]+f[y,z];
f[x_,y_+z_]:=f[x,y]+f[x,z];
);

Linearize/@{DiagramTrace,DiagramMoveUp,DiagramMoveDown};ConjugateLinearize/@{DiagramConjugate};
Bilinearize/@{DiagramTensor,DiagramCompose};

(**********)

SetAttributes[DeleteRowCol,HoldFirst];
DeleteRowCol[list_,indices_]:=
Do[
list=Delete[list,i];
list=Drop[list,None,{i}];
,{i,ReverseSort@indices}];

internalC4Atoms=AdjMtx[#,{},{2,3,4,1}]&/@{({
 {0, 1, 0, 0},
 {1, 0, 0, 0},
 {0, 0, 0, 1},
 {0, 0, 1, 0}
}),({
 {0, 0, 0, 1},
 {0, 0, 1, 0},
 {0, 1, 0, 0},
 {1, 0, 0, 0}
}),({
 {0, 0, 0, 0, 0, 1},
 {0, 0, 0, 0, 1, 0},
 {0, 0, 0, 0, 1, 0},
 {0, 0, 0, 0, 0, 1},
 {0, 1, 1, 0, 0, 1},
 {1, 0, 0, 1, 1, 0}
}),({
 {0, 0, 0, 0, 1, 0},
 {0, 0, 0, 0, 1, 0},
 {0, 0, 0, 0, 0, 1},
 {0, 0, 0, 0, 0, 1},
 {1, 1, 0, 0, 0, 1},
 {0, 0, 1, 1, 1, 0}
})};

SquareCoefficients[opts:OptionsPattern[]]:=
Switch[OptionValue@dimC4,
2,{b^2/(1+d),b^2/(1+d)},
3,{(b^2-b^2 d+d t^2)/(1+d-d^2),(b^2 (-2+d)+t^2)/(-1-d+d^2),((-1+d) (-b^2+(1+d) t^2))/(b (-1-d+d^2))},
4,{(b (b^2+b t-t^2))/(b d+t+d t),(b (b^2+b t-t^2))/(b d+t+d t),(-b^2+(1+d) t^2)/(b d+t+d t),(-b^2+(1+d) t^2)/(b d+t+d t)}
]/.{d->OptionValue@d,b->OptionValue@b,t->OptionValue@t};

GetNewLegIndices[adj_List,oldlength_,inlst_,outlst_]:=Module[{
a=adj,i,in=inlst,out=outlst,newin={},newout={}
},
For[i=1,i<=Length[a],i++,
If[Plus@@a[[i]]==1&&a[[i,i]]==0,
If[Length[in]==0,AppendTo[in,oldlength+1]];
If[Length[out]==0,AppendTo[out,oldlength+1]];
If[First@in<First@out,
AppendTo[newin,i];
in=Delete[in,1];
,(*else:*)
AppendTo[newout,i];
out=Delete[out,1];
];
]; (*if*)
];(*for*)
Return[{newin,newout}];
];(*module*)

ReduceDiagram[adj_AdjMtx,opts:OptionsPattern[]]:=Module[{
debugcounter=0,
a=First[adj],(* adjacency matrix*)
numberoflegs,
in,out,newin,newout,
result,secondround=False,
i,j,noe,
dp=0,bp=0,tp=0, (* powers of d, b, t *)
current,(* current vertex in the loop *)
degree,(* degree of current vertex *)
neighbours,(* other neighbours of current vertex, excluding current vertex, to which it is connected by a *single* edge *)
selfconnected, (* whether the current vertex is connected to itself *)
bigon,bigonneighbour,bigonloop,(* a close neighbour is one to which it is connected by 2 edges *)
bigonneighboursotherneighbour,
triangle,triangleneighbours,othertriangleneighbour,
square,squareneighbours,othersquarecorner,squarevertices,neighboursofsquare,sqcoeff,newa,newadj,
idxlst={{1,2},{1,3},{2,3}}
},

(* In the first round, remove all 2-valent vertices. *)
current=Length[a]; 
While[current>0, (**** 2-valent loop ****)
degree=0;
selfconnected=False;
neighbours={};
For[i=1,i<=Length[a],i++,
noe=a[[current,i]];
degree+=a[[current,i]];
Switch[noe,
1,
	AppendTo[neighbours,i];
	If[i==current,selfconnected=True];,
2,
	AppendTo[neighbours,i];
];(*switch*)
];(*for*)
If[selfconnected,degree++];
If[degree==2,
If[selfconnected,
DeleteRowCol[a,{current}];
dp++;
current--;
Continue[];
];
Switch[Length[neighbours],
1,
	a[[First@neighbours,First@neighbours]]+=1;
	DeleteRowCol[a,{current}];
	current--;
	Continue[];,
2,
	a[[First@neighbours,Last@neighbours]]+=1;
	a[[Last@neighbours,First@neighbours]]+=1;
	DeleteRowCol[a,{current}];
	current--;
	Continue[];
];

];(*while*)
current--;
];(*while*)

(* Begin with the last vertex, work towards the first, always considering the *last* interesting vertex. Interesting means that it is not 1-valent. 2-valent vertices do not occur since we change the graph carefully. *)
current=Length[a];
numberoflegs=If[Length[adj]>1,Length[adj[[2]]]+Length[adj[[3]]],0];

While[True, (**** main loop ****)
debugcounter++;
If[current<1,
If[Length[a]>numberoflegs&&!secondround,
current=Length[a];
secondround=True;
,(*else*)
Break[];
];
];
degree=0;neighbours={};selfconnected=False;bigon=False;
bigonloop=False;
For[i=1,i<=Length[a],i++,
noe=a[[current,i]];
degree+=a[[current,i]];

(* At this point we can already detect several interesting cases, depending on the number of edges between the current vertex and vertex i: *)
Switch[noe,
1,
If[i==current,
	selfconnected=True,
	AppendTo[neighbours,i]];,
2,(* In this case, i must be unequal to current. The two must be part of a bigon or a loop or a lollipop. *)
	bigon=True;bigonneighbour=i;,
3,(* For simplicity, we treat this case separately. *)
	bigonloop=True;bigonneighbour=i;
]; (*switch*)

]; (*for*)
(* important: *)
If[selfconnected,degree++]; 

(* main distinction according to vertex degree *)
Switch[degree,
1, (* external leg, do nothing except make sure that this vertex is not visited again *)
current-=1;
Continue[];,

3, (* trivalent vertex, it can be a lollipop, part of a bigon(loop), triangle or square *)
If[selfconnected, (* lollipop *)
Return[0];
];

If[bigon,
bigonneighboursotherneighbour=First@FirstPosition[a[[bigonneighbour]],1];
(*Print[a//MatrixForm];
Print[current," ",bigonneighbour," ",bigonneighboursotherneighbour];*)
a[[First@neighbours,bigonneighboursotherneighbour]]+=1;
If[First@neighbours!=bigonneighboursotherneighbour,
a[[bigonneighboursotherneighbour,First@neighbours]]+=1;
];
DeleteRowCol[a,{current,bigonneighbour}];
bp+=1;
current-=2;
Continue[];
];

If[bigonloop,
DeleteRowCol[a,{current,bigonneighbour}];
dp+=1;bp+=1;
current-=2;
Continue[];
];

triangle=False;
square=False;
Do[
If[a[[neighbours[[First@i]],neighbours[[Last@i]]]]==1,
triangle=True;
triangleneighbours=neighbours[[i]];
Break[];,
If[OptionValue@ReduceSquares,
(* look for a square: *)
For[j=1,j<=Length[a],j++,
If[j!=current&&a[[neighbours[[First@i]],j]]==1&&a[[neighbours[[Last@i]],j]]==1,
square=True;
squareneighbours=neighbours[[i]];
othersquarecorner=j;
Break[];
];(*if*)
];(*for*)
];(*if*)
];(*if*)
If[square,Break[]];
,{i,idxlst}];(*do*)

If[triangle,
(* find the neighbours of the triangle and connect them to current *)
Do[
(* iterate over the two vertices with which "current" forms a triangle *)
othertriangleneighbour=triangleneighbours[[If[i==1,2,1]]];
For[j=1,j<=Length[a],j++,
If[j!=current&&j!=othertriangleneighbour&&a[[triangleneighbours[[i]],j]]!=0,
a[[current,j]]+=1;
a[[j,current]]+=1;
Break[];
];(*if*)
];(*for*)
,{i,{1,2}}];(*do*)

(* then delete the vertices *)

DeleteRowCol[a,triangleneighbours];
tp+=1;
current-=2;
Continue[];
];(*if*)

If[square,
squarevertices={current,squareneighbours[[1]],othersquarecorner,squareneighbours[[2]]};
neighboursofsquare={};
(* find the neighbours of the square *)
Do[
For[j=1,j<=Length[a],j++,
If[a[[i,j]]!=0&&!MemberQ[squarevertices,j],
AppendTo[neighboursofsquare,j];
Break[];
];
];
,{i,squarevertices}];
sqcoeff=SquareCoefficients[opts];
newadj=0;
For[i=1,i<=OptionValue@dimC4,i++,
newa=ConnectAt[a,internalC4Atoms[[i,1]],
neighboursofsquare,
internalC4Atoms[[i,3]]];
DeleteRowCol[newa,squarevertices];
If[Length@adj>1,
newadj+=sqcoeff[[i]]*Join[AdjMtx[newa],AdjMtx@@GetNewLegIndices[newa,Length@First@adj,adj[[2]],adj[[3]]]];
,
newadj+=sqcoeff[[i]]*AdjMtx[newa];
];(*if*)
];
Return[ReduceDiagram[newadj,opts]];
];(*if*)

(* If we reach this point, then the diagram is invalid or the vertex is not part of something reducable because there are open legs. *)
current--;
];(*switch*)
];(*while*) (*********)

result=AdjMtx[a];

(* It might happen that one calls DReduce on a diagram with distinguished in/out legs. In this case, we can easily recover the new indices. Since this won't occur in time-critical cases, we don't optimize. *)
If[Length[adj]>1,
result=Join[result,AdjMtx@@GetNewLegIndices[a,Length@First@adj,adj[[2]],adj[[3]]]];
];

If[Length[a]>0,Return[OptionValue@d^dp*OptionValue@b^bp*OptionValue@t^tp*result],Return[OptionValue@d^dp*OptionValue@b^bp*OptionValue@t^tp]];
];(*module*)
ReduceDiagram[x_+y_,opts:OptionsPattern[]]:=ReduceDiagram[x,opts]+ReduceDiagram[y,opts];
ReduceDiagram[c_*adj_AdjMtx,opts:OptionsPattern[]]:=c*ReduceDiagram[adj,opts];
ReduceDiagram[c_*x_/;FreeQ[c,_AdjMtx],opts:OptionsPattern[]]:=c*ReduceDiagram[x,opts];
ReduceDiagram[c_/;FreeQ[c,_AdjMtx],args___]:=c;

DiagramTensor[adj1_AdjMtx,adj2_AdjMtx]:=AdjMtx@@Join[{ArrayFlatten[{{First@adj1,0},{0,First@adj2}}]},
If[Length@adj1>1,{Join[adj1[[2]],Length[First@adj1]+adj2[[2]]],Join[adj1[[3]],Length[First@adj1]+adj2[[3]]]},{}]];
DiagramTensor[adj1_AdjMtx,adj2_AdjMtx,adj3__AdjMtx]:=DiagramTensor[adj1,DiagramTensor[adj2,adj3]];

ConnectAt[adj1_List,adj2_List,legs1_List,legs2_List]:=Module[{
a1=adj1,a2=adj2,l1=legs1,l2=legs2,
len1,result,i
},
(* ConnectAt checks *nothing*. The arguments need to have the appropriate format. *)
(* Put both matrices into one matrix *)
result=ArrayFlatten[{{a1,0},{0,a2}}];
len1=Length[a1];
For[i=1,i<=Length[l1],i++,
result[[l1[[i]],len1+l2[[i]]]]=1;
result[[len1+l2[[i]],l1[[i]]]]=1;
];(*for*)
Return[result];
](*module*)

DiagramCompose[adj1_AdjMtx,adj2_AdjMtx]:=AdjMtx[ConnectAt[First@adj1,First@adj2,adj1[[3]],adj2[[2]]],adj1[[2]],Length[First@adj1]+adj2[[3]]];
DiagramCompose[adj1_AdjMtx,adj2_AdjMtx,adj3__AdjMtx]:=DiagramCompose[adj1,DiagramCompose[adj2,adj3]];

DiagramTrace[adj_AdjMtx]:=Module[{
a=First@adj,legs,len,i,v1,v2
},
(* To make life easier and speed up the program, I implement the trace manually. Again, DiagramTrace checks *nothing*. *)
legs=Join[adj[[2]],Reverse@adj[[3]]];
len=Length@legs;
For[i=1,i<=len/2,i++,
v1=legs[[i]];
v2=legs[[len-i+1]];
a[[v1,v2]]+=1;
a[[v2,v1]]+=1;
];(*for*)
Return[AdjMtx[a]];
];

DiagramRotate[adj_AdjMtx]:=AdjMtx[First@adj,Reverse@adj[[3]],Reverse@adj[[2]]];

DiagramFlipH[adj_AdjMtx]:=AdjMtx[First@adj,adj[[3]],adj[[2]]];

DiagramConjugate[adj_AdjMtx]:=DiagramFlipH[adj];

DiagramScalar[adj1_,adj2_]:=DiagramTrace@DiagramCompose[DiagramConjugate@adj1,adj2];

DiagramNorm[adj_,opts:OptionsPattern[]]:=Sqrt@ReduceDiagram[DiagramScalar[adj,adj],opts];

DiagramOrthogonalization[vectors_List,opts:OptionsPattern[]]:=Module[{
vec=vectors,
m,n=Length@vectors
},
m=Table[ReduceDiagram[DiagramScalar[vec[[i]],vec[[j]]],opts],{i,1,n},{j,1,n}];
Return@Orthogonalize[IdentityMatrix[n],#1.m.#2&];
];

DiagramMoveDown[adj_AdjMtx,nlegs_]:=AdjMtx[First@adj,Join[adj[[2]],Reverse@Take[adj[[3]],-nlegs]],Drop[adj[[3]],-nlegs]];

DiagramMoveUp[adj_AdjMtx,nlegs_]:=AdjMtx[First@adj,Drop[adj[[2]],-nlegs],Join[adj[[3]],Reverse@Take[adj[[2]],-nlegs]]];

MakeGraphs[adjs_]:=(AdjacencyGraph[#,VertexLabels->"Name"]&)@*First/@Cases[adjs,_AdjMtx,Infinity];

End[]

SetAttributes[{AdjMtx,b,d,dimC4,ReduceDiagram,ReduceSquares,t,ConnectAt,DiagramCompose,DiagramConjugate,DiagramFlipH,DiagramMoveDown,DiagramMoveUp,DiagramNorm,DiagramOrthogonalization,DiagramRotate,DiagramScalar,DiagramTensor,DiagramTrace,Bilinearize,ConjugateLinearize,Linearize,MakeGraphs,Sesquilinearize,AppendToLibrary,ClearLibrary,Description,JoinWithLibrary,LoadLibrary,Retrieve},{ReadProtected,Protected}];

EndPackage[]
