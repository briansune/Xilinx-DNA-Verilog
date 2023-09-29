/* =====================================================================
    ____         _                 ____                      
   | __ )  _ __ (_)  __ _  _ __   / ___|  _   _  _ __    ___ 
   |  _ \ | '__|| | / _` || '_ \  \___ \ | | | || '_ \  / _ \
   | |_) || |   | || (_| || | | |  ___) || |_| || | | ||  __/
   |____/ |_|   |_| \__,_||_| |_| |____/  \__,_||_| |_| \___|
   
   =====================================================================
   Date: 2023-09
   Author: Brian Sune
   Contact: briansune@gmail.com
   Revision: 1.0.0
   FPGA: XC7Z0x0-CLG400
   =====================================================================
*/


`timescale 1 ns / 1 ps


module dna_phy(
	input wire					sys_clk,
	input wire					sys_nrst,
	output wire					dna_rdy,
	output wire		[56 : 0]	dna_id
);
	
	localparam rd_str_val = 0;
	localparam rd_len_val = 2;
	
	localparam init_val = rd_len_val+1;
	localparam do_val = init_val+1;
	localparam do_len = 57;
	localparam tot_len = do_val+57;
	localparam tot_bw = $clog2(do_val+57);
	
	wire						dna_sdo;
	reg							dna_sen;
	reg							dna_srd;
	reg		[56 : 0]			dna_id_r;
	reg							startup_rd;
	reg		[tot_bw-1 : 0]		rd_cnt;
	
	DNA_PORT#(
		.SIM_DNA_VALUE	(57'h1dc_ba98_7654_3210)
	)DNA_PORT_inst(
		.DOUT	(dna_sdo),
		.CLK	(sys_clk),
		.DIN	(1'b0),
		.READ	(dna_srd),
		.SHIFT	(dna_sen)
	);
	
	always@(posedge sys_clk)begin
		if(!sys_nrst)begin
			dna_id_r <= 57'd0;
			dna_srd <= 1'b0;
			dna_sen <= 1'b0;
			startup_rd <= 1'b0;
			rd_cnt <= 0;
		end else begin
			if(!startup_rd)begin
				rd_cnt <= rd_cnt + 1'b1;
			end
			
			if(rd_cnt > init_val && rd_cnt < (init_val+do_len) )begin
				dna_sen <= 1'b1;
			end else begin
				dna_sen <= 1'b0;
			end
			
			if(rd_cnt > rd_str_val && rd_cnt < (rd_str_val+rd_len_val) )begin
				dna_srd <= 1'b1;
			end else begin
				dna_srd <= 1'b0;
			end
			
			if(rd_cnt > do_val && rd_cnt <= (do_val+do_len) )begin
				dna_id_r <= {dna_id_r[0+:56], dna_sdo};
			end
			
			if(rd_cnt == (do_len+do_val) )begin
				startup_rd <= 1'b1;
			end
		end
	end
	
	assign dna_id = dna_id_r;
	assign dna_rdy = startup_rd;
	
endmodule
