`timescale 1ns / 1ns

module traffic_light_tb;
    // Testbench signals
    reg clk;
    reg reset_n;
    reg Ta;
    reg Tb;
    wire [7:0] led_7_segment_1;
    wire [7:0] led_7_segment_2;
    wire led_7_segment_1_ena;
    wire led_7_segment_2_ena;
    wire [2:0] La;
    wire [2:0] Lb;

    // Instantiate the module under test
    traffic_light uut (
        .clk(clk),
        .reset_n(reset_n),
        .Ta(Ta),
        .Tb(Tb),
        .led_7_segment_1(led_7_segment_1),
        .led_7_segment_2(led_7_segment_2),
        .led_7_segment_1_ena(led_7_segment_1_ena),
        .led_7_segment_2_ena(led_7_segment_2_ena),
        .La(La),
        .Lb(Lb)
    );

    // Generate clock signal (50 MHz)
    always #10 clk = ~clk;

    // Testbench process
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        Ta = 1;
        Tb = 1;

        // Reset the system
        #50;
        reset_n = 1;

        // Test S0 (La green, Lb red)
        #100;
        $display("State S0: La=%b, Lb=%b, led1=%h, led2=%h", La, Lb, led_7_segment_1, led_7_segment_2);

        // Force Ta low to transition to S1 (La yellow, Lb red)
        Ta = 0;
        #200;
        Ta = 1; // Restore Ta
        #100;
        $display("State S1: La=%b, Lb=%b, led1=%h, led2=%h", La, Lb, led_7_segment_1, led_7_segment_2);

        // Allow timer to transition to S2 (La red, Lb green)
        #200;
        $display("State S2: La=%b, Lb=%b, led1=%h, led2=%h", La, Lb, led_7_segment_1, led_7_segment_2);

        // Force Tb low to transition to S3 (La red, Lb yellow)
        Tb = 0;
        #200;
        Tb = 1; // Restore Tb
        #100;
        $display("State S3: La=%b, Lb=%b, led1=%h, led2=%h", La, Lb, led_7_segment_1, led_7_segment_2);

        // Allow timer to transition back to S0
        #200;
        $display("State S0: La=%b, Lb=%b, led1=%h, led2=%h", La, Lb, led_7_segment_1, led_7_segment_2);

        // Finish simulation
        #100;
        $stop;
    end
endmodule

