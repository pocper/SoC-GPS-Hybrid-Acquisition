module max2769_bridge
(
    // Avalon Bus
    clk,
    rst_n,
    address,
    write,
    writedata,
    read,
    readdata,
    // GPIO - Input
    is_frontend_connected,
    clk_frontend_locked,
    // GPIO - Output
    IDLE_B,
    SHDN_B
);
// ===============================================================
// Input & Output
// ===============================================================
input clk;
input rst_n;

input  [1:0] address;
input  write;
input  [31:0] writedata;
input  read;
output reg [31:0] readdata;

input is_frontend_connected;
input clk_frontend_locked;
output reg IDLE_B;
output reg SHDN_B;

// ===============================================================
// Address Map
// ===============================================================
/* | Address |  Name                 | R/W |
 * | ------- | --------------------- | --- |
 * |  0x0    | IDLE_B                | R/W |
 * |  0x1    | SHDN_B                | R/W |
 * |  0x2    | is_frontend_connected | R   |
 * |  0x3    | clk_frontend_locked   | R   |
 */
// ===============================================================
// Design
// ===============================================================
// Write
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        IDLE_B <= 'b1;
        SHDN_B <= 'b1;
    end
    else begin
        if(write) begin
            case(address)
                'h0: IDLE_B <= writedata[0];
                'h1: SHDN_B <= writedata[0];
            endcase
        end
    end
end

// Read
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        readdata <= 'b0;
    end
    else begin
        if(read) begin
            case(address)
                'h0: readdata <= {31'b0, IDLE_B};
                'h1: readdata <= {31'b0, SHDN_B};
                'h2: readdata <= {31'b0, is_frontend_connected};
                'h3: readdata <= {31'b0, clk_frontend_locked};
            endcase
        end
    end
end
endmodule