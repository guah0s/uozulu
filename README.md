**Ultima Online Zulu Hotel Stealth Scripts:**
***
        
**Crafter Blacksmithy (BS.pas):**        
Basic variables:    
_CharBackpack_ - Your character's backpack    
_LegendaryBag_ - A container in your character's backpack to store Legendary items    
_PerfectBag_ = A container in your character's backpack to store Perfect items    
_ExceptionalBag_ = A container in your character's backpack to store Exceptional items    
_ForgeObj_ - ID of a forge nearby    
_ItemType_ - Uncomment an item type you want to craft        
_SmeltExcept_ - if set to 1, Exceptional items are smelted just like the regular ones; if set to 0, Exceptional items are stored in the ExceptionalBag            
 _SmeltPerfect_ - if set to 1, Perfect items are smelted just like the regular ones; if set to 0, Perfect items are stored in the PerfectBag        
    
Maximum number of items of certain quality before the script stops:    
_MAX_EXCEPTIONAL_COUNT_ = 999; // Adjust the maximum count as needed    
_MAX_PERFECT_COUNT_ = 999; // Adjust the maximum count as needed    
_MAX_LEGENDARY_COUNT_ = 999; // Adjust the maximum count as needed    
***    


**Crafter Mining in Minoc mine with unloading gathered resources into bank (Mining_Minoc_unload.pas):**        
Basic variables:    
_IngotChest_ - A container in your character's backpack to store gathered ingots into.
