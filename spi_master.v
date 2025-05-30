module spi_master (
    input clk,
    input rst_n,
    input start,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg done,
    output mosi,
    input miso,
    output reg sclk
);
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    reg [1:0] state;

    localparam IDLE = 2'b00,
               TRANS = 2'b01,
               DONE  = 2'b10;

    assign mosi = shift_reg[7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            sclk <= 0;
            done <= 0;
            bit_cnt <= 0;
            shift_reg <= 8'd0;
            data_out <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    sclk <= 0;
                    if (start) begin
                        shift_reg <= data_in;
                        bit_cnt <= 3'd0;
                        state <= TRANS;
                    end
                end
                TRANS: begin
                    sclk <= ~sclk;
                    if (sclk) begin  // rising edge: sample miso
                        shift_reg <= {shift_reg[6:0], miso};
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 3'd7) begin
                            state <= DONE;
                        end
                    end
                end
                DONE: begin
                    data_out <= shift_reg;
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
