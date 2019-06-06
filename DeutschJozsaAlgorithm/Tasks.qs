namespace Quantum.Kata.DeutschJozsaAlgorithm {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    // Oracle_Zero
    // f(x) = 0 for all x
    // @input x: N qubits in arbitrary state |x⟩ (input register)
    // @input y: a qubit in arbitrary state |y⟩ (output qubit)
    // @output: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩
    operation Oracle_Zero (x : Qubit[], y : Qubit) : Unit {
    }
    
    // Oracle_One
    // f(x) = 1 for all x
    // @input x: N qubits in arbitrary state |x⟩ (input register)
    // @input y: a qubit in arbitrary state |y⟩ (output qubit)
    // @output: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩
    operation Oracle_One (x : Qubit[], y : Qubit) : Unit {
        X(y);
    }
    
    // Oracle_Kth_Qubit
    // f(x) = x_k (the value of k-th qubit)
    // @input x: N qubits in arbitrary state |x⟩ (input register)
    // @input y: a qubit in arbitrary state |y⟩ (output qubit)
    // @input k: index into x
    // @output: transform state |x, y⟩ into state |x, y ⊕ x_k⟩
    operation Oracle_Kth_Qubit (x : Qubit[], y : Qubit, k : Int) : Unit {    
        EqualityFactB(0 <= k and k < Length(x), true, "k should be between 0 and N-1, inclusive");
        CNOT(x[k], y);
    }
    
    // Oracle_OddNumberOfOnes
    // f(x) = 1 if x has odd number of 1's else 0 
    // @input x: N qubits in arbitrary state |x⟩ (input register)
    // @input y: a qubit in arbitrary state |y⟩ (output qubit)
    // @output: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩
    operation Oracle_OddNumberOfOnes (x : Qubit[], y : Qubit) : Unit {
        ApplyToEachA(CNOT(_, y), x);
    }
    
    // Oracle_ProductFunction
    // f(x) = Σᵢ rᵢ xᵢ modulo 2 for a given bit vector r
    // @input x: N qubits in arbitrary state |x⟩ (input register)
    // @input y: a qubit in arbitrary state |y⟩ (output qubit)
    // @input r: a bit vector of length N
    // @output: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩
    operation Oracle_ProductFunction (x : Qubit[], y : Qubit, r : Int[]) : Unit {    
        EqualityFactI(Length(x), Length(r), "Arrays should have the same length");

        for (i in IndexRange(x)) {
            if (r[i] == 1) {
                CNOT(x[i], y);
            }
        }
    }
    
    // Oracle_ProductWithNegationFunction
    // f(x) = Σᵢ (rᵢ xᵢ + (1 - rᵢ)(1 - xᵢ)) modulo 2 for a given bit vector r
    // @input x: N qubits in arbitrary state |x⟩ (input register)
    // @input y: a qubit in arbitrary state |y⟩ (output qubit)
    // @input r: a bit vector of length N
    // @output: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩
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
     
    // Oracle_HammingWithPrefix
    // f(x) = Σᵢ xᵢ + (1 if prefix of x is equal to the given bit vector, and 0 otherwise) modulo 2
    // @input x: N qubits in arbitrary state |x⟩ (input register)
    // @input y: a qubit in arbitrary state |y⟩ (output qubit)
    // @input prefix: a bit vector of length P
    // @output: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩
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
    
    // Oracle_MajorityFunction
    // f(x) = 1 if x has two or three bits (out of three) set to 1, and 0 otherwise
    // @input x: N qubits in arbitrary state |x⟩ (input register)
    // @input y: a qubit in arbitrary state |y⟩ (output qubit)
    // @output: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩
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
    
    operation BV_Algorithm (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Int[] {
        using ((x, y) = (Qubit[N], Qubit())) {
            BV_StatePrep(x, y);
            
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

    operation DJ_Algorithm (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Bool {
        mutable isConstantFunction = true;
        
        let r = BV_Algorithm(N, Uf);
        
        for (i in 0 .. N - 1) {
            set isConstantFunction = isConstantFunction and r[i] == 0;
        }
        
        return isConstantFunction;
    }  
}