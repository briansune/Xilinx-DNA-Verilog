/* =====================================================================
    ____         _                 ____                      
   | __ )  _ __ (_)  __ _  _ __   / ___|  _   _  _ __    ___ 
   |  _ \ | '__|| | / _` || '_ \  \___ \ | | | || '_ \  / _ \
   | |_) || |   | || (_| || | | |  ___) || |_| || | | ||  __/
   |____/ |_|   |_| \__,_||_| |_| |____/  \__,_||_| |_| \___|
   
   =====================================================================
   Date: 2023-05
   Author: Brian Sune
   Contact: briansune@gmail.com
   Revision: 1.0.0
   FPGA: XC7Z0x0-CLG400
   =====================================================================
*/

`timescale 1ns/1ps


module tb_dna_ip;

	reg		clk;
	reg		nrst;
	
	dna_phy DUT(
		.sys_clk	(clk),
		.sys_nrst	(nrst)
	);
	
	always begin
		#2.5 clk = ~clk;
	end
	
	initial begin
		fork begin
			
			#0 clk = 1'b1;
			nrst = 1'b0;
			
			#2500 nrst = 1'b1;
			
		end join
	end
	
endmodule
