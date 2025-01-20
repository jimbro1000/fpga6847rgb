//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.01.2025 19:47:40
// Design Name: 
// Module Name: pixel_generator
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


module pixel_generator(
    input bit vclk,
    input row,
    input logic [2:0] behaviour,
    input logic [3:0] mode,
    input logic [2:0] display_state,
    input int counter,
    input bit dataload,
    input bit [7:0] char_data,
    input bit [7:0] ext_char_data,
    input bit [7:0] semi4_data,
    input bit [7:0] semi6_data,
    input bit [7:0] data,
    
    output bit [3:0] display_palette,
    output bit [1:0] bit_data
    );
    
    typedef enum logic [3:0] {
        ALPHA = 4'b0000,
        INVALPHA = 4'b0001,
        EXTALPHA = 4'b0010,
        INVEXTALPHA = 4'b0011,
        SEMI4 = 4'b0100,
        SEMI6 = 4'b0101,
        GRAPHIC0 = 4'b1000,
        GRAPHIC1 = 4'b1001,
        GRAPHIC2 = 4'b1010,
        GRAPHIC3 = 4'b1011,
        GRAPHIC4 = 4'b1100,
        GRAPHIC5 = 4'b1101,
        GRAPHIC6 = 4'b1110,
        GRAPHIC7 = 4'b1111
    } display_mode;

   typedef enum logic [2:0] {
        TEXT = 3'b000,
        SEMIG4 = 3'b010,
        SEMIG6 = 3'b011,
        MONOGRAPHIC = 3'b100,
        COLOURGRAPHIC= 3'b101
    } display_behaviour;

    typedef enum {
        LL, LS, SL, SS, DS
    } syncrow;

    typedef enum logic [2:0] {
        LEFT, RIGHT, TOP, BOTTOM, ACTIVE, SYNC
    } display_model;
        
    bit [7:0] graphic_data;

    always @(counter, vclk, dataload) begin
        if (dataload) begin
            unique case (mode)
                ALPHA:
                    graphic_data = char_data;
                INVALPHA:
                    graphic_data = char_data;
                EXTALPHA:
                    graphic_data = ext_char_data;
                INVEXTALPHA:
                    graphic_data = ext_char_data;
                SEMI4:
                    graphic_data = semi4_data;
                SEMI6:
                    graphic_data = semi6_data;
                default:
                    graphic_data = data;
            endcase
        end
        
        if (row == DS) begin
            unique case(behaviour)
                TEXT: begin
                    if (display_state == ACTIVE) begin
                        bit_data = { 1'b0, graphic_data[7] };
                        graphic_data = graphic_data << 1;
                        display_palette = { 3'b000, bit_data[0] };
                    end else
                        display_palette = 4'b0000;
                end
                SEMIG4: begin
                    if (display_state == ACTIVE) begin
                        bit_data = { 1'b0, graphic_data[7] };
                        graphic_data = graphic_data << 1;
                        display_palette = { 1'b0, semi4_data[2:0] };
                    end else
                        display_palette = 4'b0000;
                end
                SEMIG6: begin
                    if (display_state == ACTIVE) begin
                        bit_data = { 1'b0, graphic_data[7] };
                        graphic_data = graphic_data << 1;
                        display_palette = { 2'b00, semi6_data[3:2] };
                    end else
                        display_palette = 4'b0000;
                end
                MONOGRAPHIC: begin
                    if (display_state == ACTIVE) begin
                        if (mode == GRAPHIC7 || vclk) begin
                        bit_data = { 1'b0, graphic_data[7] };
                        graphic_data = graphic_data << 1;
                        end
                        display_palette = { 3'b000, bit_data[0] };
                    end else
                        display_palette = 4'b0000;
                end
                default begin
                    if (display_state == ACTIVE) begin
                        if (mode != GRAPHIC0 || vclk) begin
                            bit_data[1:0] = graphic_data[7:6];
                            graphic_data = graphic_data << 2;
                        end
                        display_palette = { 2'b00, bit_data[1:0] };
                    end else
                        display_palette = 4'b0000;
                end
            endcase
        end
    end
endmodule
