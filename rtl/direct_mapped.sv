`timescale 1ns / 1ps

module direct_mapped (
    input clk, reset,
    input [15:0] physical_addr, 
    output logic [31:0] data_o, // Data read from cache
    output logic hit_o
);
    parameter width = 133; //133 bits <valid bit[1-bits]> <tag bit[4-bits]> <data bits[128-bits]>
    parameter depth = 256; //256 depth
    logic [width-1:0] directCache [depth-1:0]; 
    logic [width-1:0] temp; 
    //    width of each word      depth/rows   columns/words per block
    logic [3:0] offset;
    logic [7:0] index;
    logic [3:0] tag;
    initial
    begin
        $readmemb("way0.mem", directCache); 
//	for(i = 0; i < 1024;i++)
//		dataFile[i] = 0;
    end
    
    assign offset = physical_addr[3:0]; //offset bits
    assign index = physical_addr[11:4]; //index bits
    assign tag = physical_addr[15:12]; //tag bits
    
    always_comb
    begin
        if(!reset)
        begin
            hit_o=0; 
            data_o=0;
        end
        else 
        begin
         temp=directCache[index];
         if(temp[132] && temp[131:128]==tag)
         begin
            hit_o<=1;
            case(offset[3:2])
                2'b00:
                    data_o=temp[127:96];
                2'b01:
                    data_o=temp[95:64];
                2'b10:
                    data_o=temp[63:32];
                2'b11:
                    data_o=temp[31:0];
                default:
                    data_o=data_o;
            
            endcase
            end
             else
                begin 
                    hit_o=0;
                    data_o=32'b0;
                end
        end
       
    
    end

endmodule
