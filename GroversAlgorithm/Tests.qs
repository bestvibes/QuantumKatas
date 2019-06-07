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
    
    
    // ------------------------------------------------------
    // operation T11_Oracle_AllOnes_Test () : Unit {
    //     let testOp = QubitArrayWrapperOperation(Oracle_AllOnes, _);
    //     let refOp = QubitArrayWrapperOperation(Oracle_AllOnes_Reference, _);
    //     AssertRegisterOperationsEqual(testOp, refOp);
    // }
    
    
    // ------------------------------------------------------
    // operation T12_Oracle_AlternatingBits_Test () : Unit {
    //     let testOp = QubitArrayWrapperOperation(Oracle_AlternatingBits, _);
    //     let refOp = QubitArrayWrapperOperation(Oracle_AlternatingBits_Reference, _);
    //     AssertRegisterOperationsEqual(testOp, refOp);
    // }
    
    
    // ------------------------------------------------------
    // operation T13_Oracle_ArbitraryPattern_Test () : Unit {
    //     for (n in 2 .. 10) {
    //         let pattern = IntAsBoolArray(RandomIntPow2(n), n);
    //         let testOp = QubitArrayWrapperOperation(Oracle_ArbitraryPattern(_, _, pattern), _);
    //         let refOp = QubitArrayWrapperOperation(Oracle_ArbitraryPattern_Reference(_, _, pattern), _);
    //         AssertOperationsEqualReferenced(n + 1, testOp, refOp);
    //     }
    // }
    
    
    // ------------------------------------------------------
    // operation T14_OracleConverter_Test () : Unit {
    //     for (n in 2 .. 10) {
    //         let pattern = IntAsBoolArray(RandomIntPow2(n), n);
    //         let markingOracle = Oracle_ArbitraryPattern_Reference(_, _, pattern);
    //         let phaseOracleRef = OracleConverter_Reference(markingOracle);
    //         let phaseOracleSol = OracleConverter(markingOracle);
    //         AssertOperationsEqualReferenced(n, phaseOracleSol, phaseOracleRef);
    //     }
    // }
    
    
    // ------------------------------------------------------
    // operation T21_HadamardTransform_Test () : Unit {
    //     AssertRegisterOperationsEqual(HadamardTransform, HadamardTransform_Reference);
    // }
    
    
    // ------------------------------------------------------
    // operation T22_ConditionalPhaseFlip_Test () : Unit {
    //     AssertRegisterOperationsEqual(ConditionalPhaseFlip, ConditionalPhaseFlip_Reference);
    // }
    
    
    // ------------------------------------------------------
    // operation T23_GroverIteration_Test () : Unit {
    //     for (n in 2 .. 10) {
    //         let pattern = IntAsBoolArray(RandomIntPow2(n), n);
    //         let markingOracle = Oracle_ArbitraryPattern_Reference(_, _, pattern);
    //         let flipOracle = OracleConverter_Reference(markingOracle);
    //         let testOp = GroverIteration(_, flipOracle);
    //         let refOp = GroverIteration_Reference(_, flipOracle);
    //         AssertOperationsEqualReferenced(n, testOp, refOp);
    //     }
    // }
    
    
    // ------------------------------------------------------
    // operation Oracle_ArbitraryPatterns (queryRegister : Qubit[], target : Qubit, patterns : (Bool[])[]) : Unit
    // is Adj {   
    //     for (pattern in patterns) {    
    //         (ControlledOnBitString(pattern, X))(queryRegister, target);
    //     }
    // }

    // operation T13_Oracle_ArbitraryPatterns_Test () : Unit {
    //     for (n in 2 .. 10) {
    //         let pattern = IntAsBoolArray(RandomIntPow2(n), n);
    //         let pattern2 = IntAsBoolArray(RandomIntPow2(n), n);
    //         let testOp = QubitArrayWrapperOperation(Oracle_ArbitraryPattern(_, _, [pattern1,pattern2]), _);

    //         for (i in 1 .. 2 ^ n - 1) {
    //             using (register = Qubit[n]) {
    //                 using (target = Qubit()) {
    //                     set register = i;
    //                     testOp(register, target);
    //                     let res = M(target);
    //                     EqualityFactB((register != pattern1 and register != pattern2) or res);
    //                     // for (bit in indexRange(res)) {
    //                     //     EqualityFactB(res[bit] == pattern1[bit] or res[bit] == pattern2[bit], true, $"Multiple patterns test failed")
    //                     // }
    //                     ResetAll(register);
    //                 }
    //             }
    //         }
    //     }
    // }

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
