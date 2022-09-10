#SingleInstance, Force
#NoEnv
#Warn
;SendMode Input
SendMode Event
SetWorkingDir, %A_ScriptDir%
SetBatchLines -1
/*

MC Script to craft nuggets to ingots, ingots into blocks, etc.
Tested ONLY on a 1920 x 1080p Monitor.

Inspired by TangoTek of Hermitcaft fame.  He wrote a short script to craft gold 
nuggets into ingots. I thought it great idea and decided to make my own.  He 
later released his script to the public. Any similarities between his script and
mine is pure coincidence.

Thanks to the AHK forums and Google for indexing the site.  There is a wealth of
knowledge there and I referenced back to there many many times while creating
this script.

AHK is an extremely powerful scripting language.  To bad their variable syntax
is absolutely atrocious.  When do you % again?  Can you say "inconsistency" boys
and girls. /rant

Change Log
-----------

V2.0.1b - 9/10/2022
   Removed: Crafting Delay
   Bug: Removed w parameter from font statement
   Code cleanup
   Modified edit boxes (crating recipes) to only except numbers.

V2.0b
   Add: ability to save 4 crafting coordinates / Recipes.
   Add: User added description to crafting coordinates / recipes.
   Add: ALT+1 and ALT+2 HotKeys to save coordinates (X1,Y1) and (X2,Y2) 
      respectfully.  Honestly it doesn't matter if the crafting book is (x1,y1) 
      or (x2,y2).
   Add: Selecting Radio Button (Recipe / Coordinates) copies those coords to the 
      table / book coords. These are the coords that will be used when executing 
      the script.
   GUI changes; size, position, font, other.
   Changed: Save These Settings? is no longer checked by default.
   Changed: Mouse positions to be relative to the screen and not to the window.
   New Feature: With the addition of the ALT+1 & 2 HotKeys, users with only one 
      monitor should now be able to use the script.
   Modified: How to Use. i.e a complete rewrite as the old text no longer was 
      applicable.
   Modified edit boxes to only except numbers.
   
v1.2.1
   Added Feature:  Save the current mouse position and then move the mouse back
      to that position after crafting is completed.
   SleepDelay: This was originally added to "slow" down the crafts.  This has a 
      negative effect that it can cause crafting of "unwanted" items.  This 
      should be removed in a later revision.

v1.2 Release
   Added an option to save / not save the settings to the ini file.

V1.1 pre-Release
   GUI completed
   INI file routines added to save / retrieve settings
   House cleaning / tiding up the UI

v1.0.1
   1.) Changed up the GUI to display the information in a neater way.
   2.) Prepping for allowing the user to be able to change their (x,y) locations
      a. Recipe Book
      b. Crafting Table / User Inventory
   3.) Display the current (X,Y) coordinates of the mouse position


How to Use V2+
---------------
Coordinates and Recipes tend to be used interchangeably here.  Ever recipe has 
an X and Y coordinate as do the crafting table and the 2 x 2 crafting grid in
your inventory.  It makes no difference if you use X1,Y1 for the crafting table
or the crafting recipe in the book.  Dealer's choice.

On first run the script will create an ini file in the same directory as this 
script.  The ini file is used to save your settings / screen coordinates.

You need to first configure your crafting grid and your book x and y 
coordinates.  In version 2+ this is much easier.  Start by selecting a "Saved
Coordinates" by clicking one of the four radio buttons.  Next, hover your mouse 
cursor over the recipe you wish to craft and press ALT+1.  Then move you mouse 
to the crafting grid location, hover and press ALT+2.  This saves both location 
to the recipe save location you have selected.  You can add a description to the
saved recipe to help when using the script next time.  Click that radio button 
again and the coordinates will be copied up to the Crafting Table and Recipe 
Book text boxes at the top.  

Now fill your inventory and press CTRL+ALT+Z to craft.  You can 
also change how many crafts will be completed by changing the "How many crafts"
text box.  It should be noted that the script is written to do "shift click" 
recipes.  Which means if your crafting nuggets to ingots, 1 craft will be 64 
ingots.  

When you're done click the "save these changes" check box to save all of your
recipes.  You don't have to but it's nice if you want to use those same settings
next time.  Currently the number of crafts is global and not recipe dependent.



How to Use V1.x:
----------------

The GUI shows the current mouse position of the current active window.  You will
need multiple monitors in order to fully utilize this script.

Open the script, place it on a different monitor and then active your Minecraft 
Window. You can then input these x,y coordinates in the appropriate input box on
the GUI.

The GUI will not "always be on top."  If you need it to be, say you only have
one monitor, then uncomment the first line in the GUI section.  You don't
actually need the GUI once you have the X,Y coordinates setup correctly.

If you have issues with crafting there is a setting in the INI file, CraftDelay,
that you can modify to add some delay, in ms, between the crafts.  This will
effectively slow down the crafting.  I would recommend that you keep this delay
as small as possible as not only does it add delay between the start of the 
mouse movement it, should, make the mouse move slower across the screen.

*/

/*
##########################################################################
##                              Variables                               ##
##########################################################################
*/
myIniFile := A_ScriptDir . "\MC_Crafting.ini"
ScriptVersion := "V2.0.1beta"
GuiWidth := 650
GuiHeigth := 800
/*
##########################################################################
##                              Ini File                                ##
##########################################################################
*/

if not (FileExist(myIniFile))   ; creates the ini file if it does not exist
{
   FileAppend,, % myIniFile
}

Gosub ReadIni

/*
##########################################################################
##                         Hotkey Def's                                 ##
##########################################################################
*/

Hotkey !^z, Start       ; Crtl Alt Z   Craft Hotkey
Hotkey +!z, Stop        ; Shift Alt Z  End Script Hotkey
HotKey !1, CursorPos1   ; Alt 1        Save (X1,Y1) Position
Hotkey !2, CursorPos2   ; Alt 2        Save (X2,Y2) Position

/*
##########################################################################
##                                GUI                                   ##
##########################################################################
*/

; Gui, Font, s12 w700, Verdana  ; Why w parameter?  This seems odd.
Gui, Font, s12, Verdana

Gui, Show, h%GuiWidth% w%GuiWidth%, Minecraft Quick Crafter - FeedTheChunk	; Show the GUI window
Gui, Add, Text, x15 w%GuiWidth% Center cGreen, Minecraft Quick Crafter Version %ScriptVersion%
Gui, Add, Text, x15 w%GuiWidth% Center cGreen, Written by FeedTheChunk

Gui, Font, norm
Gui, Add, Text, x15, Press Ctrl-Alt-z to Craft

Gui, Add, Text, ,How many crafts (99 Max)?
Gui, Add, Edit, x+88 w55 Right Number
Gui, Add, UpDown, vCraftingLoops Range1-99, % CraftingLoops   ; Allows the user to select how many crafts to make

Gui, Add, Text, y+10 x15, Crafting Book X1 Coordinate:  ;
Gui, Add, Edit, x+50 w90 Right Number
Gui, Add, UpDown, vCraftingBookX Range1-10000, % CraftingBookX

Gui, Add, Text, y+10 x15, Crafting Book Y1 Coordinate:
Gui, Add, Edit, x+50 w90 Right Number
Gui, Add, UpDown, vCraftingBookY Range1-10000, % CraftingBookY

Gui, Add, Text, y+10 x15, Crafting Table X2 Coordinate:
Gui, Add, Edit, x+47 w90 Right Number
Gui, Add, UpDown, vCraftingTableX Range1-10000, % CraftingTableX  ;Range1-10000

Gui, Add, Text, y+10 x15, Crafting Table Y2 Coordinate:
Gui, Add, Edit, x+47 w90 Right Number
Gui, Add, UpDown, vCraftingTableY Range1-10000, % CraftingTableY

Gui, Add, Text, y+10 x15, Current Mouse X Coordinate:
Gui, Add, Text, x+15 w90 Right vMouseX

Gui, Add, Text, y+10 x15, Current Mouse Y Coordinate:
Gui, Add, Text, x+15 w90 Right vMouseY

Gui, Font, underline
Gui, Add, Text, y+20 x15 , Saved Coordinates
Gui, Font, norm
Gui, Add, Text, y+10 x70, Description                 X1             Y1               X2             Y2

Loop, 4
{
   if A_Index = 1
      RadioOptions :="vMyRadioGroup checked"
   else
      RadioOptions :=""
   
   Gui, Add, Radio, y+20 x15 gButtonFunc %RadioOptions%, %A_Index%
}

Loop, 4
{
   ; We need to move the first Edit Box up 130 Pixels
   if A_Index = 1
      yoffset := "yp-120"
   ; The rest will be 10 pixels below the last one
   else
      yoffset := "y+10"

Gui, Add, Edit, %yoffset% x60 w150 Left vDescription_%A_Index% , % Description_%A_Index%
Gui, Add, Edit, x+15 w90 Right Number vX1_%A_Index% ,               % X1_%A_Index%
Gui, Add, Edit, x+15 w90 Right Number vY1_%A_Index% ,               % Y1_%A_Index%
Gui, Add, Edit, x+15 w90 Right Number vX2_%A_Index% ,               % X2_%A_Index%
Gui, Add, Edit, x+15 w90 Right Number vY2_%A_Index% ,               % Y2_%A_Index%
}

Gui, Font, Italic
; Gui, Add, Checkbox, y+30 x120 Checked vSaveIni, Save these settings?
Gui, Add, Checkbox, y+30 x0 vSaveIni, Save these settings?

Gui, Font, norm
Gui, Add, Button, y+20 x0 gStop vButClose, &Close Script        ; Add a button to close the script and center

; Calculate the x position that centers the button in the window
GuiControlGet ButClose, Pos
xpos := % (GuiWidth-ButCloseW)/2
GuiControl, Move, ButClose, x%xpos%

; Calculate the x position that centers the CheckBox in the window
GuiControlGet SaveIni, Pos
xpos := % (GuiWidth-SaveIniW)/2
GuiControl, Move, SaveIni, x%xpos%


/*
##########################################################################
##                       End of Gui                                     ##
##########################################################################
*/

CoordMode, Mouse, Screen ; Window coordinates allow for MC to be on any monitor, in theory.
SetMouseDelay, -1
gosub MousePos ; get mouse x and y position, store as %xx% and %yy%

Return

/*
##########################################################################
##                             Subroutines                              ##
##########################################################################
*/

/*
This routine will grab the current mouse coordinates and then update the UI text.
*/

MousePos:
{
   loop
   {
      MouseGetPos xx, yy
      GuiControl,, MouseX, % xx
      GuiControl,, MouseY, % yy
      sleep 100                  ; Needs a little delay or the screen / text flickers.
   }
}
return

/*
This is the main crafting loop.
*/

Start:              ; Crafting loop
    {
    gui, submit, NoHide                                         ; Grab the number of crafts from the GUI
    MouseGetPos xxx, yyy  ; Current mouse position on the screen
    MouseMove 0,0
    Loop, % CraftingLoops
       {
           ; Move to the Crafting Book Window
           send +{click %CraftingBookX% %CraftingBookY%}           ; Shift Click at Coordinates x,y
           ;sleep % SleepDelay                                      ; Some delay if needed
           ; Move to the Crafting Table
           send +{click %CraftingTableX% %CraftingTableY%}         ; This should work for lefties and righties.
           ;sleep % SleepDelay
       }
    MouseMove xxx, yyy
    Return
    }
/*
Exit the script and update the ini file.
*/
Stop:                      ; Exit the Script
    {
    gui, submit, NoHide
    if (SaveIni)
      {
      Gosub WriteIni
      }
    ExitApp, 0
   }
Return

/*
Borrowed / Inspired From:
How best to permanently store a variable
https://www.autohotkey.com/boards/viewtopic.php?t=42131
*/

ReadIni:
   {
      IniRead, CraftingBookX,  % myIniFile, CraftingBook,  CraftingBookX,    690
      IniRead, CraftingBookY,  % myIniFile, CraftingBook,  CraftingBookY,    470
      IniRead, CraftingTableX, % myIniFile, CraftingTable, CraftingTableX,  1200
      IniRead, CraftingTableY, % myIniFile, CraftingTable, CraftingTableY,   470
      IniRead, CraftingLoops,  % myIniFile, General,       NoOfCrafts,         4
      loop, 4
      {
         IniRead Description_%A_Index%,  % myIniFile, SavedRecipes, Description_%A_Index%, Description
         IniRead X1_%A_Index%,           % myIniFile, SavedRecipes, X1_%A_Index%, 0
         IniRead Y1_%A_Index%,           % myIniFile, SavedRecipes, Y1_%A_Index%, 0
         IniRead X2_%A_Index%,           % myIniFile, SavedRecipes, X2_%A_Index%, 0
         IniRead Y2_%A_Index%,           % myIniFile, SavedRecipes, Y2_%A_Index%, 0

      }
   }
Return

WriteIni:
   {
      IniWrite % CraftingBookX,  % myIniFile, CraftingBook,  CraftingBookX
      IniWrite % CraftingBookY,  % myIniFile, CraftingBook,  CraftingBookY
      IniWrite % CraftingTableX, % myIniFile, CraftingTable, CraftingTableX
      IniWrite % CraftingTableY, % myIniFile, CraftingTable, CraftingTableY
      IniWrite % CraftingLoops,  % myIniFile, General,       NoOfCrafts
      loop, 4
      {
         IniWrite % Description_%A_Index%, % myIniFile, SavedRecipes, Description_%A_Index%
         IniWrite % X1_%A_Index%,          % myIniFile, SavedRecipes, X1_%A_Index%
         IniWrite % Y1_%A_Index%,          % myIniFile, SavedRecipes, Y1_%A_Index%
         IniWrite % X2_%A_Index%,          % myIniFile, SavedRecipes, X2_%A_Index%
         IniWrite % Y2_%A_Index%,          % myIniFile, SavedRecipes, Y2_%A_Index%
         
      }
      
   }
Return


ButtonFunc: ; Add code here to move stored coords to to the Table / Book coordinates
{

   Gui, submit, nohide  ;use gui submit else it will only get the value of that one control and not the group
   if MyRadioGroup not between 1 and 4 ; Verbose.  This is NOT needed.
      return

   ; Move (x1,y1) & (x2,y2) Coords up to the Book/Table coords
   GuiControl,, CraftingBookX,  % X1_%MyRadioGroup%
   GuiControl,, CraftingBookY,  % Y1_%MyRadioGroup%
   GuiControl,, CraftingTableX, % X2_%MyRadioGroup%
   GuiControl,, CraftingTableY, % Y2_%MyRadioGroup%

}
Return

; This will place the current mouse position into (x1,y1) Coordinates
CursorPos1:  ; (X1,Y1) Coordinates
{
   Gui, submit, nohide
   MouseGetPos xx, yy

   GuiControl,, X1_%MyRadioGroup%,%xx%
   GuiControl,, Y1_%MyRadioGroup%,%yy%

}
Return

; This will place the current mouse position into (x2,y2) Coordinates
CursorPos2: ; (X2,Y2) Coordinates
{
   Gui, submit, nohide
   MouseGetPos xx, yy
   GuiControl,, X2_%MyRadioGroup%, %xx%
   GuiControl,, Y2_%MyRadioGroup%, %yy%

}
Return
