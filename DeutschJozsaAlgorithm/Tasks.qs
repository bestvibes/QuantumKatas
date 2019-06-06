


namespace Quantum.Kata.DeutschJozsaAlgorithm {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    operation Oracle_Zero (x : Qubit[], y : Qubit) : Unit {
        
        
        
    }
    
    
    
    
    
    
    
    operation Oracle_One (x : Qubit[], y : Qubit) : Unit {
        
        
        X(y);
    }
    
    
    
    
    
    
    
    
    operation Oracle_Kth_Qubit (x : Qubit[], y : Qubit, k : Int) : Unit {
        
        
        EqualityFactB(0 <= k and k < Length(x), true, "k should be between 0 and N-1, inclusive");
        CNOT(x[k], y);
    }
    
    
    
    
    
    
    
    operation Oracle_OddNumberOfOnes (x : Qubit[], y : Qubit) : Unit {
        
        ApplyToEachA(CNOT(_, y), x);
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    //
    
    operation Oracle_ProductFunction (x : Qubit[], y : Qubit, r : Int[]) : Unit {
        
        
        EqualityFactI(Length(x), Length(r), "Arrays should have the same length");

        for (i in IndexRange(x)) {
            if (r[i] == 1) {
                CNOT(x[i], y);
            }
        }
    }
    
    
    
    
    
    
    
    
    
    operation Oracle_ProductWithNegationFunction (x : Qubit[], y : Qubit, r : Int[]) : Unit {
        
        
        EqualityFactI(Length(x), Length(r), "Arrays should have the same length");

        for (i in IndexRange(x)) {
            if (r[i] == 1) {
                CNOT(x[i], y);
            } else {
                
                X(x[i]);
                CNOT(x[i], y);
                X(x[i]);
            }
        }
    }
    
    
    
    
    
    
    
    
    //
    
    
    operation Oracle_HammingWithPrefix (x : Qubit[], y : Qubit, prefix : Int[]) : Unit {
        
        
        let P = Length(prefix);
        EqualityFactB(1 <= P and P <= Length(x), true, "P should be between 1 and N, inclusive");

        
        for (q in x) {
            CNOT(q, y);
        }
            
        
        
        for (i in 0 .. P - 1) {
                
            if (prefix[i] == 0) {
                X(x[i]);
            }
        }
            
        Controlled X(x[0 .. P - 1], y);
            
        
        for (i in 0 .. P - 1) {
                
            if (prefix[i] == 0) {
                X(x[i]);
            }
        }
    }
    
    
    
    
    
    
    
    operation Oracle_MajorityFunction (x : Qubit[], y : Qubit) : Unit {
        
        
        EqualityFactB(3 == Length(x), true, "x should have exactly 3 qubits");

        
        
        CCNOT(x[0], x[1], y);
        CCNOT(x[0], x[2], y);
        CCNOT(x[1], x[2], y);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    operation BV_StatePrep (query : Qubit[], answer : Qubit) : Unit
    is Adj {
        ApplyToEachA(H, query);
        X(answer);
        H(answer);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //
    
    
    
    operation BV_Algorithm (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Int[] {
        
        
        using ((x, y) = (Qubit[N], Qubit())) {
            
            
            BV_StatePrep_Reference(x, y);
            
            
            Uf(x, y);
            
            
            ApplyToEach(H, x);
            
            
            
            mutable r = new Int[N];
            for (i in 0 .. N - 1) {
                if (M(x[i]) != Zero) {
                    set r w/= i <- 1;
                }
            }
            
            
            ResetAll(x);
            Reset(y);
            return r;
        }
    }
    
    
    
    
    
    
    
    operation BV_Test () : Unit {
        
        
        
        
        
        
        

        
        

        

        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //
    
    
    
    operation DJ_Algorithm (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Bool {
        
        
        
        mutable isConstantFunction = true;
        
        
        
        
        
        
        let r = BV_Algorithm_Reference(N, Uf);
        
        for (i in 0 .. N - 1) {
            set isConstantFunction = isConstantFunction and r[i] == 0;
        }
        
        return isConstantFunction;
    }
    
    
    
    
    
    operation DJ_Test () : Unit {
        
        

        

        

        
    }    
}