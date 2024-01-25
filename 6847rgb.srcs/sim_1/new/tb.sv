`timescale 100ps / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.01.2024 10:04:17
// Design Name: 
// Module Name: tb
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


module tb;
    logic [7:0] data;
    logic vclk;
    logic css; 
    logic ieb; 
    logic asb; 
    logic agb;
    logic inv;
    logic [2:0] gm;
    logic da0;
    logic hsb;
    logic fsb;
    logic msb;
    logic rp;
    logic [3:0] red;
    logic [3:0] green;
    logic [3:0] blue;
    logic vhs;
    logic vfs;
    
    int show_mode;
    // 0, 1, 2, 3, 4, 5, 6, 7, alpha
    int char;
    int row;
    int count;
    int char_row;
    
    vdg u_vdg (.*);
    
    initial begin
        $printtimescale(tb);
        vclk = 0;
        data = 0;
        css = 0;
        ieb = 0;
        asb = 0;
        agb = 0;
        gm = 0;
        inv = 0;
        show_mode = 0;
        char = 0;
        row = 0;
        count = 0;
        char_row = 0;
        
        forever begin
            vclk = !vclk;
            #1397;
        end
    end
    
    always @(posedge fsb) begin
        show_mode = (show_mode + 1) % 9;
        row = 0;
        char = 0;
        count = 0;
    end
    
    always @(negedge hsb) begin
        if (show_mode < 8)
            data = data * 255;
        row = row + 1;
    end
    
    always @(da0) begin
        if (show_mode == 8) begin
            count = count + 1;
            char = count % 32;
            char_row = row / 12;
            data = ((32 * char_row) + char) % 128;
        end
    end
    
    always @(show_mode) begin
        if (show_mode < 8) begin
            gm = show_mode;
            agb = 1;
            data = 85;
        end else begin
            gm = 0;
            agb = 0;
            data = 0;
        end
    end
endmodule
