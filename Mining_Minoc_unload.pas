Program mining;

{$Include 'all.inc'}

type
  LumbRecord = Record
    x, y, tt: integer;
  end;

var
  x, y, k: integer;
  ctime: TDateTime;
  mn1, mf1, mf2, ms1, ms2: Integer;

const
  Pickaxe1 = $0E85;
  Pickaxe2 = $0E85;
  IngotType = $1BF2;

  typeTTools = $1EBA;

  BankX = 2509; //Minoc Bank coordinates
  BankY = 537;

  sunduk = $5E4AB377; //ID of a container inside bank to store ingots in

function CheckPickaxe: Boolean;
var
  tmpser: Cardinal;
begin
  Result := true;
  if (ObjAtLayerEx(RhandLayer, self) = 0) then
  begin
    tmpser := findtype(Pickaxe1, backpack);
    if tmpser = 0 then
      tmpser := findtype(Pickaxe2, backpack);
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

procedure DropMap;
begin
  repeat
    FindTypeEx($14ED, $ffff, backpack, False);
    if (findcount > 0) then
      Drop(finditem, 0, 0, 0, 0);
    wait(100);
    checksave;
  until findcount = 0;
end;

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

procedure goUpload;
label
  m, g;
Begin
  AddToSystemJournal('Smelting ore into ingots...');
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

  AddToSystemJournal('Backpack is full. Unloading into the bank...');
  NewMoveXY(2563, 529, true, 1, true);
  NewMoveXY(2510, 540, true, 1, true);
  NewMoveXY(BankX, BankY, true, 1, true);
  UoSay('bank');
  wait(1000);

  AddToSystemJournal('Storing Ingots into the bank...');

g:
  FindType($1BF2, backpack);
  If finditem > 0 then
  begin
    moveItem(finditem, 0, sunduk, 0, 0, 0);
    wait(1000);
    goto g;
  end;

  AddToSystemJournal('Go back to the mine.');

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
      DropMap;
      CheckPick
      If weight > (MaxWeight - 50) then
        //weight left before unload
        goUpload;
      wait(3000);
    end;
  end;
End.