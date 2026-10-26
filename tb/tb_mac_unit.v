`timescale 1ns/1ps

module tb_mac_unit;

    reg signed [15:0] a, b;
    reg signed [31:0] acc;
    wire signed [31:0] y;

    mac_unit dut (
        .a(a),
        .b(b),
        .acc_in(acc),
        .acc_out(y)
    );

    initial begin
        a = 3;
        b = 4;
        acc = 5;
        #1;

        if (y !== 17)
            $fatal(1, "MAC test 1 failed: %0d", y);

        a = -2;
        b = 7;
        acc = 1;
        #1;

        if (y !== -13)
            $fatal(1, "MAC test 2 failed: %0d", y);

        $display("PASS: MAC unit");
        $finish;
    end

endmodule
