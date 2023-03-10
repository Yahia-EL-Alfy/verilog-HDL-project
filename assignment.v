//we used 3 - 2 in 1 mux and 3 - 4 in 1 mux and 3 - full adders - 1 and
module half_adder(output s, output c, input a, input b); // internals of the half adder
xor(s, a, b);
and(c, a, b);
endmodule

module full_adder(output s, output c, input x, input y, input carry); // internals of the full adder
wire s1, c1, c2;
half_adder h1(s1, c1, x, y);
half_adder h2(s, c2, s1, carry);
or(c, c1, c2);
endmodule

module Mux2in1(output Y, input D0, D1, S); // internals of mux 2 in 1

wire T1, T2, T3;
and(T1, D1, S);
not(T2, S);
and(T3, D0, T2);
or(Y, T1, T3);
endmodule

module Mux4in1(output y,input i0, input i1, input i2 , input i3 , input s0 ,  input s1); // internals of mux 4 in 1
wire y1,y2,y3,y4,no_s0,no_s1;
not(no_s0,s0);
not(no_s1,s1);
and(y1,i0,no_s0,no_s1);
and(y2,i1,no_s0,s1);
and(y3,i2,s0,no_s1);
and(y4,i3,s0,s1);
or(y,y1,y2,y3,y4);
endmodule

module topModule_(output [2:0]G, input s0, input s1, input [2:0]a, input [2:0]b); // top module that contain all the rtl

wire mux41o , mux42o , mux43o , cout1 , cout2 , cout3 , ss, mux21o , bf1 , bf2 , bf3 , mux22o , mux23o; //wires
   
and(ss , s1 , s0); // and that makes output to mux 2 in 1 (i1) only if s1 = 0 , s0 = 0

Mux2in1 m21(mux21o , a[0] , 0 , ss);// selection of mux 2 in 1
Mux4in1 m41(mux41o ,1'b1, b[0] , ~b[0] , ~b[0] , s0 , s1);  // selection of mux 4 in 1
full_adder f1(G[0] , cout1 , mux41o , mux21o , s0 ); // add output from mux 4 in 1 + mux 2 in 1

Mux2in1 m22(mux22o , a[1] , 0 , ss);// selection of mux 2 in 1
Mux4in1 m42(mux42o ,1'b1, b[1] ,~b[1] , ~b[1] , s0 , s1);// selection of mux 4 in 1
full_adder f2(G[1] , cout2 , mux42o , mux22o , cout1); // add output from mux 4 in 1 + mux 2 in 1

Mux2in1 m23(mux23o , a[2] , 0 , ss);// selection of mux 2 in 1
Mux4in1 m43(mux43o, 1'b1, b[2] , ~b[2] , ~b[2] , s0 , s1);// selection of mux 4 in 1
full_adder f3(G[2] , cout3 , mux43o , mux23o , cout2); // add output from mux 4 in 1 + mux 2 in 1
endmodule

//testbench for the top module 
module topModule_tb();
reg s0,s1;//Input is reg s0,s1
reg [2:0]A;//Input is A 3 bit
reg [2:0]B;//Input is  B 3 bit
wire [2:0]G;//Output is G for 3 bit
topModule_ f(G, s0,s1,A,B);// making an instance
initial 
begin
$dumpfile("gtkwave.vcd");
$dumpvars(0 , topModule_tb);
$monitor("Time",$time, "| s0=%b | s1=%b | A=%b | B=%b | G=%b ", s0 , s1 , A , B , G ); // to print the output

//40-test cases
//s0 = 0 , s1 = 0;
s0=0;s1=0;A=000;B=000; 
#100 s0=0;s1=0;A=001;B=001; 
#100 s0=0;s1=0;A=010;B=010; 
#100 s0=0;s1=0;A=011;B=011; 
#100 s0=0;s1=0;A=100;B=100;
#100 s0=0;s1=0;A=101;B=111;
#100 s0=0;s1=0;A=110;B=010;
#100 s0=0;s1=0;A=111;B=101;
#100 s0=0;s1=0;A=000;B=011;
#100 s0=0;s1=0;A=001;B=111;
//s0 = 0 , s1 = 1;
#100 s0=0;s1=1;A=001;B=001;
#100 s0=0;s1=1;A=010;B=010;
#100 s0=0;s1=1;A=011;B=011;
#100 s0=0;s1=1;A=100;B=100;
#100 s0=0;s1=1;A=101;B=111;
#100 s0=0;s1=1;A=110;B=010;
#100 s0=0;s1=1;A=111;B=000;
#100 s0=0;s1=1;A=000;B=011;
#100 s0=0;s1=1;A=001;B=110;
#100 s0=0;s1=1;A=010;B=101;
//s0 = 1 , s1 = 0;
#100 s0=1;s1=0;A=001;B=001;
#100 s0=1;s1=0;A=010;B=010;
#100 s0=1;s1=0;A=011;B=011;
#100 s0=1;s1=0;A=100;B=100;
#100 s0=1;s1=0;A=101;B=111;
#100 s0=1;s1=0;A=110;B=010;
#100 s0=1;s1=0;A=111;B=000;
#100 s0=1;s1=0;A=000;B=011;
#100 s0=1;s1=0;A=001;B=110;
#100 s0=1;s1=0;A=010;B=101;
//s0 = 1 , s1 = 1;
#100 s0=1;s1=1;A=001;B=001;
#100 s0=1;s1=1;A=010;B=010;
#100 s0=1;s1=1;A=011;B=011;
#100 s0=1;s1=1;A=100;B=100;
#100 s0=1;s1=1;A=101;B=111;
#100 s0=1;s1=1;A=110;B=010;
#100 s0=1;s1=1;A=111;B=000;
#100 s0=1;s1=1;A=000;B=011;
#100 s0=1;s1=1;A=001;B=110;
#100 s0=1;s1=1;A=010;B=101;
//end
$finish;
end
endmodule
