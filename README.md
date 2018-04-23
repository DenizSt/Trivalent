# Trivalent

A framework and set of tools to perform calculations with trivalent diagrams in *Mathematica*.

*Written by* Deniz Stiegemann.

## Table of Contents

* [**Installation & Setup**](#installation-setup)
* [**List of Files in the Repository**](#list-of-files-in-the-repository)
* [**Background**](#background)
* [**Documentation**](#documentation)
	* [Reduction of Trivalent Diagrams](#reduction-of-trivalent-diagrams)<br />
    	AdjMtx, b, d, dimC4, ReduceDiagram, ReduceSquares, t
    * [Operations on Diagrams](#operations-on-diagrams)<br />
    	ConnectAt, DiagramCompose, DiagramConjugate, DiagramFlipH, DiagramMoveDown, DiagramMoveUp, DiagramNorm, DiagramOrthogonalization, DiagramRotate, DiagramScalar, DiagramTensor, DiagramTrace
    * [Other Tools](#other-tools)<br />
    	Bilinearize, ConjugateLinearize, Linearize, MakeGraphs, Sesquilinearize
    * [Libraries](#libraries)<br />
    	AppendToLibrary, ClearLibrary, Description, JoinWithLibrary, LoadLibrary, Retrieve
* [**Acknowledgements**](#acknowledgements)
* [**License**](#license)

## Installation & Setup

You need *Mathematica* 11.2 or higher to run the package.

The easiest way to get started is to copy the two files

* `Trivalent.m`
* `stdlib`

into the folder that also contains the notebook in which you want to use the package. You can then load the package with the following two lines:

```mathematica
SetDirectory[NotebookDirectory[]];
<< Trivalent`;
```

## List of Files in the Repository

The following files are sufficient for using the package:

* `Trivalent.m` contains the package code.
* `stdlib` is the standard library, which contains shortcuts for frequently-used diagrams and relations.

Additionally, I added the following files:

* `C4ONB.nb` is the notebook which was used to compute an orthonormal basis for C4 and the relations for the square diagram.
* `stdlib.nb` is the notebook used to create the standard library.

`C4ONB.nb` can serve as an illustration of how to do calculations with the package in practice, and `stdlib.nb` shows how library files can be created.


## Background

The main reference is

* S. Morrison, E. Peters, and N. Snyder. _Categories generated by a trivalent vertex._ Selecta Mathematica **23** (2017), no. 2, pp. 817–868. doi:[10.1007/s00029-016-0240-3](https://doi.org/10.1007/s00029-016-0240-3), arXiv:[1501.06869](https://arxiv.org/abs/1501.06869),

where trivalent categories were introduced and classified for a large variety of dimensions. The arXiv source contains notebooks with which the authors did some of the calculations and where they implement many functions also found in this package.


## Documentation

After having loaded the package, you can use

```mathematica
?Trivalent`*
```

to obtain a list of all symbols and functions introduced by the **Trivalent** package, together with their usage descriptions.

*Please note* that the package does not yet have any exception handling, so you are always expected to enter valid arguments, and errors might not always be visible.


### Reduction of Trivalent Diagrams

#### AdjMtx

`AdjMtx[a,in,out]`<br />
represents a diagram with adjacency matrix `a`, ingoing legs `in`, and outgoing legs `out`.

`AdjMtx[a]`<br />
represents a diagram with adjacency matrix `a` and no exernal legs. Equivalent to `AdjMtx[a,{},{}]`.

Legs are represented in the adjacency matrix by 1-valent vertices. Obsolete 2-valent vertices (i.e. 2-valent vertices that are not loops) are allowed and correctly removed by `ReduceDiagram`.

The convention for graphical representations of diagrams is that ingoing legs are located at the bottom of a diagram and outgoing legs at the top.

#### b

`b` represents the formal bigon parameter of a trivalent category. It is also an option of functions such as `ReduceDiagram`, having the symbol `b` as its default value.

#### d

`d` represents the formal loop parameter of a trivalent category. It is also an option of functions such as `ReduceDiagram`, having the symbol `d` as its default value.

#### dimC4

`dimC4` represents the dimension of C4 of a trivalent category, the linear space of diagrams with four external legs. It is an option of functions such as `ReduceDiagram`, where it is relevant for substituting squares.
In this case, the default value is 4.

#### ReduceDiagram

`ReduceDiagram[adj]` simplifies the diagram `adj` by removing 2-valent vertices and applying substitution rules for loops, lollipops, bigons, triangles, and squares. If the diagram has no external legs and can be completely reduced, an expression in terms of only d, b, and t is returned. Otherwise, the simplified form of `adj` is returned.

`ReduceDiagram` admits the following options:

Option | Default | Description
--- | --- | ---
[b](#b) | b | bigon parameter
[d](#d) | d | loop parameter
[dimC4](#dimc4) | 4 | dimension of C4
[ReduceSquares](#reducesquares) | True | whether to reduce squares
[t](#t) | t | triangle parameter

Note that unless there is no other way of reducing a diagram, it is often helpful to set `ReduceSquares->False` in order to avoid complicated return values.

`ReduceDiagram` is linear with respect to expressions with head `AdjMtx`.

#### ReduceSquares

`ReduceSquares` is an option of `ReduceDiagram` that specifies whether squares should be reduced. Its default value is `True`.

Note that unless there is no other way of reducing a diagram, it is often helpful to set `ReduceSquares->False` in order to avoid complicated return values when calling `ReduceDiagram`.

#### t

`t` represents the formal triangle parameter of a trivalent category. It is also an option of functions such as `ReduceDiagram`, having the symbol `t` as its default value.


### Operations on Diagrams

#### ConnectAt

`ConnectAt[a1, a2, legs1, legs2]` is a low-level function that gives the adjacency matrix obtained by connecting the legs `legs1` of `a1` to the legs `legs2` of `a2`.

#### DiagramCompose

`DiagramCompose[adj1, adj2]` gives the diagram obtained by composing `adj1` and `adj2`.

`DiagramCompose[adj1, adj2, …]` composes a finite sequence of diagrams.

`DiagramCompose` is bilinear with respect to expressions with head `AdjMtx`.

#### DiagramConjugate

`DiagramConjugate[adj]` gives the diagram `adj` reflected horizontally by swapping ingoing with outgoing legs.

`DiagramConjugate` is the conjugate-linear version of `DiagramFlipH` and therefore more useful for computations.

`DiagramConjugate` is conjugate-linear with respect to expressions with head `AdjMtx`.

#### DiagramFlipH

`DiagramFlipH[adj]` gives the diagram `adj` reflected horizontally by exchanging the lists of in and out vertices.

`DiagramConjugate` is the conjugate-linear version of `DiagramFlipH` and therefore more useful for computations.

#### DiagramMoveDown

`DiagramMoveDown[adj,n]` takes the `n` rightmost outgoing legs of `adj` and makes them ingoing legs in reverse order.

`DiagramMoveDown[adj,-n]` takes the `n` leftmost outgoing legs of `adj` and makes them ingoing legs in reverse order.

`DiagramMoveDown` is linear with respect to expressions with head `AdjMtx`.

#### DiagramMoveUp

`DiagramMoveUp[adj,n]` takes the `n` rightmost ingoing legs of `adj` and makes them outgoing legs in reverse order.

`DiagramMoveUp[adj,-n]` takes the `n` leftmost ingoing legs of `adj` and makes them outgoing legs in reverse order.

`DiagramMoveUp` is linear with respect to expressions with head `AdjMtx`.

#### DiagramNorm

`DiagramNorm[adj]` gives the norm of the diagram `adj`.

`DiagramNorm` uses `ReduceDiagram` to compute the value of the scalar product of `adj` with itself. Options to be used by `ReduceDiagram` can be specified as options for `DiagramNorm` and are passed along.

`DiagramNorm` uses `DiagramScalar` and therefore supports linear combinations of expressions with head `AdjMtx` as input.

#### DiagramOrthogonalization

`DiagramOrthogonalization[vectors]` takes a list `vectors` of (linear combinations of) diagrams and returns the coefficients obtained by performing the Gram–Schmidt orthonormalization algorithm.

`DiagramOrthogonalization` uses `ReduceDiagram` to compute scalar products. Options to be used by `ReduceDiagram` can be specified as options for `DiagramOrthogonalization` and are passed along.

The elements of the list `vectors` can be linear combinations of expressions with head `AdjMtx`.

#### DiagramRotate

`DiagramRotate[adj]` gives the diagram `adj` rotated by 180 degrees, i.e. the lists of ingoing and outgoing legs are swapped and each reversed.

`DiagramRotate` is linear with respect to expressions with head `AdjMtx`.

#### DiagramScalar

`DiagramScalar[adj1, adj2]` gives the scalar product of `adj1` and `adj2`.

`DiagramScalar` is sesquilinear with respect to expressions with head `AdjMtx`, i.e. conjugate-linear in the first and linear in the second argument.

#### DiagramTensor

`DiagramTensor[adj1, adj2]` gives the tensor product of the diagrams `adj1` and `adj2`.

`DiagramTensor` is bilinear with respect to expressions with head `AdjMtx`.

#### DiagramTrace

`DiagramTrace[adj]` gives the trace of `adj`.

`DiagramTrace` is linear with respect to expressions with head `AdjMtx`.

### Other Tools

#### Bilinearize

`Linearize[f]` makes the function `f` bilinear with respect to expressions with head `AdjMtx`.

`f` can be any function of two arguments which has already been defined for expressions with head `AdjMtx` in the following way:
```mathematica
f[adj1_AdjMtx, adj2_AdjMtx]:= expr
```

#### ConjugateLinearize

`Linearize[f]` makes the function `f` conjugate-linear, in its first argument, with respect to expressions with head `AdjMtx`.

`f` can be any function which has already been defined for expressions with head `AdjMtx` in the following way:
```mathematica
f[adj_AdjMtx, …]:= expr
```
`f` can have more than one argument.

#### Linearize

`Linearize[f]` makes the function `f` linear, in its first argument, with respect to expressions with head `AdjMtx`.

`f` can be any function which has already been defined for expressions with head `AdjMtx` in the following way:
```mathematica
f[adj_AdjMtx, …]:= expr
```
`f` can have more than one argument.

#### MakeGraphs

`MakeGraphs[expr]` gives a list of graphs for all adjacency matrices occuring in `expr`.

#### Sesquilinearize

`Linearize[f]` makes the function `f` sesquilinear with respect to expressions with head `AdjMtx`, i.e. conjugate-linear in its first and linear in its second argument.

`f` can be any function of two arguments which has already been defined for expressions with head `AdjMtx` in the following way:
```mathematica
f[adj1_AdjMtx, adj2_AdjMtx]:= expr
```

### Libraries

Diagrams and relations often used in computations can be conveniently stored in a file and are loaded with the following routines.

The *library* is a dictionary whose entries can be looked up with `Retrieve["name of item"]`. By default, the library is empty. `LoadLibrary` can be used to load the contents of a file into the library. For example, to load the standard library *stdlib*, use
```mathematica
LoadLibrary["stdlib"]
```
and to obtain the basic diagrams in C4, use
```mathematica
Retrieve["C4Atoms"]
```

In practice, you will only need `LoadLibrary` and `Retrieve`.

#### AppendToLibrary

`AppendToLibrary[r]` adds a single item to the library, given by the rule `r`.

#### ClearLibrary

`ClearLibrary[]` deletes all entries from the library.

#### Description

`Description[item]` gives the description of item in the library.

#### JoinWithLibrary

`JoinWithLibrary[a]` adds the contents of the association `a` to the library.

#### LoadLibrary

`LoadLibrary[file]` adds the contents of the file `file` to the library.

`file` must be a string.

#### Retrieve

`Retrieve[item]` gives the value of `item` in the current library.

Options can be specified in the form `Retrieve[item,opts]` and are applied to the result of the library search. For example, in order to choose the dimension of C4 to be 2, you can use `Retrieve[item,dimC4->2]`.

## Acknowledgements

I would like to thank Tobias Osborne for introducing me to the topic, and Markus Duwe and Ramona Wolf for many helpful comments and for testing the package.

## License

The package is available under the terms of the MIT license. See the LICENSE file for details.

Copyright (c) 2018 Deniz Stiegemann
