`timescale 100ps / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.01.2025 20:03:42
// Design Name: 
// Module Name: tb_display_behaviour
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_display_behaviour;
    `include "display_behaviour.sv"
    `include "display_mode.sv"

    bit [7:0] data;
    bit dataload;
    bit [3:0] mode;
    
    bit [2:0] behaviour;
    bit [3:0] semi_data;
    bit [3:0] semi4_code;
    bit [5:0] semi6_code;
    bit [7:0] char_code;
    
    int clock;
    
    data_behaviour u_db
    (
        .dataload (dataload),
        .mode (mode),
        .data (data),
        .behaviour (behaviour),
        .semi_data (semi_data),
        .semi4_code (semi4_code),
        .semi6_code (semi6_code),
        .char_code (char_code)
    );
    
    initial begin
        data = 8'b01010101;
        dataload = 0;
        mode = ALPHA;
        
        forever begin
            #10;
            clock = clock + 1;
        end
    end
    
    always @(clock) begin
        dataload = (clock % 8) == 0;
        if (dataload)
            data = ~data;
        if (clock % 32 == 0) begin
            mode = mode + 1;
        end
    end
endmodule
