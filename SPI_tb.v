module spi_tb ();

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

reg clk, rst_n, MOSI, SS_n;
wire MISO;

wrapper #(.MEM_DEPTH(MEM_DEPTH), .ADDR_SIZE(ADDR_SIZE)) dut (.clk(clk), .rst_n(rst_n), .MOSI(MOSI), .SS_n(SS_n), .MISO(MISO));

initial begin
  clk = 0;
  forever 
    #1 clk = ~clk;
end

//RAM Write Command - Write Address
initial begin
    rst_n = 0;
    SS_n = 1;
    MOSI = 0;
    @(negedge clk);
    rst_n = 1;
  
    SS_n = 0; // cs = IDLE, ns = CHK_CMD
    @(negedge clk);
    MOSI = 0; // cs = CHK_CMD, ns = WRITE, rx_counter <= 1, rx_data <= 00_0000_0000 = 000
    @(negedge clk);
    MOSI = 0; // cs = WRITE, rx_counter <= 2, rx_data <= 00_0000_0000 = 000
    @(negedge clk);
    MOSI = 1; // cs = WRITE, rx_counter <= 3, rx_data <= 00_0000_0001 = 001
    @(negedge clk);
    MOSI = 1; // cs = WRITE, rx_counter <= 4, rx_data <= 00_0000_0011 = 003
    @(negedge clk);
    MOSI = 1; // cs = WRITE, rx_counter <= 5, rx_data <= 00_0000_0111 = 007
    @(negedge clk);
    MOSI = 1; // cs = WRITE, rx_counter <= 6, rx_data <= 00_0000_1111 = 00f
    @(negedge clk);
    MOSI = 1; // cs = WRITE, rx_counter <= 7, rx_data <= 00_0001_1111 = 01f
    @(negedge clk);
    MOSI = 1; // cs = WRITE, rx_counter <= 8, rx_data <= 00_0011_1111 = 03f
    @(negedge clk);
    MOSI = 0; // cs = WRITE, rx_counter <= 9, rx_data <= 00_0111_1110 = 07e
    @(negedge clk);
    MOSI = 1; // cs = WRITE, rx_counter <= 10, rx_data <= 00_1111_1101 = 0fd 
    @(negedge clk);

    SS_n = 1;
    @(negedge clk); // Wait 1 cycle for write_addr to get updated
    
  //RAM Write Command - Write Data
    SS_n = 0; // ns = CHK_CMD
    @(negedge clk);
    MOSI = 0; // rx_data <= 00_0000_0000 = 000
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_0000_0001 = 001
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_0000_0011 = 003
    @(negedge clk);
    MOSI = 0; // rx_data <= 00_0000_0110 = 006
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_0000_1101 = 00d
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_0001_1011 = 01b
    @(negedge clk);
    MOSI = 0; // rx_data <= 00_0011_0110 = 036
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_0110_1101 = 06d
    @(negedge clk);
    MOSI = 0; // rx_data <= 00_1101_1010 = 0da
    @(negedge clk);
    MOSI = 1; // rx_data <= 01_1011_0101 = 0b5
    @(negedge clk);

    SS_n = 1;
    @(negedge clk); // Wait 1 cycle for memory to get updated
    
  //RAM Write Command - Read Address
    SS_n = 0; // ns = CHK_CMD
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_0000_0001 = 001
    @(negedge clk);
    MOSI = 0; // rx_data <= 00_0000_0010 = 002
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_0000_0101 = 005
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_0000_1011 = 00b
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_0001_0111 = 017
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_00010_1111 = 02f
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_0101_1111 = 05f
    @(negedge clk);
    MOSI = 1; // rx_data <= 00_1011_1111 = 0bf
    @(negedge clk);
    MOSI = 0; // rx_data <= 01_0111_1110 = 17e
    @(negedge clk);
    MOSI = 1; // rx_data <= 10_1111_1101= 2fd
    @(negedge clk);

    SS_n = 1;
    @(negedge clk); // Wait 1 cycle for read_addr to get updated

    //RAM Write Command - Read Data
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = $random;
    @(negedge clk);
    MOSI = $random;
    @(negedge clk);
    MOSI = $random;
    @(negedge clk);
    MOSI = $random;
    @(negedge clk);
    MOSI = $random;
    @(negedge clk);
    MOSI = $random;
    @(negedge clk);
    MOSI = $random;
    @(negedge clk);
    MOSI = $random;
    @(negedge clk);
    

        
    #20 $stop;
end

initial 
    $monitor ("MOSI= %d , SS_n=%d, MISO=%d, clk=%d, rst_n=%d",MOSI, SS_n, MISO, clk, rst_n);

 endmodule