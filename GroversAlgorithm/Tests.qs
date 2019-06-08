// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.GroversAlgorithm {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    
    
    // ------------------------------------------------------
    // helper wrapper to represent oracle operation on input and output registers as an operation on an array of qubits
    operation QubitArrayWrapperOperation (op : ((Qubit[], Qubit) => Unit is Adj), qs : Qubit[]) : Unit
    is Adj {
        op(Most(qs), Tail(qs));
    }
    
    
    // ------------------------------------------------------
    // helper wrapper to test for operation equality on various register sizes
    operation AssertRegisterOperationsEqual (testOp : (Qubit[] => Unit), refOp : (Qubit[] => Unit is Adj)) : Unit {
        for (n in 2 .. 10) {
            AssertOperationsEqualReferenced(n, testOp, refOp);
        }
    }

    operation Grover (i : Int, N : Int) : Unit {
        let pattern = IntAsBoolArray(i, N);
        let markingOracle = Oracle_ArbitraryPattern(_, _, pattern);
        let num_iter = Floor(PI() / 4.0 * Sqrt(IntAsDouble(2^N)));
        let testOp = GroversSearch(_, markingOracle, num_iter);
        using (register = Qubit[N]) {
            testOp(register);
            let res = MultiM(register);
            AllEqualityFactB(pattern, ResultArrayAsBoolArray(res), "Grover failed");
            ResetAll(register);
        }
    }

    operation Grover_N_2_a_0_Test () : Unit {
        Grover(0, 2);
    }

    operation Grover_N_2_a_1_Test () : Unit {
        Grover(1, 2);
    }

    operation Grover_N_2_a_2_Test () : Unit {
        Grover(2, 2);
    }

    operation Grover_N_2_a_3_Test () : Unit {
        Grover(3, 2);
    }

    operation Grover_N_1_a_1_Test () : Unit {
        Grover(1, 1);
    }

    operation Grover_N_2_a_1_2_Test () : Unit {
        Grover(1, 2);
    }

    operation Grover_N_3_a_1_Test () : Unit {
        Grover(1, 3);
    }

    operation Grover_N_4_a_1_Test () : Unit {
        Grover(1, 4);
    }

    operation Grover_N_5_a_1_Test () : Unit {
        Grover(1, 5);
    }

    operation Grover_N_6_a_1_Test () : Unit {
        Grover(1, 6);
    }

    operation Grover_N_7_a_1_Test () : Unit {
        Grover(1, 7);
    }

    // operation T31_GroversSearch_Test () : Unit {
    //     for (n in 2 .. 7) {
    //         Message ($"Grover n={n}");
    //         for (i in 1 .. 2 ^ (n-1)) {
    //             let pattern = IntAsBoolArray(i, n);
    //             let markingOracle = Oracle_ArbitraryPattern(_, _, pattern);
    //             let num_iter = Floor(PI() / 4.0 * Sqrt(IntAsDouble(2^n)));
    //             let testOp = GroversSearch(_, markingOracle, num_iter);
    //             let refOp = GroversSearch_Reference(_, markingOracle, num_iter);
    //             // using (register = Qubit[n]) {
    //             //     testOp(register);
    //             //     // for (i in 0 .. n-1) {
    //             //     //     Message ($"res={M(register[i])}");
    //             //     // }
    //             //     ResetAll(register);
    //             // }
    //             AssertOperationsEqualReferenced(n, testOp, refOp);
    //         }
    //     }
    // }
}
