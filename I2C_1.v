module I2C_1
//----------------------------------------------------------------------
( 
  input   wire                clk,
  input   wire                rst_n,
  input   wire                valid,
  input   wire      [6:0]     id,
  input   wire      [7:0]     data,
  output  reg                 scl,
  output  reg                 sda
);
//----------------------------------------------------------------------
reg                           valid_i2c;
integer                       cnt;
integer                       cnt_cnt;
integer                       cnt_data;
//----------------------------------------------------------------------
always @(posedge clk)
  begin
    if (rst_n)
      begin
        scl       <= 1'b1;
        sda       <= 1'b1;
        valid_i2c <= 1'b0;
        cnt_cnt   <= 0;
        cnt_data  <= 0;
        cnt       <= 0;
      end
    if (valid && cnt == 0)
      valid_i2c <= 1'b1;
    if (valid_i2c && cnt == 2)
      scl <= ~scl;
    if (valid_i2c && cnt < 2)
      begin
        sda <= 1'b0;
        cnt <= cnt + 1;
        if (sda == 1'b0 && cnt == 1)
          begin
            scl       <= 1'b0;
            cnt       <= cnt + 1;
          end
      end
//----------------------------------------------------------------------
    if (valid_i2c && cnt == 2)
      begin
        if (cnt_cnt == 0 && scl == 1'b1)
          begin
            sda <= id [cnt_data];
            if (cnt_data < 6)
              cnt_data  <= cnt_data + 1;
            else 
              begin
                cnt_data <= 0;
                cnt_cnt <= cnt_cnt + 1;
              end
          end 
        if (cnt_cnt == 1 && scl == 1'b1)
          begin
            sda <= data [cnt_data];
            if (cnt_data < 7)
              cnt_data  <= cnt_data + 1;
            else 
              begin
                cnt_data <= 0;
                cnt_cnt <= 2;
                cnt       <= cnt + 1;
              end
          end
      end
//----------------------------------------------------------------------
    if (valid_i2c && cnt == 3)
        begin
          scl     <= 1'b1; 
          valid_i2c <= 1'b0;
          sda       <= 1'b0;
          cnt       <= 4;
        end
    if (valid_i2c == 1'b0 && scl == 1'b1 && cnt == 4)
      sda <= 1'b1;
  end
//----------------------------------------------------------------------
endmodule
//----------------------------------------------------------------------