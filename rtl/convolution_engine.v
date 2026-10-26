`timescale 1ns/1ps

module convolution_engine #(
    parameter DATA_W = 16,
    parameter ACC_W  = 32
)(
    input  wire clk,
    input  wire rst,
    input  wire start,

    input  wire signed [DATA_W-1:0] pixel_in,
    input  wire signed [DATA_W-1:0] weight_in,

    output reg [3:0] pixel_addr,
    output reg [3:0] weight_addr,

    output reg signed [ACC_W-1:0] result,
    output reg busy,
    output reg done
);

    reg [3:0] index;
    reg signed [ACC_W-1:0] accumulator;

    wire signed [ACC_W-1:0] accumulator_next;

    mac_unit #(
        .DATA_W(DATA_W),
        .ACC_W(ACC_W)
    ) mac (
        .a(pixel_in),
        .b(weight_in),
        .acc_in(accumulator),
        .acc_out(accumulator_next)
    );

    // Addresses for the top-left 3x3 window
    // of a row-major 4x4 input feature map.
    always @* begin
        case (index)
            0: pixel_addr = 0;
            1: pixel_addr = 1;
            2: pixel_addr = 2;
            3: pixel_addr = 4;
            4: pixel_addr = 5;
            5: pixel_addr = 6;
            6: pixel_addr = 8;
            7: pixel_addr = 9;
            8: pixel_addr = 10;
            default: pixel_addr = 0;
        endcase

        weight_addr = index;
    end

    always @(posedge clk) begin
        if (rst) begin
            index       <= 0;
            accumulator <= 0;
            result      <= 0;
            busy        <= 0;
            done        <= 0;
        end else begin
            done <= 0;

            if (start && !busy) begin
                index       <= 0;
                accumulator <= 0;
                busy        <= 1;
            end else if (busy) begin
                accumulator <= accumulator_next;

                if (index == 8) begin
                    result <= accumulator_next;
                    busy   <= 0;
                    done   <= 1;
                    index  <= 0;
                end else begin
                    index <= index + 1'b1;
                end
            end
        end
    end

endmodule
