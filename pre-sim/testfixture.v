`timescale 1ns/10ps
`define CYCLE  100      // Modify your clock period here
`define INFILE1 "IN.DAT"  
`define INFILE2 "EXPECT.DAT"  

module test;
parameter INPUT_DATA = `INFILE1;
parameter EXPECT_DATA = `INFILE2;
reg     clk;
reg     reset;
reg     nt;
reg     [7:0] xi, yi;

wire    [7:0] xo, yo;
wire    po;
wire    busy;


integer i, j, k, l, m,  out_f, err, pattern_num, total_num, total_cycle_num;
integer a, b, c, d;
reg [15:0]  data_base [0:304128];
reg [15:0]  data_base_expect [0:304128];
reg [15:0]  data_tmp_expect;
reg [15:0]  data_tmp_i, data_tmp_i1, data_tmp_i2, data_tmp_i3;


trapezoid top(clk, reset, nt, xi, yi, busy, po, xo, yo);

//initial $sdf_annotate("chip.sdf",top);

initial	$readmemh( INPUT_DATA,  data_base);
initial	$readmemh( EXPECT_DATA,  data_base_expect);

initial begin
$dumpvars();
$dumpfile("trapezoid.vcd");
    clk   = 1'b1;
    reset = 1'b0;
    nt    = 1'b0;
    xi    = 8'bz;
    yi    = 8'bz;
   l = 0;
   i = 0;
   j = 0;
   k = 0;
   err = 0;
   pattern_num = 1 ; 
   total_num = 0 ;
end

initial begin

   out_f = $fopen("OUT.DAT");
   if (out_f == 0) begin
        $display("Output file open error !");
        $finish;
   end
end

always begin #(`CYCLE/2)  clk = ~clk;
end


initial begin 
   @(negedge clk)  
   reset = 1'b1;
   $display ("\n******START to VERIFY the Trapezoid Rendering Enginen OPERATION  ******\n");
   #(`CYCLE -0.1)
          reset = 1'b0;
   
    for  (i = 0; i < 68; i = i + k) begin
    if(busy ==1'b1) begin
      @(negedge clk)
           nt =1'b0;
           k  =0;
    end
    else begin   // else begin
           k  = 4;
      @(negedge clk)
           nt =1'b1;
      
      #(`CYCLE*0.3)  data_tmp_i = data_base[i] ;
           xi = data_tmp_i[15:8];
           yi = data_tmp_i[7:0];
      @(posedge clk)
      #(`CYCLE*0.2) 
           xi = 8'bz; 
           yi = 8'bz; 
      @(negedge clk)
           nt = 1'b0;
      #(`CYCLE*0.3)  data_tmp_i1 = data_base[i+1] ;
           xi = data_tmp_i1[15:8];
           yi = data_tmp_i1[7:0];
      @(posedge clk)
      #(`CYCLE*0.2) 
           xi = 8'bz; 
           yi = 8'bz; 
      @(negedge clk)
      #(`CYCLE*0.3)  data_tmp_i2 = data_base[i+2] ;
           xi = data_tmp_i2[15:8];
           yi = data_tmp_i2[7:0];
      @(posedge clk)
      #(`CYCLE*0.2) 
           xi = 8'bz; 
           yi = 8'bz; 

      @(negedge clk)
      #(`CYCLE*0.3)  data_tmp_i3 = data_base[i+3] ;
           xi = data_tmp_i3[15:8];
           yi = data_tmp_i3[7:0];
      @(posedge clk)
      #(`CYCLE*0.2) 
           xi = 8'bz; 
           yi = 8'bz; 
      
  $display("Waiting for the rendering operation of the trapezoid points with:"); 
    $display("(xul, yu)=(%h, %h)",data_tmp_i[15:8], data_tmp_i[7:0]); 
    $display("(xur, yu)=(%h, %h)",data_tmp_i1[15:8], data_tmp_i1[7:0]); 
    $display("(xdl, yd)=(%h, %h)",data_tmp_i2[15:8], data_tmp_i2[7:0]); 
    $display("(xdr, yd)=(%h, %h)",data_tmp_i3[15:8], data_tmp_i3[7:0]); 
  end //else end 
 end //for end
end 

always @ ( posedge clk) begin
  if (po ==1'b1) begin 
     data_tmp_expect = data_base_expect[l]; 
     if ((xo !== data_tmp_expect[15:8])|| (yo!== data_tmp_expect[7:0])) begin
         $display("ERROR at %d:xo=(%h) yo=(%h)!=expect xo=(%h), yo=(%h)",l 
         ,xo, yo, data_tmp_expect[15:8], data_tmp_expect[7:0]);
          err = err + 1 ;   
         end
       $fdisplay(out_f,"%h%h",xo,yo); 
        l = l + 1;
     end
    //if( l == 162 ) begin
    if( l == 119527 ) begin
      if (err == 0)
         $display("PASS! All data have been generated successfully!");
      else begin
      $display("---------------------------------------------");
         $display("There are %d errors!", err);
      $display("---------------------------------------------");
      end
      $display("---------------------------------------------");
      total_num = total_cycle_num * `CYCLE ;
      $display("Total delay: %d ns", total_num );
      $display("---------------------------------------------");
      $finish;
    end
end

always @ ( posedge clk) begin
   if (reset == 1'b1) 
      total_cycle_num = 0 ;
   else 
      total_cycle_num = total_cycle_num + 1 ;
end 

endmodule
