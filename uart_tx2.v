module uart_tx2
    #(parameter CLKS_PER_BIT = 868)
    (
        input clk,
        input rst,
        input tx_dv,
        input [7:0] tx_byte,
        output reg tx,
        output reg tx_done
    );
    localparam IDLE = 0, TX_START = 1, TX_DATA = 2, TX_STOP = 3;
    reg [1:0] state = IDLE;
    reg [15:0] clk_count = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] tx_data = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1;
            tx_done <= 0;
            clk_count <= 0;
            bit_index <= 0;
            tx_data <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    tx <= 1;
                    tx_done <= 0;
                    if (tx_dv) begin
                        state <= TX_START;
                        tx_data <= tx_byte;
                        clk_count <= 0;
                        $display("Debug: TX start, byte=%h, clk=%t", tx_byte, $time);
                    end
                end
                TX_START: begin
                    tx <= 0;
                    if (clk_count < CLKS_PER_BIT - 1) clk_count <= clk_count + 1;
                    else begin
                        state <= TX_DATA;
                        clk_count <= 0;
                    end
                end
                TX_DATA: begin
                    if (clk_count < CLKS_PER_BIT - 1) clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        tx <= tx_data[bit_index];
                        if (bit_index < 7) bit_index <= bit_index + 1;
                        else state <= TX_STOP;
                    end
                end
                TX_STOP: begin
                    tx <= 1;
                    if (clk_count < CLKS_PER_BIT - 1) clk_count <= clk_count + 1;
                    else begin
                        state <= IDLE;
                        tx_done <= 1;
                        $display("Debug: TX done, clk=%t", $time);
                        clk_count <= 0;
                    end
                end
            endcase
        end
    end
endmodule