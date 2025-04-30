`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2025 20:16:52
// Design Name: 
// Module Name: RO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RO(
    input enable,
    input [2:0] ch,
    output out
    );
    
   
      wire w1;
      wire w2;
      wire w3;
      wire w4;
      wire w5;
      wire w6;
      wire w7;
      wire w8;
      wire w9;
      wire w10;
//      (* dont_touch = "yes" *) wire w11;
   //   (* dont_touch = "yes" *) wire feedback;
      
    
//         wire w1;
//        wire w2;
//          wire w3;
//           wire w4;
//       wire w5;
//            wire w6;
//            wire w7;
//            wire w8;
//            wire w9;
//            wire w10;
        // wire w11;
    
     nand a ( w1 ,enable , out);
       not b(w2 ,w1);
       nand c(w6 ,ch[0], w1);
       not d(w3 , w2);
       nand e(w9 , ch[1],out);
       and f(w4 , w3 ,w9);
       not g(w5 , w4);
       and h(w7 ,w5, w6);
       not i(w8 , w7);
       nand j(w10,ch[2], w2);
       assign out = (w8 & w10);
      // assign out = feedback;
    
    
    
endmodule
