`timescale 1ns / 1ps

module set_associative (
    input clk, reset,
    input [15:0] physical_addr, 
    output logic [31:0] data_o, // Data read from cache
    output logic hit_o
);
    parameter width = 135; // 135 bits <valid bit[1-bit]> <tag bit[6-bits]> <data bits[128-bits]>
    parameter depth = 64;  // 64 sets
    parameter ways = 2;    // 2-way associative
    
    logic [width-1:0] cache [ways-1:0][depth-1:0];
    logic [width-1:0] temp0, temp1; 
    logic [3:0] offset;
    logic [5:0] index;
    logic [5:0] tag;
    
    initial begin
        $readmemb("way0.mem", cache[0]); 
        $readmemb("way0.mem", cache[1]);
    end
    
    assign offset = physical_addr[3:0]; // offset bits
    assign index = physical_addr[9:4];  // index bits
    assign tag = physical_addr[15:10];  // tag bits
    
    always_comb begin
        if (!reset) begin
            hit_o = 0;
            data_o = 0;
        end else begin
            temp0 = cache[0][index];
            temp1 = cache[1][index];
            hit_o = 0;
            data_o = 32'b0;
            
            if (temp0[134] && temp0[133:128] == tag) begin
                hit_o = 1;
                case (offset[3:2])
                    2'b00: data_o = temp0[127:96];
                    2'b01: data_o = temp0[95:64];
                    2'b10: data_o = temp0[63:32];
                    2'b11: data_o = temp0[31:0];
                    default: data_o = data_o;
                endcase
            end else if (temp1[134] && temp1[133:128] == tag) begin
                hit_o = 1;
                case (offset[3:2])
                    2'b00: data_o = temp1[127:96];
                    2'b01: data_o = temp1[95:64];
                    2'b10: data_o = temp1[63:32];
                    2'b11: data_o = temp1[31:0];
                    default: data_o = data_o;
                endcase
            end
        end
    end
endmodule
