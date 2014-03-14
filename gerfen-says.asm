; --------------------------------------------------------------------
; Author: Robin Choudhury and Angela Yoeurng
; March, 2014
; --------------------------------------------------------------------

; Various key parameter constants
;------------------------------------------------------------
; All from numpad.
.EQU K_UPPER_LEFT  = 0x6B     ; 4
.EQU K_UPPER_RIGHT = 0x73     ; 5
.EQU K_LOWER_LEFT  = 0x69     ; 1
.EQU K_LOWER_RIGHT = 0x72     ; 2
;------------------------------------------------------------

;------------------------------------------------------------
; Various screen parameter constants for 40x30 screen
;------------------------------------------------------------
.EQU LO_X    = 0x01
.EQU HI_X    = 0x26
.EQU LO_Y    = 0x01
.EQU HI_Y    = 0x1C
;------------------------------------------------------------

;------------------------------------------------------------
; Various screen I/O constants
;------------------------------------------------------------
.EQU LEDS                = 0x40     ; LED array
.EQU SSEG                = 0x81     ; 7-segment decoder

.EQU PS2_CONTROL         = 0x46     ; ps2 control register
.EQU PS2_KEY_CODE        = 0x44     ; ps2 data register
.EQU PS2_STATUS          = 0x45     ; ps2 status register

;------------------------------------------------------------------
; VGA Ports
;------------------------------------------------------------------
.EQU VGA_HADD   = 0x90
.EQU VGA_LADD   = 0x91
.EQU VGA_COLOR  = 0x92

;------------------------------------------------------------------
; Random Number Generator
;------------------------------------------------------------------
.EQU RANDOM_NUMBER   = 0x75

;------------------------------------------------------------------
; Various drawing constants
;------------------------------------------------------------------
.EQU BG_COLOR =    0xE0    ; Background: red
.EQU C_BLACK  =    0x00    ; color data: black
.EQU C_WHITE  =    0xFF    ; color data: blue
.EQU C_BLUE   =    0x03    ; color data: blue
.EQU C_GREEN  =    0x10    ; color data: green
.EQU C_YELLOW =    0xF8    ; color data: yellow
.EQU C_RED    =    0xE0    ; must be appended with color_ to avoid register syntax
;------------------------------------------------------------------

;------------------------------------------------------------------
; Various Constant Definitions
;------------------------------------------------------------------
.EQU KEY_UP     = 0xF0        ; key release data
.EQU int_flag   = 0x01        ; interrupt hello from keyboard
;------------------------------------------------------------------

;------------------------------------------------------------------------------
;-- Time Wasters
;------------------------------------------------------------------------------
.EQU MIDDLE_CNT  = 0XFF
.EQU INSIDE_CNT  = 0XFF

;------------------------------------------------------------------------------
;-- Square Numbers
;------------------------------------------------------------------------------
.EQU UPPER_LEFT  = 0x00
.EQU UPPER_RIGHT  = 0X01
.EQU LOWER_LEFT  = 0X02
.EQU LOWER_RIGHT  = 0X03

;------------------------------------------------------------------
;- Register Usage Key
;------------------------------------------------------------------
;- r2 --- holds keyboard input
;- r6 --- holds drawing color
;- r7 --- main Y location value
;- r8 --  main X location value
;- r15 -- for interrupt flag
;------------------------------------------------------------------

;------------------------------------------------------------------
.CSEG
.ORG 0x20
;------------------------------------------------------------------

;------------------------------------------------------------------
; Foreground Task
;------------------------------------------------------------------
init:
   CALL draw_simon

main:
   SEI
   IN R24, RANDOM_NUMBER
   CALL level_1
   CALL level_1_user
   IN R25, RANDOM_NUMBER
   CALL level_2
   CALL level_2_user
   IN R26, RANDOM_NUMBER
   CALL level_3
   CALL level_3_user
   IN R27, RANDOM_NUMBER
   CALL level_4
   CALL level_4_user
   IN R28, RANDOM_NUMBER
   CALL level_5
   CALL level_5_user
   IN R29, RANDOM_NUMBER
   CALL level_6
   CALL level_6_user
   IN R30, RANDOM_NUMBER
   CALL level_7
   CALL level_7_user
   IN R31, RANDOM_NUMBER
   CALL level_8
   CALL level_8_user
   IN R18, RANDOM_NUMBER
   CALL level_9
   CALL level_9_user
   IN R19, RANDOM_NUMBER
   CALL level_10
   CALL level_10_user
   IN R20, RANDOM_NUMBER
   CALL level_11
   CALL level_11_user
   BRN draw_win
   BRN main



;--------------------------------------------------------------------
;-  Level subroutines
;-
;-  Select random squares based off the random number generator. Wait for user
;-  input. Branch to the next level if the user gets it. Otherwise, branch to
;-  loss.
;--------------------------------------------------------------------
level_1:
   CLI
   MOV R17, R24
   CALL big_time_waster
   CALL get_random_square
   RET

 level_1_user:
   SEI
   MOV R0, 0x05
   CALL tiny_delay
   CMP R0, 0x05
   BREQ level_1_user
   CMP R0, R24
   BRNE draw_loss
   RET

level_2:
   CALL level_1
   MOV R17, R25
   CALL big_time_waster
   CALL get_random_square
   RET

level_2_user:
   SEI
   CALL level_1_user
   CALL tiny_delay
   MOV r0, 0x05
level_2_wait:
   CALL tiny_delay
   CMP R0, 0x05
   BREQ level_2_wait
   CMP r0, R25
   BRNE draw_loss
   RET

level_3:
   CALL level_2
   MOV R17, R26
   CALL big_time_waster
   CALL get_random_square
   RET

level_3_user:
   SEI
   CALL level_2_user
   CALL tiny_delay
   MOV R0, 0x05
level_3_wait:
   CALL tiny_delay
   CMP r0, 0x05
   BREQ level_3_wait
   CMP r0, R26
   BRNE draw_loss
   RET

level_4:
   CALL level_3
   MOV R17, R27
   CALL big_time_waster
   CALL get_random_square
   RET

level_4_user:
   SEI
   CALL level_3_user
   CALL tiny_delay
   MOV R0, 0x05
level_4_wait:
   CALL tiny_delay
   CMP r0, 0x05
   BREQ level_4_wait
   CMP r0, R27
   BRNE draw_loss
   RET

level_5:
   CALL level_4
   MOV R17, R28
   CALL big_time_waster
   CALL get_random_square
   RET

level_5_user:
   SEI
   CALL level_4_user
   CALL tiny_delay
   MOV R0, 0x05
level_5_wait:
   CALL tiny_delay
   CMP r0, 0x05
   BREQ level_5_wait
   CMP r0, R28
   BRNE draw_loss
   RET

level_6:
   CALL level_5
   MOV R17, R29
   CALL big_time_waster
   CALL get_random_square
   RET

level_6_user:
   SEI
   CALL level_5_user
   CALL tiny_delay
   MOV R0, 0x05
level_6_wait:
   CALL tiny_delay
   CMP r0, 0x05
   BREQ level_6_wait
   CMP r0, R29
   BRNE draw_loss
   RET

level_7:
   CALL level_6
   MOV R17, R30
   CALL big_time_waster
   CALL get_random_square
   RET

level_7_user:
   SEI
   CALL level_6_user
   CALL tiny_delay
   MOV R0, 0x05
level_7_wait:
   CALL tiny_delay
   CMP r0, 0x05
   BREQ level_7_wait
   CMP r0, R30
   BRNE draw_loss
   RET

level_8:
   CALL level_7
   MOV R17, R31
   CALL big_time_waster
   CALL get_random_square
   RET

level_8_user:
   SEI
   CALL level_7_user
   CALL tiny_delay
   MOV R0, 0x05
level_8_wait:
   CALL tiny_delay
   CMP r0, 0x05
   BREQ level_8_wait
   CMP r0, R31
   BRNE draw_loss
   RET

level_9:
   CALL level_8
   MOV R17, R18
   CALL big_time_waster
   CALL get_random_square
   RET

level_9_user:
   SEI
   CALL level_8_user
   CALL tiny_delay
   MOV R0, 0x05
level_9_wait:
   CALL tiny_delay
   CMP r0, 0x05
   BREQ level_9_wait
   CMP r0, R18
   BRNE draw_loss
   RET

level_10:
   CALL level_9
   MOV R17, R19
   CALL big_time_waster
   CALL get_random_square
   RET

level_10_user:
   SEI
   CALL level_9_user
   CALL tiny_delay
   MOV R0, 0x05
level_10_wait:
   CALL tiny_delay
   CMP r0, 0x05
   BREQ level_10_wait
   CMP r0, R19
   BRNE draw_loss
   RET

level_11:
   CALL level_10
   MOV R17, R20
   CALL big_time_waster
   CALL get_random_square
   RET

level_11_user:
   SEI
   CALL level_10_user
   CALL tiny_delay
   MOV R0, 0x05
level_11_wait:
   CALL tiny_delay
   CMP r0, 0x05
   BREQ level_11_wait
   CMP r0, R20
   BRNE draw_loss
   RET
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;- Subroutines: Flashing squares
;-
;-  Flashes a square and returns it to its original color.
;--------------------------------------------------------------------
flash_upper_left:
   CALL select_upper_left_square
   CALL flash_delay
   CALL draw_upper_left_square
   RET

flash_upper_right:
   CALL select_upper_right_square
   CALL flash_delay
   CALL draw_upper_right_square
   RET

flash_lower_left:
   CALL select_lower_left_square
   CALL flash_delay
   CALL draw_lower_left_square
   RET

flash_lower_right:
   CALL select_lower_right_square
   CALL flash_delay
   CALL draw_lower_right_square
   RET
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;-  Subroutine: Draw Simon
;-
;-  Draws 4 squares that represent the original simon board.
;-
;--------------------------------------------------------------------
draw_simon:
   CALL draw_upper_left_square
   CALL draw_upper_right_square
   CALL draw_lower_left_square
   CALL draw_lower_right_square
   RET
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;-  Subroutine: Draw square over the portion of the screen
;-
;-  Draws a square in its respective location.
;-
;--------------------------------------------------------------------
draw_upper_left_square:
   MOV R10, 0x00 ; starting x-coordinate
   MOV R11, 0x00 ; starting y-coordinate
   MOV R12, 0x13 ; ending x-coordinate
   MOV R13, 0x0E ; ending y-coordinate
   MOV R14, C_BLUE ; blue
   CALL draw_square
   RET

draw_upper_right_square:
   MOV R10, 0x14 ; starting x-coordinate
   MOV R11, 0x00 ; starting y-coordinate
   MOV R12, 0x28 ; ending x-coordinate
   MOV R13, 0x0E ; ending y-coordinate
   MOV R14, C_GREEN
   CALL draw_square
   RET

draw_lower_left_square:
   MOV R10, 0x00 ; starting x-coordinate
   MOV R11, 0x10 ; starting y-coordinate
   MOV R12, 0x13 ; ending x-coordinate
   MOV R13, 0x1D ; ending y-coordinate
   MOV R14, C_RED
   CALL draw_square
   RET

draw_lower_right_square:
   MOV R10, 0x14 ; starting x-coordinate
   MOV R11, 0x10 ; starting y-coordinate
   MOV R12, 0x28 ; ending x-coordinate
   MOV R13, 0x1D ; ending y-coordinate
   MOV R14, C_YELLOW
   CALL draw_square
   RET
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;-  Select subroutines
;-
;-  Draws a white square over the selected portion of the screen.
;--------------------------------------------------------------------
select_upper_left_square:
   MOV R10, 0x00 ; starting x-coordinate
   MOV R11, 0x00 ; starting y-coordinate
   MOV R12, 0x13 ; ending x-coordinate
   MOV R13, 0x0E ; ending y-coordinate
   MOV R14, C_WHITE ; blue
   CALL draw_square
   RET

select_upper_right_square:
   MOV R10, 0x14 ; starting x-coordinate
   MOV R11, 0x00 ; starting y-coordinate
   MOV R12, 0x28 ; ending x-coordinate
   MOV R13, 0x0E ; ending y-coordinate
   MOV R14, C_WHITE
   CALL draw_square
   RET

select_lower_left_square:
   MOV R10, 0x00 ; starting x-coordinate
   MOV R11, 0x10 ; starting y-coordinate
   MOV R12, 0x13 ; ending x-coordinate
   MOV R13, 0x1D ; ending y-coordinate
   MOV R14, C_WHITE
   CALL draw_square
   RET

select_lower_right_square:
   MOV R10, 0x14 ; starting x-coordinate
   MOV R11, 0x10 ; starting y-coordinate
   MOV R12, 0x28 ; ending x-coordinate
   MOV R13, 0x1D ; ending y-coordinate
   MOV R14, C_WHITE
   CALL draw_square
   RET
;--------------------------------------------------------------------

draw_face:
   ; draw eyes
   MOV R6,  C_WHITE ; blue
   MOV R8,  0x05 ; starting x-coordinate
   MOV R7,  0x15 ; starting y-coordinate
   MOV R9,  0x17 ; ending y-coordinate
   CALL draw_vertical_line
   MOV R8,  0x08 ; starting x-coordinate
   MOV R7,  0x15 ; starting y-coordinate
   MOV R9,  0x17 ; ending y-coordinate
   CALL draw_vertical_line
   ; draw lips
   MOV R8,  0x03 ; starting x-coordinate
   MOV R7,  0x19 ; starting y-coordinate
   MOV R9,  0x0B ; ending x-coordinate
   CALL draw_horizontal_line
   RET

draw_smile:
   CALL draw_face
   ; draw right dot
   MOV R8,  0x03 ; x-coordinate
   MOV R7,  0x18 ; y-coordinate
   CALL draw_dot
   ; draw right dot
   MOV R8,  0x0A ; x-coordinate
   MOV R7,  0x18 ; y-coordinate
   CALL draw_dot
   RET

draw_frown:
   CALL draw_face
   ; draw right dot
   MOV R8,  0x03 ; x-coordinate
   MOV R7,  0x1a ; y-coordinate
   CALL draw_dot
   ; draw right dot
   MOV R8,  0x0A ; x-coordinate
   MOV R7,  0x1a ; y-coordinate
   CALL draw_dot
   RET

draw_win:
   CLI
   ; draw the W
   ; draw left line
   MOV R6,  C_WHITE ; blue
   MOV R8,  0x01 ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x06 ; ending y-coordinate
   CALL draw_vertical_line
   ; draw middle line
   MOV R8,  0x03 ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x06 ; ending y-coordinate
   CALL draw_vertical_line
   ; draw right line
   MOV R8,  0x05 ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x06 ; ending y-coordinate
   CALL draw_vertical_line
   ; draw left dot
   MOV R8,  0x02 ; x-coordinate
   MOV R7,  0x06 ; y-coordinate
   CALL draw_dot
   ; draw right dot
   MOV R8,  0x04 ; x-coordinate
   MOV R7,  0x06 ; y-coordinate
   CALL draw_dot
   ; draw I
   MOV R8,  0x07 ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x06 ; ending y-coordinate
   CALL draw_vertical_line
   ; draw N
   ; draw left line
   MOV R8,  0x09 ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x06 ; ending y-coordinate
   CALL draw_vertical_line
   ; draw top line
   MOV R8,  0x09 ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x0C ; ending x-coordinate
   CALL draw_horizontal_line
   ; draw right line
   MOV R8,  0x0C ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x06 ; ending y-coordinate
   CALL draw_vertical_line
   ; draw exclamation point
   MOV R8,  0x0E ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x04 ; ending y-coordinate
   CALL draw_vertical_line
   ; draw bottom dot
   MOV R8,  0x0E ; x-coordinate
   MOV R7,  0x06 ; y-coordinate
   CALL draw_dot
   CALL draw_smile
   BRN draw_win
   RET

draw_loss:
   CLI
   ; draw the L
   MOV R6,  C_WHITE ; blue
   MOV R8,  0x01 ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x06 ; ending y-coordinate
   CALL draw_vertical_line
   MOV R8,  0x01 ; starting x-coordinate
   MOV R7,  0x06 ; starting y-coordinate
   MOV R9,  0x04 ; ending x-coordinate
   CALL draw_horizontal_line
   ; draw the O
   ; left most line
   MOV R8,  0x05 ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x06 ; ending y-coordinate
   CALL draw_vertical_line
   ; bottom line
   MOV R8,  0x05 ; starting x-coordinate
   MOV R7,  0x06 ; starting y-coordinate
   MOV R9,  0x08 ; ending x-coordinate
   CALL draw_horizontal_line
   ; top line
   MOV R8,  0x05 ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x08 ; ending x-coordinate
   CALL draw_horizontal_line
   ; right most line
   MOV R8,  0x08 ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x06 ; ending y-coordinate
   CALL draw_vertical_line
   ; draw the S
   ; top line
   MOV R8,  0x0A ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x0E ; ending x-coordinate
   CALL draw_horizontal_line
   ; middle line
   MOV R8,  0x0A ; starting x-coordinate
   MOV R7,  0x04 ; starting y-coordinate
   MOV R9,  0x0E ; ending x-coordinate
   CALL draw_horizontal_line
   ; bottom line
   MOV R8,  0x0A ; starting x-coordinate
   MOV R7,  0x06 ; starting y-coordinate
   MOV R9,  0x0E ; ending x-coordinate
   CALL draw_horizontal_line
   ; left dot
   MOV R8,  0x0A ; x-coordinate
   MOV R7,  0x03 ; y-coordinate
   CALL draw_dot
   ; right dot
   MOV R8,  0x0D ; x-coordinate
   MOV R7,  0x05 ; y-coordinate
   CALL draw_dot
   ; draw the second S
   ; top line
   MOV R8,  0x0F ; starting x-coordinate
   MOV R7,  0x02 ; starting y-coordinate
   MOV R9,  0x13 ; ending x-coordinate
   CALL draw_horizontal_line
   ; middle line
   MOV R8,  0x0F ; starting x-coordinate
   MOV R7,  0x04 ; starting y-coordinate
   MOV R9,  0x13 ; ending x-coordinate
   CALL draw_horizontal_line
   ; bottom line
   MOV R8,  0x0F ; starting x-coordinate
   MOV R7,  0x06 ; starting y-coordinate
   MOV R9,  0x13 ; ending x-coordinate
   CALL draw_horizontal_line
   ; left dot
   MOV R8,  0x0F ; x-coordinate
   MOV R7,  0x03 ; y-coordinate
   CALL draw_dot
   ; right dot
   MOV R8,  0x12 ; x-coordinate
   MOV R7,  0x05 ; y-coordinate
   CALL draw_dot
   CALL draw_frown
   BRN draw_loss
   RET

;--------------------------------------------------------------------
;-  Subroutine: get_random_square
;-
;-  Takes a random number from the random number generator and flashes a square
;-  based off the obtained number.
;-
;-  Parameters:
;-   r17  = register to compare to
;--------------------------------------------------------------------
get_random_square:
   CMP R17, UPPER_LEFT
   BRNE check_upper_right
   CALL flash_upper_left
   RET
check_upper_right:
   CMP R17, UPPER_RIGHT
   BRNE check_lower_left
   CALL flash_upper_right
   RET
check_lower_left:
   CMP R17, LOWER_LEFT
   BRNE check_lower_right
   CALL flash_lower_left
   RET
check_lower_right:
   CMP R17, LOWER_RIGHT
   BRNE get_random_square
   CALL flash_lower_right
   RET
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;-  Subroutine: draw_square
;-
;-  Draws a square starting at (r10, r11) and ending at R12 (x-coordinate) of
;-  color r6.
;-
;-  Parameters:
;-   r10  = starting x-coordinate
;-   r11  = y-coordinate
;-   r12  = ending x-coordinate
;-   r13  = ending y-coordinate
;-   r14  = color used for line
;-
;- Tweaked registers: r8,r9
;--------------------------------------------------------------------
draw_square:
   MOV R6, R14  ; blue
   MOV R8, R10  ; x-coordinate
   MOV R7, R11  ; y-coordinate
   MOV R9, R12  ; end of middle of screen
   CALL draw_horizontal_line
   BRN square_loop

square_loop:
   MOV R8, R10 ; x-coordinate
   ADD R7, 0x01
   CALL draw_horizontal_line
   CMP R7, R13
   BRNE square_loop
   RET
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;-  Subroutine: draw_horizontal_line
;-
;-  Draws a horizontal line from (r8,r7) to (r9,r7) using color in r6.
;-   This subroutine works by consecutive calls to drawdot, meaning
;-   that a horizontal line is nothing more than a bunch of dots.
;-
;-  Parameters:
;-   r8  = starting x-coordinate
;-   r7  = y-coordinate
;-   r9  = ending x-coordinate
;-   r6  = color used for line
;-
;- Tweaked registers: r8,r9
;--------------------------------------------------------------------
draw_horizontal_line:
        ;ADD    r9,0x01          ; go from r8 to r9 inclusive

draw_horiz1:
        CALL   draw_dot         ; draw tile
        ADD    r8,0x01          ; increment column (X) count
        CMP    r8,r9            ; see if there are more columns
        BRNE   draw_horiz1      ; branch if more columns
        RET
;--------------------------------------------------------------------

;---------------------------------------------------------------------
;-  Subroutine: draw_vertical_line
;-
;-  Draws a horizontal line from (r8,r7) to (r8,r9) using color in r6.
;-   This subroutine works by consecutive calls to drawdot, meaning
;-   that a vertical line is nothing more than a bunch of dots.
;-
;-  Parameters:
;-   r8  = x-coordinate
;-   r7  = starting y-coordinate
;-   r9  = ending y-coordinate
;-   r6  = color used for line
;-
;- Tweaked registers: r7,r9
;--------------------------------------------------------------------
draw_vertical_line:
         ADD    r9,0x01         ; go from r7 to r9 inclusive

draw_vert1:
         CALL   draw_dot        ; draw tile
         ADD    r7,0x01         ; increment row (y) count
         CMP    r7,R9           ; see if there are more rows
         BRNE   draw_vert1      ; branch if more rows
         RET
;--------------------------------------------------------------------

;---------------------------------------------------------------------
;- Subrountine: draw_dot
;-
;- This subroutine draws a dot on the display the given coordinates:
;-
;- (X,Y) = (r8,r7)  with a color stored in r6
;-
;- Tweaked registers: r4,r5
;---------------------------------------------------------------------
draw_dot:
           MOV   r4,r7         ; copy Y coordinate
           MOV   r5,r8         ; copy X coordinate

           AND   r5,0x3F       ; make sure top 2 bits cleared
           AND   r4,0x1F       ; make sure top 3 bits cleared

           ;--- you need bottom two bits of r4 into top two bits of r5
           LSR   r4            ; shift LSB into carry
           BRCC  bit7          ; no carry, jump to next bit
           OR    r5,0x40       ; there was a carry, set bit
           CLC                 ; freshen bit, do one more left shift

bit7:      LSR   r4            ; shift LSB into carry
           BRCC  dd_out        ; no carry, jump to output
           OR    r5,0x80       ; set bit if needed

dd_out:    OUT   r5,VGA_LADD   ; write low 8 address bits to register
           OUT   r4,VGA_HADD   ; write hi 3 address bits to register
           OUT   r6,VGA_COLOR  ; write data to frame buffer
           RET
;---------------------------------------------------------------------

;--------------------------------------------------------------
; Time Wasters
;--------------------------------------------------------------
; These methods are dedicated to forcing the CPU to slow down, take a breather,
; and let the user enjoy what our game has to offer.
;
; Delays the CPU by a certain amount of time using for loops.
;--------------------------------------------------------------
tiny_delay:
         MOV R16, 0x01
         CALL time_waster
         RET

big_time_waster: MOV R16, 0x50
         CALL time_waster
         RET

flash_delay: MOV R16, 0x30
         CALL time_waster
         RET

time_waster: MOV     R21, R16  ;set outside for loop count

outside_for: SUB     R21, 0x01

             MOV     R22, MIDDLE_CNT   ;set middle for loop count
middle_for:  SUB     R22, 0x01

             MOV     R23, INSIDE_CNT   ;set inside for loop count
inside_for:  SUB     R23, 0x01
             BRNE    inside_for

             OR      R22, 0x00         ;load flags for middle for counter
             BRNE    middle_for

             OR      R21, 0x00         ;load flags for outsde for counter value
             BRNE    outside_for
             RET
;---------------------------------------------------------------------


;--------------------------------------------------------------
; Interrupt Service Routine - Handles Interrupts from keyboard
;--------------------------------------------------------------
; Sample ISR that looks for various key presses. When a useful
; key press is found, the program does something useful. The
; code also handles the key-up code and subsequent re-sending
; of the associated scan-code.
; - write some_null_value to R2 to represent something that nothing is being pressed
; Tweaked Registers; r2,r3,r15
;--------------------------------------------------------------
ISR:
         CMP   r15, int_flag        ; check key-up flag
         BRNE  continue
         MOV   r15, 0x00            ; clean key-up flag
         BRN   reset_ps2_register

continue: IN    r2, PS2_KEY_CODE     ; get keycode data

select_upper_left:
         CMP r2, K_UPPER_LEFT
         BRNE select_upper_right
         CALL flash_upper_left
         MOV r0, UPPER_LEFT
         BRN reset_ps2_register

select_upper_right:
         CMP r2, K_UPPER_RIGHT
         BRNE select_lower_left
         CALL flash_upper_right
         MOV r0, UPPER_RIGHT
         BRN reset_ps2_register

select_lower_left:
         CMP r2, K_LOWER_LEFT
         BRNE select_lower_right
         CALL flash_lower_left
         MOV r0, LOWER_LEFT
         BRN reset_ps2_register

select_lower_right:
         CMP r2, K_LOWER_RIGHT
         BRNE key_up_check
         CALL flash_lower_right
         MOV r0, LOWER_RIGHT
         BRN reset_ps2_register

key_up_check:
          CMP   r2,KEY_UP            ; look for key-up code
          BRNE  reset_ps2_register   ; branch if not found

set_skip_flag:
          ADD   r15, 0x01            ; indicate key-up found

reset_ps2_register:                  ; reset PS2 register
          MOV    r3, 0x01
          OUT    r3, PS2_CONTROL
          MOV    r3, 0x00
          OUT    r3, PS2_CONTROL
          RETIE
;-------------------------------------------------------------------

;---------------------------------------------------------------------
; interrupt vector
;---------------------------------------------------------------------
.CSEG
.ORG 0x3FF
BRN   ISR
;---------------------------------------------------------------------

