module twoscomp(input  logic clk,
                input  logic reset,
                input  logic a,
                output logic n);

typedef enum logic {S0, S1} statetype;
statetype state, nextstate;

// state register

always_ff @(posedge clk, posedge reset)
if (reset) state <= S1;
else state <= nextstate;

// next state and output logic

always_comb begin
n = 1'b0;
case (state)
S0: if (a) nextstate = S0;
n = 1'b1;
else nextstate = S0;
S1: if (a) begin
nextstate = S0;
n = 1'b1;
else nextstate = S1;
end
else nextstate = S1;
default: nextstate = S0;
endcase
end

endmodule

// flip-flop
module flop(input  logic clk, d,
         output logic q);
            
  always_ff @(posedge clk)
    q <= d;
endmodule


// asynchronously resettable flip-flop
module flopr(input  logic clk, reset, d,
            output logic q);
            
  always_ff @(posedge clk or posedge reset)
    if (reset) q <= 0; // resets state to 0 on reset
    else       q <= d;
endmodule

// asynchronously settable flip-flop
module flops(input  logic clk, reset, d,
            output logic q);
            
  always_ff @(posedge clk or posedge reset)
    if (reset) q <= 1;  // sets state to 1 on reset
    else       q <= d;
endmodule

module testbench(); 
  logic        clk, reset;
  logic        a, n, nexpected;
  logic [6:0]  hash;
  logic [31:0] vectornum, errors;
  logic [1:0]  testvectors[10000:0];

  // instantiate device under test 
twoscomp dut(clk, reset, a, n);




  // generate clock 
  always 
    begin
      clk=1; #5; clk=0; #5; 
    end 

  // at start of test, load vectors and pulse reset
  initial 
    begin
      $readmemb("twoscomp.tv", testvectors); 
      vectornum = 0; errors = 0; hash = 0; reset = 1; #22; reset = 0; 
    end 

  // apply test vectors on rising edge of clk 
  always @(posedge clk) 
    begin
      #1; {a, nexpected} = testvectors[vectornum]; 
    end 

  // check results on falling edge of clk 
  always @(negedge clk) 
    if (~reset) begin    // skip during reset
      if (n !== nexpected) begin // check result 
        $display("Error: input = %b", a);
        $display(" output = %b (%b expected)", n, nexpected); 
        errors = errors + 1; 
      end
      vectornum = vectornum + 1;
      hash = hash ^ n;
      hash = {hash[5:0], hash[6] ^ hash[5]};
      if (testvectors[vectornum] === 2'bx) begin 
        $display("%d tests completed with %d errors", vectornum, errors); 
        $display("Hash: %h", hash);
        $stop; 
      end 
    end 
endmodule 
 
