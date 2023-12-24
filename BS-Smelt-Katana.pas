Program BlackSmithy;
{$Include 'all.inc'}

var
TimeStart : TDateTime;
k :integer;

const
//Containers setup:
CharBackpack = $5D2A576B;
LegendaryBag = $5E66B128;
PerfectBag = $5E66B1F7;
ExceptionalBag = $5E66B301;
//Item to craft:
//ItemType = $1401; // Kriss
ItemType = $13FE; // Katana
ItemCost = 5;
//Tools and Objects:
Ingots = $1BF2;
ForgeObj = $5E293A96;
HammerType = $13E3;
TongsType = $0FBB;



procedure Resmelt;
begin
findtype(ItemType,backpack);
while FindCount() > 0 do
    repeat
    Clearjournal();
    checksave;
     k:=0;
     TimeStart:=Now;
      repeat
       UseObject(FindType(TongsType,Backpack));
       k := k + 1;
        wait(2000);
       until (InJournalBetweenTimes('What do you wish to smelt into ingots?|has to be', TimeStart, Now)<>-1) or (k > 7);
		findtype(ItemType,backpack);
		WaitTargetObject(finditem);
		 wait(1000);
         WaitTargetObject(ForgeObj);
              repeat
               wait(100);
               k := k + 1;
              until (InJournalBetweenTimes('You turned|ailed|That cannot be melted down!', TimeStart, Now)<>-1) or (k > 300);
              findtype(ItemType,backpack);
    Clearjournal();
    until findcount () = 0  ;
findtype(ItemType,backpack);
wait(1000);
end;

procedure CheckHammer;
   begin
	  if (ObjAtLayerEx(RhandLayer,self) = 0) then
	  begin
		UseObject(FindType(HammerType,Backpack));
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
  if itemCount <> 0 then
    AddToSystemJournal('Legendary: ' + IntToStr(itemCount));
  Wait(100);
  FindType(ItemType, PerfectBag);
  itemCount := FindCount;
  if itemCount <> 0 then
    AddToSystemJournal('Perfect: ' + IntToStr(itemCount));
  Wait(100);
  FindType(ItemType, ExceptionalBag);
  itemCount := FindCount;
  if itemCount <> 0 then
    AddToSystemJournal('Exceptional: ' + IntToStr(itemCount));
  Wait(100);
  FindType(HammerType, Backpack);
  itemCount := FindCount;
  if itemCount <> 0 then
    AddToSystemJournal('Hammers: ' + IntToStr(itemCount));
  Wait(100);
  FindType(TongsType, Backpack);
  itemCount := FindCount;
  if itemCount <> 0 then
    AddToSystemJournal('Tongs: ' + IntToStr(itemCount));
  Wait(100);
  FindType(Ingots, Backpack);
  itemCount := FindFullQuantity;
  if itemCount <> 0 then
    AddToSystemJournal('Ingots:' + IntToStr(itemCount));
end;


Begin
SetARStatus(true);
while (not Dead) do
begin

		 CancelMenu;
		 Clearjournal();
		 k:=0;
		 TimeStart:=Now;
		 UseObject(ObjAtLayerEx(RhandLayer,self));
		 findtype(Ingots,backpack);
		 WaitTargetObject(finditem);
		 wait(1000)
		 WaitGump('300'); //Change For item type
		 wait(500)
		 WaitGump('3010');
		 wait(500)
		 WaitGump('0x13fe');
repeat
wait(100);
k := k + 1;
wait(500);
until (InJournalBetweenTimes('stop', TimeStart, Now)<>-1) or (k > 300);
wait(100);
if InJournal('Legendary') > -1 then
	begin
	    UoSay('Finally the Masterpiece! (Legendary)');
		ClearJournal;
		Findtype(ItemType,backpack);
		wait(100);
		MoveItem(finditem, 0, LegendaryBag, 0, 0, 0);
		wait(100);
	end;
	
if InJournal('Perfect')>-1 then
	begin
		UoSay('That one looks really good! (Perfect)');
		ClearJournal;
		Findtype(ItemType,backpack);
		wait(100);
		MoveItem(finditem, 0, PerfectBag, 0, 0, 0);
		wait(100);
	end;
	
if InJournal('Exceptional')>-1 then
	begin
		UoSay('This one is not bad! (Exceptional)');
		ClearJournal;
		wait(500);
		Findtype(ItemType,backpack);
		wait(100);
		MoveItem(finditem, 0, ExceptionalBag, 0, 0, 0); // CharBackpack = smelt Exceptionals, ExceptionalBag = save Exceptionals in ExceptionalBag
		wait(100);
	end;
	
if InJournal('Success')<>-1 then
	begin
		wait(500);
		Findtype(ItemType,backpack);
		wait(100);
		MoveItem(finditem, 0, CharBackpack, 0, 0, 0);
		wait(100);
	end;
	
CheckHammer;
CheckCounts;
Resmelt;
end;
End.
