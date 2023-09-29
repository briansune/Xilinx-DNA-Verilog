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


module dna_ip#(
	
	parameter integer C_S_AXI_DATA_WIDTH	= 32

)(
	
	// This clock must use 24MHz
	(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 dna_clk CLK" *)
	(* X_INTERFACE_PARAMETER = "ASSOCIATED_RESET ip_sys_rst" *)
	input wire		ip_sys_clk,
	
	(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 dna_rst RST" *)
	(* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
	input wire		ip_sys_nrst,
	
	input wire  s_axi_aclk,
	input wire  s_axi_aresetn,
	input wire [ $clog2(4) + 2 - 1 : 0] s_axi_awaddr,
	input wire [2 : 0] s_axi_awprot,
	input wire  s_axi_awvalid,
	output wire  s_axi_awready,
	input wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_wdata,
	input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb,
	input wire  s_axi_wvalid,
	output wire  s_axi_wready,
	output wire [1 : 0] s_axi_bresp,
	output wire  s_axi_bvalid,
	input wire  s_axi_bready,
	input wire [ $clog2(4) + 2 - 1 : 0] s_axi_araddr,
	input wire [2 : 0] s_axi_arprot,
	input wire  s_axi_arvalid,
	output wire  s_axi_arready,
	output wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_rdata,
	output wire [1 : 0] s_axi_rresp,
	output wire  s_axi_rvalid,
	input wire  s_axi_rready
);
	
	wire					dna_rdy;
	wire		[56 : 0]	dna_id;
	
	initial begin
		$display("AXI Address Width: %d", $clog2(4) + 2 );
	end
	
	axi_dna_v1_0_S_AXI#( 
		
		.C_S_AXI_DATA_WIDTH		(C_S_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH		($clog2(4) + 2)
		
	)axi_dna_inst0(
		
		.S_AXI_ACLK				(s_axi_aclk),
		.S_AXI_ARESETN			(s_axi_aresetn),
		.S_AXI_AWADDR			(s_axi_awaddr),
		.S_AXI_AWPROT			(s_axi_awprot),
		.S_AXI_AWVALID			(s_axi_awvalid),
		.S_AXI_AWREADY			(s_axi_awready),
		.S_AXI_WDATA			(s_axi_wdata),
		.S_AXI_WSTRB			(s_axi_wstrb),
		.S_AXI_WVALID			(s_axi_wvalid),
		.S_AXI_WREADY			(s_axi_wready),
		.S_AXI_BRESP			(s_axi_bresp),
		.S_AXI_BVALID			(s_axi_bvalid),
		.S_AXI_BREADY			(s_axi_bready),
		.S_AXI_ARADDR			(s_axi_araddr),
		.S_AXI_ARPROT			(s_axi_arprot),
		.S_AXI_ARVALID			(s_axi_arvalid),
		.S_AXI_ARREADY			(s_axi_arready),
		.S_AXI_RDATA			(s_axi_rdata),
		.S_AXI_RRESP			(s_axi_rresp),
		.S_AXI_RVALID			(s_axi_rvalid),
		.S_AXI_RREADY			(s_axi_rready),
		
		.dna_id					(dna_id),
		.dna_rdy				(dna_rdy)
		
	);
	
	dna_phy dna_phy_inst0(
		
		.sys_clk	(ip_sys_clk),
		.sys_nrst	(ip_sys_nrst),
		
		.dna_id		(dna_id),
		.dna_rdy	(dna_rdy)
	);
	
endmodule
