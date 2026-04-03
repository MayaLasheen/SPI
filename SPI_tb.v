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
  SS_n = 0;
  MOSI = 0;
  @(negedge clk);
  rst_n = 1;
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
  SS_n = 1;
  @(negedge clk);
 //RAM Write Command - Write Data
  MOSI = 0;
  SS_n = 0;
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
  SS_n = 1;
  @(negedge clk);
//RAM Write Command - Read Address
  MOSI = 1;
  SS_n = 0;
  @(negedge clk);
  MOSI = 0;
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
  SS_n = 1;
  @(negedge clk);
  //RAM Write Command - Read Data
  MOSI = 1;
  SS_n = 0;
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
  SS_n = 1;
  @(negedge clk);
  $stop;
end

initial 
$monitor ("MOSI= %d , SS_n=%d, MISO=%d, clk=%d, rst_n=%d",MOSI, SS_n, MISO, clk, rst_n);

 endmodule