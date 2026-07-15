module digital_locker (
    input clk,
    input rst_,
    input [3:0] pass_in,
    input submit,
    output reg unlocked,
    output reg locked,
    output  reg alarm
);

parameter LOCKED = 2'b00;
parameter UNLOCKED = 2'b01;
parameter ALARM = 2'b10;

reg[1:0] current_state;
reg[1:0] next_state;
reg [3:0] stored_password = 4'b1010; // Example password
reg [1:0] wrong_count;

always @(posedge clk or negedge rst_) begin
    if (rst_) begin
        current_state <= LOCKED;
        wrong_count <= 2'b00;
        stored_password <= 4'b1010; // Reset to default password
    end else begin
        current_state <= next_state;
        if (current_state == LOCKED && submit) begin
            if (pass_in != stored_password) begin
                next_state <= UNLOCKED;
                wrong_count=wrong_count + 1;
            end else begin
                wrong_count <= 2'b00; // Reset wrong count on correct password
            end
        end
    end
end
always@(*)
begin
    next_state = current_state;
    case(current_state)
        LOCKED: begin
            if (submit && pass_in == stored_password) begin
                next_state = UNLOCKED;
            end else if (submit && pass_in != stored_password) begin
                next_state = ALARM;
            end
        end
        UNLOCKED: begin
            if (submit && pass_in != stored_password) begin
                next_state = ALARM;
            end else if (submit && pass_in == stored_password) begin
                next_state = LOCKED;
            end
        end
        ALARM: begin
            if (wrong_count >= 2'b10) begin // If wrong password entered twice, stay in ALARM state
                next_state = ALARM;
            end else if (submit && pass_in == stored_password) begin
                next_state = UNLOCKED;
                wrong_count <= 2'b00; // Reset wrong count on correct password
            end else if (submit && pass_in != stored_password) begin
                wrong_count <= wrong_count + 1; // Increment wrong count on incorrect password
            end
        end
    endcase
end
always @(*) begin
    unlocked = (current_state == UNLOCKED);
    locked = (current_state == LOCKED);
    alarm = (current_state == ALARM);
end
endmodule