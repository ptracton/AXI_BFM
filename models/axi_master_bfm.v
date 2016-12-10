//                              -*- Mode: Verilog -*-
// Filename        : axi_master_bfm.v
// Description     : AXI Master Bus Functional Model
// Author          : Philip Tracton
// Created On      : Fri Dec  9 17:11:22 2016
// Last Modified By: Philip Tracton
// Last Modified On: Fri Dec  9 17:11:22 2016
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "axi_defines.vh"

module axi_master_bfm (/*AUTOARG*/
   // Outputs
   awid, awadr, awlen, awsize, awburst, awlock, awcache, awprot,
   awvalid, wid, wrdata, wstrb, wlast, wvalid, bid, bresp, bvalid,
   arid, araddr, arlen, arsize, arlock, arcache, arprot, arvalid,
   rready,
   // Inputs
   aclk, aresetn, awready, wready, bready, arready, rid, rdata, rresp,
   rlast, rvalid
   ) ;
   
   //
   // Global Signals
   //
   input wire aclk;
   input wire aresetn;   //Active LOW
   
   //
   // Write Address Channel
   //
   output reg [3:0]  awid;    // Address Write ID
   output reg [31:0] awadr;   // Write Address
   output reg [3:0]  awlen;   // Burst Length
   output reg [2:0]  awsize;  // Burst Size
   output reg [1:0]  awburst; // Burst Type
   output reg [1:0]  awlock;  // Lock Type
   output reg [3:0]  awcache; // Cache Type
   output reg [2:0]  awprot;  // Protection Type
   output reg        awvalid; // Write Address Valid   
   input wire        awready; // Write Address Ready

   //
   // Write Data Channel
   //
   output reg [3:0]  wid;     // Write ID
   output reg [31:0] wrdata;  // Write Data
   output reg [3:0]  wstrb;   // Write Strobes
   output reg        wlast;   // Write Last
   output reg        wvalid;  // Write Valid   
   input wire        wready;  // Write Ready
   
   //
   // Write Response CHannel
   //
   output reg [3:0]  bid;    // Response ID
   output reg [1:0]  bresp;  // Write Response
   output reg        bvalid; // Write Response Valid   
   input wire        bready; // Response Ready
   
   //
   // Read Address Channel
   //
   output reg [3:0]  arid;    // Read Address ID
   output reg [31:0] araddr;  // Read Address
   output reg [3:0]  arlen;   // Burst Length
   output reg [2:0]  arsize;  // Burst Size
   output reg [1:0]  arlock;  // Lock Type
   output reg [3:0]  arcache; // Cache Type
   output reg [2:0]  arprot;  // Protection Type
   output reg        arvalid; // Read Address Valid   
   input wire        arready; // Read Address Ready
   input wire [3:0]  rid;     // Read ID
   input wire [31:0] rdata;   // Read Data
   input wire [1:0]  rresp;   // Read Response
   input wire        rlast;   // Read Last
   input wire        rvalid;  // Read Valid
   output reg        rready;  // Read Ready

   //
   // Set all output regs to 0
   // 
   initial begin
      awid    <= 0;
      awadr   <= 0;
      awlen   <= 0;
      awsize  <=0;
      awburst <= 0;
      awlock  <= 0;
      awcache <= 0;
      awprot  <= 0;
      awvalid <= 0;

      wid    <= 0;
      wrdata <= 0;
      wstrb  <= 0;
      wlast  <= 0;
      wvalid <= 0;

      bid    <= 0;
      bresp  <= 0;
      bvalid <= 0;

      arid    <= 0;
      araddr  <= 0;
      arlen   <= 0;
      arsize  <= 0;
      arlock  <= 0;
      arcache <= 0;
      arprot  <= 0;
      arvalid <= 0;
      rready  <= 0;      
   end

   
   //
   // Task: Single Write Transaction
   //
   task write_single;      
      input [31:0] address;
      input [31:0] data;
      input [2:0]  size;      
      input [3:0]  strobe;
      begin

         //
         // Operate in a synchronous manner
         //
         @(posedge aclk); 
         $display("TASK: Write Single Addr = 0x%4x Data = 0x%4x Size = 0x%x Strobe = 0x%x Time = %d",
                  address, data, size, strobe, $time);         
         awid    <= 0;         
         awadr   <= address;
         awvalid <= 1;
         awlen   <= `AXI_BURST_LENGTH_1;
         awsize  <= size;
         awburst <= `AXI_BURST_TYPE_FIXED;
         awlock  <= `AXI_LOCK_NORMAL;
         awcache <= 0;
         awprot  <= `AXI_PROTECTION_NORMAL;
         @(posedge awready);  //This should arrive on a clock edge!
         awvalid <= 0;
         awadr  <= 'bX;         
         wid <= 0;
         wvalid <= 1;         
         wrdata <= data;
         wstrb <= strobe;
         wlast <= 1;
         @(posedge wready);
         wid <= 0;
         wvalid <= 0;         
         wrdata <= 'bX;
         wstrb <= 0;
         wlast <= 0;         
         
      end
   endtask //
   
   
endmodule // axi_master_bfm

