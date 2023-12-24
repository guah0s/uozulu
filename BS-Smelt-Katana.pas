program BlackSmithy;

{$Include 'all.inc'}

var
  TimeStart: TDateTime;
  k: Integer;

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

procedure Resmelt;
begin
  FindType(ItemType, backpack);
  while FindCount() > 0 do
  begin
    repeat
      ClearJournal();
      CheckSave;
      k := 0;
      TimeStart := Now;
      repeat
        UseObject(FindType(TongsType, Backpack));
        k := k + 1;
        Wait(2000);
      until (InJournalBetweenTimes('What do you wish to smelt into ingots?|has to be', TimeStart, Now) <> -1) or (k > 7);

      FindType(ItemType, backpack);
      WaitTargetObject(finditem);
      wait(1000);
      WaitTargetObject(ForgeObj);
      repeat
        wait(100);
        k := k + 1;
      until (InJournalBetweenTimes('You turned|ailed|That cannot be melted down!', TimeStart, Now) <> -1) or (k > 300);

      FindType(ItemType, backpack);
      ClearJournal();
    until FindCount() = 0;

    FindType(ItemType, backpack);
    wait(1000);
  end;
  FindType(ItemType, backpack);
  wait(1000);
end;

procedure CheckHammer;
begin
  if ObjAtLayerEx(RhandLayer, self) = 0 then
  begin
    UseObject(FindType(HammerType, Backpack));
    UoSay('Another hammer cracked!');
  end;
end;

procedure CheckCounts;
begin
  AddToSystemJournal('***');
  FindType(ItemType, LegendaryBag);
  AddToSystemJournal('Legendary Items Crafted: ' + IntToStr(FindCount));
  Wait(500);
  FindType(ItemType, PerfectBag);
  AddToSystemJournal('Perfect Items Crafted: ' + IntToStr(FindCount));
  Wait(500);
  FindType(ItemType, ExceptionalBag);
  AddToSystemJournal('Exceptional Items Crafted: ' + IntToStr(FindCount));
  Wait(500);
  FindType(HammerType, Backpack);
  AddToSystemJournal('Hammers Count: ' + IntToStr(FindCount));
  Wait(500);
  FindType(TongsType, Backpack);
  AddToSystemJournal('Tongs Count: ' + IntToStr(FindCount));
  Wait(500);
  FindType(Ingots, Backpack);
  AddToSystemJournal(IntToStr(FindFullQuantity) + ' Ingots left');
end;

begin
  SetARStatus(true);
  while not Dead do
  begin
    CancelMenu;
    ClearJournal();
    k := 0;
    TimeStart := Now;
    UseObject(ObjAtLayerEx(RhandLayer, self));
    FindType(Ingots, backpack);
    WaitTargetObject(finditem);
    wait(1000);
    WaitGump('300'); // Change For item type
    wait(500);
    WaitGump('3010');
    wait(500);
    WaitGump('0x13fe');

    repeat
      wait(100);
      k := k + 1;
      wait(500);
    until (InJournalBetweenTimes('stop', TimeStart, Now) <> -1) or (k > 300);

    wait(100);

    if InJournal('Legendary') > -1 then
    begin
      UoSay('Finally the Masterpiece! (Legendary)');
      ClearJournal;
      FindType(ItemType, backpack);
      wait(100);
      MoveItem(finditem, 0, LegendaryBag, 0, 0, 0);
      wait(100);
    end;

    if InJournal('Perfect') > -1 then
    begin
      UoSay('That one looks really good! (Perfect)');
      ClearJournal;
      FindType(ItemType, backpack);
      wait(100);
      MoveItem(finditem, 0, PerfectBag, 0, 0, 0);
      wait(100);
    end;

    if InJournal('Exceptional') > -1 then
    begin
      UoSay('This one is not bad! (Exceptional)');
      ClearJournal;
      wait(500);
      FindType(ItemType, backpack);
      wait(100);
      MoveItem(finditem, 0, ExceptionalBag, 0, 0, 0); // CharBackpack = smelt Exceptionals, ExceptionalBag = save Exceptionals in ExceptionalBag
      wait(100);
    end;

    if InJournal('Success') <> -1 then
    begin
      wait(500);
      FindType(ItemType, backpack);
      wait(100);
      MoveItem(finditem, 0, CharBackpack, 0, 0, 0);
      wait(100);
    end;

    CheckHammer;
    CheckCounts;
    Resmelt;
  end;
end.