


namespace Quantum.Kata.GroversAlgorithm {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    operation Oracle_AllOnes (queryRegister : Qubit[], target : Qubit) : Unit
    is Adj {        
        Controlled X(queryRegister, target);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    operation Oracle_AlternatingBits (queryRegister : Qubit[], target : Qubit) : Unit
    is Adj {

        
        
        FlipOddPositionBits(queryRegister);
        Controlled X(queryRegister, target);
        Adjoint FlipOddPositionBits(queryRegister);
    }

    operation FlipOddPositionBits (register : Qubit[]) : Unit
    is Adj {
        
        
        for (i in 1 .. 2 .. Length(register) - 1) {
            X(register[i]);
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    operation Oracle_ArbitraryPattern (queryRegister : Qubit[], target : Qubit, pattern : Bool[]) : Unit
    is Adj {        
        (ControlledOnBitString(pattern, X))(queryRegister, target);
    }
    
    
    
    
    
    
    
    //
    
    
    
    
    function OracleConverter (markingOracle : ((Qubit[], Qubit) => Unit is Adj)) : (Qubit[] => Unit is Adj) {
        return OracleConverterImpl(markingOracle, _);
    }

    operation OracleConverterImpl (markingOracle : ((Qubit[], Qubit) => Unit is Adj), register : Qubit[]) : Unit
    is Adj {
        
        using (target = Qubit()) {
            
            X(target);
            H(target);
                
            
            
            markingOracle(register, target);
                
            
            H(target);
            X(target);
        }
    }
    
    
    
    
    
    
    
    
    
    //
    
    
    operation HadamardTransform (register : Qubit[]) : Unit
    is Adj {
        ApplyToEachA(H, register);
    }
    
    
    
    
    
    
    
    
    
    operation ConditionalPhaseFlip (register : Qubit[]) : Unit
    is Adj {
    
        body (...) {
            
            let allZerosOracle = Oracle_ArbitraryPattern_Reference(_, _, new Bool[Length(register)]);
            
            
            let flipOracle = OracleConverter_Reference(allZerosOracle);
            flipOracle(register);
        }
        
        adjoint self;
    }
    
    
    
    
    
    
    
    
    operation GroverIteration (register : Qubit[], oracle : (Qubit[] => Unit is Adj)) : Unit
    is Adj {
        
        oracle(register);
        HadamardTransform_Reference(register);
        ConditionalPhaseFlip_Reference(register);
        HadamardTransform_Reference(register);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //
    
    
    operation GroversSearch (register : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj), iterations : Int) : Unit {
        
        let phaseOracle = OracleConverter_Reference(oracle);
        HadamardTransform_Reference(register);
            
        for (i in 1 .. iterations) {
            GroverIteration_Reference(register, phaseOracle);
        }
    }
    
    
    
    
    
    
    operation E2E_GroversSearch_Test () : Unit {

        
        
        

        
        

        

        
    }
    
}
