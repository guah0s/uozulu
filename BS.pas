Program BlackSmithy;
{$Include 'all.inc'}

var
  TimeStart : TDateTime;

const
  // Containers setup:
  CharBackpack = $5D2A576B;
  LegendaryBag = $5E66B128;
  PerfectBag = $5E66B1F7;
  ExceptionalBag = $5E66B301;

  // Item to craft:
  //ItemType = $1401; // Kryss
  ItemType = $13FE; // Katana
  //ItemType = $0F63; // Spear
  //ItemType = $1415; // Breastplate
  //ItemType = $1414; // Gloves
  //ItemType = $1413; // Gorget
  //ItemType = $1412; // Helmet
  //ItemType = $1411; // Legs
  //ItemType = $1410; // Arms
  //ItemType = $1B76; // Shield

  // Tools and Objects:
  Ingots = $1BF2;
  ForgeObj = $5E293A96;
  HammerType = $13E3;
  TongsType = $0FBB;
  SmeltExcept = 1; // 1 = smelt exceptional items into ingots, 0 = store exceptional items in the ExceptionalBag

  MAX_EXCEPTIONAL_COUNT = 999;  // Adjust the maximum count as needed (don't forget to set SmeltExcept = 0)
  MAX_PERFECT_COUNT = 999;      // Adjust the maximum count as needed
  MAX_LEGENDARY_COUNT = 999;    // Adjust the maximum count as needed

procedure Resmelt;
begin
  repeat
    findtype(ItemType, backpack);
    
    if FindCount() > 0 then
    begin
      Clearjournal();
      UseObject(FindType(TongsType, Backpack));
      wait(500);
      findtype(ItemType, backpack);
      
      if FindCount() > 0 then
      begin
        WaitTargetObject(finditem);
        wait(1000);
        WaitTargetObject(ForgeObj);
        wait(3000);
      end;
    end;
  until FindCount() = 0;
end;

procedure CheckStopConditions;
begin
  FindType(ItemType, ExceptionalBag);
  if FindCount >= MAX_EXCEPTIONAL_COUNT then
  begin
    AddToSystemJournal('Reached maximum exceptional count. Stopping script.');
    Halt;
  end;

  FindType(ItemType, PerfectBag);
  if FindCount >= MAX_PERFECT_COUNT then
  begin
    AddToSystemJournal('Reached maximum perfect count. Stopping script.');
    Halt;
  end;

  FindType(ItemType, LegendaryBag);
  if FindCount >= MAX_LEGENDARY_COUNT then
  begin
    AddToSystemJournal('Reached maximum legendary count. Stopping script.');
    Halt;
  end;
end;

procedure HandleGumpsKatana(ItemType: Integer);
begin
  WaitGump('300'); // Change for item type
  wait(500);
  WaitGump('3010');
  WaitGump('0x' + IntToHex(ItemType, 4));
  wait(500);
end;

procedure HandleGumpsKryss(ItemType: Integer);
begin
  WaitGump('300'); // Change for item type
  wait(500);
  WaitGump('3020');
  WaitGump('0x' + IntToHex(ItemType, 4));
  wait(500);
end;

procedure HandleGumpsSpear(ItemType: Integer);
begin
  WaitGump('300'); // Change for item type
  wait(500);
  WaitGump('3020');
  WaitGump('0x' + IntToHex(ItemType, 4));
  wait(500);
end;

procedure HandleGumpsBreastplate(ItemType: Integer);
begin
  WaitGump('100'); // Change for item type
  wait(500);
  WaitGump('1001');
  WaitGump('0x' + IntToHex(ItemType, 4));
  wait(500);
end;

procedure HandleGumpsGloves(ItemType: Integer);
begin
  WaitGump('100'); // Change for item type
  wait(500);
  WaitGump('1001');
  WaitGump('0x' + IntToHex(ItemType, 4));
  wait(500);
end;

procedure HandleGumpsGorget(ItemType: Integer);
begin
  WaitGump('100'); // Change for item type
  wait(500);
  WaitGump('1001');
  WaitGump('0x' + IntToHex(ItemType, 4));
  wait(500);
end;

procedure HandleGumpsHelmet(ItemType: Integer);
begin
  WaitGump('100'); // Change for item type
  wait(500);
  WaitGump('1001');
  WaitGump('0x' + IntToHex(ItemType, 4));
  wait(500);
end;

procedure HandleGumpsLegs(ItemType: Integer);
begin
  WaitGump('100'); // Change for item type
  wait(500);
  WaitGump('1001');
  WaitGump('0x' + IntToHex(ItemType, 4));
  wait(500);
end;

procedure HandleGumpsArms(ItemType: Integer);
begin
  WaitGump('100'); // Change for item type
  wait(500);
  WaitGump('1001');
  WaitGump('0x' + IntToHex(ItemType, 4));
  wait(500);
end;

procedure HandleGumpsShield(ItemType: Integer);
begin
  WaitGump('200'); // Change for item type
  wait(500);
  WaitGump('0x' + IntToHex(ItemType, 4));
  wait(500);
end;

procedure CraftItem;
begin
	UseObject(ObjAtLayerEx(RhandLayer, self));
	findtype(Ingots, backpack);
	WaitTargetObject(finditem);
	wait(1000);
	if ItemType = $13FE then
	HandleGumpsKatana(ItemType);
	if ItemType = $1401 then
	HandleGumpsKryss(ItemType);
	if ItemType = $0F63 then
	HandleGumpsSpear(ItemType);	
	if ItemType = $1415 then
	HandleGumpsBreastplate(ItemType);
	if ItemType = $1414 then
	HandleGumpsGloves(ItemType);
	if ItemType = $1413 then
	HandleGumpsGloves(ItemType);
	if ItemType = $1412 then
	HandleGumpsHelmet(ItemType);
	if ItemType = $1411 then
	HandleGumpsLegs(ItemType);
	if ItemType = $1410 then
	HandleGumpsLegs(ItemType);
	if ItemType = $1B76 then
	HandleGumpsShield(ItemType);
	
	
repeat
    wait(500);
  until (InJournalBetweenTimes('stop', TimeStart, Now) <> -1) or (InJournal('Cancelled') <> -1);

  wait(100);

  if InJournal('Legendary') > -1 then
  begin
    UoSay('Finally the Masterpiece! (Legendary)');
    ClearJournal;
    Findtype(ItemType, backpack);
    wait(100);
    MoveItem(finditem, 0, LegendaryBag, 0, 0, 0);
    wait(100);
  end;

  if InJournal('Perfect') > -1 then
  begin
    UoSay('That one looks really good! (Perfect)');
    ClearJournal;
    Findtype(ItemType, backpack);
    wait(100);
    MoveItem(finditem, 0, PerfectBag, 0, 0, 0);
    wait(100);
  end;

  if InJournal('Exceptional') > -1 then
  begin
    UoSay('This one is not bad! (Exceptional)');

    if SmeltExcept = 0 then
    begin
      ClearJournal;
      wait(500);
      Findtype(ItemType, backpack);
      wait(100);
      MoveItem(finditem, 0, ExceptionalBag, 0, 0, 0);
      wait(100);
    end
    else if SmeltExcept = 1 then
    begin
      ClearJournal;
      wait(500);
      Findtype(ItemType, backpack);
      wait(100);
      MoveItem(finditem, 0, CharBackpack, 0, 0, 0);
      wait(100);
    end;
  end;

  if InJournal('Success') <> -1 then
  begin
    wait(500);
    Findtype(ItemType, backpack);
    wait(100);
    MoveItem(finditem, 0, CharBackpack, 0, 0, 0);
    wait(100);
  end;
end;

procedure CheckHammer;
begin
  if (ObjAtLayerEx(RhandLayer, self) = 0) then
  begin
    UseObject(FindType(HammerType, Backpack));
    UoSay('Another hammer cracked!');
  end;
end;

procedure CheckCounts;
var
  itemCount: Integer;
begin
  AddToSystemJournal('***');

  FindType(ItemType, LegendaryBag);
  itemCount := FindCount;
  AddToSystemJournal('Legendary: ' + IntToStr(itemCount));
  Wait(100);
  FindType(ItemType, PerfectBag);
  itemCount := FindCount;
  AddToSystemJournal('Perfect: ' + IntToStr(itemCount));
  Wait(100);
  FindType(ItemType, ExceptionalBag);
  itemCount := FindCount;
  if SmeltExcept = 0 then
    AddToSystemJournal('Exceptional: ' + IntToStr(itemCount));
  Wait(100);
  FindType(HammerType, Backpack);
  itemCount := FindCount;
  AddToSystemJournal('Hammers: ' + IntToStr(itemCount));
  Wait(100);
  FindType(TongsType, Backpack);
  itemCount := FindCount;
  AddToSystemJournal('Tongs: ' + IntToStr(itemCount));
  Wait(100);
  FindType(Ingots, Backpack);
  itemCount := FindFullQuantity;
  AddToSystemJournal('Ingots:' + IntToStr(itemCount));
end;

Begin //the main loop
  while (not Dead) do
  begin
    CheckHammer;
    CraftItem;
	CheckStopConditions;
	Resmelt;
    CheckCounts;
  end;
End.