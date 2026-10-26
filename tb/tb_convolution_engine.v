`timescale 1ns/1ps

module tb_convolution_engine;

    reg clk = 0;
    reg rst = 1;
    reg start = 0;

    wire [3:0] pixel_addr;
    wire [3:0] weight_addr;

    reg signed [15:0] pixels [0:15];
    reg signed [15:0] weights [0:8];

    wire signed [31:0] result;
    wire busy, done;

    // Combinational read model for unit testing
    wire signed [15:0] pixel_in = pixels[pixel_addr];
    wire signed [15:0] weight_in = weights[weight_addr];

    always #5 clk = ~clk;

    convolution_engine dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .pixel_in(pixel_in),
        .weight_in(weight_in),
        .pixel_addr(pixel_addr),
        .weight_addr(weight_addr),
        .result(result),
        .busy(busy),
        .done(done)
    );

    integer i;

    initial begin
        for (i = 0; i < 16; i = i + 1)
            pixels[i] = 1;

        for (i = 0; i < 9; i = i + 1)
            weights[i] = 1;

        repeat (2) @(negedge clk);
        rst = 0;

        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);
        #1;

        if (result !== 32'sd9)
            $fatal(1, "Convolution failed: got %0d expected 9",
                   result);

        $display("PASS: convolution engine, result=%0d", result);
        $finish;
    end

    initial begin
        #1000;
        $fatal(1, "Timeout waiting for convolution");
    end

endmodule
