module carFSM_tb;
    logic clk;
    logic reset;
    logic left, right;
    logic la, lb, lc, ra, rb, rc;
    carFSM dut (
        .clk(clk),
        .reset(reset),
        .left(left),
        .right(right),
        .la(la),
        .lb(lb),
        .lc(lc),
        .ra(ra),
        .rb(rb),
        .rc(rc)
    );
    // Clock generation
    always #5 clk = ~clk;
    // Test vectors
    logic [7:0] test_vectors [0:12]; // Adjust size if necessary
    integer i;
    initial begin
        $readmemb("testVectors.txt", test_vectors);
        clk = 0;
        reset = 0;
        #10 reset = 1;
        for (i = 0; i < 13; i = i + 1) begin
            {left, right} = test_vectors[i][7:6];  // Extract inputs
            #10; // Wait for one clock cycle
            if ({la, lb, lc, ra, rb, rc} !== test_vectors[i][5:0]) begin
                $display("Test failed at vector %0d", i);
                $display("Inputs: left=%b, right=%b, Expected: %b, Got: %b",
                         left, right, test_vectors[i][5:0], {la, lb, lc, ra, rb, rc});
            end else begin
                $display("Test passed at vector %0d", i);
                $display("Inputs: left=%b, right=%b, Expected: %b, Got: %b",
                         left, right, test_vectors[i][5:0], {la, lb, lc, ra, rb, rc});
            end
        end
        $stop;
    end
endmodule

