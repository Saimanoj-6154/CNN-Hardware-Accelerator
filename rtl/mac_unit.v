`timescale 1ns/1ps

module mac_unit #(
    parameter DATA_W = 16,
    parameter ACC_W  = 32
)(
    input  wire signed [DATA_W-1:0] a,
    input  wire signed [DATA_W-1:0] b,
    input  wire signed [ACC_W-1:0]  acc_in,
    output wire signed [ACC_W-1:0]  acc_out
);

    wire signed [(2*DATA_W)-1:0] product;

    assign product = a * b;
    assign acc_out = acc_in + product;

endmodule
