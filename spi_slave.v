module spi_slave (
    input clk,
    input rst_n,
    input sclk,
    input mosi,
    output reg miso,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg_in;
    reg [7:0] shift_reg_out;
    reg sclk_d;

    wire sclk_posedge = (sclk && !sclk_d);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sclk_d <= 0;
            bit_cnt <= 0;
            shift_reg_in <= 8'd0;
            shift_reg_out <= data_in;  // 初始時就載入 data_in
            done <= 0;
        end else begin
            sclk_d <= sclk;
            if (sclk_posedge) begin
                shift_reg_in <= {shift_reg_in[6:0], mosi};
                shift_reg_out <= {shift_reg_out[6:0], 1'b0};
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 3'd7) begin
                    done <= 1;
                    data_out <= {shift_reg_in[6:0], mosi};
                end
            end
        end
    end

    always @(*) begin
        miso = shift_reg_out[7];
    end
endmodule
