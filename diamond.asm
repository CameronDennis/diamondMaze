;Cameron Dennis ECE 109 (001)
;This program allows you to navigate through a maze and change the color of your diamond
;Navigate with WASD, change colors with space,rgby
;Quit with q
;There's supposed to be a timer, but it's broke.
            .ORIG x3000
;Main Block: Where all the subroutines are called
START       LD R0, TIMEINT
            LD R1, PULSE
            STR R1, R0, #0
            JSR CLEAR
            JSR DMAZE
            JSR DLINES
            LD R5, INITDIAX
            LD R6, INITDIAY
            LEA R0, DIAMCOORD
            STR R5, R0, #0          ;Stores initial coords in DIAMCOORD
            STR R6, R0, #1
            LEA R0, COLOR
            LD R1, BLU
            STR R1, R0, #0
            JSR DDIAM
POLLB       JSR TIMER
            LDI R0, KBSRPtr         ;Checks for value in keyboard register
            BRzp POLLB
            LDI R0, KBDRPtr         ;Loads value from keyboard register in R0
            JSR POLLING
            JSR TIMER
            BRnzp POLLB


END         ADD R6, R6, #1
            HALT


;Clears Screen
;Uses R0, R1, R2
;Nothing passed in
;No outputs
CLEAR       LD R0, BLK          ;Loads black into R0
            LD R1, TOPLEFT      ;Loads first pixel address of screen in R1
            BRnzp DRAWC
ADDC        ADD R1, R1, #1
DRAWC       STR R0, R1, #0      ;Stores color in screen
            LD R2, BOTRIGH      ;Loads bottom right coordinate into R2
            NOT R2, R2
            ADD R2, R2, #1      ;Inverts bot right for check
            ADD R2, R2, R1
            BRnp ADDC
            RET

;Draws Maze
;Uses R0, R1, R2
;Nothing passed in
;No outputs
DMAZE       LD R0, WAL
            LD R1, MAZEL1       ;Loads in line address 1
            BRnzp DRAWM1
ADDM1       ADD R1, R1, #1
DRAWM1      STR R0, R1, #0
            LD R2, MAZEL1E      ;Loads in end line address 1
            NOT R2, R2
            ADD R2, R2, #1      ;Inverts for check
            ADD R2, R2, R1
            BRnp ADDM1
            LD R1, MAZEL2       ;Loads in line address 2
            BRnzp DRAWM2
ADDM2       ADD R1, R1, #1
DRAWM2      STR R0, R1, #0
            LD R2, MAZEL2E      ;Loads in end line address 2
            NOT R2, R2
            ADD R2, R2, #1      ;Inverts for check
            ADD R2, R2, R1
            BRnp ADDM2
            LD R1, MAZEL3       ;Loads in line address 3
            BRnzp DRAWM3
ADDM3       ADD R1, R1, #1
DRAWM3      STR R0, R1, #0
            LD R2, MAZEL3E      ;Loads in end line address 3
            NOT R2, R2
            ADD R2, R2, #1      ;Inverts for check
            ADD R2, R2, R1
            BRnp ADDM3
            LD R1, MAZEL4       ;Loads in line address 4
            BRnzp DRAWM4
ADDM4       ADD R1, R1, #1
DRAWM4      STR R0, R1, #0
            LD R2, MAZEL4E      ;Loads in end line address 4
            NOT R2, R2
            ADD R2, R2, #1      ;Inverts for check
            ADD R2, R2, R1
            BRnp ADDM4
            RET

;Draws Start and End Lines
;Uses R0, R1, R2, R3
;Nothing passed in
;No outputs
DLINES      LD R0, ORA          ;Loads orange into R0
            LD R1, STARTL       ;Loads first pixel address of the start line into R1
            LD R3, YAXIS        ;Loads y-incrementor into R3
            BRnzp DRAWLS
ADDLS       ADD R1, R1, R3
DRAWLS      STR R0, R1, #0
            LD R2, STARTLE
            NOT R2, R2
            ADD R2, R2, #1      ;Inverts for check
            ADD R2, R2, R1
            BRnp ADDLS
            LD R0, RDE          ;Loads orange into R0
            LD R1, FINISHL      ;Loads first pixel address of the start line into R1
            BRnzp DRAWLE
ADDLE       ADD R1, R1, R3
DRAWLE      STR R0, R1, #0
            LD R2, FINISHLE
            NOT R2, R2
            ADD R2, R2, #1      ;Inverts for check
            ADD R2, R2, R1
            BRnp ADDLE
            RET

;Draws Diamond
;Uses R0, R1, R2, R3, R4
;Passes in [R5 (x-pos), R6 (y-pos) from DIAMCOORD]used in COORDCALC, and R4 from COORDCALC
;No outputs
DDIAM       LEA R0, DIASTORE    ;Stores PC
            STR R7, R0, #0
            LEA R0, DIAMCOORD
            LDR R5, R0, #0
            LDR R6, R0, #1
            JSR COORDCALC
            LD R7, DIASTORE     ;Reloads PC
            LD R0, COLOR        ;Loads COLOR into R0
            STR R0, R4, #-1
            STR R0, R4, #0
            STR R0, R4, #1      ;^^draws horizontal
            LD R1, YAXIS
            ADD R4, R4, R1
            STR R0, R4, #0      ;Draws bottom pixel
            ADD R1, R1, R1      ;Doubles YINC
            NOT R1, R1
            ADD R1, R1, #1      ;Inverts 2*YINC
            ADD R4, R4, R1
            STR R0, R4, #0      ;Draws Top pixel
            RET

;Calculates Display Address of Pixel based on coordinates
;Uses R0, R4, R5, R6
;Passes in R5 (x-pos) Preserves, R6 (y-pos) Preserves
;Outputs in R4
COORDCALC   LEA R0, COORDSTORE
            STR R5, R0, #0      ;Stores X Coord
            STR R6, R0, #1      ;Stores Y Coord
            LD R4, TOPLEFT      ;Loads first display coord into R4
            LD R0, YAXIS
ADDYC       ADD R4, R0, R4      ;Increments by the Y Coord
            ADD R6, R6, #-1
            BRnp ADDYC
            ADD R4, R4, R5      ;Increments by the X Coord
            LEA R0, COORDSTORE
            LDR R5, R0, #0      ;Loads X Coord into R5
            LDR R6, R0, #1      ;Loads Y Coord into R6
            RET

;Continuous Polling Loop
;Uses R0, R1,
;Passes in R0, which contains keyboard press
;Branches to other SR depending on pressed key
POLLING     LD R1, REDC
            ADD R1, R1, R0          ;Checks for r to change to RED
            BRnp GG
            LEA R0, COLOR
            LD R1, RED
            STR R1, R0, #0          ;Stores RED in COLOR
            BRnzp REDRAW
GG          LD R1, GRNC
            ADD R1, R1, R0          ;Checks for g to change to GRN
            BRnp BB
            LEA R0, COLOR
            LD R1, GRN
            STR R1, R0, #0          ;Stores GRN in COLOR
            BRnzp REDRAW
BB          LD R1, BLUC
            ADD R1, R1, R0          ;Checks for b to change to BLU
            BRnp YY
            LEA R0, COLOR
            LD R1, BLU
            STR R1, R0, #0          ;Stores BLU in COLOR
            BRnzp REDRAW
YY          LD R1, YELC
            ADD R1, R1, R0          ;Checks for y to change to YEL
            BRnp WW
            LEA R0, COLOR
            LD R1, YEL
            STR R1, R0, #0          ;Stores YEL in COLOR
            BRnzp REDRAW
WW          LD R1, WHTC
            ADD R1, R1, R0          ;Checks for space to change to WHT
            BRnp QUIT
            LEA R0, COLOR
            LD R1, WHT
            STR R1, R0, #0          ;Stores WHT in COLOR
            BRnzp REDRAW

QUIT        LD R1, QUIC
            ADD R1, R1, R0          ;Checks for q to quit
            BRz END

;HERE IS THE NEXT CHECK AREA FOR MOVEMENT, BREAK TO SUBROUTINES FOR CAN I MOVE HERE

UP          LD R1, UPC
            ADD R1, R1, R0
            BRnp DOWN
            ADD R6, R6, #-2          ;Increment new position
            ADD R0, R6, #-1          ;Checks for OOB
            BRn RETURN
            LEA R0, MOVESTORE       ;Stores PC
            STR R7, R0, #0
            JSR MOVE
            LD R7, MOVESTORE        ;Reloads PC
            RET

DOWN        LD R1, DNC
            ADD R1, R1, R0
            BRnp RIGHT
            ADD R6, R6, #2          ;Increment new position
            ADD R0, R6, #1
            LD R2, OOBYC
            ADD R0, R0, R2          ;Checks for OOB
            BRp RETURN
            LEA R0, MOVESTORE       ;Stores PC
            STR R7, R0, #0
            JSR MOVE
            LD R7, MOVESTORE        ;Reloads PC
            RET

RIGHT       LD R1, RTC
            ADD R1, R1, R0
            BRnp LEFT
            ADD R5, R5, #2          ;Increment new position
            ADD R0, R5, #1
            LD R2, OOBXC
            ADD R0, R0, R2          ;Checks for OOB
            BRp RETURN
            LEA R0, MOVESTORE       ;Stores PC
            STR R7, R0, #0
            JSR MOVE
            LD R7, MOVESTORE        ;Reloads PC
            RET

LEFT        LD R1, LTC
            ADD R1, R1, R0
            BRnp RETURN
            ADD R5, R5, #-2          ;Increment new position
            ADD R0, R5, #-1          ;Checks for OOB
            BRn RETURN
            LEA R0, MOVESTORE       ;Stores PC
            STR R7, R0, #0
            JSR MOVE
            LD R7, MOVESTORE        ;Reloads PC
            RET



REDRAW      LEA R0, POLLSTORE       ;Stores PC
            STR R7, R0, #0
            JSR DDIAM
            LD R7, POLLSTORE        ;Reloads PC
            RET

;Initials
INITDIAX    .FILL #5
INITDIAY    .FILL #110


;Keyboard Registers
KBSRPtr     .FILL xFE00
KBDRPtr     .FILL xFE02

;Timer
TIMEINT     .FILL xFE0A
TIMETICK    .FILL xFE08
TIMERON     .BLKW 1
TIMERSTART  .BLKW 1
TIMERHOLD   .BLKW 1
STARTLOC    .FILL x3000
PULSE       .FILL #100
TIMOFF      .FILL x8000

;Colors
WHT         .FILL x7FFF
BLK         .FILL x0000
RED         .FILL x7C00
RDE         .FILL x7C01
GRN         .FILL x03E0
BLU         .FILL x001F
YEL         .FILL x7FED
ORA         .FILL xFAED
WAL         .FILL xFBE1

;Addresses
TOPLEFT     .FILL xC000
BOTRIGH     .FILL xFDFF

MAZEL1      .FILL xCC0A
MAZEL1E     .FILL xCC7F
MAZEL2      .FILL xD880
MAZEL2E     .FILL xD8F5
MAZEL3      .FILL xE50A
MAZEL3E     .FILL xE57F
MAZEL4      .FILL xF180
MAZEL4E     .FILL xF1F5

STARTL      .FILL xF20A
STARTLE     .FILL xFD8A
FINISHL     .FILL xC075
FINISHLE    .FILL xCBF5


;Incrementation
YAXIS       .FILL x0080
NEG10       .FILL #-10
NEG100      .FILL #-100
NEG1000     .FILL #-1000
POS10       .FILL #10
POS100      .FILL #100
POS1000     .FILL #1000

;Storage
DIAMCOORD   .BLKW 2
COLOR       .BLKW 1
DIASTORE    .BLKW 1     ;R7
POLLSTORE   .BLKW 1     ;R7
MOVESTORE   .BLKW 1     ;R7
MOVESTORE1  .BLKW 1     ;R7
MOVESTORE2  .BLKW 1     ;R7
AHHHSTORE   .BLKW 1     ;R7
TIMESTORE   .BLKW 1     ;R7
COORDSTORE  .BLKW 2
RSTORA      .BLKW 7
TEMPSTORE   .BLKW 2     ;X&Y
TESTHOLD    .BLKW 1
OUTPUT      .BLKW 4     ;Output number

;Checks
;colors
REDC    .FILL xFF8E
GRNC    .FILL xFF99
BLUC    .FILL xFF9E
YELC    .FILL xFF87
WHTC    .FILL xFFE0
QUIC    .FILL xFF8F
STAC    .FILL x0513
FINC    .FILL x83FF
;movement
UPC     .FILL xFF89
DNC     .FILL xFF8D
RTC     .FILL xFF9C
LTC     .FILL xFF9F
;OOB
OOBXC   .FILL xFF81
OOBYC   .FILL xFF85
WALC    .FILL x041F


;Turns on timer if TIMERSTART is positive
;Uses R0, R1, R2, R3
;Passes in nothing
TIMER       LD R0, TIMERSTART
            BRz RETURN
            BRn PRINTOUT
            LDI R0, TIMETICK
            BRn TIMERN
            RET
TIMERN      LD R0, TIMERHOLD
            ADD R0, R0, #1
            ST R0, TIMERHOLD
            LEA R0, TIMETICK
            AND R1, R1, #0
            STR R1, R0, #0
            RET
PRINTOUT    LD R0, TIMETICK
            LD R1, NEG1000
            AND R2, R2, #0
ITER1000    ADD R0, R0, R1
            BRn FIX1000
            ADD R2, R2, #1
            BRnzp ITER1000
FIX1000     LD R1, POS1000
            ADD R0, R0, R1
            LEA R1, OUTPUT
            STR R2, R1, #0
            LD R1, NEG100
            AND R2, R2, #0
ITER100     ADD R0, R0, R1
            BRn FIX100
            ADD R2, R2, #1
            BRnzp ITER100
FIX100      LD R1, POS100
            ADD R0, R0, R1
            LEA R1, OUTPUT
            STR R2, R1, #1
            LD R1, NEG10
            AND R2, R2, #0
ITER10      ADD R0, R0, R1
            BRn FIX10
            ADD R2, R2, #1
            BRnzp ITER10
FIX10       LD R1, POS10
            ADD R0, R0, R1
            LEA R1, OUTPUT
            STR R2, R1, #2
            AND R2, R2, #0
ITER1       ADD R0, R0, #1
            ADD R2, R2, #1
            BRz FINALPRINT
            BRnzp ITER1

FINALPRINT  LEA R1, OUTPUT
            STR R2, R1, #3



            AND R0, R0, #0
            AND R1, R1, #0
            AND R2, R2, #0
            AND R3, R3, #0
            AND R4, R4, #0
            AND R5, R5, #0
            AND R6, R6, #0
            AND R7, R7, #0
            ST R0, TIMERON
            ST R0, TIMERSTART
            ST R0, TIMERHOLD
            LD R0, STARTLOC
            JMP R0


;Checks for walls, if no walls, SR to clear previous diamond, changes position, SR to draw lines, SR to draw new diamond
;Uses R0, R1, R4, R5, R6
;Passes in R4, R5, R6
;Outputs new coordinates stored
MOVE        LEA R0, MOVESTORE1
            STR R7, R0, #0
            JSR COORDCALC           ;Calculates Coordinates of new center position, places in R4
            LD R7, MOVESTORE1
            LD R0, WALC
            LDR R1, R4, #-1
            ADD R1, R0, R1          ;Checking left middle pixel for wall
            BRz RETURN
            LD R0, WALC
            LDR R1, R4, #0
            ADD R1, R0, R1          ;Checking middle pixel for wall
            BRz RETURN
            LD R0, WALC
            LDR R1, R4, #1
            ADD R1, R0, R1          ;Checking right middle pixel for wall
            BRz RETURN
            LD R0, WALC
            LD R1, YAXIS
            ADD R4, R1, R4
            LDR R1, R4, #0
            ADD R1, R0, R1          ;Checking bottom pixel for wall
            BRz RETURN
            LD R0, WALC
            LD R1, YAXIS
            ADD R1, R1, R1
            NOT R1, R1
            ADD R1, R1, #1
            ADD R4, R1, R4
            LDR R1, R4, #0
            ADD R1, R0, R1          ;Checking top pixel for wall
            BRz RETURN

            LD R0, STAC
            LDR R1, R4, #0
            ADD R1, R0, R1          ;Checking middle pixel for start line
            BRz STARTTIME

            LD R0, STAC
            LDR R1, R4, #1
            ADD R1, R0, R1          ;Checking right middle pixel for start line
            BRz STARTTIME

            LD R0, FINC
            LDR R1, R4, #0
            ADD R1, R0, R1          ;Checking middle pixel for end line
            BRz ENDTIME

            LD R0, FINC
            LDR R1, R4, #1
            ADD R1, R0, R1          ;Checking right middle pixel for end line
            BRz ENDTIME

HERE        LEA R0, MOVESTORE2       ;Stores PC
            STR R7, R0, #0
            JSR CLEARDIAM
            LD R7, MOVESTORE2        ;Reloads PC
            LEA R0, MOVESTORE2       ;Stores PC
            STR R7, R0, #0
            JSR DLINES
            LD R7, MOVESTORE2        ;Reloads PC
            LEA R0, MOVESTORE2       ;Stores PC
            STR R7, R0, #0
            JSR DDIAM
            LD R7, MOVESTORE2        ;Reloads PC
            RET

RETURN      LEA R0, DIAMCOORD
            LDR R5, R0, #0
            LDR R6, R0, #1
            RET

STARTTIME   LEA R0, TIMERSTART
            LD R3, TIMERSTART
            BRp HERE
            ADD R3, R3, #1
            STR R3, R0, #0
            BRnzp HERE

ENDTIME     LEA R0, TIMERSTART
            LD R1, TIMOFF
            STR R1, R0, #0
            BRnzp HERE



;Clears previous diamond
;Uses R0, R1, R3, R4, R5, R6
;Passes in R0, R1, which contains old coordinates, R5, R, which contains new coordinates
CLEARDIAM   LEA R0, DIAMCOORD
            LDR R1, R0, #1
            LDR R0, R0, #0      ;Loads X and Y of previous diamond into R0 and R1
            LEA R3, TEMPSTORE
            STR R5, R3, #0
            STR R6, R3, #1      ;Stores updated coordinates
            ADD R5, R0, #0
            ADD R6, R1, #0
            LEA R0, AHHHSTORE
            STR R7, R0, #0
            JSR COORDCALC
            LD R7, AHHHSTORE    ;Reloads PC
            LD R0, BLK          ;Loads COLOR into R0
            STR R0, R4, #-1
            STR R0, R4, #0
            STR R0, R4, #1      ;^^draws horizontal
            LD R1, YAXIS
            ADD R4, R4, R1
            STR R0, R4, #0      ;Draws bottom pixel
            ADD R1, R1, R1      ;Doubles YINC
            NOT R1, R1
            ADD R1, R1, #1      ;Inverts 2*YINC
            ADD R4, R4, R1
            STR R0, R4, #0      ;Draws Top pixel
            LEA R0, TEMPSTORE
            LDR R5, R0, #0
            LDR R6, R0, #1
            LEA R0, DIAMCOORD
            STR R5, R0, #0
            STR R6, R0, #1
            RET



TESTSTRING  .STRINGZ "1 for start, 2 for end"
