local str_back = [[This mod originates from the classic 【Tropical Experience】 mod.
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
    1. Fixing trawlnet...


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
The full name of this mod is 【Tropical Adventure | Ship of Theseus】.
True to its name, my goal is to maintain the mod's availability while gradually replacing and updating its original content—much like the Ship of Theseus—allowing it to continuously find new life.

If you feel your journey thus far has been exciting, feel free to support us through a donation. Your appreciation is an affirmation of our past work!
]]

local WikiAbout = {
    str_back = str_back,
    str_progress = str_progress,
    str_preview = str_preview,
}

return {
    WikiAbout = WikiAbout,
}
