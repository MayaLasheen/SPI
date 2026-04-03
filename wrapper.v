module wrapper #(parameter ADDR_SIZE = 8, parameter MEM_DEPTH = 256) (
    input clk, rst_n, SS_n,
    input MOSI, 
    output MISO
);

    wire [7:0] tx_data;
    wire tx_valid;
    wire [9:0] rx_data;
    wire rx_valid;

    spi_slave_interface spi (.clk(clk), .rst_n(rst_n), .SS_n(SS_n), .MOSI(MOSI), .tx_data(tx_data), .MISO(MISO), .rx_data(rx_data), .rx_valid(rx_valid));
    
    mem #(.ADDR_SIZE(ADDR_SIZE), .MEM_DEPTH(MEM_DEPTH)) RAM (.clk(clk), .rst_n(rst_n), .din(rx_data), .rx_valid(rx_valid), .dout(tx_data), .tx_valid(tx_valid));


endmodule