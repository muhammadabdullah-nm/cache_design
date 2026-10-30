`timescale 1ns / 1ps

module cache_testbench;

localparam string filename = "../log/core_access.log"; // Replace with your file name  
reg clk_i, rst_n_i;


reg [15:0] physical_address[4095:0];
reg [11:0] pa_pointer;
initial begin 
    $readmemb("phys_addr_buffere.mem",physical_address);
end

// reg hit_temp;
// reg [31:0] data_temp;


int fd;
//-----------------------------------------------
//          Instantiate Your Cache Here
//-----------------------------------------------

// cache_<type>(.clk_i(clk_i),
//              .rst_n_i(rst_n_i),
//              .hit_o(hit_o)),
//              .data_o(data_o)
//              );
             
//-----------------------------------------------

logic [31:0] data_o; // Data read from cache
logic hit_o;

direct_mapped dm(
     .clk(clk_i), 
     .reset(rst_n_i),
     .physical_addr(physical_address[pa_pointer]), 
     .data_o(data_o), // Data read from cache
     .hit_o(hit_o)
);


function int write_file(string filename);
    int file;
    
    file = $fopen(filename, "w"); // Open file for writing
    if (file == 0) begin
      $display("Error: Unable to open file '%s' for writing", filename);
      return 0;
    end
    return file;
    // Write data to the file
endfunction

  // Testbench example
  initial begin
    clk_i = 0;
    rst_n_i = 0;
    pa_pointer = 0;
    #5;
    rst_n_i = 1;
    fd = write_file(filename); // Call function to write data to file
    #81920
    $finish();
  end

initial forever #10 clk_i = ~clk_i;

always @ (posedge clk_i) begin
        // data_temp <= $urandom();
        // hit_temp <= $urandom();
        // $display("PA: %d ; Accessed Data: %b\n", physical_address[pa_pointer], data_o);
        if (hit_o) begin
            $fwrite(fd, "HIT! ; PA: %d ; Accessed Data: %b\n", physical_address[pa_pointer], data_o);
        end
        else begin
            $fwrite(fd, "MISS! ; PA: %d ; Accessed Data: %b\n", physical_address[pa_pointer], data_o);
        end
        pa_pointer <= pa_pointer + 1;
        if(pa_pointer == 4096) begin
            $fclose(fd); // Close file
            $finish;
        end
    end

// assign data_o = data_temp;
// assign hit_o  = hit_temp;

endmodule 