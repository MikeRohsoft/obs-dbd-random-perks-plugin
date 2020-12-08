# DbD Random Perk Generator as OBS Plugin

## What does it?
- It provides a new OBS Source to Display a Random Perk Generation on Screen
## Do I need something?
- You need OBS and Dead by Daylight for PC or a costum Perk Pack to make it work
## Why I should use it?
- Because you are tired of searching a new Website with updated Random Perks / Killers
Even if there would not come any update anymore, you can just add the new Entries in the "db" by yourself, should be easy for everyone
just copy and paste the last entry, modify it and done

## Installation:
1) make sure you can provide the Assets the Script is using
Currently it is supposed to use with a DbD Installation which provides all Perks and a set of Killer Backgrounds in 
%PATH_TO_STEAM%\steamapps\common\Dead by Daylight\DeadByDaylight\Content\UI\Icons
If you want provide a costum Icon Set you need a Directory which provides the "Perks" and the "StoreBackgrounds" Directories
2) 
- In OBS you have to add a new Script in the Application Bar -> "Tools" -> "Scripts" -> "+" and add "random-perks.lua" there
**Ignore all Settings first**
- Now you can add 2 new Sources to your Scences "DbD Random Perks" and "DbD Random Killer"
- Add them to your scene **only Random Perks works too**
**Optional**
-- Create a Hotkey for Killer and/or Survivor Perks
-- Create a Hotkey for Enable/Disable the Source
-- If you also want to display Text for the results, you have to add also a new "GDI+ Text Source"
3)
Now you can go back to the Script Settings (Application Bar -> "Tools" -> "Scripts" -> "random-perks.lua")
- Set your language
- Set your Asset Path
** If you have "next -> next -> next"-DbD Steam Installation, it will be C:\Program Files (x86)\Steam\steamapps\common\Dead by Daylight\DeadByDaylight\Content\UI\Icons **
- Set the Text Source if you created a new "GDI+ Text Souce"
Now RESTART OBS!

## NOTE: 
If you only use the Random Perks Source without the Random Killer Source, you can ignore this note.
You can NOT just delete and add the Sources again if the Script is active, your OBS can crash from it!
You have to unload the lua Script first and do all steps from Installation Step 2 again, so it can not restored while streaming!

## Hidden Feature:
- If the Killer Source is hidden from the Scene, the text result will also not provide a Killer name