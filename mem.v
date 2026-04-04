module mem #(parameter ADDR_SIZE = 8, parameter MEM_DEPTH = 256) (
    input clk, rst_n,
    input [ADDR_SIZE+1:0] din,
    input rx_valid,
    output reg [ADDR_SIZE-1:0] dout,
    output reg tx_valid
);

    // din first 2 bits indicate the op.
    // the remaining din bits is equal to the address and as the word size.
    // so if ADDR_SIZE = 8, din size should be 10, i.e., 9 downto 0.
    // and the word size would be 7 downto 0 too, i.e, [ADDR_SIZE-1:0]

    reg [ADDR_SIZE-1:0] mem_array [0:MEM_DEPTH-1];
    reg [ADDR_SIZE-1:0] write_addr;
    reg [ADDR_SIZE-1:0] read_addr;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            read_addr <= 0;
            write_addr <= 0;
            dout <= 0;
            tx_valid <= 0;
        end else begin
            if (rx_valid) begin
                case (din[ADDR_SIZE+1:ADDR_SIZE]) 
                    2'b00: begin
                        write_addr <= din[ADDR_SIZE-1:0];
                        tx_valid <= 0;
                    end
                    2'b01: begin
                        mem_array[write_addr] <= din[ADDR_SIZE-1:0];
                        tx_valid <= 0;
                    end
                    2'b10: begin
                        read_addr <= din[ADDR_SIZE-1:0];
                        tx_valid <= 0;
                    end
                    2'b11: begin
                        dout <= mem_array[read_addr];
                        tx_valid <= 1;
                    end
                    default: begin
                        dout <= 0;
                        tx_valid <= 0;
                    end
                endcase
            end else begin
                dout <= 0;
                tx_valid <= 0;
            end
        end
    end

endmodule