﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains parts of the testing harness. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

using System.Diagnostics;
using System;
using System.Threading;

using Microsoft.Quantum.Simulation.XUnit;
using Microsoft.Quantum.Simulation.Simulators;
using Xunit.Abstractions;

namespace Quantum.Kata.GroversAlgorithm
{
    public class TestSuiteRunner
    {
        private readonly ITestOutputHelper output;

        public TestSuiteRunner(ITestOutputHelper output)
        {
            this.output = output;
        }

        /// <summary>
        /// This driver will run all Q# tests (operations named "...Test") 
        /// that belong to namespace Quantum.Kata.GroversAlgorithm.
        /// </summary>
        [OperationDriver(TestNamespace = "Quantum.Kata.GroversAlgorithm")]
        public void TestTarget(TestOperation op)
        {
            using (var sim = new QuantumSimulator())
            {
                // OnLog defines action(s) performed when Q# test calls function Message
                sim.OnLog += (msg) => { output.WriteLine(msg); };
                sim.OnLog += (msg) => { Debug.WriteLine(msg); };

                var watch = System.Diagnostics.Stopwatch.StartNew();
                op.TestOperationRunner(sim);
                watch.Stop();
                long ticks = watch.ElapsedTicks;
                Console.WriteLine("Name: " + op.className + " RunTime: " + ticks);
            }
        }
    }
}
