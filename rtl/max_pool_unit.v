module max_pool_unit #(
    parameter DATA_W = 32
)(
    input  wire signed [DATA_W-1:0] a,
    input  wire signed [DATA_W-1:0] b,
    input  wire signed [DATA_W-1:0] c,
    input  wire signed [DATA_W-1:0] d,
    output reg signed [DATA_W-1:0] y
);

    reg signed [DATA_W-1:0] max_ab;
    reg signed [DATA_W-1:0] max_cd;

    always @* begin
        max_ab = (a > b) ? a : b;
        max_cd = (c > d) ? c : d;
        y = (max_ab > max_cd) ? max_ab : max_cd;
    end

endmodule
