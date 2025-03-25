 @R1           
   D=M
   @INVALID_DIV // If R1==0, jump to error routine
   D;JEQ


   @R1
   D=M
   @DIV1_POS
   D;JGE       
   @R8
   M=-1       
   @SKIP_DIV_SIGN1
   0;JMP
(DIV1_POS)
   @R8
   M=1        
(SKIP_DIV_SIGN1)


   @R0
   D=M
   @DIV0_POS
   D;JGE       // If R0>=0, jump to DIV0_POS
   @R7
   M=-1      // R0 was negative; flag = -1
   @SKIP_DIV_SIGN0
   0;JMP
(DIV0_POS)
   @R7
   M=1       // R0 was nonnegative; flag = +1
(SKIP_DIV_SIGN0)


// Get |R1| into R6
   @R1
   D=M
   @ABS_R1
   D;JGE      // If R1 is nonnegative, skip negation
   @R1
   D=M
   D=-D      // Otherwise, negate it
(ABS_R1)
   @R6
   M=D      // R6 now holds the absolute value of R1

// Get |R0| into R5
   @R0
   D=M
   @ABS_R0
   D;JGE      // If R0 is nonnegative, skip negation
   @R0
   D=M
   D=-D      // Otherwise, negate it
(ABS_R0)
   @R5
   M=D      // R5 now holds the absolute value of R0

// ----- Initialize quotient and error flag ----- 
   @R4
   M=0      // R4 = 0 (no error)
   @R2
   M=0      // R2 will hold the quotient

// Copy the absolute dividend from R5 into R3 (the running remainder)
   @R5
   D=M
   @R3
   M=D

// ----- Division Loop: Repeated subtraction ----- 
(LOOP)
   @R3
   D=M        // Load current remainder
   @R6
   D=D-M      // Compute (remainder - divisor)
   @END_LOOP
   D;JLT      // If (remainder - divisor) is negative, exit loop
   @R3
   M=D        // Update remainder with new value
   @R2
   M=M+1      // Increment quotient
   @LOOP
   0;JMP

(END_LOOP)

   @R7
   D=M       
   @R8
   D=D-M     
   @SIGN_CORRECT
   D;JEQ      // If D==0 then the signs were the same; no change needed.
   @R2
   D=M
   D=-D
   @R2
   M=D
(SIGN_CORRECT)
// Also, the remainder should have the same sign as the dividend.
   @R7
   D=M
   @REMAINDER_POS
   D;JGT     

   @R3
   D=M
   D=-D
   @R3
   M=D
(REMAINDER_POS)
   @END
   0;JMP

// w
(INVALID_DIV)
   @R4
   M=1      
   @END
   0;JMP


(END)
   @END
   0;JMP