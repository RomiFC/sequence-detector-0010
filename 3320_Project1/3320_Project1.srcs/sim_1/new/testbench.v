`timescale 1ns / 1ps
// testbench.v

module testbench ();        
    wire reset, clk, x, z;
    
    fsmTester testVectorGen  (reset, clk, x, z);
    Source    seqDetectorFSM (reset, clk, x, z);
endmodule