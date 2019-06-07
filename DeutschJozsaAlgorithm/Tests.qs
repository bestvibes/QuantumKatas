// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.DeutschJozsaAlgorithm {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;

    open Quantum.Kata.Utils;
    
    
    // ------------------------------------------------------
    operation ApplyOracle (qs : Qubit[], oracle : ((Qubit[], Qubit) => Unit)) : Unit {
        let N = Length(qs);
        oracle(qs[0 .. N - 2], qs[N - 1]);
    }
    
    
    // ------------------------------------------------------
    operation ApplyOracleA (qs : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj)) : Unit
    is Adj {        
        let N = Length(qs);
        oracle(qs[0 .. N - 2], qs[N - 1]);
    }
    
    
    // ------------------------------------------------------
    operation AssertTwoOraclesAreEqual (nQubits : Range, 
        oracle1 : ((Qubit[], Qubit) => Unit), 
        oracle2 : ((Qubit[], Qubit) => Unit is Adj)) : Unit {
        let sol = ApplyOracle(_, oracle1);
        let refSol = ApplyOracleA(_, oracle2);
        
        for (i in nQubits) {
            AssertOperationsEqualReferenced(i + 1, sol, refSol);
        }
    }
    
    
    // ------------------------------------------------------
    // operation T11_Oracle_Zero_Test () : Unit {
    //     AssertTwoOraclesAreEqual(1 .. 10, Oracle_Zero, Oracle_Zero_Reference);
    // }
    
    
    // ------------------------------------------------------
    // operation T12_Oracle_One_Test () : Unit {
    //     AssertTwoOraclesAreEqual(1 .. 10, Oracle_One, Oracle_One_Reference);
    // }
    
    
    // ------------------------------------------------------
    // operation T13_Oracle_Kth_Qubit_Test () : Unit {
    //     let maxQ = 6;
        
    //     // loop over index of the qubit to be used
    //     for (k in 0 .. maxQ - 1) {
    //         // number of qubits to try is from k+1 to 6
    //         AssertTwoOraclesAreEqual(k + 1 .. maxQ, Oracle_Kth_Qubit(_, _, k), Oracle_Kth_Qubit_Reference(_, _, k));
    //     }
    // }
    
    
    // ------------------------------------------------------
    // operation T14_Oracle_OddNumberOfOnes_Test () : Unit {
        
    //     // cross-test: for 1 qubit it's the same as Kth_Qubit for k = 0
    //     AssertTwoOraclesAreEqual(1 .. 1, Oracle_OddNumberOfOnes, Oracle_Kth_Qubit_Reference(_, _, 0));

    //     AssertTwoOraclesAreEqual(1 .. 10, Oracle_OddNumberOfOnes, Oracle_OddNumberOfOnes_Reference);
    // }
    
    
    // ------------------------------------------------------
    operation AssertTwoOraclesWithIntAreEqual (r : Int[], 
        oracle1 : ((Qubit[], Qubit, Int[]) => Unit), 
        oracle2 : ((Qubit[], Qubit, Int[]) => Unit is Adj)) : Unit {
        AssertTwoOraclesAreEqual(Length(r) .. Length(r), oracle1(_, _, r), oracle2(_, _, r));
    }
    
    
    // operation T15_Oracle_ProductFunction_Test () : Unit {
    //     // cross-tests
    //     // the mask for all 1's corresponds to Oracle_OddNumberOfOnes
    //     mutable r = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
    //     let L = Length(r);
        
    //     for (i in 2 .. L) {
    //         AssertTwoOraclesAreEqual(i .. i, Oracle_ProductFunction(_, _, r[0 .. i - 1]), Oracle_OddNumberOfOnes_Reference);
    //     }
        
    //     // the mask with all 0's corresponds to Oracle_Zero
    //     for (i in 0 .. L - 1) {
    //         set r w/= i <- 0;
    //     }
        
    //     for (i in 2 .. L) {
    //         AssertTwoOraclesAreEqual(i .. i, Oracle_ProductFunction(_, _, r[0 .. i - 1]), Oracle_Zero_Reference);
    //     }
        
    //     // the mask with only the K-th element set to 1 corresponds to Oracle_Kth_Qubit
    //     for (i in 0 .. L - 1) {
    //         AssertTwoOraclesAreEqual(L .. L, Oracle_ProductFunction(_, _, r w/ i <- 1), Oracle_Kth_Qubit_Reference(_, _, i));
    //     }
        
    //     set r = [1, 0, 1, 0, 1, 0];
    //     AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductFunction, Oracle_ProductFunction_Reference);

    //     set r = [1, 0, 0, 1];
    //     AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductFunction, Oracle_ProductFunction_Reference);

    //     set r = [0, 0, 1, 1, 1];
    //     AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductFunction, Oracle_ProductFunction_Reference);
    // }
    
    
    // operation T16_Oracle_ProductWithNegationFunction_Test () : Unit {
    //     // cross-tests
    //     // the mask for all 1's corresponds to Oracle_OddNumberOfOnes
    //     mutable r = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
    //     let L = Length(r);
        
    //     for (i in 2 .. L) {
    //         AssertTwoOraclesAreEqual(i .. i, Oracle_ProductWithNegationFunction(_, _, r[0 .. i - 1]), Oracle_OddNumberOfOnes_Reference);
    //     }
        
    //     set r = [1, 0, 1, 0, 1, 0];
    //     AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductWithNegationFunction, Oracle_ProductWithNegationFunction_Reference);

    //     set r = [1, 0, 0, 1];
    //     AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductWithNegationFunction, Oracle_ProductWithNegationFunction_Reference);

    //     set r = [0, 0, 1, 1, 1];
    //     AssertTwoOraclesWithIntAreEqual(r, Oracle_ProductWithNegationFunction, Oracle_ProductWithNegationFunction_Reference);
    // }
    
    
    // operation T17_Oracle_HammingWithPrefix_Test () : Unit {
    //     mutable prefix = [1];
    //     AssertTwoOraclesAreEqual(1 .. 10, Oracle_HammingWithPrefix(_, _, prefix), Oracle_HammingWithPrefix_Reference(_, _, prefix));

    //     set prefix = [1, 0];
    //     AssertTwoOraclesAreEqual(2 .. 10, Oracle_HammingWithPrefix(_, _, prefix), Oracle_HammingWithPrefix_Reference(_, _, prefix));

    //     set prefix = [0, 0, 0];
    //     AssertTwoOraclesAreEqual(3 .. 10, Oracle_HammingWithPrefix(_, _, prefix), Oracle_HammingWithPrefix_Reference(_, _, prefix));
    // }
    
    
    // operation T18_Oracle_MajorityFunction_Test () : Unit {
    //     AssertTwoOraclesAreEqual(3 .. 3, Oracle_MajorityFunction, Oracle_MajorityFunction_Reference);
    // }
    
    
    // ------------------------------------------------------
    // operation T21_BV_StatePrep_Test () : Unit {
        
    //     for (N in 1 .. 10) {
            
    //         using (qs = Qubit[N + 1]) {
    //             // apply operation that needs to be tested
    //             BV_StatePrep(qs[0 .. N - 1], qs[N]);
                
    //             // apply adjoint reference operation
    //             Adjoint BV_StatePrep_Reference(qs[0 .. N - 1], qs[N]);
                
    //             // assert that all qubits end up in |0⟩ state
    //             AssertAllZero(qs);
    //         }
    //     }
    // }
    
    // ------------------------------------------------------
    function AllEqualityFactI (actual : Int[], expected : Int[], message : String) : Unit {
        
        let n = Length(actual);
        if (n != Length(expected)) {
            fail message;
        }
        
        for (idx in 0 .. n - 1) {
            if (actual[idx] != expected[idx]) {
                fail message;
            }
        }
    }
    
    
    // ------------------------------------------------------
    function IntArrFromPositiveInt (n : Int, bits : Int) : Int[] {
        
        let rbool = IntAsBoolArray(n, bits);
        mutable r = new Int[bits];
        
        for (i in 0 .. bits - 1) {
            if (rbool[i]) {
                set r w/= i <- 1;
            }
        }
        
        return r;
    }
    
    
    // ------------------------------------------------------
    operation AssertBVAlgorithmWorks (r : Int[]) : Unit {
        let oracle = Oracle_ProductFunction(_, _, r);
        AllEqualityFactI(BV_Algorithm(Length(r), oracle), r, "Bernstein-Vazirani algorithm failed");

        let nu = GetOracleCallsCount(oracle);
        EqualityFactB(nu <= 1, true, $"You are allowed to call the oracle at most once, and you called it {nu} times");
    }

    operation BV(a : Int, N : Int) : Unit {
        ResetOracleCallsCount();
        let r = IntArrFromPositiveInt(a, N);
        AssertBVAlgorithmWorks(r);
    }
    
    operation BV_Algorithm_0_Test() : Unit {
        BV(0, 12);
    }

    operation BV_Algorithm_5_Test() : Unit {
        BV(5, 12);
    }

    operation BV_Algorithm_512_Test() : Unit {
        BV(512, 12);
    }
    
    operation BV_Algorithm_1024_Test() : Unit {
        BV(1024, 12);
    }

    operation BV_Algorithm_2048_Test() : Unit {
        BV(2048, 12);
    }

    operation BV_Algorithm_512_N_1_Test() : Unit {
        BV(1, 1);
    }

    operation BV_Algorithm_512_N_2_Test() : Unit {
        BV(1, 2);
    }

    operation BV_Algorithm_512_N_3_Test() : Unit {
        BV(1, 3);
    }

    operation BV_Algorithm_512_N_4_Test() : Unit {
        BV(1, 4);
    }

    operation BV_Algorithm_512_N_5_Test() : Unit {
        BV(1, 5);
    }

    operation BV_Algorithm_512_N_6_Test() : Unit {
        BV(1, 6);
    }

    operation BV_Algorithm_512_N_7_Test() : Unit {
        BV(1, 7);
    }

    operation BV_Algorithm_512_N_8_Test() : Unit {
        BV(1, 8);
    }

    operation BV_Algorithm_512_N_9_Test() : Unit {
        BV(1, 9);
    }

    operation BV_Algorithm_512_N_10_Test() : Unit {
        BV(1, 10);
    }

    operation BV_Algorithm_512_N_11_Test() : Unit {
        BV(1, 11);
    }

    operation BV_Algorithm_512_N_12_Test() : Unit {
        BV(1, 12);
    }
    
    // operation T22_BV_Algorithm_Test () : Unit {
    //     ResetOracleCallsCount();

    //     for (bits in 1 .. 12) {
    //         // Message ($"BV n={bits}");
    //         for (n in 0 .. 2 ^ bits - 1) {
    //             let r = IntArrFromPositiveInt(n, bits);
    //             AssertBVAlgorithmWorks(r);
    //         }
    //     }
    // }
    
    
    // ------------------------------------------------------
    operation AssertDJAlgorithmWorks (N : Int, oracle : ((Qubit[], Qubit) => Unit), expected : Bool, msg : String) : Unit {
        EqualityFactB(DJ_Algorithm(N, oracle), expected, msg);
        
        let nu = GetOracleCallsCount(oracle);
        EqualityFactB(nu <= 1, true, $"You are allowed to call the oracle at most once, and you called it {nu} times");
    }

    operation DJ_Algorithm_Constant_1_N_23_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(23, Oracle_One,
                               true,  "f(x) = 1 not identified as constant");
    }

    operation DJ_Algorithm_Mod_2_N_23_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(23, Oracle_Kth_Qubit(_, _, 23-1),
                               false,  "f(x) x%2 not identified as balanced");
    }

    operation DJ_Algorithm_Half_Range_N_23_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(23, Oracle_Kth_Qubit(_, _, 0),
                               false,  "f(x) = 1 if top half of range else 0 not identified as balanced");
    }

    operation DJ_Algorithm_Constant_0_N_0_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(0, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_1_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(1, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_2_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(2, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_3_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(3, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_4_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(4, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_5_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(5, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_6_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(6, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_7_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(7, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_8_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(8, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_9_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(9, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_10_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(10, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_11_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(11, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_12_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(12, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_13_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(13, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_14_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(14, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_15_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(15, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_16_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(16, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_17_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(17, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_18_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(18, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_19_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(19, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_20_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(20, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_21_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(21, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_22_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(22, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }

    operation DJ_Algorithm_Constant_0_N_23_Test() : Unit {
        ResetOracleCallsCount();
        AssertDJAlgorithmWorks(23, Oracle_Zero,
                               true,  "f(x) = 0 not identified as constant");
    }
    
    // operation T31_DJ_Algorithm_Test () : Unit {

    //     ResetOracleCallsCount();

    //     for (n in 1 .. 24) {
    //         // Message ($"DJ n={n}");
    //         AssertDJAlgorithmWorks(n, Oracle_Zero,
    //                            true,  "f(x) = 0 not identified as constant");
    //         AssertDJAlgorithmWorks(n, Oracle_One, 
    //                                true,  "f(x) = 1 not identified as constant");

    //         AssertDJAlgorithmWorks(n, Oracle_Kth_Qubit(_, _, n-1),
    //                            false,  "f(x) = x%2 not identified as balanced");
    //         ResetOracleCallsCount();
    //         AssertDJAlgorithmWorks(n, Oracle_Kth_Qubit(_, _, 0),
    //                            false,  "f(x) = 1 if top half of range else 0 not identified as balanced");
    //         ResetOracleCallsCount();
    //     }

    //     AssertDJAlgorithmWorks(4, Oracle_Zero,
    //                            true,  "f(x) = 0 not identified as constant");
    //     AssertDJAlgorithmWorks(4, Oracle_One, 
    //                            true,  "f(x) = 1 not identified as constant");
    //     AssertDJAlgorithmWorks(4, Oracle_Kth_Qubit(_, _, 1), 
    //                            false, "f(x) = x_k not identified as balanced");
    //     AssertDJAlgorithmWorks(4, Oracle_OddNumberOfOnes, 
    //                            false, "f(x) = sum of x_i not identified as balanced");
    //     AssertDJAlgorithmWorks(4, Oracle_ProductFunction(_, _, [1, 0, 1, 1]), 
    //                            false, "f(x) = sum of r_i x_i not identified as balanced");
    //     AssertDJAlgorithmWorks(4, Oracle_ProductWithNegationFunction(_, _, [1, 0, 1, 1]), 
    //                            false, "f(x) = sum of r_i x_i + (1 - r_i)(1 - x_i) not identified as balanced");
    //     AssertDJAlgorithmWorks(4, Oracle_HammingWithPrefix(_, _, [0, 1]), 
    //                            false, "f(x) = sum of x_i + 1 if prefix equals given not identified as balanced");
    //     AssertDJAlgorithmWorks(3, Oracle_MajorityFunction, 
    //                            false, "f(x) = majority function not identified as balanced");
    // }
}
