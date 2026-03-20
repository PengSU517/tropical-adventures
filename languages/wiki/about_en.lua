local str_back =
[[The full name of this mod is
[Tropical Adventures | Ship of Theseus].
-----------------------------------------
This mod originates from the classic 【Tropical Experience】 mod.
It retains the Shipwrecked and Hamlet portions while implementing extensive optimizations and additions.
Currently, this mod offers 【high compatibility】; however, as one of the largest mods in the Workshop, compatibility issues may arise with certain large-scale mods.
It is 【not recommended】 to enable this alongside other mods that 【contain single-player DLC content】 or mods that modify single-player DLC assets.
-----------------------------------------
Given the extensive volume of this mod, the encyclopedia primarily covers original additions and optimized content.
]]

local str_progress = [[
We would like to extend our sincere gratitude to the original "Tropical Experience" development team (represented by Vagner),
as well as Runar、momo、狼轩木林、杰杰、月下独酌、酒酒、萌新 and BBGoat、绯世行 for their invaluable technical assistance and support.
Furthermore, during the development process, we drew great inspiration and experience from several outstanding mods, including "Candy House" and "Above the cloud."
We truly appreciate the foundations laid by these talented developers.

==========================================
Planning Update:
    1. Fixing trawlnet...(maybe next time)

26.03.20 Update:
    1. Now perfectly compatible with the [Global Event Timer] mod! As long as you have that Mod enabled, you can see the countdowns for various BOSSes directly on your screen, allowing you to prepare your defenses in advance.
    2. The Aporkalypse is now perfectly adapted to the "Don't Starve Alone (DSA)" single-player mode. Fixed the issue where triggering the Aporkalypse would cause an error previously, greatly improving the stability of both multiplayer and single-player gameplay.

    3. Tiger Shark combat is now smoother. Also cleared up redundant Tiger Shark spawn points on the map.
    4. Fixed the issue where the ROC could not land normally.
    5. Optimized the issue of the Twister sucking in too many items.

    6. The Smelter and Crock Pot can now more accurately identify whether what you put in is an "ore" or an "ingredient", preventing misjudgments!
    7. Water Chest Fix: Fixed the issue where the water chest had no interactive UI.
    8. Crop Adjustment: Hidden wheat and turnips.

26.03.06 Update：
    1. update wiki UI
    2. better boat UI

26.03.03 Update:
    1. Terrain generation is now compatible with [Montfluv].
    2. Optimized the Mod Wiki UI.
    3. Adjusted the generation structure of the pigtown.


Feb 26, 2025 Update:
    1. Added Mod Wiki/Encyclopedia.
    2. Fixed an error occurring when fishing for lobsters on a boat in single-player.
    3. Fixed an issue where fog and rain would appear indoors within the Hamlet region during winter.
    4. Corrected default turf detection for different regions (e.g., the default turf for the shipwrecked is now set to Sand).
    5. Fixed missing iron ore textures when Smart Cooking is enabled.
    6. Added a recipe for the Captain to craft gold coins.


=========================================
]]

local str_preview = [[
The Ship of Theseus: Our goal is to gradually overhaul and update the original content—breathing new life into it—all while ensuring the mod remains 100% playable throughout the process.
Please note that all current updates are passion projects done in the free time of the author and our community members. Progress will be slow, so we appreciate your patience and ask that you don't expect too much too soon.
-----------------------------------------
Want to help out? We'd love to have you! Github Page: [PengsTA/tropical-adventures] to connect and contribute.
You can also support us through donations! Every contribution goes straight into the ongoing development and maintenance of the mod.
Your support means the world to us—it validates the hard work we've put in and gives us the motivation to keep the updates coming!
]]


local str_donation = [[
Nobody yet.
]]

local WikiAbout = {
    str_back = str_back,
    str_progress = str_progress,
    str_preview = str_preview,
    str_donation = str_donation,
}

return {
    WikiAbout = WikiAbout,
}
