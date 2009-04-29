// True dual port RAM as found in ACTEL proasic3 devices
module ram_sc_dw (d_a, q_a, adr_a, we_a, q_b, adr_b, d_b, we_b, clk);
   
   parameter dat_width = 32;
   parameter adr_width = 11;
   parameter mem_size  = 2048;
   
   input [dat_width-1:0]      d_a;
   input [adr_width-1:0]      adr_a;
   input [adr_width-1:0]      adr_b;
   input 		      we_a;
   output reg [dat_width-1:0] q_b;
   input [dat_width-1:0]      d_b;
   output reg [dat_width-1:0] q_a;
   input 		      we_b;
   input 		      clk;   

   reg [dat_width-1:0] 	      ram [0:mem_size - 1] ;
   
   always @ (posedge clk)
     begin 
	q_a <= ram[adr_a];
	if (we_a)
	  ram[adr_a] <= d_a;
     end 
   always @ (posedge clk)
     begin 
	q_b <= ram[adr_b];
	if (we_b)
	  ram[adr_b] <= d_b;
     end
   
endmodule 

// wrapper for the above dual port RAM
module ram (dat_i, dat_o, adr_i, we_i, clk );

   parameter dat_width = 32;
   parameter adr_width = 11;
   parameter mem_size  = 2048;
   
   input [dat_width-1:0]      dat_i;
   input [adr_width-1:0]      adr_i;
   input 		      we_i;
   output [dat_width-1:0]     dat_o;
   input 		      clk;   
   
   ram_sc_dw
     #
     (
      .dat_width(dat_width),
      .adr_width(adr_width),
      .mem_size(mem_size)
      )
     ram0
     (
      .d_a(dat_i),
      .q_a(),
      .adr_a(adr_i),
      .we_a(we_i),
      .q_b(dat_o),
      .adr_b(adr_i),
      .d_b({dat_width{1'b0}}),
      .we_b(1'b0),
      .clk(clk)
      );

endmodule // ram
