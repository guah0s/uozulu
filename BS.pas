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
  // ItemType = $1401; // Kriss
  ItemType = $13FE; // Katana
  ItemCost = 5;

  // Tools and Objects:
  Ingots = $1BF2;
  ForgeObj = $5E293A96;
  HammerType = $13E3;
  TongsType = $0FBB;
  SmeltExcept = 1; // 1 = smelt exceptional items into ingots, 0 = store exceptional items in the ExceptionalBag

  MAX_EXCEPTIONAL_COUNT = 999;  // Adjust the maximum count as needed
  MAX_PERFECT_COUNT = 999;      // Adjust the maximum count as needed
  MAX_LEGENDARY_COUNT = 999;    // Adjust the maximum count as needed

procedure Resmelt;
begin
  findtype(ItemType, backpack);
  if FindCount() > 1 then
  begin
    Clearjournal();
    UseObject(FindType(TongsType, Backpack));
    wait(500);
    findtype(ItemType, backpack);
    WaitTargetObject(finditem);
    wait(1000);
    WaitTargetObject(ForgeObj);
    wait(3000);
  end;
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

procedure CraftItem;
begin
  UseObject(ObjAtLayerEx(RhandLayer, self));
  findtype(Ingots, backpack);
  WaitTargetObject(finditem);
  wait(1000);
  WaitGump('300'); // Change For item type
  wait(500);
  WaitGump('3010');
  wait(500);
  WaitGump('0x13fe');

  repeat
    wait(500);
  until (InJournalBetweenTimes('stop', TimeStart, Now) <> -1) or (InJournal('Cancelled') <> -1);

  wait(100);

  if InJournal('Legendary') > -1 then
  begin
    CheckStopConditions;
    UoSay('Finally the Masterpiece! (Legendary)');
    ClearJournal;
    Findtype(ItemType, backpack);
    wait(100);
    MoveItem(finditem, 0, LegendaryBag, 0, 0, 0);
    wait(100);
  end;

  if InJournal('Perfect') > -1 then
  begin
    CheckStopConditions;
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
      CheckStopConditions;
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
    CancelMenu;
    ClearJournal();
    CheckHammer;
    CraftItem;
	Resmelt;
    CheckCounts;
  end;
End.
