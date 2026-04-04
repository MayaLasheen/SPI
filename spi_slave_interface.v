module spi_slave_interface (
    input clk, rst_n, SS_n,
    input MOSI,
    input [7:0] tx_data, 
    input tx_valid,

    output reg MISO,
    output reg [9:0] rx_data, 
    output reg rx_valid
);

    // States
    parameter IDLE      = 3'd0;
    parameter CHK_CMD   = 3'd1;
    parameter READ_ADD  = 3'd2;
    parameter READ_DATA = 3'd3;
    parameter WRITE     = 3'd4;

    reg [2:0] cs, ns;

    reg flag;  // distinguishes READ_ADD / READ_DATA
    reg [3:0] rx_counter; // counts bits for serial to parallel conversion and vice versa
    reg [2:0] tx_counter; // counts bits for serial to parallel conversion and vice versa
    reg [7:0] tx_shift; // temporary register for MISO

    // Next State Logic
    always @(*) begin
        case (cs)
            IDLE:
                if (~SS_n)
                    ns = CHK_CMD;
                else
                    ns = cs;

            CHK_CMD:
                if (~SS_n) begin
                    if (MOSI) begin
                        if (flag)
                            ns = READ_DATA;
                        else
                            ns = READ_ADD;
                    end else
                        ns = WRITE;
                end else 
                    ns = IDLE;

            READ_ADD, READ_DATA, WRITE:
                if (SS_n)
                    ns = IDLE;
                else
                    ns = cs;
        endcase   

    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            flag <= 0;
        else if (cs == CHK_CMD && ~SS_n && MOSI)
            flag <= ~flag; 
        else
            flag <= 0;
    end

    // State Memory
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end


    // Output Logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            rx_data <= 0;
            rx_valid <= 0;
            rx_counter <= 0;
            tx_counter <= 0;
            MISO <= 0;
            tx_shift <= 0;
        end else begin
            rx_valid <= 0;
            MISO <= 0; 

            if (SS_n) begin
                rx_counter <= 0;
                tx_counter <= 0;
            end else begin
                case (cs) 
                    WRITE, READ_ADD: begin
                        rx_data <= {rx_data[8:0], MOSI};
                        if (rx_counter == 8) begin
                                rx_valid <= 1;
                        end else if (rx_counter == 9) begin
                                rx_counter <= 0;
                        end else
                                rx_counter <= rx_counter + 1;
                    end
                    READ_DATA: begin
                        if (tx_valid) begin
                            if (tx_counter == 0) begin
                                tx_shift <= tx_data;
                                MISO <= tx_data[7];
                            end else begin
                                tx_shift <= {tx_shift[6:0], 1'b0};
                                MISO <= tx_shift[7];
                            end

                            if (tx_counter == 7) begin
                                tx_counter <= 0;
                            end else begin
                                tx_counter <= tx_counter + 1;
                            end

                        end else begin 
                            MISO <= 0;
                            tx_counter <= 0;
                        end
                    end
                    default: begin
                        rx_counter <= 0;
                        tx_counter <= 0;
                    end

                endcase
            end
        end
    end
                



endmodule