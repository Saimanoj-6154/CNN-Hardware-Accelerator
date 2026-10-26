`timescale 1ns/1ps

module cnn_accelerator_top #(
    parameter DATA_W = 16,
    parameter ACC_W  = 32
)(
    input wire clk,
    input wire rst,
    input wire start,

    input wire input_we,
    input wire [3:0] input_addr,
    input wire signed [DATA_W-1:0] input_din,

    input wire weight_we,
    input wire [3:0] weight_addr_in,
    input wire signed [DATA_W-1:0] weight_din,

    output wire done,
    output wire signed [ACC_W-1:0] result
);

    wire signed [DATA_W-1:0] pixel;
    wire signed [DATA_W-1:0] weight;

    wire [3:0] pixel_addr;
    wire [3:0] kernel_addr;

    wire conv_start;
    wire conv_done;
    wire busy;

    wire signed [ACC_W-1:0] conv_result;
    wire signed [ACC_W-1:0] relu_result;
    wire [1:0] controller_state;

    input_buffer #(
        .DATA_W(DATA_W),
        .DEPTH(16),
        .ADDR_W(4)
    ) input_mem (
        .clk(clk),
        .we(input_we),
        .addr(input_we ? input_addr : pixel_addr),
        .din(input_din),
        .dout(pixel)
    );

    weight_buffer #(
        .DATA_W(DATA_W),
        .DEPTH(9),
        .ADDR_W(4)
    ) weight_mem (
        .clk(clk),
        .we(weight_we),
        .addr(weight_we ? weight_addr_in : kernel_addr),
        .din(weight_din),
        .dout(weight)
    );

    convolution_engine #(
        .DATA_W(DATA_W),
        .ACC_W(ACC_W)
    ) conv (
        .clk(clk),
        .rst(rst),
        .start(conv_start),
        .pixel_in(pixel),
        .weight_in(weight),
        .pixel_addr(pixel_addr),
        .weight_addr(kernel_addr),
        .result(conv_result),
        .busy(busy),
        .done(conv_done)
    );

    relu_unit #(
        .DATA_W(ACC_W)
    ) relu (
        .data_in(conv_result),
        .data_out(relu_result)
    );

    cnn_controller controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        .conv_done(conv_done),
        .conv_start(conv_start),
        .done(done),
        .state(controller_state)
    );

    assign result = relu_result;

endmodule
