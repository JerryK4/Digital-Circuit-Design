module carFSM(
    input logic clk,
    input logic reset,
    input logic left, right,
    output logic la, lb, lc, ra, rb, rc
);
    // State encoding
    localparam INIT = 3'b000;
    localparam L1   = 3'b001;
    localparam L2   = 3'b010;
    localparam L3   = 3'b011;
    localparam R1   = 3'b100;
    localparam R2   = 3'b101;
    localparam R3   = 3'b110; 

    reg [2:0] current_state, next_state;

    // State register block (State Blocking)
    always_ff @(posedge clk or negedge reset) begin
        if (~reset) // Active low reset
            current_state <= INIT;
        else
            current_state <= next_state;
    end

    // State transition logic
    always_comb begin
        next_state = current_state; // Default to stay in current state
        case (current_state)
            INIT: begin
                if (left)
                    next_state = L1;
                else if (right)
                    next_state = R1;
            end
            L1: next_state = L2;
            L2: next_state = L3;
            L3: next_state = INIT;
            R1: next_state = R2;
            R2: next_state = R3;
            R3: next_state = INIT;
        endcase
    end
    // Output logic
    always_comb begin
        // Default outputs
        {la, lb, lc, ra, rb, rc} = 6'b000000;

        case (current_state)
            L1: {la, lb, lc, ra, rb, rc} = 6'b100000;
            L2: {la, lb, lc, ra, rb, rc} = 6'b110000;
            L3: {la, lb, lc, ra, rb, rc} = 6'b111000;
            R1: {la, lb, lc, ra, rb, rc} = 6'b000100;
            R2: {la, lb, lc, ra, rb, rc} = 6'b000110;
            R3: {la, lb, lc, ra, rb, rc} = 6'b000111;
        endcase
    end
endmodule

