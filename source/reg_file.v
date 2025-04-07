`timescale 1ns / 1ps

module reg_file (
	input wire 			clk,
	input wire 			rst_n,
	input wire [4:0]	raddr1,
	input wire [4:0] 	raddr2, 
	output wire [31:0]  rdata1,
	output wire [31:0] 	rdata2,

	input wire			we,
	input wire [4:0]    waddr,
	input wire [31:0]	wdata,
	);'
