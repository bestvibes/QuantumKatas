// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains parts of the testing harness.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SimonsAlgorithm {
    
    open Microsoft.Quantum.Diagnostics;
    
    
    // ------------------------------------------------------
    operation ApplyOracleA (qs : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj)) : Unit
    is Adj {        
        let N = Length(qs);
        oracle(qs[0 .. N - 2], qs[N - 1]);
    }
    
    
    operation ApplyOracleWithOutputArrA (qs : Qubit[], oracle : ((Qubit[], Qubit[]) => Unit is Adj), outputSize : Int) : Unit
    is Adj {
        let N = Length(qs);
        oracle(qs[0 .. (N - 1) - outputSize], qs[N - outputSize .. N - 1]);
    }
    
    
    // ------------------------------------------------------
    operation AssertTwoOraclesAreEqual (
        nQubits : Range, 
        oracle1 : ((Qubit[], Qubit) => Unit is Adj), 
        oracle2 : ((Qubit[], Qubit) => Unit is Adj)) : Unit {
        let sol = ApplyOracleA(_, oracle1);
        let refSol = ApplyOracleA(_, oracle2);
        
        for (i in nQubits) {
            AssertOperationsEqualReferenced(i+1, sol, refSol);
        }
    }
    
    
    operation AssertTwoOraclesWithOutputArrAreEqual (
        inputSize : Int, 
        outputSize : Int, 
        oracle1 : ((Qubit[], Qubit[]) => Unit is Adj), 
        oracle2 : ((Qubit[], Qubit[]) => Unit is Adj)) : Unit {
        let sol = ApplyOracleWithOutputArrA(_, oracle1, outputSize);
        let refSol = ApplyOracleWithOutputArrA(_, oracle2, outputSize);
        AssertOperationsEqualReferenced(inputSize + outputSize, sol, refSol);
    }
    
    // ------------------------------------------------------
    operation AssertTwoOraclesWithIntArrAreEqual (A : Int[], oracle1 : ((Qubit[], Qubit, Int[]) => Unit is Adj), oracle2 : ((Qubit[], Qubit, Int[]) => Unit is Adj)) : Unit {
        AssertTwoOraclesAreEqual(Length(A) .. Length(A), oracle1(_, _, A), oracle2(_, _, A));
    }
    
    
    // ------------------------------------------------------
    operation AssertTwoOraclesWithIntMatrixAreEqual (
        A : Int[][], 
        oracle1 : ((Qubit[], Qubit[], Int[][]) => Unit is Adj), 
        oracle2 : ((Qubit[], Qubit[], Int[][]) => Unit is Adj)) : Unit {
        let inputSize = Length(A[0]);
        let outputSize = Length(A);
        AssertTwoOraclesWithOutputArrAreEqual(inputSize, outputSize, oracle1(_, _, A), oracle2(_, _, A));
    }
    
    
    operation AssertTwoOraclesWithDifferentOutputsAreEqual (
        inputSize : Int, 
        oracle1 : ((Qubit[], Qubit[]) => Unit is Adj), 
        oracle2 : ((Qubit[], Qubit) => Unit is Adj)) : Unit {
        let sol = ApplyOracleWithOutputArrA(_, oracle1, 1);
        let refSol = ApplyOracleA(_, oracle2);
        AssertOperationsEqualReferenced(inputSize + 1, sol, refSol);
    }
    
    // ------------------------------------------------------
    operation cs_helper (N : Int, Matrix : Int[][]) : (Int[], ((Qubit[], Qubit[]) => Unit)) {
        let Uf = Oracle_MultidimensionalOperatorOutput(_, _, Matrix);
        return (Simon_Algorithm(N, Uf), Uf);
    }
    
}
