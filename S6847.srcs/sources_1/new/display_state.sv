//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2025 11:44:05
// Design Name: 
// Module Name: display_state
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: define the scan and sync state of the display output
//              updates on display row change (nextrow)
//              outputs new machine state, trigger for counter resets
//              and vertical sync signal
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module display_state(
    input bit nextrow,
    input shortint vcounter,
    input int allrows,
    
    output bit [4:0] delta_state,
    output bit [2:0] row,
    output bit vertical_sync,
    output bit reset_vcounter,
    output bit reset_displayrow
    );
    
    typedef enum bit [4:0] {
        LL1 = 0, 
        LL2 = 1, 
        LS3 = 2, 
        SS4 = 3, 
        SS5 = 4,
        DS6 = 5,
        SS7 = 6, 
        SS8 = 7, 
        SL9 = 8, 
        LL10 = 9, 
        LL11 = 10,
        SS12 = 11, 
        SS13 = 12,
        DS14 = 13,
        SS15 = 14, 
        SS16 = 15, 
        SS17 = 16
    } sync;
    
    typedef enum bit [2:0] {
        LL, LS, SL, SS, DS
    } syncrow;
    
    sync state;
    sync new_state;
    
    always @(posedge nextrow) begin
        reset_displayrow = 0;
        reset_vcounter = 0;
        
        unique case(state)
            SS17: begin
                new_state = LL1;
                row = LL;
                vertical_sync = 1;
                reset_vcounter = 1;
            end
            LL1: begin 
                new_state = LL2;
                row = LL;
                vertical_sync = 1;
            end
            LL2: begin 
                new_state = LS3;
                row = LS;
                vertical_sync = 1;
            end
            LS3: begin
                new_state = SS4;
                row = SS;
                vertical_sync = 1;
            end
            SS4: begin
                new_state = SS5;
                row = SS;
                vertical_sync = 1;
            end
            SS5: begin
                new_state = DS6;
                row = DS;
                vertical_sync = 0;
                reset_displayrow = 1;
            end
            DS6:
                if (vcounter > allrows) begin
                    new_state = SS7;
                    row = SS;
                    vertical_sync = 1;
                end
            SS7: begin
                new_state = SS8;
                row = SS;
                vertical_sync = 1;
            end
            SS8: begin
                new_state = SL9;
                row = SL;
                vertical_sync = 1;
            end
            SL9: begin
                new_state = LL10;
                row = LL;
                vertical_sync = 1;
                reset_vcounter = 1;
            end
            LL10: begin
                new_state = LL11;
                row = LL;
                vertical_sync = 1;
            end
            LL11: begin
                new_state = SS12;
                row = SS;
                vertical_sync = 1;
            end
            SS12: begin
                new_state = SS13;
                row = SS;
                vertical_sync = 1;
            end
            SS13: begin
                new_state = DS14;
                row = DS;
                vertical_sync = 0;
                reset_displayrow = 1;
            end
            DS14: 
                if (vcounter > allrows) begin
                    new_state = SS15;
                    row = SS;
                    vertical_sync = 1;
                end 
            SS15: begin
                new_state = SS16;
                row = SS;
                vertical_sync = 1;
            end
            SS16: begin
                new_state = SS17;
                row = SS;
                vertical_sync = 1;
            end
            default begin
                new_state = LL1;
                row = LL;
                vertical_sync = 1;
            end
        endcase
        state = new_state;
        delta_state = state;
    end
endmodule
