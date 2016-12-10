//                              -*- Mode: Verilog -*-
// Filename        : basic.v
// Description     : Basic Test Case
// Author          : Philip Tracton
// Created On      : Fri Dec  9 20:43:36 2016
// Last Modified By: Philip Tracton
// Last Modified On: Fri Dec  9 20:43:36 2016
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "axi_defines.vh"

module test_case (/*AUTOARG*/ ) ;
`define TB testbench_axi_master_bfm
`define MASTER `TB.master
`define SLAVE `TB.slave
`define MEMORY `SLAVE.memory
   
   initial begin
      $dumpfile("basic.vcd");
	  $dumpvars(0, `TB);      
   end

   integer i;
   
   initial begin
      $display("AXI Master BFM Test: Basic");
      
      @(negedge `TB.aresetn);
      @(posedge `TB.aresetn);
      repeat (10) @(posedge `TB.aclk);
      `MASTER.write_single(32'h0000_0004, 32'hdead_beef, `AXI_BURST_SIZE_WORD, 4'hF);
      `MASTER.write_single(32'h0000_0008, 32'h1234_5678, `AXI_BURST_SIZE_WORD, 4'hF);
      `MASTER.write_single(32'h0000_000C, 32'hABCD_EF00, `AXI_BURST_SIZE_WORD, 4'hF);
      `MASTER.write_single(32'h0000_0010, 32'hAA55_66BB, `AXI_BURST_SIZE_WORD, 4'hF);
      repeat (10) @(posedge `TB.aclk);

      if (`MEMORY[4] !== 32'hdead_beef) begin
         $display("Memory 4 FAIL 0x%04x", `MEMORY[0]);         
      end

      if (`MEMORY[8] !== 32'h1234_5678) begin
         $display("Memory 8 FAIL 0x%04x", `MEMORY[8]);         
      end

      if (`MEMORY[12] !== 32'hABCD_EF00) begin
         $display("Memory 12 FAIL 0x%04x", `MEMORY[12]);         
      end

      if (`MEMORY[16] !== 32'hAA55_66BB) begin
         $display("Memory 16 FAIL 0x%04x", `MEMORY[16]);         
      end

      for (i=0; i<32; i=i+1) begin
         $display("MEMORY[%d] = 0x%04x", i, `MEMORY[i]);         
      end
      
      $display("TEST COMPLETE @ %d", $time);      
      $finish;
      
   end
   
endmodule // test_case
