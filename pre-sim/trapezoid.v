module trapezoid (clk, reset, nt, xi, yi, busy, po, xo, yo);
	input clk, reset, nt;
	input [7:0] xi, yi;
	output po;
	output reg busy;
	output [7:0] xo, yo;
  
	parameter S0_RST = 0, S1_WAIT = 1, S2_START = 2, S3_RX_ENDPOINT = 3, S4_PREPARE_CAL = 4, S5_CAL = 5, S6_TX_RESULT = 6;
	
	reg [2:0] curr_state, next_state;
	reg count_flag;
	reg [31:0] end_point_x, end_point_y;
	reg [2:0]cnt;
	wire finish;
	
	Trapezoid_Rendering t1(finish, po, xo, yo, clk, count_flag, end_point_x, end_point_y);
	
	always@(posedge clk or posedge reset)begin
		if(reset)begin
			curr_state = S0_RST;
		end else begin
			curr_state = next_state;
		end
	end
	
	always@(curr_state or reset or nt or cnt or finish)begin
		case(curr_state)
		S0_RST:
			begin
				if(reset) next_state = S0_RST;
				else next_state = S1_WAIT;
			end
		S1_WAIT:
			begin
				next_state = S2_START;
			end
		S2_START:
			begin
				if(nt) next_state = S3_RX_ENDPOINT;
				else next_state = S2_START;
			end
		S3_RX_ENDPOINT:
			begin
				if(cnt == 3'd3) next_state = S4_PREPARE_CAL;
				else next_state = S3_RX_ENDPOINT;
			end
		S4_PREPARE_CAL:
			begin
				next_state = S5_CAL;
			end
		S5_CAL:
			begin
				if(finish) next_state = S1_WAIT;
				else next_state = S5_CAL;
			end
		S6_TX_RESULT:
			begin
			
			end
		default:;
		endcase
	end
	
  
  always@(curr_state)begin
		case(curr_state)
		S0_RST:
			begin
				busy = 1'd1;
				count_flag = 1'd0;
			end
		
		S1_WAIT:
			begin
				busy = 1'd0;
				count_flag = 1'd0;
			end
		
		S2_START:
			begin
				busy = 1'd0;
				count_flag = 1'd0;
			end
		
		S3_RX_ENDPOINT:
			begin
				busy = 1'd0;
				count_flag = 1'd0;
			end
		S4_PREPARE_CAL:
			begin
				busy = 1'd1;
				count_flag = 1'd0;
			end
		S5_CAL:
			begin
				busy = 1'd1;
				count_flag = 1'd1;
			end
		S6_TX_RESULT:
			begin
			
			end
		default:;
		endcase
	end
	
	
	always@(posedge clk)begin
		if(curr_state == S2_START) cnt = 3'd0;
		else if(curr_state == S3_RX_ENDPOINT) begin
			cnt = cnt + 3'd1;
			end_point_x[7:0] = xi;
			end_point_x  = end_point_x << 8;
			end_point_y[7:0] = yi;
			end_point_y = end_point_y << 8;
		end else if(curr_state == S4_PREPARE_CAL)begin
			end_point_x[7:0] = xi;
			end_point_y[7:0] = yi;
			

		end else cnt = 3'd0;
	end
	

endmodule

module Trapezoid_Rendering(finish, po, xo, yo, clk, count_flag, point_x, point_y);

	output reg po, finish;
	output reg [7:0]xo, yo;
	input clk, count_flag;
	input [31:0] point_x, point_y;

	reg signed[17:0] dxl, dxr;
	reg [17:0] xl, xr;
	reg [7:0] end_x;
	
	reg [2:0] curr_state, next_state;
	reg [7:0] i, j;
	reg init_slope, init_end_x, outdata, plus_slope, init_i;
	parameter S0_RST = 0, S1_PAR_INIT = 1, S2_OUTER_LOOP = 2, S3_END_X_INIT = 3, S4_OUTPUT = 4, S5_INCRESE_SLOPE = 5, S6_FINISH = 6;
	
	always@(posedge clk or posedge count_flag)begin
		if(count_flag) curr_state = next_state;
		else curr_state = S0_RST;
	end
	
	
	always@(curr_state or j or i)begin
		case(curr_state)
			S0_RST:
				begin
					next_state = S1_PAR_INIT;
				end
			S1_PAR_INIT:
				begin
					next_state = S2_OUTER_LOOP;
				end
			S2_OUTER_LOOP:
				begin
					next_state = S3_END_X_INIT;
				end
			S3_END_X_INIT:
				begin
					next_state = S4_OUTPUT; 
				end
			S4_OUTPUT:
				begin
					if(j >= end_x) next_state = S5_INCRESE_SLOPE;
					else next_state = S4_OUTPUT;
				end
			S5_INCRESE_SLOPE:
				begin
					if(i[6:0] <= point_y[30:24]) next_state = S3_END_X_INIT;
					else next_state = S6_FINISH;
				end
			S6_FINISH:
				begin
				
				end
			default:;
		endcase
	end
	
	always@(curr_state)begin
		case(curr_state)
			S0_RST:
				begin
					init_slope = 0;
					init_i = 0;
					init_end_x = 0;
					outdata = 0;
					plus_slope = 0;
					finish = 0;
				end
			S1_PAR_INIT:
				begin
					init_i = 0;
					init_end_x = 0;
					outdata = 0;
					plus_slope = 0;
					init_slope = 1;
					finish = 0;
				end
			S2_OUTER_LOOP:
				begin
					init_slope = 0;
					init_end_x = 0;
					outdata = 0;
					plus_slope = 0;
					init_i = 1;
					finish = 0;
				end
			S3_END_X_INIT:
				begin
					init_slope = 0;
					init_i = 0;
					outdata = 0;
					plus_slope = 0;
					init_end_x = 1;
					finish = 0;
				end
			S4_OUTPUT:
				begin
					init_slope = 0;
					init_i = 0;
					init_end_x = 0;
					plus_slope = 0;
					outdata = 1;
					finish = 0;
				end
			S5_INCRESE_SLOPE:
				begin
					init_slope = 0;
					init_i = 0;
					init_end_x = 0;
					outdata = 0;
					plus_slope = 1;
					finish = 0;
				end
			S6_FINISH:
				begin
					init_slope = 0;
					init_i = 0;
					init_end_x = 0;
					outdata = 0;
					plus_slope = 0;
					finish = 1;
				end
			default:;
		endcase
	end
	
	
	reg signed[17:0]tmp_x, tmp_y;
	always@(posedge init_slope or posedge plus_slope)begin
		if(init_slope)begin
			tmp_x = (point_x[31:24] - point_x[15:8]) << 10;
			tmp_y = (point_y[31:24] - point_y[15:8]);
	
			dxl = tmp_x / tmp_y;
			
			tmp_x = (point_x[23:16] - point_x[7:0]) << 10;
			tmp_y = (point_y[31:24] - point_y[15:8]);
			
			dxr = tmp_x / tmp_y;
				
			xl = point_x[15:8] << 10;
			xr = point_x[7:0] << 10;
		end else if(plus_slope)begin
			xl = xl + dxl;
			xr = xr + dxr;	
		end else begin
			dxl = dxl; 
			dxr = dxr;
			xl = xl;
			xr = xr;
		end
	end
	
	always@(posedge init_i or posedge plus_slope)begin
		if(init_i)begin
			i = point_y[15:8];
		end else if(plus_slope) i = i + 1;
		else i = 0;
	end

//need to consider the sign number	
	always@(posedge init_end_x)begin
		if(init_end_x)begin
			if(xl[9:0] == 10'd0) end_x = xr[17:10];  //xl is integer
			else if(xr[9:0] == 10'd0) end_x = xr[17:10] + 8'd1; //xr is not integer
			else begin
				//if(xr[9:0] != 10'd0) end_x = xr[17:10] + 8'd1;
				//else end_x = xr[17:10];
				end_x = xr[17:10];
			end
		end
	end
	
	always@(posedge clk)begin
		//if(next_state == S5_INCRESE_SLOPE) po = 0;
		if(outdata) po = 1;
		else po = 0;
	end
	
	always@(posedge clk or posedge init_end_x)begin
		if(init_end_x) begin
			if(i == (point_y[31:24] - point_y[15:8]) / 2) j = xl[17:10] + 1;
			else if(i == point_y[31:24]) j = xl[17:10] + 1;
			else j = xl[17:10];
		end
		else if(outdata)begin
			xo = j;
			yo = i;
			j = j + 1;
		end else begin
			xo = xo;
			yo = yo;
			j = j;
		end
	end
	
endmodule
