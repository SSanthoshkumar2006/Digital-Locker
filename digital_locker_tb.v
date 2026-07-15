module digital_locker_tb;

    reg clk;
    reg rst_;
    reg [3:0] pass_in;
    reg submit;
    wire unlocked;
    wire locked;
    wire alarm;

    digital_locker uut (
        .clk(clk),
        .rst_(rst_),
        .pass_in(pass_in),
        .submit(submit),
        .unlocked(unlocked),
        .locked(locked),
        .alarm(alarm)
    );
     always #5 clk = ~clk;
    initial begin
       
        $dumpfile("digital_locker.vcd");
        $dumpvars(0,digital_locker_tb);

        // Initialize signals
        clk = 0;
        rst_ = 0;
        pass_in = 4'b0000;
        submit = 0;

        // Reset the system
        #5 rst_ = 1; // Release reset after 5 time units

        // Test case 1: Correct password
        #10 pass_in = 4'b1010; // Correct password
            submit = 1; // Submit the password
            #10 submit = 0; // Deassert submit

        // Test case 2: Incorrect password
        #10 pass_in = 4'b1111; // Incorrect password
            submit = 1; // Submit the password
            #10 submit = 0; // Deassert submit

        // Test case 3: Another incorrect password
        #10 pass_in = 4'b0001; // Another incorrect password
            submit = 1; // Submit the password
            #10 submit = 0; // Deassert submit

        // Test case 4: Correct password after wrong attempts
        #10 pass_in = 4'b1010; // Correct password again
            submit = 1; // Submit the password
            #10 submit = 0; // Deassert submit

        // Finish simulation
        #20 $finish;
    end
endmodule

    