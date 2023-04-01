`timescale 1ns / 1ps    // Timescale of 1ns with 1ps precision
`define CK2Q 5          // Clk to Q propagation delay
// Source.v

// This is a FSM which outputs 1 when an input sequence of 0010 is detected, 0 otherwise
// Input "reset" resets FSM to default state s0 and input/output to 0
module Source(reset, clk, x, z);
    input   reset, clk, x;
    output  z;
    
    reg     x_reg;
    reg     z;
    
    // Parameters for binary encoded FSM states
    parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
    
    // Variables to store encoded state values
    reg [3:0] currentState;
    reg [3:0] nextState;
    
    // Initializes x_reg to x unless reset is 1
    always @ (posedge clk)
        begin : REG_INPUT
            if (reset == 1'b1)
                x_reg <= #`CK2Q 1'b0;
            else
                x_reg <= #`CK2Q x;
        end // end block REG_INPUT
    
    // Initializes nextState and output z depending on values of currentState and input x.
    // i.e determines where to go and what do output based on an input at a given state.
    always @ (currentState or x_reg or reset)
        begin : FSM_COMBO
            nextState = 2'b00;
            if (reset == 1'b1)
                z <= 1'b0;
            else begin
                case (currentState)                 // Switch/case which determines what to do at each state
                s0 : if (x_reg == 1'b0) begin       // At state s0, if input is 0...
                        nextState = s1;             // move to state s1..
                        z <= 1'b0;                  // and output 0.
                     end
                     else begin                     // if input is 1...
                        nextState = s0;             // stay at state s0
                        z <= 1'b0;                  // and output 0.
                     end
                s1 : if (x_reg == 1'b0) begin
                        nextState = s2;
                        z <= 1'b0;
                     end
                     else begin
                        nextState = s0;
                        z <= 1'b0;
                     end
                s2 : if (x_reg == 1'b0) begin
                        nextState = s2;
                        z <= 1'b0;
                     end
                     else begin
                        nextState = s3;
                        z <= 1'b0;
                     end
                s3 : if (x_reg == 1'b0) begin
                        nextState = s1;
                        z <= 1'b1;
                     end
                     else begin
                        nextState = s0;
                        z <= 1'b0;
                     end
                default : begin
                        nextState = s0;
                        z <= 1'b0;
                     end
                endcase
            end     // end elseif statement
        end         // end block FSM_COMBO
                     
    // Initializes reg currentState to nextState on every clk
    always @ (posedge clk)
    begin : FSM_SEQ
        if (reset == 1'b1) begin
            currentState <= #`CK2Q s0;
        end
        else begin
            currentState <= #`CK2Q nextState;
        end
    end         // end block FSM_SEQ       
    
    
endmodule
    

// Testvector generator which sends input sequence "data" to the FSM at every clock cycle (rising edge)
module fsmTester (reset, clk, x, z);
    output  reset, clk, x;
    reg     reset, clk, x;
    input   z;
    
    reg     [23:0] data;        // data which will be pushed to the input of the fsm
    integer i;
    
    initial                 // resets fsm to initial state s0
        begin               // 24 bit data requires simulation time of ~32 us
            data = 24'b010010110100100101101001;
            i = 0;
            reset = 1'b1;  
            #1200;
            reset = 1'b0;
            #2000;
            $finish;
        end
        
    initial                     // creates clock cycle which loops forever
        begin
            clk = 0;            // initializes clk to 0
            forever begin
                #600;           // constantly inverts clk every 600 ns
                clk = ~clk;
            end
        end
        
    always @ (posedge clk)      // pushes data bit to input x after every rising edge of clk
        begin
            #50;
            x = data >> i;
            i = i + 1;
        end
 
endmodule








