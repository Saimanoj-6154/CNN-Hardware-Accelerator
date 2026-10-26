module relu_unit #(
    parameter DATA_W = 32
)(
    input  wire signed [DATA_W-1:0] data_in,
    output wire signed [DATA_W-1:0] data_out
);

    assign data_out =
        data_in[DATA_W-1] ? {DATA_W{1'b0}} : data_in;

endmodule
