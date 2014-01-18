module trapezoid (clk, reset, nt, xi, yi, busy, po, xo, yo);
	input clk, reset, nt;
	input [7:0] xi, yi;
	output reg busy, po;
	output [7:0] xo, yo;
  
	reg [2:0] curr_state, next_state;
	reg [31:0] point_x, point_y;
	reg [1:0] cnt;
	reg signed[7:0] i, j, end_x;
	
	reg get_end_point;
	parameter [2:0] S0_RST = 3'd0, S1_PREPARE = 3'd1, S2_START = 3'd2, S3_OUTTER_LOOP = 3'd3, S4_END_X = 3'd4, S5_OUTPUT = 3'd5, S6_INCRESE = 3'd6, S7_DONE = 3'd7;
   
   
	always@(posedge clk or posedge reset)begin
		if(reset) cnt = 2'd0;
		else if(get_end_point) begin
			cnt = cnt + 2'd1;
			point_x = point_x << 8;
			point_y = point_y << 8;
			point_x[7:0] = xi;
			point_y[7:0] = yi;
			
		end
		else cnt <= 2'd0;
	end
   
	always@(posedge clk or posedge reset)begin
		if(reset) curr_state <= S0_RST;
		else curr_state <= next_state;
	end
   
	always@(curr_state or reset or i or j or cnt)begin
		case(curr_state)
			S0_RST:
				begin
					if(~reset) next_state = S1_PREPARE;
					else next_state = S0_RST;
				end
			S1_PREPARE:
				begin
					if(cnt >= 2'd2) next_state = S2_START;
					else next_state = S1_PREPARE;
				end
			S2_START:
				begin
					next_state = S3_OUTTER_LOOP;
				end
			S3_OUTTER_LOOP:
				begin
					if( i <= point_y[31:28]) next_state = S4_END_X;
					else next_state = S7_DONE;
				end
			S4_END_X:
				begin
					next_state = S5_OUTPUT;
				end
			S5_OUTPUT:
				begin
					if( j <= end_x) next_state = S5_OUTPUT;
					else next_state = S6_INCRESE;
				end
			S6_INCRESE:
				begin
					next_state = S3_OUTTER_LOOP;
				end
			S7_DONE: next_state = S1_PREPARE;
			default: next_state = S0_RST;
		endcase
	end
	
	always@(curr_state or nt or cnt)begin
		case(curr_state)
			S0_RST:
				begin
					busy = 1'd1;
					get_end_point = 1'd0;
					po = 1'd0;
				end
			S1_PREPARE:
				begin
					po = 1'd0;
					busy = 1'd0;
					if(nt || cnt <= 2'd3) get_end_point = 1'd1;
					else get_end_point = '1d0;
					
				end
			S2_START:
				begin
					po = 1'd0;
					busy = 1'd1;
					get_end_point = 1'd1;
				end
			S3_OUTTER_LOOP:
				begin
					po = 1'd0;
					busy = 1'd1;
					get_end_point = 1'd0;
				end
			S4_END_X:
				begin
					po = 1'd0;
					busy = 1'd1;
					get_end_point = 1'd0;
				end
			S5_OUTPUT:
				begin
					po = 1'd1;
					busy = 1'd1;
					get_end_point = 1'd0;
				end
			S6_INCRESE:
				begin
					po = 1'd0;
					busy = 1'd1;
					get_end_point = 1'd0;
				end
			S7_DONE:
				begin
					po = 1'd0;
					busy = 1'd0;
					get_end_point = 1'd0;
				end
			default:;
		endcase
	end	

endmodule
