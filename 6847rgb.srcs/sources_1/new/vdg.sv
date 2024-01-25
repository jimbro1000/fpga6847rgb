`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.01.2024 20:53:54
// Design Name: 
// Module Name: vdg
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


module vdg(
    input logic [7:0] data,
    input logic vclk, 
    input logic css, 
    input logic ieb, 
    input logic asb, 
    input logic agb, 
    input logic inv,
    input logic [2:0] gm,
//    input logic rwb,
//    input logic cs,
//    input logic [1:0] a,
    
//    input logic [7:0] register_bus_in,
//    output logic [7:0] register_bus_out,
    
    output logic da0,
    output logic hsb,
    output logic fsb,
    output logic msb,
    output logic rp,
    output logic [3:0] red,
    output logic [3:0] green,
    output logic [3:0] blue,
    output logic vhs,
    output logic vfs
    );
    
    bit [7:0] sm6_data;
    bit [7:0] sm4_data;
    bit [2:0] assert_palette;
    bit [7:0] graphic_data;
    bit [2:0] display_palette;
    bit [7:0] register_select_a;
    bit [7:0] register_data_a;
    bit [7:0] register_select_b;
    bit [7:0] register_data_b;
    shortint vcounter;
    shortint hcounter;
    shortint displayrow;
    shortint displaycol;
    bit vs;
    bit hs;
    bit nextrow;
    bit dataload;
    bit preload;
    bit a0;
    int left;
    bit [2:0] bit_data;
    int clkdiv;
    int char_code;
    int semi4_code;
    int semi6_code;
    bit [7:0] semi_data;
    bit [7:0] char_lookup;
    bit [3:0] char_row;
    bit [7:0] char_data;
    bit [7:0] ext_char_data;
    bit sync_high;
    bit clk1;
    bit clk2;
    
    bit [7:0] alphared;
    bit [7:0] alphagreen;
    bit [7:0] alphablue;
    
    // bit [7:0] ext_char [12][128];
    // 8-bit x 12 = 1 character
    // x 128
    
    typedef enum {
        LL1, LL2, LS3, SS4, SS5,
        DS6,
        SS7, SS8, SL9, LL10, LL11,
        SS12, SS13,
        DS14,
        SS15, SS16, SS17
    } sync;
    
    typedef enum {
        LL, LS, SL, SS, DS
    } syncrow;
    
    typedef enum {
        LEFT, RIGHT, TOP, BOTTOM, ACTIVE, SYNC
    } display_model;
    
    typedef enum {
        ALPHA,
        INVALPHA,
        EXTALPHA,
        INVEXTALPHA,
        SEMI4,
        SEMI6,
        GRAPHIC0,
        GRAPHIC1,
        GRAPHIC2,
        GRAPHIC3,
        GRAPHIC4,
        GRAPHIC5,
        GRAPHIC6,
        GRAPHIC7
    } display_mode;
    
    typedef enum {
        TEXT,
        SEMIG4,
        SEMIG6,
        MONOGRAPHIC,
        COLOURGRAPHIC
    } display_behaviour;
    
    sync state;
    syncrow row;
    display_model ds_state;
    display_mode mode;
    display_behaviour behaviour;
    
    text_rom internal_text_rom
    (
        .clock (vclk),
        .index (char_code[6:0]),
        .row   (char_row),
        .char_bitmap (char_data)
    );
    
    external_text_rom ext_text_rom
    (
        .clock (vclk),
        .index (char_code[6:0]),
        .row   (char_row),
        .char_bitmap (ext_char_data)
    );
    
    internal_semigraphics semigraphics4_rom
    (
        .clock          (vclk),
        .index          (semi4_code[3:0]),
        .row            (char_row),
        .char_bitmap    (sm4_data)
    );
    
    external_semigraphics semigraphics6_rom
    (
        .clock          (vclk),
        .index          (semi6_code[5:0]),
        .row            (char_row),
        .char_bitmap    (sm6_data)
    );
    
    palette internal_palette
    (
        .clock (vclk),
        .css (css),
        .palette_code (assert_palette),
        .mode (gm),
        .graphic (agb),
        .semi (asb),
        .semi_data (bit_data[0]),
        .v_sync (vs),
        .h_sync (hs),
        .sync_high (sync_high),
        .red (red),
        .green (green),
        .blue (blue)
    );
    
    parameter int toprows = 60;
    parameter int activerows = 192;
    parameter int allrows = 308;
    parameter int maxrows = 312;
    
    parameter int leftcols = 101;
    parameter int activecols = 256;
    parameter int allcols = 458; //458.18176
    parameter int rightcols = leftcols + activecols;
    parameter int leftpreload = leftcols - 9;
    parameter int rightpreload = rightcols - 9;
    
    parameter int hzeropulse = 15; //14.2857
    parameter int hlowpulse = 19; //28.5714
    parameter int hshortsync = 34; //2uS approx
    parameter int hmidway = allcols / 2;
    parameter int hlongsync = hmidway - hshortsync; //30uS approx
    
    parameter int CLK4 = 8;
    parameter int CLK8 = 16;
    
    // vclk cycles per row = 229.09
    // 1 vclk = 279.365ns
    // pixel clock cycles = 458.18
    // 1 p.clock == 0.000000139S => 0.139uS => 139nS
    // normal h sync = 4uS
    // h. backporch = 8uS
    
    initial begin
        sm6_data = 0;
        sm4_data = 0;
        vcounter = -1;
        hcounter = -1;
        a0 = 1;
        hsb = 1;
        fsb = 1;
        msb = 1;
        rp = 0;
        vs = 0;
        hs = 0;
        state = LL1;
        row = LL;
        displayrow = 0;
        displaycol = 0;
        mode = ALPHA;
        da0 = a0;
        clkdiv = CLK4;
        char_row = 0;
        sync_high = 0;
        clk1 = 0;
        clk2 = 0;
    end

// VCLK expected to operate at 3.579545MHz
// 1 clock duration is 279.365nS
// hcounter -> 7.15909MHz
// 1 pixel clock duration is 139.682nS

// active on positive and negative vclk edge
    always @(posedge vclk) begin
        clk1 = !clk1;
    end
    
    always @(negedge vclk) begin
        clk2 = !clk2;
    end
    
    always @(clk1, clk2) begin
        hcounter = (hcounter + 1) % (allcols + 1);
        if (row == DS && hcounter != 0)
            displaycol <= displaycol + 1;
        else
            displaycol <= 0;
    end
    
    assign nextrow = (hcounter == allcols);
    assign vhs = hsb;
    assign vfs = fsb;
    
//    always @(cs) begin
//        if (rwb) begin
//            if (a == 1) begin
//                register_bus_out <= register_data_a;
//            end else if (a == 3) begin
//                register_bus_out <= register_data_b;
//            end
//        end else begin
//            if (a == 0) begin
//                register_select_a <= register_bus_in;
//            end else if (a==1) begin
//                register_data_a <= register_bus_in;
//            end else if (a==2) begin
//                register_select_b <= register_bus_in;
//            end else begin
//                register_data_b <= register_bus_in;
//            end
//        end
//    end
    
    always @(ieb, asb, agb, gm) begin
        if (agb) begin
            unique case (gm)
                0: begin
                    mode = GRAPHIC0;
                    clkdiv = CLK8;
                end
                1: begin
                    mode = GRAPHIC1;
                    clkdiv = CLK8;
                end
                2: begin
                    mode = GRAPHIC2;
                    clkdiv = CLK4;
                end
                3: begin
                    mode = GRAPHIC3;
                    clkdiv = CLK8;
                end
                4: begin
                    mode = GRAPHIC4;
                    clkdiv = CLK4;
                end
                5: begin
                    mode = GRAPHIC5;
                    clkdiv = CLK8;
                end
                6: begin
                    mode = GRAPHIC6;
                    clkdiv = CLK4;
                end
                7: begin
                    mode = GRAPHIC7;
                    clkdiv = CLK4;
                end
            endcase
        end else begin
            if (asb) begin
                if (ieb) mode = SEMI6;
                else mode = SEMI4;
            end else begin
                if (ieb) begin
                    if (inv) mode = INVEXTALPHA;
                    else mode = EXTALPHA;
                end else begin
                    if (inv) mode = INVALPHA;
                    else mode = ALPHA;
                end
            end
        end
    end
    
    always @(preload, nextrow) begin
        if (nextrow)
            da0 = 1; // causing a pulse on hs - should stay high
        else
            da0 = a0;
        a0 = !a0;
    end
    
    always @(posedge dataload) begin
        if (mode == ALPHA || mode == INVALPHA || mode == EXTALPHA || mode == INVEXTALPHA) begin
            char_code = data;
            behaviour = TEXT;
        end else if (mode == SEMI4) begin
            semi_data = data;
            semi4_code = semi_data & 8'b00001111;
            behaviour = SEMIG4;
        end else if (mode == SEMI6) begin
            semi_data = data;
            semi6_code = semi_data & 8'b00111111;
            behaviour = SEMIG6;
        end else begin
            if (mode == GRAPHIC1 || mode == GRAPHIC3 || mode == GRAPHIC5 || mode == GRAPHIC7)
                behaviour = MONOGRAPHIC;
            else
                behaviour = COLOURGRAPHIC;
        end
    end 
    
    always @(display_palette) begin
        assert_palette = display_palette;
    end
        
    assign hs = (row == DS) && !vs && (hcounter < (hzeropulse + hlowpulse));
        
    always @(hcounter) begin
        if (hcounter == allcols) begin
            vcounter = vcounter + 1;
            displayrow = displayrow + 1;
            if (vcounter > toprows && vcounter <= (toprows + activerows))
                char_row = (char_row + 1) % 12;
            else
                char_row = 0;
        end
        
        if (row == DS & !vs & (vcounter >= toprows) & (vcounter < toprows + activerows)) begin
            left = hcounter - (leftcols - 8);
            dataload = (hcounter > leftpreload) & (hcounter <= rightpreload) & ((left % clkdiv) == 0);
            preload = (hcounter >= leftpreload) & (hcounter < rightpreload) & ((left - 1) % clkdiv < 3);
        end else begin
            dataload = 0;
            preload = 0;
        end
        
        if (nextrow) begin
            unique case(state)
                SS17: begin
                    state = LL1;
                    row = LL;
                    vs = 1;
                    vcounter = 0;
                end
                LL1: begin 
                    state = LL2;
                    row = LL;
                    vs = 1;
                end
                LL2: begin 
                    state = LS3;
                    row = LS;
                    vs = 1;
                end
                LS3: begin
                    state = SS4;
                    row = SS;
                    vs = 1;
                end
                SS4: begin
                    state = SS5;
                    row = SS;
                    vs = 1;
                end
                SS5: begin
                    state = DS6;
                    row = DS;
                    vs = 0;
                    displayrow = 0;
                end
                DS6:
                    if (vcounter > allrows) begin
                        state = SS7;
                        row = SS;
                        vs = 1;
                    end
                SS7: begin
                    state = SS8;
                    row = SS;
                    vs = 1;
                end
                SS8: begin
                    state = SL9;
                    row = SL;
                    vs = 1;
                end
                SL9: begin
                    state = LL10;
                    row = LL;
                    vs = 1;
                    vcounter = 0;
                end
                LL10: begin
                    state = LL11;
                    row = LL;
                    vs = 1;
                end
                LL11: begin
                    state = SS12;
                    row = SS;
                    vs = 1;
                end
                SS12: begin
                    state = SS13;
                    row = SS;
                    vs = 1;
                end
                SS13: begin
                    state = DS14;
                    row = DS;
                    vs = 0;
                    displayrow = 0;
                end
                DS14: 
                    if (vcounter > allrows) begin
                        state = SS15;
                        row = SS;
                        vs = 1;
                    end 
                SS15: begin
                    state = SS16;
                    row = SS;
                    vs = 1;
                end
                SS16: begin
                    state = SS17;
                    row = SS;
                    vs = 1;
                end
            endcase
        end
        
        unique case(row)
            SS: begin
                sync_high = (hcounter < hmidway & hcounter > hshortsync) | (hcounter > (hshortsync + hmidway));
                ds_state = SYNC;
            end
            LL: begin
                sync_high = (hcounter < hmidway & hcounter > hlongsync) | (hcounter > (hlongsync + hmidway));
                ds_state = SYNC;
            end
            LS: begin
                sync_high = (hcounter < hmidway & hcounter > hlongsync) | (hcounter > (hshortsync + hmidway));
                ds_state = SYNC;
            end
            SL: begin
                sync_high = (hcounter < hmidway & hcounter > hshortsync) | (hcounter > (hlongsync + hmidway));
                ds_state = SYNC;
            end
            DS: begin
                if (!hs) begin
                    if (displayrow <= toprows)
                        ds_state = TOP;
                    else if (displayrow >= (toprows + activerows))
                        ds_state = BOTTOM;
                    else begin
                        if (displaycol <= leftcols)
                            ds_state = LEFT;
                        else if (displaycol >= (leftcols + activecols))
                            ds_state = RIGHT;
                        else
                            ds_state = ACTIVE;
                    end
                    
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
                                graphic_data = sm4_data;
                            SEMI6:
                                graphic_data = sm6_data;
                            default:
                                graphic_data = data;
                        endcase 
                    end
                    
                    unique case (behaviour)
                        TEXT: begin
                            if (ds_state == ACTIVE) begin
                                bit_data = 0;
                                bit_data[0] = graphic_data[7];
                                graphic_data = graphic_data << 1;
                                display_palette = { 2'b00, bit_data[0] };
                            end else
                                display_palette = 3'b000;
                        end
                        SEMIG4: begin
                            if (ds_state == ACTIVE) begin
                                bit_data = 0;
                                bit_data[0] = graphic_data[7];
                                graphic_data = graphic_data << 1;
                                display_palette = semi_data[6:4];
                            end else
                                display_palette = 3'b000;
                        end
                        SEMIG6: begin
                            if (ds_state == ACTIVE) begin
                                bit_data = 0;
                                bit_data[0] = graphic_data[7];
                                graphic_data = graphic_data << 1;
                                display_palette = { 1'b0, semi_data[7:6] };
                            end else
                                display_palette = 3'b000;
                        end
                        MONOGRAPHIC: begin
                            if (ds_state == ACTIVE) begin
                                if (mode == GRAPHIC7 || vclk) begin
                                    bit_data = 0;
                                    bit_data[0] = graphic_data[7];
                                    graphic_data = graphic_data << 1;
                                end
                                display_palette = { 2'b00, bit_data[0] };
                            end else
                                display_palette = 3'b000;
                        end
                        COLOURGRAPHIC: begin
                            if (ds_state == ACTIVE) begin
                                if (mode != GRAPHIC0 || vclk) begin
                                    bit_data = 0;
                                    bit_data[1] = graphic_data[7];
                                    bit_data[0] = graphic_data[6];
                                    graphic_data = graphic_data << 2;
                                end
                                display_palette = { 1'b0, bit_data[1:0] };
                            end else
                                display_palette = 3'b000;
                        end
                    endcase
                    
                    unique case (mode)
                        ALPHA: begin
                            if (ds_state == ACTIVE) begin
                                bit_data = 0;
                                bit_data[0] = graphic_data[7];
                                graphic_data = graphic_data << 1;
                                display_palette = { 2'b00, bit_data[0] };
                            end else
                                display_palette = 3'b000;
                        end
                        INVALPHA: begin
                            if (ds_state == ACTIVE) begin
                                bit_data = 0;
                                bit_data[0] = graphic_data[7];
                                graphic_data = graphic_data << 1;
                                display_palette = { 2'b00, bit_data[0] };
                            end else
                                display_palette = 3'b000;
                        end
                        EXTALPHA: begin
                            if (ds_state == ACTIVE) begin
                                bit_data = 0;
                                bit_data[0] = graphic_data[7];
                                graphic_data = graphic_data << 1;
                                display_palette = { 2'b00, bit_data[0] };
                            end else
                                display_palette = 3'b000;
                        end
                        INVEXTALPHA: begin
                            if (ds_state == ACTIVE) begin
                                bit_data = 0;
                                bit_data[0] = graphic_data[7];
                                graphic_data = graphic_data << 1;
                                display_palette = { 2'b00, bit_data[0] };
                            end else
                                display_palette = 3'b000;
                        end
                        SEMI4: begin
                            if (ds_state == ACTIVE) begin
                                bit_data = 0;
                                bit_data[0] = graphic_data[7];
                                graphic_data = graphic_data << 1;
                                display_palette = semi_data[6:4];
                            end else
                                display_palette = 3'b000;
                        end
                        SEMI6: begin
                            if (ds_state == ACTIVE) begin
                                bit_data = 0;
                                bit_data[0] = graphic_data[7];
                                graphic_data = graphic_data << 1;
                                display_palette = { 1'b0, semi_data[7:6] };
                            end else
                                display_palette = 3'b000;
                        end
                        GRAPHIC7: begin
//                            if (ds_state == ACTIVE) begin
//                                bit_data = 0;
//                                bit_data[0] = graphic_data[7];
//                                graphic_data = graphic_data << 1;
//                                display_palette = { 2'b00, bit_data[0] };
//                            end else
//                                display_palette = 3'b000;
                        end
                        GRAPHIC6: begin
//                            if (ds_state == ACTIVE) begin
//                                bit_data = 0;
//                                bit_data[1] = graphic_data[7];
//                                bit_data[0] = graphic_data[6];
//                                graphic_data = graphic_data << 2;
//                                display_palette = { 1'b0, bit_data[1:0] };
//                            end else
//                                display_palette = 3'b000;
                        end
                        GRAPHIC5: begin
//                            if (ds_state == ACTIVE) begin
//                                if (vclk) begin
//                                    bit_data = 0;
//                                    bit_data[0] = graphic_data[7];
//                                    graphic_data = graphic_data << 1;
//                                end
//                                display_palette = { 2'b00, bit_data[0] };
//                            end else
//                                display_palette = 3'b000;
                        end
                        GRAPHIC4: begin
//                            if (ds_state == ACTIVE) begin
//                                bit_data = 0;
//                                bit_data[1] = graphic_data[7];
//                                bit_data[0] = graphic_data[6];
//                                graphic_data = graphic_data << 2;
//                                display_palette = { 1'b0, bit_data[1:0] };
//                            end else
//                                display_palette = 3'b000;
                        end
                        GRAPHIC3: begin
//                            if (ds_state == ACTIVE) begin
//                                if (vclk) begin
//                                    bit_data = 0;
//                                    bit_data[0] = graphic_data[7];
//                                    graphic_data = graphic_data << 1;
//                                end
//                                display_palette = { 2'b00, bit_data[0] };
//                            end else
//                                display_palette = 3'b000;
                        end
                        GRAPHIC2: begin
//                            if (ds_state == ACTIVE) begin
//                                bit_data = 0;
//                                bit_data[1] = graphic_data[7];
//                                bit_data[0] = graphic_data[6];
//                                graphic_data = graphic_data << 2;
//                                display_palette = { 1'b0, bit_data[1:0] };
//                            end else
//                                display_palette = 3'b000;
                        end
                        GRAPHIC1: begin
//                            if (ds_state == ACTIVE) begin
//                                if (vclk) begin
//                                    bit_data = 0;
//                                    bit_data[0] = graphic_data[7];
//                                    graphic_data = graphic_data << 1;
//                                end
//                                display_palette = { 2'b00, bit_data[0] };
//                            end else
//                                display_palette = 3'b000;
                        end
                        GRAPHIC0: begin
//                            if (ds_state == ACTIVE) begin
//                                if (vclk) begin
//                                    bit_data = 0;
//                                    bit_data[1] = graphic_data[7];
//                                    bit_data[0] = graphic_data[6];
//                                    graphic_data = graphic_data << 2;
//                                end
//                                display_palette = { 1'b0, bit_data[1:0] };
//                            end else
//                                display_palette = 3'b000;
                        end
                    endcase
                end else begin
                    sync_high = (hcounter >= hzeropulse);
                end
            end
        endcase
    end

    assign fsb = !vs;
    assign hsb = !hs;
    
endmodule
