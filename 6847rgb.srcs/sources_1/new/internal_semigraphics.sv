//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2024 20:32:42
// Design Name: 
// Module Name: internal_semigraphics
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


module internal_semigraphics(
    input clock,
    input [3:0] index,
    input [3:0] row,
    
    output logic [7:0] char_bitmap
    );
    
    logic [7:0] bitmap;
    bit block_row;
    
    always @(posedge clock) begin
        block_row <= row / 6;
        case({index, block_row})
            {4'h0, 0} : bitmap <= 8'b00000000;
            {4'h0, 1} : bitmap <= 8'b00000000;
            {4'h1, 0} : bitmap <= 8'b00000000;
            {4'h1, 1} : bitmap <= 8'b00001111;
            {4'h2, 0} : bitmap <= 8'b00000000;
            {4'h2, 1} : bitmap <= 8'b11110000;
            {4'h3, 0} : bitmap <= 8'b00000000;
            {4'h3, 1} : bitmap <= 8'b11111111;
            {4'h4, 0} : bitmap <= 8'b00001111;
            {4'h4, 1} : bitmap <= 8'b00000000;
            {4'h5, 0} : bitmap <= 8'b00001111;
            {4'h5, 1} : bitmap <= 8'b00001111;
            {4'h6, 0} : bitmap <= 8'b00001111;
            {4'h6, 1} : bitmap <= 8'b11110000;
            {4'h7, 0} : bitmap <= 8'b00001111;
            {4'h7, 1} : bitmap <= 8'b11111111;
            {4'h8, 0} : bitmap <= 8'b11110000;
            {4'h8, 1} : bitmap <= 8'b00000000;
            {4'h9, 0} : bitmap <= 8'b11110000;
            {4'h9, 1} : bitmap <= 8'b00001111;
            {4'ha, 0} : bitmap <= 8'b11110000;
            {4'ha, 1} : bitmap <= 8'b11110000;
            {4'hb, 0} : bitmap <= 8'b11110000;
            {4'hb, 1} : bitmap <= 8'b11111111;
            {4'hc, 0} : bitmap <= 8'b11111111;
            {4'hc, 1} : bitmap <= 8'b00000000;
            {4'hd, 0} : bitmap <= 8'b11111111;
            {4'hd, 1} : bitmap <= 8'b00001111;
            {4'he, 0} : bitmap <= 8'b11111111;
            {4'he, 1} : bitmap <= 8'b11110000;
            {4'hf, 0} : bitmap <= 8'b11111111;
            {4'hf, 1} : bitmap <= 8'b11111111;
        endcase
        char_bitmap <= bitmap;
    end

endmodule
