\ -----------------------------------------------------------------------------
\  Pixel - simulation of old school screen 320 x 200 V1.0
\  with OpenGl for ForthWin
\  For demo enter : star-wars
\ -----------------------------------------------------------------------------


\ S" lib\include\float2.f" INCLUDED



MODULE: HIDDEN  \   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

WINAPI: CreateWindowExA		USER32.DLL
WINAPI: GetSystemMetrics	USER32.DLL
WINAPI: GetDC			USER32.DLL
WINAPI: ReleaseDC		USER32.DLL
WINAPI: ShowCursor		USER32.DLL
WINAPI: GetAsyncKeyState	USER32.DLL

WINAPI: ChoosePixelFormat	GDI32.DLL
WINAPI: SetPixelFormat		GDI32.DLL
WINAPI: SwapBuffers		GDI32.DLL

WINAPI: wglCreateContext	OPENGL32.DLL
WINAPI: wglMakeCurrent		OPENGL32.DLL
WINAPI: glHint			OPENGL32.DLL
WINAPI: glMatrixMode		OPENGL32.DLL
WINAPI: glClear			OPENGL32.DLL
WINAPI: glLoadIdentity		OPENGL32.DLL
WINAPI: glTranslated		OPENGL32.DLL
WINAPI: glPointSize		OPENGL32.DLL
WINAPI: glBegin			OPENGL32.DLL
WINAPI:	glVertex2d		OPENGL32.DLL
WINAPI:	glEnd			OPENGL32.DLL
WINAPI: glColor3b		OPENGL32.DLL
WINAPI: glRotated		OPENGL32.DLL
WINAPI: glLineWidth		OPENGL32.DLL
WINAPI: glPolygonMode		OPENGL32.DLL
WINAPI: glEnable		OPENGL32.DLL
WINAPI: glDisable		OPENGL32.DLL

WINAPI: gluPerspective		GLU32.DLL

0
2 -- nSize
2 -- nVersion
CELL -- dwFlags
1 -- iPixelType
1 -- cColorBits
1 -- cRedBits
1 -- cRedShift
1 -- cGreenBits
1 -- cGreenShift
1 -- cBlueBits
1 -- cBlueShift
1 -- cAlphaBits
1 -- cAlphaShift
1 -- cAccumBits
1 -- cAccumRedBits
1 -- cAccumGreenBits
1 -- cAccumBlueBits
1 -- cAccumAlphaBits
1 -- cDepthBits
1 -- cStencilBits
1 -- cAuxBuffers
1 -- iLayerType
1 -- bReserved
CELL -- dwLayerMask
CELL -- dwVisibleMask
CELL -- dwDamageMask
CONSTANT PIXELFORMATDESCRIPTOR
0 VALUE pfd		\ structure for opengl
PIXELFORMATDESCRIPTOR ALLOCATE THROW TO pfd
0x25 pfd dwFlags !
32 pfd cColorBits C!
pfd FREE THROW

0 VALUE glhandle	\ handle window
0 VALUE glhdc		\ context handle

EXPORT

0.0E FVALUE X		\ x coordinate
0.0E FVALUE Y		\ Y coordinate
0.0E FVALUE X1		\ x1
0.0E FVALUE Y1		\ y1
0.0E FVALUE X2		\ x2
0.0E FVALUE Y2		\ y2
0.0E FVALUE X3		\ x3
0.0E FVALUE Y3		\ y3


\ The height of the screen image in pixels
: VScreen ( -> n )
	1 GetSystemMetrics ;

\ Screen width in pixels
: HScreen ( -> n )
	0 GetSystemMetrics ;
\ Cls
\
\ Number of float from float stack to data stack
: F>FL  ( -> f ) ( F: f -> )
	[
	0x8D C, 0x6D C, 0xFC C,
	0xD9 C, 0x5D C, 0x00 C,
	0x87 C, 0x45 C, 0x00 C,
	0xC3 C, ] ;

\ Number of float from float stack to data stack
: F>DL ( -> d ) ( F: f -> )
	FLOAT>DATA SWAP ;

\ Convert number on stack to float
: S>FL ( n -> f )
	DS>F F>FL ;

\ Convert number on stack to double
: S>DL ( n -> d )
	DS>F F>DL ;

\ Aspect ratio of width and height
: AScreen ( -> d )
	HScreen DS>F VScreen S>D D>F F/ F>DL ;

\ Output the specified number of lines on the screen (from point to 4)
: LineLoop ( n -> )
	DUP 0 > IF Y F>DL X F>DL glVertex2d DROP THEN
	DUP 1 > IF Y1 F>DL X2 F>DL glVertex2d DROP THEN
	DUP 2 > IF Y2 F>DL X2 F>DL glVertex2d DROP THEN
	DUP 3 > IF Y3 F>DL X3 F>DL glVertex2d DROP THEN
	DROP ;


\ Show cursor on screen
: ShowCursore ( -> )
	1 ShowCursor DROP ;

\ Hide screen cursor
: HideCursore ( -> )
	0 ShowCursor DROP ;

\ Output
: glClose ( -> )
	glhdc glhandle ReleaseDC 0 ExitProcess ;


: glClose2 ( -> )
	glhdc glhandle ReleaseDC  ;  \  0 ExitProcess ;

\ Checks if a key is pressed by a given code
\ : key ( n -- flag )
\	GetAsyncKeyState ;


\ &&&&&&&&&&&&&&&&&&&&&       SCREEN  SIZE   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
\ &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
\ Initialize gl window
: glOpen ( -> )
  600 800 0 0  VScreen  2 /   HScreen   2 /  40 40 \ border
  0x90000000 S" edit" DROP DUP 8 CreateWindowExA
   \  WILL OPEN AT 1/4 SCREEN TOP LEFT
  \ 0 0 800 660 VScreen HScreen 0 0 0x90000000 S" edit" DROP DUP 8 CreateWindowExA

  \  TO MAKE  FULL SCREEN  USE THIS LINE :
\ 0  0  0 0  VScreen  ( 2 /  )  HScreen  ( 2 / )  0 0 0x90000000 S" edit" DROP DUP 8 CreateWindowExA
\ &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
\ &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&



 DUP TO glhandle GetDC TO glhdc
 pfd DUP glhdc ChoosePixelFormat glhdc SetPixelFormat DROP
 glhdc wglCreateContext glhdc wglMakeCurrent DROP
 0x1102 0xC50 glHint DROP
 0x1701 glMatrixMode DROP
 100 S>DL 1 DS>F 10 DS>F F/ F>DL AScreen 90 S>DL gluPerspective DROP
 0x1700 glMatrixMode DROP ;

\ Clear image buffer
: Cls ( -> )
	0x4000 glClear DROP ;

 \ Show image buffer (where we drew)
: View ( -> )
	glhdc SwapBuffers DROP
	Cls
	;

\ The unit matrix
: SingleMatrix ( -> )
	glLoadIdentity DROP ;


\ Shifts the current matrix by a vector (x, y, z).
: ShiftMatrix ( F: f f f -> )
	F>DL F>DL F>DL glTranslated DROP ;

\ Point size
: PointSize ( n -> )
	S>FL glPointSize DROP ;


\  DUP 0 > IF Y F>DL X F>DL glVertex2d DROP THEN

\  Display 2D point on the screen (X, Y)
: Point ( -> )
	0 glBegin DROP 1 LineLoop glEnd DROP ;

\ SET COLOR  (B G R)
: Color ( n n n -> )
	glColor3b DROP ;

\  Rotates the current matrix at a given angle around the specified vector.
\ z y x angle
: RotatedMatrix ( F: f f f f -> )
	F>DL F>DL F>DL F>DL glRotated DROP ;

\ \ Output 2D line (X, Y, X1, Y1)
: Line ( -> )
	1 glBegin DROP
	Y F>DL X F>DL glVertex2d DROP
	Y1 F>DL X1 F>DL glVertex2d DROP
	glEnd DROP ;

\ Draw line width
: LineSize ( n -> )
	S>FL glLineWidth DROP ;

\ Print 2D triangle (X,Y,X1,Y1,X2,Y2)
: Triangle ( -> )
	4 glBegin DROP
	Y F>DL X F>DL glVertex2d DROP
	Y1 F>DL X1 F>DL glVertex2d DROP
	Y2 F>DL X2 F>DL glVertex2d DROP
	glEnd DROP ;

\ Drawing shapes with a wire style
: GlLine ( -> )
	0x1B01 0x408 glPolygonMode DROP ;

\ Drawing shapes painted style
: GlFill ( -> )
	0x1B02 0x408 glPolygonMode DROP ;

\ 2D rectangle (X,Y,X1,Y1)
: Rectangle ( -> )
	7 glBegin DROP
	Y F>DL X F>DL glVertex2d DROP
	Y F>DL X1 F>DL glVertex2d DROP
	Y1 F>DL X1 F>DL glVertex2d DROP
	Y1 F>DL X F>DL glVertex2d DROP
	glEnd DROP ;

\ Smoothing
: Smoothing ( -> )
	0xB10 glEnable DROP ;

\ Remove smoothing
: NoSmoothing ( -> )
	0xB10 glDisable DROP ;

\ 2D quadrilateral (X,Y,X1,Y1,X2,Y2,X3,Y3)
: Tetragon ( -> )
	7 glBegin DROP
	Y F>DL X F>DL glVertex2d DROP
	Y1 F>DL X1 F>DL glVertex2d DROP
	Y2 F>DL X2 F>DL glVertex2d DROP
	Y3 F>DL X3 F>DL glVertex2d DROP
	glEnd DROP ;

\ 2D angle (X,Y,X1,Y1,X2,Y2)
: Corner ( -> )
	3 glBegin DROP
	Y F>DL X F>DL glVertex2d DROP
	Y1 F>DL X1 F>DL glVertex2d DROP
	Y2 F>DL X2 F>DL glVertex2d DROP
	glEnd DROP ;

\ STARTLOG

;MODULE  \ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


0 VALUE msec					\ for synchronization
0 VALUE msei
0.0E FVALUE theta				\ matrix rotation angle

\ \ Checks if a key is pressed and return value of the key
: ReadKey ( -- n )
BEGIN
	key? if key exit then
AGAIN ;

: S>F    S>D D>F ;         \ *******  this is very important  !!!
\ ----------------------------------------------------------------


: Dessin   \ start the routine

\ --------------------------------------: main ( -- )
       glOpen
          GlLine
              Smoothing
                   HideCursore
                         SingleMatrix
           0.0E 0.0E -5.0E ShiftMatrix
              theta 0.0E 0.0E 1.0E RotatedMatrix
                  TIMER@ DROP TO msei  msei msec <> IF   msei TO msec
      Cls
;


\ ==================== Random ====================================

WINAPI: GetTickCount KERNEL32.DLL

variable seed
GetTickCount seed !


: Random    ( -- x )  \ return a 32-bit random number x
    seed @
    dup 13 lshift xor
    dup 17 rshift xor
    dup 5  lshift xor
    dup seed !
    um* nip
;
\ ==================================================================

\ =========================================
\ Retro console
\ 320 x 200
\ =========================================
\ basic retro colors

: green ( -- ) \ light-green
	0 100 0 Color ;

: dark-green ( -- )
	0 300 0 Color ;

: red ( -- )
	0 0 100 Color ;

: blue ( -- )
	100 0 0 Color ;

: cyan ( -- )
	100 100 0 Color ;

: yellow ( -- )
	0 100 100 Color ;

: pink ( -- )
	100 20 100 Color ;

: orange ( -- )
	0 75 100 Color ;

: white ( -- )
	100 100 100 Color ;

: black ( -- )
	0 0 0 Color ;

: set-screen \ show the screen and set pixel dimension
Dessin 3 dup LineSize PointSize \ dimension of the pixel and line
;

: pixel ( X Y -- ) \ Draw one pixel
    s>d d>f 20e  f/ 50e-1 f- fto  Y            \  X
    s>d d>f 20e  f/ 80e-1 f- fto  X            \ Y déplace 1/4
	Point
 ;

: draw-line ( X Y X1 Y1 -- )
	s>d d>f 20e  f/ 50e-1 f- fto  Y1
    s>d d>f 20e  f/ 80e-1 f- fto  X1
    s>d d>f 20e  f/ 50e-1 f- fto  Y
    s>d d>f 20e  f/ 80e-1 f- fto  X
	Line
 ;
: draw-rectangle ( X Y X1 Y1 -- )
	s>d d>f 20e  f/ 50e-1 f- fto  Y1
    s>d d>f 20e  f/ 80e-1 f- fto  X1
    s>d d>f 20e  f/ 50e-1 f- fto  Y
    s>d d>f 20e  f/ 80e-1 f- fto  X
	Rectangle
;

: draw-triangle ( X Y X1 Y1 -- )
	s>d d>f 20e  f/ 50e-1 f- fto  Y2
    s>d d>f 20e  f/ 80e-1 f- fto  X2
	s>d d>f 20e  f/ 50e-1 f- fto  Y1
    s>d d>f 20e  f/ 80e-1 f- fto  X1
    s>d d>f 20e  f/ 50e-1 f- fto  Y
    s>d d>f 20e  f/ 80e-1 f- fto  X
	Triangle
;
\ ================ Circle and Ellipse ============================
\ variables for plotting circle
0 value PC_X
0 value PC_Y
0 value CX
0 value CY
0 value R
0 value pc_d

: DrawCircle

CX PC_X +   CY PC_Y +  pixel
CX PC_X -   CY PC_Y +  pixel
CX PC_X -   CY PC_Y -  pixel
CX PC_X +   CY PC_Y -  pixel
CX PC_Y +   CY PC_X +  pixel
CX PC_Y -   CY PC_X +  pixel
CX PC_Y -   CY PC_X -  pixel
CX PC_Y +   CY PC_X -  pixel
;

: Bresenham-Cercle
0 TO PC_X
R TO PC_Y
3 2 R * - to pc_d \ pc_d = 3-2*R
DrawCircle

BEGIN
   PC_Y PC_X < NOT \ WHILE PC_Y >= PC_X
WHILE
     \ For each pixel we will draw 8 pixels
     PC_X 1+ TO PC_X   \ PC_X = PC_X+1
     \ check for decision parameter and correspondingly update d, PC_X and PC_Y
     pc_d 0 >   \ if pc_d>0
     if
       PC_Y 1- TO PC_Y \ PC_Y = PC_Y -1
       pc_d 4  PC_X PC_Y - * + 10 + to pc_d  \ pc_d = pc_d + 4*(PC_X - PC_Y) + 10
     else
       pc_d 4 PC_X * 6 + + to pc_d   \ pc_d = pc_d + 4*PC_X + 6
     then
     DrawCircle
REPEAT ;

\ =====================================
\ variables for plotting ellipse
0 value Xchange
0 value Ychange
0 value PE_X
0 value PE_Y
0 value EllipseError
0 value TwoASquare
0 value TwoBSquare
0 value StoppingX
0 value StoppingY
0 value Xradius
0 value Yradius


0e0  fvalue xn  0e0 fvalue yn


create sinus
     0 ,  1745 ,  3490 ,  5234 ,  6976 ,  8716 , 10453 , 12187 , 13917 ,
 15643 , 17365 , 19081 , 20791 , 22495 , 24192 , 25882 , 27564 , 29237 ,
 30902 , 32567 , 34202 , 35837 , 37461 , 39073 , 40674 , 42262 , 43837 ,
 45399 , 46947 , 48481 , 50000 , 51504 , 52992 , 54464 , 55919 , 57358 ,
 58779 , 60182 , 61566 , 62932 , 64279 , 65606 , 66913 , 68200 , 69466 ,
 70711 , 71934 , 73135 , 74314 , 75471 , 76604 , 77715 , 78801 , 79864 ,
 80902 , 81915 , 82904 , 83867 , 84805 , 85717 , 86603 , 87462 , 88295 ,
 89101 , 89879 , 90631 , 91355 , 92050 , 92718 , 93358 , 93969 , 94552 ,
 95106 , 95630 , 96126 , 96593 , 97030 , 97437 , 97815 , 98163 , 98481 ,
 98769 , 99027 , 99255 , 99452 , 99619 , 99756 , 99863 , 99939 , 99985 ,
100000 ,

: (sinus)  4 * sinus + @ ;   ( angle - unsigned_sin*100000 )

: sin  ( angle - sin*100000 )
   dup abs dup
   360 > if  360 mod
         then dup
         91 < if (sinus)                                 \ < 90
              else dup 181 <
                   if 180 - abs (sinus)                   \ 91 - 179
                   else dup 271 <
                        if 180 - (sinus) negate            \ 180 - 269
                        else 360 - abs (sinus) negate      \ 270 - 360
                        then
                    then
                then
   swap 0< if negate
           then
 ;
\ 90 sin .s abort
: cos          ( angle - cos*100000 )
   90 - dup 0 > >r
   abs sin r>
       if negate then
 ;


: Plot4EllipsePoints
CX PE_X  + CY PE_Y +  pixel
CX PE_X  - CY PE_Y +  pixel
CX PE_X  - CY PE_Y -  pixel
CX PE_X  + CY PE_Y -  pixel
;

: Bresenham_Ellipse ( cx, cy, Xradius, Yradius -- ) \ Start Bresenham Ellipse algorithm

Xradius dup * 2 * to TwoASquare  \ TwoASquare = 2*Xradius*Xradius
Yradius dup * 2 * to TwoBSquare  \ TwoBSquare = 2*Yradius*Yradius

Xradius to PE_X    \ PE_X = Xradius
0       to PE_Y    \ PE_y = 0
Yradius dup * 1 2 Xradius * - * to Xchange \ Xchange = Yradius*Yradius*(1-2*Xradius)
Xradius dup * to Ychange                   \ Ychange = Xradius*Xradius
0 to EllipseError                          \ EllipseError = 0
TwoBSquare Xradius * to StoppingX          \ StoppingX = TwoSquare*Xradius
0                    to StoppingY          \ StoppingY = 0

Begin

   StoppingX StoppingY < NOT

While \ While StoppingX >= StoppingY

  Plot4EllipsePoints ( PE_X, PE_Y )
  PE_Y 1+ to PE_Y   \ PE_Y = PE_Y + 1
   StoppingY TwoASquare + to StoppingY       \ Stoppingx = StoppingX + TwoASquare
   EllipseError Ychange + to EllipseError    \ EllipseError = EllipseError + Ychange
   Ychange TwoASquare +   to Ychange         \ Ychange = Ychange + TwoASquare

   2 EllipseError * Xchange + 0 >
   if \ if 2*EllipseError + Xchange > 0
      PE_X 1- to PE_X                        \ PE_X = PE_X - 1
      StoppingX TwoBSquare - to StoppingX    \ StoppingX = StoppingX - TwoBSquare
      EllipseError Xchange + to EllipseError \ EllipseError = EllipseError + Xchange
      Xchange TwoBSquare +   to Xchange      \ Xchange = Xchange + TwoBSquare
   then

Repeat

\ 1st point set is done; start the 2nd set of points

0 to PE_X                                   \ PE_X = 0
YRadius to PE_Y                             \ PE_Y = Yradius
Yradius dup * to Xchange                    \ Xchange = Yradius*Yradius
Xradius dup * 1 2 Yradius * - * to Ychange  \ Ychange = Xradius*Xradius*(1-2*Yradius)
0 to EllipseError                           \ EllipseError = 0
0 to StoppingX                              \ StoppingX = 0
TwoASquare Yradius * to StoppingY           \ StoppingY = TwoASquare * Yradius

Begin

StoppingX StoppingY > NOT

While  \ while StoppingX <= StoppingY
     Plot4EllipsePoints
     PE_X 1+ to PE_X                         \ PE_X = PE_X + 1
      StoppingX TwoBSquare + to StoppingX    \ StoppingX = StoppingX + TwoBSquare
      EllipseError Xchange + to EllipseError \ EllipseError = EllipseError + Xchange
      Xchange  TwoBSquare  + to Xchange      \ Xchange = Xchange + TwoBSquare

      2 EllipseError * Ychange + 0 >
      if      \  if  2*EllipseError + Ychange > 0
          PE_Y 1- TO PE_Y                        \ PE_Y = PE_Y - 1
          StoppingY TwoASquare - to StoppingY    \ StoppingY = StoppingY - TwoASquare
          EllipseError Ychange + to EllipseError \ EllipseError = EllipseError + Ychange
          Ychange TwoASquare   + to Ychange      \ Ychange= Ychange + TwoASquare
      then
repeat
;

: draw-circle ( X Y R )
	TO R TO CY TO CX
	Bresenham-Cercle ;

: draw-ellipse ( X Y Xradius Yradius )
	TO yradius TO xradius TO CY TO CX
	Bresenham_Ellipse ;

2drop


\ ===============================================
\ Demo Affichage Star-Wars ;-)
\ ===============================================
variable pos-stars 100 cells allot

: create-stars ( -- )
50 0 do
	320 Random pos-stars i 2 * cells + !
	200 Random pos-stars i 2 * 1 + cells + ! loop ;

: stars ( -- )
	50 0 do
	i 2 * cells pos-stars + @
	i 2 * 1 + cells pos-stars + @
	pixel loop ;

: sight ( -- )
	150 0 150 200 draw-line \ vertical line
	170 0 170 200 draw-line
;

: Death-Star
	230 140 30 50 draw-ellipse
	230 140 10 50 draw-ellipse
	230 140 50 50 draw-ellipse
	230 140 50 30 draw-ellipse
	230 140 50 10 draw-ellipse
	230 90 230 190 draw-line
;

: Death-Star2
	230 140 40 50 draw-ellipse
	230 140 20 50 draw-ellipse
	230 140 50 50 draw-ellipse
	230 140 50 30 draw-ellipse
	230 140 50 10 draw-ellipse
	230 90 230 190 draw-line
;

: grid ( -- )
	20 20 300 180 draw-rectangle
	120 80 200 120 draw-rectangle
	70 50 250 150 draw-rectangle
	20 20 120 80 draw-line
	20 180 120 120 draw-line
	300 180 200 120 draw-line
	300 20 200 80 draw-line
	120 100 200 100 draw-line
	160 80 160 120 draw-line
;

: ship ( -- ) \ filled triangle
	GlFill 70 30 95 105 270 170 draw-triangle
	GlLine
 ;

: star-wars
set-screen
create-stars
10 0 do
\ 180 TO R
	17 0 do
	\ 160 to CX 100 TO CY R 10 - to R
	        white stars
		cyan Death-star
		dark-green ship
		yellow grid
	    yellow 160 100 170 i 10 * - draw-circle
	    red 160 100 18 draw-circle
	    red sight
	    view
	    50 pause
		white stars
		cyan Death-star2
		dark-green ship
		yellow grid
	    yellow 160 100 170 i 10 * - draw-circle
	    red 160 100 18 draw-circle
	    red sight
	    view
	    50 PAUSE
        loop loop
	;

\ star-wars







