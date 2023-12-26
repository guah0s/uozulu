**Ultima Online Zulu Hotel Stealth Scripts:**
***
        
**Crafter Blacksmithy (BS.pas):**
Basic variables:    
CharBackpack - Your character's backpack    
LegendaryBag - A container in your character's backpack to store Legendary items    
PerfectBag = A container in your character's backpack to store Perfect items    
ExceptionalBag = A container in your character's backpack to store Exceptional items    
ForgeObj - ID of a forge nearby    
SmeltExcept - if set to 1, Exceptional items are smelted just like the regular ones, if set to 0, Exceptional items are stored in the ExceptionalBag    
    
Maximum number of items of certain quality before the script stops:    
MAX_EXCEPTIONAL_COUNT = 999; // Adjust the maximum count as needed    
MAX_PERFECT_COUNT = 999; // Adjust the maximum count as needed    
MAX_LEGENDARY_COUNT = 999; // Adjust the maximum count as needed    
***    


**Crafter Mining in Minoc mine with unloading gathered resources into bank (Mining_Minoc_unload.pas):**
Basic variables:    
IngotChest - A container in your character's backpack to store gathered ingots into.
