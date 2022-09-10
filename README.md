# Minecraft Fast Craft
 AHK Script for fast crafting
 By: FeedTheChunk
 
MC Script to craft nuggets to ingots, ingots into blocks, etc.
Tested ONLY on a 1920 x 1080p Monitor.  This should work regardless of monitor
resolution or the number of monitors.

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

