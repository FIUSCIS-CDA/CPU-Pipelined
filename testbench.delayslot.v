//`timescale 1ps / 1ps
module testbenchDelaySlot();
   reg clk, rst;
   
   localparam CLK_PERIOD = 100;
   
   wire[31:0] PC, IFIR, IDIR, EXIR, MEMIR, WBIR;

   // Third parameter is branch prediction strategy
   // 00=NOT TAKEN (works)
   // 01=TAKEN (does not work yet)
   // 10=DELAY SLOT (works if the program uses delay slots - the bubble sort below does not)   
   CPU_Pipelined myCPU(rst, clk, 2'b10, EXIR, IDIR, IFIR, MEMIR, PC, WBIR);
   
   initial begin
      // initialize instruction memory
      /////////////////////////////////////////////////////////////
      // NEW CODE HERE - START
      myCPU.b2v_IFStage.b2v_MYIM.memory[0] = 'b00100000000100000000001000000000; // addi $s0, $zero, 512                    0
      myCPU.b2v_IFStage.b2v_MYIM.memory[1] = 'b00100000000100010000000000001100; // addi $s1, $zero, 12                     4
      /////////////////////////////////////////////////////////////
      // PUT BUBBLE SORT CODE HERE
      myCPU.b2v_IFStage.b2v_MYIM.memory[2] = 'b00100010001100101111111111111111; // addi $s2, $s1, -1                       8
      myCPU.b2v_IFStage.b2v_MYIM.memory[3] = 'b00100000000011010000000000000001; // addi $t5, $zero, 1                      12
      myCPU.b2v_IFStage.b2v_MYIM.memory[4] = 'b00000000000100100100000000101010; // loop1:   slt $t0, $zero, $s2            16
      myCPU.b2v_IFStage.b2v_MYIM.memory[5] = 'b00010001000000000000000000010000; // beq $t0, $zero, doneloop1               20
      //myCPU.b2v_IFStage.b2v_MYIM.memory[5] = 'b00010101000011010000000000010000; // 	bne $t0, $t5, doneloop1(16)         20
      myCPU.b2v_IFStage.b2v_MYIM.memory[6] = 'b00000000000000001001100000100000; // add $s3, $zero, $zero  [DELAY]          24
      myCPU.b2v_IFStage.b2v_MYIM.memory[7] = 'b00000010011100100100100000101010; // loop2:   slt $t1, $s3, $s2              28
      myCPU.b2v_IFStage.b2v_MYIM.memory[8] = 'b00010001001000000000000000001011; // beq $t1, $zero, doneloop2               32
      //myCPU.b2v_IFStage.b2v_MYIM.memory[8] = 'b00010101001011010000000000001011; // 	bne $t1, $t5, doneloop2(11)         32   
      myCPU.b2v_IFStage.b2v_MYIM.memory[9] = 'b00000010011100110101000000100000; // add $t2, $s3, $s3         [DELAY}       36
      myCPU.b2v_IFStage.b2v_MYIM.memory[10] = 'b00000001010010100101000000100000; // add $t2, $t2, $t2                      40
      myCPU.b2v_IFStage.b2v_MYIM.memory[11] = 'b00000010000010100101100000100000; // add $t3, $s0, $t2                      44
      myCPU.b2v_IFStage.b2v_MYIM.memory[12] = 'b10001101011101000000000000000000; // lw $s4, 0($t3)                         48
      myCPU.b2v_IFStage.b2v_MYIM.memory[13] = 'b10001101011101010000000000000100; // lw $s5, 4($t3)                         52
      myCPU.b2v_IFStage.b2v_MYIM.memory[14] = 'b00000010101101000110000000101010; // slt $t4, $s5, $s4                      56
      myCPU.b2v_IFStage.b2v_MYIM.memory[15] = 'b00010001100000000000000000000011; // beq $t4, $zero, doneif                 60
            //myCPU.b2v_IFStage.b2v_MYIM.memory[15] = 'b00010101100011010000000000000011; // 	bne $t4, $t5, doneif        60        60
      myCPU.b2v_IFStage.b2v_MYIM.memory[16] = 'b00100010011100110000000000000001; // doneif:    addi $s3, $s3, 1   [DELAY}  68
      myCPU.b2v_IFStage.b2v_MYIM.memory[17] = 'b10101101011101010000000000000000; // sw $s5, 0($t3)                         72
      myCPU.b2v_IFStage.b2v_MYIM.memory[18] = 'b10101101011101000000000000000100; // sw $s4, 4($t3)                         76     
      myCPU.b2v_IFStage.b2v_MYIM.memory[19] = 'b00001000000000000000000000000111; // j loop2 //instruction 9                76
      myCPU.b2v_IFStage.b2v_MYIM.memory[20] = 'b00100010010100101111111111111111; //doneloop2: addi $s2, $s2, -1            80
      myCPU.b2v_IFStage.b2v_MYIM.memory[21] = 'b00001000000000000000000000000100; // j loop1 //instruction 6                84
      myCPU.b2v_IFStage.b2v_MYIM.memory[22] = 'b00000000000000000000000000000000; // doneloop1:                             88
       // doneloop1: 
      // Next instruction, uses myCPU.b2v_MEMStage.b2v_MYDM.memory[4]

      /////////////////////////////////////////////////////////////

      // Constants (Note: addi not supported here)
      myCPU.b2v_MEMStage.b2v_MYDM.memory[500 >> 2] = 512;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[504 >> 2] = 12;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[508 >> 2] = 1;
      // Initialized array manually
      myCPU.b2v_MEMStage.b2v_MYDM.memory[512 >> 2] = 55;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[516 >> 2] = 88;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[520 >> 2] = 0;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[524 >> 2] = 22;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[528 >> 2] = 77;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[532 >> 2] = 11;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[536 >> 2] = 99;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[540 >> 2] = 33;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[544 >> 2] = 110;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[548 >> 2] = 66;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[552 >> 2] = 121;
      myCPU.b2v_MEMStage.b2v_MYDM.memory[556 >> 2] = 44;

      rst <= 1;  # (CLK_PERIOD/2);
      rst <= 0; 
   end


   // Generate clock
   always @*
   begin
      clk <= 1;       # (CLK_PERIOD/2);
      clk <= 0;       # (CLK_PERIOD/2);
   end
   

  always@(posedge clk)
    begin

        //////////////////////////////////////////////////
        // CHANGE PC VALUE IN THIS IF STATEMENT
        // ADD 4 TIMES THE AMOUNT OF INSTRUCTIONS YOU RUN
        if(PC === 92) begin

        //////////////////////////////////////////////////
        // CHANGE THIS TEST
        // CURRENT TEST ASSUMES YOU SWAPPED THE THIRD AND SIXTH
          if ( 
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[512 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[516 >> 2]) &&
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[516 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[520 >> 2]) &&
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[520 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[524 >> 2]) &&
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[524 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[528 >> 2]) &&
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[528 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[532 >> 2]) &&
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[532 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[536 >> 2]) &&
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[536 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[540 >> 2]) &&
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[540 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[544 >> 2]) &&
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[544 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[548 >> 2]) &&
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[548 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[552 >> 2]) &&
             (myCPU.b2v_MEMStage.b2v_MYDM.memory[552 >> 2] < myCPU.b2v_MEMStage.b2v_MYDM.memory[556 >> 2])  )


 begin
             $display("CPU functional");
             $stop;
          end
          else begin
             $display("CPU not functional");
             $stop;
           end
       end
   end
 
endmodule
