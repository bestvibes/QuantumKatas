


namespace Quantum.Kata.SimonsAlgorithm {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    operation Oracle_CountBits (x : Qubit[], y : Qubit) : Unit
    is Adj {   

        let N = Length(x);

        for (i in 0 .. N - 1) {
            CNOT(x[i], y);
        }
    }
    
    
    
    
    
    
    
    
    operation Oracle_BitwiseRightShift (x : Qubit[], y : Qubit[]) : Unit
    is Adj {        
    
        let N = Length(x);

        for (i in 1 .. N - 1) {
            CNOT(x[i - 1], y[i]);
        }
    }
    
    
    
    
    
    
    
    
    
    operation Oracle_OperatorOutput (x : Qubit[], y : Qubit, A : Int[]) : Unit
    is Adj {
        
        
        
        EqualityFactI(Length(x), Length(A), "Arrays x and A should have the same length");
            
        let N = Length(x);
            
        for (i in 0 .. N - 1) {
            if (A[i] == 1) {
                CNOT(x[i], y);
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    operation Oracle_MultidimensionalOperatorOutput (x : Qubit[], y : Qubit[], A : Int[][]) : Unit
    is Adj {
        
        
        
        EqualityFactI(Length(x), Length(A[0]), "Arrays x and A[0] should have the same length");
        EqualityFactI(Length(y), Length(A), "Arrays y and A should have the same length");
            
        let N1 = Length(y);
        let N2 = Length(x);
            
        for (i in 0 .. N1 - 1) {
            for (j in 0 .. N2 - 1) {
                if ((A[i])[j] == 1) {
                    CNOT(x[j], y[i]);
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    operation SA_StatePrep (query : Qubit[]) : Unit
    is Adj {        
        ApplyToEachA(H, query);
    }
    
    
    
    
    
    
    
    
    //
    
    
    
    //
    
    
    //
    
    
    //
    
    
    
    operation Simon_Algorithm (N : Int, Uf : ((Qubit[], Qubit[]) => Unit)) : Int[] {
        
        
        using ((x, y) = (Qubit[N], Qubit[N])) {
            
            SA_StatePrep_Reference(x);
            
            
            Uf(x, y);
            
            
            ApplyToEach(H, x);
            
            
            
            mutable j = new Int[N];
            for (i in 0 .. N - 1) {
                if (M(x[i]) == One) {
                    set j w/= i <- 1;
                }
            }
            
            
            ResetAll(x);
            ResetAll(y);
            return j;
        }
    }
    
}
