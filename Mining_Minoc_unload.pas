Program mining;

{$Include 'all.inc'}

var
  x, y, k: integer;
  ctime: TDateTime;
  mn1, mf1, mf2, ms1, ms2: Integer;

const
  PickaxeType = $0E85;
  IngotType = $1BF2;

  BankX = 2509; //Minoc Bank coordinates
  BankY = 537;

  IngotChest = $5E4AB377; //ID of a container inside bank to store ingots in

function CheckPickaxe: Boolean;
var
  tmpser: Cardinal;
begin
  Result := true;
  if (ObjAtLayerEx(RhandLayer, self) = 0) then
  begin
    tmpser := findtype(PickaxeType, backpack);
    if tmpser = 0 then
    begin
      Result := false;
      exit;
    end;
    if not equip(RhandLayer, tmpser) then
    begin
      wait(1000);
      if not equip(RhandLayer, tmpser) then
      begin
        Result := false;
        exit;
      end;
    end;
    wait(500);
    checksave;
  end;
end;

procedure CheckPick;
begin
  CheckSave;
  if (Count($0E85) < 1) then
  begin
    repeat
      ClearJournal;
      WaitTargetobject(findtype($1BF2, Backpack));
      UseObject(FindType($1EBA, backpack));
      wait(500);
      waitgump('400');
      wait(500);
      waitgump('0x0E85');
      WaitJournalLine(Now, 'Success|destroy|You put', 10000);
      wait(500);
    until (Count($0E85) >= 2);
  end;
end;

procedure MiningAround;
Begin
  for x := -0 to 0 do
  begin
    for y := -0 to 0 do
    begin
      repeat
        waitconnection(5000);
        if not CheckPickaxe then
          exit;
        if TargetPresent then
          CancelTarget;
        if WarMode = true then
          SetWarMode(false);
        ctime := Now;
        WaitTargetObject(self);
        UseObject(ObjAtLayerEx(RhandLayer, self));
        wait(250);
        k := 0;
        repeat
          wait(100);
          k := k + 1;
          //checksave;
          mn1 := InJournalBetweenTimes('ou can|stop|far', ctime, Now);
          mf1 := InJournalBetweenTimes('already', ctime, Now);
          mf2 := InJournalBetweenTimes('fail', ctime, Now);
          ms1 := InJournalBetweenTimes('way', ctime, Now);
          ms2 := InJournalBetweenTimes('mine or dig|There is no metal here to mine|for sand somewhere', ctime, Now);
        until (mn1 <> -1) or (mf1 <> -1) or (mf2 <> -1) or (ms1 <> -1) or (ms2 <> -1) or (k > 300) or dead;

      until (ms2 <> -1) or dead;
    end;
  end;
End;



procedure randomstep();
var
  ld: Integer;
begin
  ld := Random(4);

  if (ld = 0) then
  begin
    Step(0, false);
    Step(0, false);
  end;

  if (ld = 1) then
  begin
    Step(2, false);
    Step(2, false);
  end;

  if (ld = 2) then
  begin
    Step(4, false);
    Step(4, false);
  end;

  if (ld = 3) then
  begin
    Step(6, false);
    Step(6, false);
  end;
end;

procedure BankUnload;
label
  m, g;
Begin
  AddToSystemJournal('***');
  AddToSystemJournal('Backpack is full of ore, smelting it into ingots..');
  NewMoveXY(2573, 458, true, 1, false);
m:
  FindType($19B8, backpack);
  If (FindItem > 0) then
  begin
    UseObject(FindItem);
    wait(1000);
    goto m;
  end
  else
    ignore(finditem);

  ignoreReset;

  AddToSystemJournal('Moving to the bank..');
  NewMoveXY(2563, 529, true, 1, true);
  NewMoveXY(2510, 540, true, 1, true);
  NewMoveXY(BankX, BankY, true, 1, true);
  UoSay('bank');
  wait(1000);
  AddToSystemJournal('Storing Ingots into the bank:');
  AddToSystemJournal(
  'Iron:' + IntToStr(CountEx(IngotType, $0000, backpack)) + ' ' +
  'Copper:' + IntToStr(CountEx(IngotType, $0602, backpack)) + ' ' +
  'BD:' + IntToStr(CountEx(IngotType, $0425, backpack)) + ' ' +
  'Pagan:' + IntToStr(CountEx(IngotType, $050C, backpack)) + ' ' +
  'Silver:' + IntToStr(CountEx(IngotType, $03E9, backpack)) + ' ' +
  'Spectral:' + IntToStr(CountEx(IngotType, $0483, backpack)) + ' ' +
  'Lava:' + IntToStr(CountEx(IngotType, $0486, backpack)) + ' ' +
  'Ice:' + IntToStr(CountEx(IngotType, $04E7, backpack)) + ' ' +
  'Mythril:' + IntToStr(CountEx(IngotType, $0492, backpack)) + ' ' +
  'Basilisk:' + IntToStr(CountEx(IngotType, $0487, backpack)) + ' ' +
  'Sun:' + IntToStr(CountEx(IngotType, $0514, backpack)) + ' ' +
  'Daedra:' + IntToStr(CountEx(IngotType, $0494, backpack)) + ' ' +
  'Doom:' + IntToStr(CountEx(IngotType, $049F, backpack)) + ' ' +
  'Zulu:' + IntToStr(CountEx(IngotType, $0488, backpack)));
wait(2000);

g:
  FindType($1BF2, backpack);
  If finditem > 0 then
  begin
    moveItem(finditem, 0, IngotChest, 0, 0, 0);
    wait(1000);
    goto g;
  end;
  
	AddToSystemJournal('Total ingots in the bank:');
	AddToSystemJournal(
  'Iron:' + IntToStr(CountEx(IngotType, $0000, IngotChest)) + ' ' +
  'Copper:' + IntToStr(CountEx(IngotType, $0602, IngotChest)) + ' ' +
  'BD:' + IntToStr(CountEx(IngotType, $0425, IngotChest)) + ' ' +
  'Pagan:' + IntToStr(CountEx(IngotType, $050C, IngotChest)) + ' ' +
  'Silver:' + IntToStr(CountEx(IngotType, $03E9, IngotChest)) + ' ' +
  'Spectral:' + IntToStr(CountEx(IngotType, $0483, IngotChest)) + ' ' +
  'Lava:' + IntToStr(CountEx(IngotType, $0486, IngotChest)) + ' ' +
  'Ice:' + IntToStr(CountEx(IngotType, $04E7, IngotChest)) + ' ' +
  'Mythril:' + IntToStr(CountEx(IngotType, $0492, IngotChest)) + ' ' +
  'Basilisk:' + IntToStr(CountEx(IngotType, $0487, IngotChest)) + ' ' +
  'Sun:' + IntToStr(CountEx(IngotType, $0514, IngotChest)) + ' ' +
  'Daedra:' + IntToStr(CountEx(IngotType, $0494, IngotChest)) + ' ' +
  'Doom:' + IntToStr(CountEx(IngotType, $049F, IngotChest)) + ' ' +
  'Zulu:' + IntToStr(CountEx(IngotType, $0488, IngotChest)));
	wait(2000);
  AddToSystemJournal('Going back to the mine..');

  NewMoveXY(2563, 529, true, 1, true);
  MoveXYZ(2562, 508, -40, 1, 0, true);
  MoveXYZ(2564, 481, -45, 1, 0, true);
end;

Begin
  SetARStatus(true);
  while (connected) do
  begin
    while (true) do
    begin
      randomstep;
      FindDistance := 2;
      MiningAround;
      CheckPick
      If weight > (MaxWeight - 30) then
        //weight left before unload
        BankUnload;
      wait(3000);
    end;
  end;
End.