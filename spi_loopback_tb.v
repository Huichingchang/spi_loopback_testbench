module spi_loopback_tb;

    reg clk = 0;
    reg rst_n = 0;
    reg start = 0;
    reg [7:0] master_data_in = 8'b11001100;
    wire [7:0] master_data_out;
    wire master_done;
    reg [7:0] slave_data_in = 8'b10101101;
    wire [7:0] slave_data_out;
    wire slave_done;
    wire mosi, miso, sclk;

    spi_master master (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_in(master_data_in),
        .data_out(master_data_out),
        .done(master_done),
        .mosi(mosi),
        .miso(miso),
        .sclk(sclk)
    );

    spi_slave slave (
        .clk(clk),
        .rst_n(rst_n),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .data_in(slave_data_in),
        .data_out(slave_data_out),
        .done(slave_done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("spi_loopback.vcd");
        $dumpvars(0, spi_loopback_tb);
        
        #10 rst_n = 1;
        #20 start = 1;
        #10 start = 0;

        wait (master_done && slave_done);
        #50 $finish;
    end
endmodule
