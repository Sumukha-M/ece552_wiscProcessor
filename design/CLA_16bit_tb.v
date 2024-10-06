module tb_CLA_16bit;
    reg [15:0] a, b;
    reg cin;
    wire [15:0] sum;
    wire cout;
    reg [16:0] expected_sum;

    // Instantiate the 16-bit CLA
    CLA_16bit uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        // Test case 1
        a = 16'h1234; b = 16'h5678; cin = 0;
        expected_sum = a + b + cin;
        #10;
        check_result();

        // Test case 2
        a = 16'hFFFF; b = 16'h0001; cin = 0;
        expected_sum = a + b + cin;
        #10;
        check_result();

        // Test case 3
        a = 16'hAAAA; b = 16'h5555; cin = 1;
        expected_sum = a + b + cin;
        #10;
        check_result();

        // Test case 4
        a = 16'h0000; b = 16'h0000; cin = 0;
        expected_sum = a + b + cin;
        #10;
        check_result();

        // Test case 5
        a = 16'h8000; b = 16'h8000; cin = 1;
        expected_sum = a + b + cin;
        #10;
        check_result();

        $stop;
    end

    task check_result;
        begin
            if ({cout, sum} !== expected_sum) begin
                $display("Test failed: a=%h, b=%h, cin=%b, expected_sum=%h, got_sum=%h, got_cout=%b", a, b, cin, expected_sum, sum, cout);
            end else begin
                $display("Test passed: a=%h, b=%h, cin=%b, sum=%h, cout=%b", a, b, cin, sum, cout);
            end
        end
    endtask
endmodule
