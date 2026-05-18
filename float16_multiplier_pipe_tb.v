`timescale 1ns / 1ps

// Pipelined-DUT testbench. 

module float16_multiplier_pipe_tb;

  localparam FLOAT_BIAS  = 15;
  localparam DOUBLE_BIAS = 1023;

  localparam int PIPE_LATENCY = 3;      // cycles from input to output
  localparam time CLK_PERIOD  = 1;      // ns

  reg               clk;
  reg               rst_n;
  reg  [15:0]       float_a;
  reg  [15:0]       float_b;
  wire [15:0]       float_product;

  float16_multiplier dut (
      .clk            (clk),
      .rst_n          (rst_n),
      .float_a_i      (float_a),
      .float_b_i      (float_b),
      .float_product_o(float_product)
  );

  initial clk = 1'b0;
  always #(CLK_PERIOD/2.0) clk = ~clk;


  function real float_to_real(input [15:0] float_i);
    reg            float_sign;
    reg     [ 4:0] float_exp;
    reg     [ 9:0] float_frac;

    reg     [63:0] double_bits;
    reg     [10:0] double_exp;
    reg     [51:0] double_frac;

    reg     [ 9:0] denorm_shifted_frac;
    integer        denorm_lz;
    integer        denorm_true_exp;
    integer        k;
    reg            denorm_found;
    begin
      float_sign = float_i[15];
      float_exp  = float_i[14:10];
      float_frac = float_i[9:0];

      if (float_exp == 5'd0 && float_frac == 10'd0) begin
        double_bits = {float_sign, 63'd0};
      end else if (float_exp == 5'd31) begin
        double_exp  = 11'd2047;
        double_frac = {float_frac, 42'd0};
        double_bits = {float_sign, double_exp, double_frac};
      end else if (float_exp == 5'd0) begin
        denorm_lz    = 0;
        denorm_found = 1'b0;
        for (k = 9; k >= 0; k = k - 1) begin
          if (!denorm_found && float_frac[k]) denorm_found = 1'b1;
          else if (!denorm_found) denorm_lz = denorm_lz + 1;
        end

        denorm_true_exp     = (9 - denorm_lz) - 24;
        denorm_shifted_frac = float_frac << (denorm_lz + 1);
        double_exp          = denorm_true_exp + DOUBLE_BIAS;
        double_frac         = {denorm_shifted_frac, 42'd0};
        double_bits         = {float_sign, double_exp, double_frac};
      end else begin
        double_exp  = float_exp - FLOAT_BIAS + DOUBLE_BIAS;
        double_frac = {float_frac, 42'd0};
        double_bits = {float_sign, double_exp, double_frac};
      end

      float_to_real = $bitstoreal(double_bits);
    end
  endfunction

  function [15:0] real_to_float;
    input real double_i;
    reg     [63:0] double_bits;
    reg            double_sign;
    reg     [10:0] double_exp;
    reg     [51:0] double_frac;

    reg     [52:0] full_frac;
    reg     [52:0] shifted_frac;
    integer        shift_dist;

    integer        float_new_exp;
    reg     [ 4:0] float_exp;
    reg     [ 9:0] float_frac;

    reg     [10:0] rounding_frac;
    reg            sticky;
    reg            round_up;
    reg     [10:0] frac_carry_adder;
    begin
      double_bits = $realtobits(double_i);
      double_sign = double_bits[63];
      double_exp  = double_bits[62:52];
      double_frac = double_bits[51:0];

      if (double_exp == 11'd0 && double_frac == 52'd0) begin
        real_to_float = {double_sign, 15'd0};
      end else if (double_exp == 11'd2047) begin
        if (double_frac == 52'd0) real_to_float = {double_sign, 5'b11111, 10'd0};
        else                      real_to_float = {double_sign, 5'b11111, 10'h3FF};
      end else begin
        float_new_exp = double_exp - DOUBLE_BIAS + FLOAT_BIAS;
        full_frac     = (double_exp == 11'd0) ? {1'b0, double_frac} : {1'b1, double_frac};

        if (float_new_exp >= 31) begin
          real_to_float = {double_sign, 5'b11111, 10'd0};
        end else if (float_new_exp <= 0) begin
          float_exp  = 5'd0;
          shift_dist = 1 - float_new_exp;

          if (shift_dist > 53) begin
            rounding_frac = 11'd0;
            sticky        = 1'b1;
          end else begin
            shifted_frac  = full_frac >> shift_dist;
            rounding_frac = shifted_frac[51:41];
            sticky        = (|shifted_frac[40:0]) | (|(full_frac << (53 - shift_dist)));
          end

          round_up         = rounding_frac[0] & (rounding_frac[1] | sticky);
          frac_carry_adder = {1'b0, rounding_frac[10:1]} + round_up;
          float_frac       = frac_carry_adder[9:0];

          if (frac_carry_adder[10]) float_exp = 5'd1;

          real_to_float = {double_sign, float_exp, float_frac};

        end else begin
          float_exp        = float_new_exp[4:0];
          rounding_frac    = double_frac[51:41];
          sticky           = |double_frac[40:0];

          round_up         = rounding_frac[0] & (rounding_frac[1] | sticky);
          frac_carry_adder = {1'b0, rounding_frac[10:1]} + round_up;
          float_frac       = frac_carry_adder[9:0];

          if (frac_carry_adder[10]) begin
            float_exp = float_exp + 5'd1;
            if (float_exp == 5'b11111) real_to_float = {double_sign, 5'b11111, 10'd0};
            else                       real_to_float = {double_sign, float_exp, 10'd0};
          end else begin
            real_to_float = {double_sign, float_exp, float_frac};
          end
        end
      end
    end
  endfunction

  function automatic logic is_nan(input real val);
    return (val != val);
  endfunction

  // Drive writes the expected result into expected_pending 
  reg [15:0] expected_pending;
  reg        valid_pending;
  reg [15:0] expected_pipe   [0:PIPE_LATENCY-1];
  reg        valid_pipe      [0:PIPE_LATENCY-1];

  integer pass_count;
  integer fail_count;
  integer drive_count;

  task drive;
    input reg [15:0] float16_a;
    input reg [15:0] float16_b;
    real        double_a;
    real        double_b;
    real        double_expected_unrounded;
    begin
      @(posedge clk);
      #0.1;
      float_a          <= float16_a;
      float_b          <= float16_b;

      double_a                  = float_to_real(float16_a);
      double_b                  = float_to_real(float16_b);
      double_expected_unrounded = double_a * double_b;
      expected_pending          <= real_to_float(double_expected_unrounded);
      valid_pending             <= 1'b1;
      drive_count               <= drive_count + 1;
    end
  endtask

  integer i;

  // Shift the expected-result pipeline every cycle to stay aligned
  always @(posedge clk) begin
    if (!rst_n) begin
      expected_pending <= 16'd0;
      valid_pending    <= 1'b0;
      for (i = 0; i < PIPE_LATENCY; i = i + 1) begin
        expected_pipe[i] <= 16'd0;
        valid_pipe[i]    <= 1'b0;
      end
    end else begin
      expected_pipe[0] <= expected_pending;
      valid_pipe[0]    <= valid_pending;
      for (i = 1; i < PIPE_LATENCY; i = i + 1) begin
        expected_pipe[i] <= expected_pipe[i-1];
        valid_pipe[i]    <= valid_pipe[i-1];
      end
    end
  end

  // Check output on each cycle that has a valid expected result in the end
  always @(posedge clk) begin
    if (rst_n && valid_pipe[PIPE_LATENCY-1]) begin
      reg  [15:0] float16_expected;
      reg  [15:0] float16_actual;
      real        double_expected;
      real        double_actual;
      float16_expected = expected_pipe[PIPE_LATENCY-1];
      float16_actual   = float_product;
      double_expected  = float_to_real(float16_expected);
      double_actual    = float_to_real(float16_actual);

      if ((is_nan(double_actual) && is_nan(double_expected)) || double_actual == double_expected) begin
        pass_count = pass_count + 1;
      end else begin
        $display("Mismatch: expected %f (%h), actual %f (%h)",
                 double_expected, float16_expected, double_actual, float16_actual);
        fail_count = fail_count + 1;
      end
    end
  end

  reg [15:0] rand_a;
  reg [15:0] rand_b;
  integer    j;

  initial begin
    clk         = 1'b0;
    rst_n       = 1'b0;
    float_a     = 16'd0;
    float_b     = 16'd0;
    pass_count  = 0;
    fail_count  = 0;
    drive_count = 0;

    // reset
    repeat (4) @(posedge clk);
    rst_n <= 1'b1;
    @(posedge clk);

    $display("Starting float16_multiplier pipelined testbench (PIPE_LATENCY=%0d)", PIPE_LATENCY);

    // directed tests
    drive(16'h3C00, 16'h3C00);  // 1.0   * 1.0
    drive(16'h3E00, 16'h3E00);  // 1.5   * 1.5
    drive(16'h4000, 16'h3800);  // 2.0   * 0.5
    drive(16'hC200, 16'h4000);  // -3.0  * 2.0
    drive(16'h3400, 16'h4400);  // 0.25  * 4.0
    drive(16'h0000, 16'h4700);  // 0.0   * 7.0
    drive(16'h5640, 16'h5640);  // 100.0 * 100.0

    // random tests
    $display("Starting 100 random tests");
    for (j = 0; j < 100; j = j + 1) begin
      rand_a = $random;
      rand_b = $random;
      drive(rand_a, rand_b);
    end

    @(posedge clk);
    valid_pending <= 1'b0;
    repeat (PIPE_LATENCY) @(posedge clk);

    $display("Finished Testing: %0d driven, %0d passed, %0d failed",
             drive_count, pass_count, fail_count);
    $finish;
  end

endmodule
