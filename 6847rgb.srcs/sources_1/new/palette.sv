//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.01.2024 14:05:11
// Design Name: 
// Module Name: palette
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


module palette(
    input bit clock,
    input bit css,
    input bit [2:0] palette_code,
    input bit [2:0] mode,
    input bit graphic,
    input bit semi,
    input bit semi_data,
    input bit v_sync,
    input bit h_sync,
    input bit sync_high,
    output bit [7:0] RED,
    output bit [7:0] GREEN,
    output bit [7:0] BLUE
    );
    
    bit [1:0] bitsPerPixel;
    int set;
    
    always @(clock) begin
        if (h_sync)
            set = 4;
        else if (v_sync)
            set = 3;
        else if (graphic) begin
            set = 2;
            if (mode == 7 || mode == 5 || mode == 3 || mode == 1)
                bitsPerPixel = 1;
            else
                bitsPerPixel = 2;
        end else begin
            if (semi) begin
                set = 1;
                bitsPerPixel = 3;
            end else begin
                set = 0;
                bitsPerPixel = 1;
            end
        end
        if (set == 4) begin
            if (sync_high) begin
                RED <= 76;
                GREEN <= 76;
                BLUE <= 76;
            end else begin
                RED <= 0;
                GREEN <= 0;
                BLUE <= 0;
            end
        end else if (set == 3) begin
            if (sync_high) begin
                RED <= 76;
                GREEN <= 76;
                BLUE <= 76;
            end else begin
                RED <= 0;
                GREEN <= 0;
                BLUE <= 0;
            end
        end else if (set == 2) begin
            unique case ({bitsPerPixel, css, palette_code})
                {2'b1, 1'b0, 3'b0} : begin
                    // black
                    RED <= 76;
                    GREEN <= 76;
                    BLUE <= 76;
                end
                {2'b1, 1'b0, 3'b1} : begin
                    // white
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 255;
                end
                {2'b1, 1'b1, 3'b0} : begin
                    // darkgreen
                    RED <= 76;
                    GREEN <= 124;
                    BLUE <= 76;
                end
                {2'b1, 1'b1, 3'b1} : begin
                    // green
                    RED <= 76;
                    GREEN <= 255;
                    BLUE <= 76;
                end
                // green palette
                {2'b10, 1'b0, 3'b00} : begin
                    // green
                    RED <= 76;
                    GREEN <= 255;
                    BLUE <= 76;
                end
                {2'b10, 1'b0, 3'b01} : begin
                    // yellow
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 124;
                end
                {2'b10, 1'b0, 3'b10} : begin
                    // blue
                    RED <= 100;
                    GREEN <= 88;
                    BLUE <= 207;
                end
                {2'b10, 1'b0, 3'b11} : begin
                    // red
                    RED <= 207;
                    GREEN <= 76;
                    BLUE <= 100;
                end
                // white palette
                {2'b10, 1'b1, 3'b00} : begin
                    // white
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 255;
                end
                {2'b10, 1'b1, 3'b01} : begin
                    // cyan
                    RED <= 75;
                    GREEN <= 231;
                    BLUE <= 159;
                end
                {2'b10, 1'b1, 3'b10} : begin
                    // magenta
                    RED <= 255;
                    GREEN <= 88;
                    BLUE <= 255;
                end
                {2'b10, 1'b1, 3'b11} : begin
                    // orange
                    RED <= 255;
                    GREEN <= 124;
                    BLUE <= 76;
                end
            endcase 
        end else if (set == 1) begin
            if (semi_data)
                unique case (palette_code)
                    3'b000 : begin
                        //green
                        RED <= 76;
                        GREEN <= 255;
                        BLUE <= 76;
                    end
                    3'b001 : begin
                        //yellow
                        RED <= 255;
                        GREEN <= 255;
                        BLUE <= 124;
                    end
                    3'b010 : begin
                        //blue
                        RED <= 100;
                        GREEN <= 88;
                        BLUE <= 207;
                    end
                    3'b011 : begin
                        //red
                        RED <= 207;
                        GREEN <= 76;
                        BLUE <= 100;
                    end
                    3'b100 : begin
                        //white
                        RED <= 255;
                        GREEN <= 255;
                        BLUE <= 255;
                    end
                    3'b101 : begin
                        //cyan
                        RED <= 76;
                        GREEN <= 231;
                        BLUE <= 159;
                    end
                    3'b110 : begin
                        //magenta
                        RED <= 255;
                        GREEN <= 88;
                        BLUE <= 255;
                    end
                    3'b111 : begin
                        //orange
                        RED <= 255;
                        GREEN <= 124;
                        BLUE <= 76;
                    end
                endcase
            else begin
                RED <= 0;
                GREEN <= 0;
                BLUE <= 0;
            end
        end else begin
            unique case ({css, palette_code})
                {1'b0, 1'b0} : begin 
                    //dark green
                    RED <= 76;
                    GREEN <= 124;
                    BLUE <= 76;
                end 
                {1'b0, 1'b1} : begin
                    //green 
                    RED <= 76;
                    GREEN <= 255;
                    BLUE <= 76;
                end 
                {1'b1, 1'b0} : begin
                    //dark orange 
                    RED <= 147;
                    GREEN <= 76;
                    BLUE <= 76;
                end 
                {1'b1, 1'b1} : begin
                    //bright orange 
                    RED <= 255;
                    GREEN <= 207;
                    BLUE <= 124;
                end 
            endcase 
        end
    end
    
endmodule
