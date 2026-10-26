`timescale 1ns/1ps

module tb_cnn_accelerator;

    reg clk = 0;
    reg rst = 1;
    reg start = 0;

    reg input_we = 0;
    reg [3:0] input_addr = 0;
    reg signed [15:0] input_din = 0;

    reg weight_we = 0;
    reg [3:0] weight_addr_in = 0;
    reg signed [15:0] weight_din = 0;

    wire done;
    wire signed [31:0] result;

    integer i;

    always #5 clk = ~clk;

    cnn_accelerator_top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .input_we(input_we),
        .input_addr(input_addr),
        .input_din(input_din),
        .weight_we(weight_we),
        .weight_addr_in(weight_addr_in),
        .weight_din(weight_din),
        .done(done),
        .result(result)
    );

    initial begin
        repeat (2) @(negedge clk);
        rst = 0;

        // Load 4x4 input feature map with ones.
        for (i = 0; i < 16; i = i + 1) begin
            @(negedge clk);
            input_we = 1;
            input_addr = i;
            input_din = 1;
        end

        @(negedge clk);
        input_we = 0;

        // Load 3x3 kernel with ones.
        for (i = 0; i < 9; i = i + 1) begin
            @(negedge clk);
            weight_we = 1;
            weight_addr_in = i;
            weight_din = 1;
        end

        @(negedge clk);
        weight_we = 0;

        repeat (3) @(negedge clk);

        start = 1;
        @(negedge clk);
        start = 0;

        wait(done);
        #1;

        if (result !== 32'sd9)
            $fatal(1, "Top-level test failed: result=%0d", result);

        $display("PASS: CNN accelerator top");
        $finish;
    end

    initial begin
        #5000;
        $fatal(1, "Top-level simulation timeout");
    end

endmodule
