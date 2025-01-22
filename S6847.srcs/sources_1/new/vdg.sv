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

    `include "syncrow.sv"
    `include "display_mode.sv"
    `include "display_behaviour.sv"
    `include "display_model.sv"
    `include "sync.sv"
    
    bit [7:0] sm6_data;
    bit [7:0] sm4_data;
    bit [4:0] assert_palette;
    bit [7:0] graphic_data;
    bit [4:0] display_palette;
//    bit [7:0] register_select_a;
//    bit [7:0] register_data_a;
//    bit [7:0] register_select_b;
//    bit [7:0] register_data_b;
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
    bit [7:0] char_code;
    bit [3:0] semi4_code;
    bit [5:0] semi6_code;
    bit [3:0] semi_data;
    bit [7:0] char_lookup;
    bit [3:0] char_row;
    bit [7:0] char_data;
    bit [7:0] ext_char_data;
    bit sync_high;
    bit clk1;
    bit clk2;
    bit reset_vertical;
    bit reset_display;
    
//    bit [7:0] alphared;
//    bit [7:0] alphagreen;
//    bit [7:0] alphablue;
    
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
        .index          (semi4_code),
        .row            (char_row),
        .char_bitmap    (sm4_data)
    );
    
    external_semigraphics semigraphics6_rom
    (
        .clock          (vclk),
        .index          (semi6_code),
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
        .double (1'b0),
        .red (red),
        .green (green),
        .blue (blue)
    );
    
    data_behaviour loaddata
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
    
    pixel_generator pixels
    (
        .vclk (vclk),
        .row (row),
        .behaviour (behaviour),
        .mode (mode),
        .display_state (ds_state),
        .counter (hcounter),
        .dataload (dataload),
        .char_data (char_data),
        .ext_char_data (ext_char_data),
        .semi4_data (sm4_data),
        .semi6_data (sm6_data),
        .data (data),
        .display_palette (display_palette),
        .bit_data ()
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
    
    display_state sync_state_machine
    (
        .nextrow (nextrow),
        .vcounter (vcounter),
        .allrows (allrows),
        .delta_state (state),
        .row (row),
        .vertical_sync (vs),
        .reset_vcounter (reset_vertical),
        .reset_displayrow (reset_display)
    );
    
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
                end else begin
                    sync_high = (hcounter >= hzeropulse);
                end
            end
            default
                ds_state = SYNC;
        endcase
    end

    assign fsb = !vs;
    assign hsb = !hs;
    
endmodule
