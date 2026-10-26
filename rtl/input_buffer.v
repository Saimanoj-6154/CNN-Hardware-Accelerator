module input_buffer #(
    parameter DATA_W = 16,
    parameter DEPTH  = 16,
    parameter ADDR_W = 4
)(
    input  wire clk,
    input  wire we,
    input  wire [ADDR_W-1:0] addr,
    input  wire signed [DATA_W-1:0] din,
    output reg signed [DATA_W-1:0] dout
);

    reg signed [DATA_W-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;

        dout <= mem[addr];
    end

endmodule
