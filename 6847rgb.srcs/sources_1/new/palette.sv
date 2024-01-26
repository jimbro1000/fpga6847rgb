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
    input bit [3:0] palette_code,
    input bit [2:0] mode,
    input bit graphic,
    input bit semi,
    input bit semi_data,
    input bit v_sync,
    input bit h_sync,
    input bit sync_high,
    input bit double,
    output bit [3:0] red,
    output bit [3:0] green,
    output bit [3:0] blue
    );
    
    bit [7:0] RED;
    bit [7:0] GREEN;
    bit [7:0] BLUE;
    
    bit [2:0] bitsPerPixel;
    int set;
    
    assign red[3:0] = RED[7:4];
    assign green[3:0] = GREEN[7:4];
    assign blue[3:0] = BLUE[7:4];
    
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
            if (double)
                bitsPerPixel = bitsPerPixel * 2;
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
                {3'b1, 1'b0, 4'b0} : begin
                    // black
                    RED <= 76;
                    GREEN <= 76;
                    BLUE <= 76;
                end
                {3'b1, 1'b0, 4'b1} : begin
                    // white
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 255;
                end
                {3'b1, 1'b1, 4'b0} : begin
                    // darkgreen
                    RED <= 76;
                    GREEN <= 124;
                    BLUE <= 76;
                end
                {3'b1, 1'b1, 4'b1} : begin
                    // green
                    RED <= 76;
                    GREEN <= 255;
                    BLUE <= 76;
                end
                // green palette
                {3'b10, 1'b0, 4'b00} : begin
                    // green
                    RED <= 76;
                    GREEN <= 255;
                    BLUE <= 76;
                end
                {3'b10, 1'b0, 4'b01} : begin
                    // yellow
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 124;
                end
                {3'b10, 1'b0, 4'b10} : begin
                    // blue
                    RED <= 100;
                    GREEN <= 88;
                    BLUE <= 207;
                end
                {3'b10, 1'b0, 4'b11} : begin
                    // red
                    RED <= 207;
                    GREEN <= 76;
                    BLUE <= 100;
                end
                // white palette
                {3'b10, 1'b1, 4'b00} : begin
                    // white
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 255;
                end
                {3'b10, 1'b1, 4'b01} : begin
                    // cyan
                    RED <= 75;
                    GREEN <= 231;
                    BLUE <= 159;
                end
                {3'b10, 1'b1, 4'b10} : begin
                    // magenta
                    RED <= 255;
                    GREEN <= 88;
                    BLUE <= 255;
                end
                {3'b10, 1'b1, 4'b11} : begin
                    // orange
                    RED <= 255;
                    GREEN <= 124;
                    BLUE <= 76;
                end
                // double palette 0
                {3'b100, 1'b0, 4'b0000} : begin
                    // green
                    RED <= 76;
                    GREEN <= 255;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0001} : begin
                    // yellow
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 124;
                end
                {3'b100, 1'b0, 4'b0010} : begin
                    // blue
                    RED <= 100;
                    GREEN <= 88;
                    BLUE <= 207;
                end
                {3'b100, 1'b0, 4'b0011} : begin
                    // red
                    RED <= 207;
                    GREEN <= 76;
                    BLUE <= 100;
                end
                {3'b100, 1'b0, 4'b0100} : begin
                    // white
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 255;
                end
                {3'b100, 1'b0, 4'b0101} : begin
                    // cyan
                    RED <= 76;
                    GREEN <= 231;
                    BLUE <= 159;
                end
                {3'b100, 1'b0, 4'b0110} : begin
                    // magenta
                    RED <= 255;
                    GREEN <= 88;
                    BLUE <= 255;
                end
                {3'b100, 1'b0, 4'b0111} : begin
                    // orange
                    RED <= 255;
                    GREEN <= 124;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0000} : begin
                    // black
                    RED <= 76;
                    GREEN <= 76;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0001} : begin
                    // green glow
                    RED <= 76;
                    GREEN <= 124;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0010} : begin
                    // orange glow
                    RED <= 147;
                    GREEN <= 76;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0011} : begin
                    // grey
                    RED <= 147;
                    GREEN <= 147;
                    BLUE <= 147;
                end
                {3'b100, 1'b0, 4'b0100} : begin
                    // pure red
                    RED <= 255;
                    GREEN <= 76;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0101} : begin
                    // pure blue
                    RED <= 76;
                    GREEN <= 76;
                    BLUE <= 255;
                end
                {3'b100, 1'b0, 4'b0110} : begin
                    // pure yellow
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0111} : begin
                    // pure pink
                    RED <= 255;
                    GREEN <= 76;
                    BLUE <= 255;
                end
                // double palette 1 - ttl and half bright
                {3'b100, 1'b0, 4'b0000} : begin
                    // black
                    RED <= 76;
                    GREEN <= 76;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0001} : begin
                    // red
                    RED <= 255;
                    GREEN <= 76;
                    BLUE <= 124;
                end
                {3'b100, 1'b0, 4'b0010} : begin
                    // green
                    RED <= 76;
                    GREEN <= 255;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0011} : begin
                    // blue
                    RED <= 76;
                    GREEN <= 76;
                    BLUE <= 255;
                end
                {3'b100, 1'b0, 4'b0100} : begin
                    // orange
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0101} : begin
                    // cyan
                    RED <= 76;
                    GREEN <= 255;
                    BLUE <= 255;
                end
                {3'b100, 1'b0, 4'b0110} : begin
                    // magenta
                    RED <= 255;
                    GREEN <= 76;
                    BLUE <= 255;
                end
                {3'b100, 1'b0, 4'b0111} : begin
                    // white
                    RED <= 255;
                    GREEN <= 255;
                    BLUE <= 255;
                end
                {3'b100, 1'b0, 4'b0000} : begin
                    // dark grey
                    RED <= 124;
                    GREEN <= 124;
                    BLUE <= 124;
                end
                {3'b100, 1'b0, 4'b0001} : begin
                    // half red
                    RED <= 76;
                    GREEN <= 166;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0010} : begin
                    // half green
                    RED <= 76;
                    GREEN <= 166;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0011} : begin
                    // half blue
                    RED <= 76;
                    GREEN <= 76;
                    BLUE <= 166;
                end
                {3'b100, 1'b0, 4'b0100} : begin
                    // half orange
                    RED <= 166;
                    GREEN <= 166;
                    BLUE <= 76;
                end
                {3'b100, 1'b0, 4'b0101} : begin
                    // half cyan
                    RED <= 76;
                    GREEN <= 166;
                    BLUE <= 166;
                end
                {3'b100, 1'b0, 4'b0110} : begin
                    // half magenta
                    RED <= 166;
                    GREEN <= 76;
                    BLUE <= 166;
                end
                {3'b100, 1'b0, 4'b0111} : begin
                    // light grey
                    RED <= 207;
                    GREEN <= 207;
                    BLUE <= 207;
                end
            endcase 
        end else if (set == 1) begin
            if (semi_data)
                unique case (palette_code)
                    4'b000 : begin
                        //green
                        RED <= 76;
                        GREEN <= 255;
                        BLUE <= 76;
                    end
                    4'b001 : begin
                        //yellow
                        RED <= 255;
                        GREEN <= 255;
                        BLUE <= 124;
                    end
                    4'b010 : begin
                        //blue
                        RED <= 100;
                        GREEN <= 88;
                        BLUE <= 207;
                    end
                    4'b011 : begin
                        //red
                        RED <= 207;
                        GREEN <= 76;
                        BLUE <= 100;
                    end
                    4'b100 : begin
                        //white
                        RED <= 255;
                        GREEN <= 255;
                        BLUE <= 255;
                    end
                    4'b101 : begin
                        //cyan
                        RED <= 76;
                        GREEN <= 231;
                        BLUE <= 159;
                    end
                    4'b110 : begin
                        //magenta
                        RED <= 255;
                        GREEN <= 88;
                        BLUE <= 255;
                    end
                    4'b111 : begin
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
                {1'b0, 4'b0} : begin 
                    //dark green
                    RED <= 76;
                    GREEN <= 124;
                    BLUE <= 76;
                end 
                {1'b0, 4'b1} : begin
                    //green 
                    RED <= 76;
                    GREEN <= 255;
                    BLUE <= 76;
                end 
                {1'b1, 4'b0} : begin
                    //dark orange 
                    RED <= 147;
                    GREEN <= 76;
                    BLUE <= 76;
                end 
                {1'b1, 4'b1} : begin
                    //bright orange 
                    RED <= 255;
                    GREEN <= 207;
                    BLUE <= 124;
                end 
            endcase 
        end
    end
    
endmodule
