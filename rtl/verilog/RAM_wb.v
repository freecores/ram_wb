

module RAM_wb ( dat_i, dat_o, adr_i, we_i, sel_i, cyc_i, stb_i, ack_o, cti_i, clk_i, rst_i);

   parameter ram_wb_adr_width = `RAM_WB_ADR_WIDTH;
   parameter ram_wb_mem_size  = `RAM_WB_MEM_SIZE;
   parameter ram_wb_dat_width = `RAM_WB_DAT_WIDTH;
   
   // wishbone signals
   input [31:0]      dat_i;   
   output [31:0]     dat_o;
   input [ram_wb_adr_width-1:2] adr_i;
   input 		    we_i;
   input [3:0] 		    sel_i;
   input 		    cyc_i;
   input 		    stb_i;
   output reg 		    ack_o;
   input [2:0] 		    cti_i;

   // clock
   input 		    clk_i;
   // async reset
   input 		    rst_i;

   wire [31:0] 	  wr_data;
   
   // mux for data to ram
   assign wr_data[31:24] = sel_i[3] ? dat_i[31:24] : dat_o[31:24];
   assign wr_data[23:16] = sel_i[2] ? dat_i[23:16] : dat_o[23:16];
   assign wr_data[15: 8] = sel_i[1] ? dat_i[15: 8] : dat_o[15: 8];
   assign wr_data[ 7: 0] = sel_i[0] ? dat_i[ 7: 0] : dat_o[ 7: 0];


   //vfifo_dual_port_ram_sc_dw
   RAM_wb_sc_dw
     /* #
     (
      .DATA_WIDTH(32),
      .ADDR_WIDTH(11)
      )*/
     ram
     (
      .d_a(wr_data),
      .q_a(),
      .adr_a(adr_i), 
      .we_a(we_i & ack_o),
      .q_b(dat_o),
      .adr_b(adr_i),
      .d_b(32'h0), 
      .we_b(1'b0),
      .clk(clk_i)
      );
 
 
   // ack_o
   always @ (posedge clk_i or posedge rst_i)
     if (rst_i)
       ack_o <= 1'b0;
     else
       ack_o <= cyc_i & stb_i & !ack_o;
      
endmodule
 
	      