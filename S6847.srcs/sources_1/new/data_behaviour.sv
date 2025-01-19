//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Julian Brown
// 
// Create Date: 19.01.2025 10:03:00
// Design Name: 
// Module Name: data_behaviour
// Project Name: fpga6847
// Target Devices: 
// Tool Versions: 
// Description: define internal behaviour mode superset based on specific mode
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_behaviour(
    input bit dataload,
    input logic [3:0] mode,
    input bit [7:0] data,
    output logic [2:0] behaviour,
    output bit [3:0] semi_data,
    output bit [3:0] semi4_code,
    output bit [5:0] semi6_code,
    output bit [7:0] char_code
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
    
    display_behaviour state;
    
    always @(posedge dataload) begin
        if (mode == ALPHA || mode == INVALPHA || mode == EXTALPHA || mode == INVEXTALPHA) begin
            state = TEXT;
        end else if (mode == SEMI4) begin
            state = SEMIG4;
        end else if (mode == SEMI6) begin
            state = SEMIG6;
        end else begin
            if (mode == GRAPHIC1 || mode == GRAPHIC3 || mode == GRAPHIC5 || mode == GRAPHIC7)
                state = MONOGRAPHIC;
            else
                state = COLOURGRAPHIC;
        end
        unique case (state)
            TEXT: begin
                char_code = data;
                semi_data = 4'b0000;
                semi4_code = 4'b0000;
                semi6_code = 6'b000000;
            end
            SEMI4: begin
                char_code = 8'b00000000;
                semi_data [3:0] = data [7:4];
                semi4_code [3:0] = data [3:0];
                semi6_code = 6'b000000;
            end
            SEMI6: begin
                char_code = 8'b00000000;
                semi_data [3:0] = data [7:4];
                semi6_code [5:0] = data [5:0];
                semi4_code = 4'b0000;            
            end
            default begin
                char_code = 8'b00000000;
                semi_data = 4'b0000;
                semi4_code = 4'b0000;
                semi6_code = 6'b000000;            
            end
        endcase
        behaviour = state;
    end
    
endmodule
