unit UMinecraftLoader;

interface

uses WinApi.Windows, classes, UFileUtilities, SysUtils, ULauncherProfileLoader,
    SuperObject;

type
  TMinecraftLibrary = class
  public
    OldText, Formatted:string;
    RuleCount:integer;
    RulesAction:array[1..8]of string;
    RulesOSName:array[1..8]of string;
    RulesOSVersion:array[1..8]of string;
  end;

  TMinecraftUnPackingLibrary = class(TMinecraftLibrary)
  public
    NativeLinux, NativeWindows, NativeOSX: string;
    ExtractExcludes: array[1..5]of string;
    ExtractExcludeCount: Integer;
  end;

  TMinecraftLoader = class

  public
    MinecraftVersionText: string;
    MinecraftVersionJson: ISuperObject;

    profile: TProfile;

    MinecraftPath: string;
    ID, Time, ReleaseTime, MType, ProcessArguments, MinecraftArguments,
      MainClass, JavaPath, Session: string;
    UseJava: Boolean;
    PlayerName, AuthSession, VersionName, GameDir, GameAssets, LaunchMode: string;
    MinimumLauncherVersion, MaxMemory: Integer;
    UnpackingLibraries: array[1..100] of TMinecraftUnPackingLibrary;
    Libraries:array[1..100] of TMinecraftLibrary;
    LibraryCount, UnpackingLibraryCount: Integer;

    // MinecraftPath, MinecraftVersionText, JavaPath, LaunchMode, PlayerName, MaxMemory
    constructor Create
      (mcp, mvt, jp, lm, pn, ss:string; mm:Integer; pro: TProfile; usejava: Boolean);

    function GenerateLaunchString:string;

    procedure FormatLibrary
      (name:string; var res:TMinecraftLibrary; Rules:ISuperObject);
    procedure FormatUnpackingLibrary
      (name:string; var res:TMinecraftUnpackingLibrary; Rules, Natives:ISuperObject);

  private
  protected
  end;

implementation

function IntegerToString(i:Integer): string;
begin
  str(i, Result);
end;

function SplitString(const Source,ch:String):TStringList;
var
  temp:String;
  i:Integer;
begin
  SplitString:=TStringList.Create;
  //如果是空自符串则返回空列表
  if Source='' then exit;
  temp:=Source;
  i:=pos(ch,Source);
  while i<>0 do
  begin
    SplitString.add(copy(temp,0,i-1));
    Delete(temp,1,i);
    i:=pos(ch,temp);
  end;
  SplitString.add(temp);
end;

constructor TMinecraftLoader.Create
  (mcp, mvt, jp, lm, pn, ss: string; mm:Integer; pro: TProfile; usejava: Boolean);
var lib: TSuperArray; i: Integer; tmp: ISuperObject;
begin

  Self.UseJava := usejava;
  Self.MinecraftPath := mcp;
  Self.MaxMemory := mm;
  Self.JavaPath := jp;
  Self.UseJava := usejava;
  Self.LaunchMode := lm;
  Self.PlayerName := pn;
  Self.Session := ss;
  Self.GameDir := mcp;
  Self.GameAssets := mcp + '\assets';
  Self.MinecraftVersionText := mvt;

  Self.MinecraftVersionJson := SO(mvt);
  Self.ID := Self.MinecraftVersionJSON.S['id'];
  Self.VersionName := ID;
  Self.Time := Self.MinecraftVersionJson.S['time'];
  Self.ReleaseTime := Self.MinecraftVersionJson.S['releaseTime'];
  Self.MType := Self.MinecraftVersionJson.S['type'];
  Self.ProcessArguments := Self.MinecraftVersionJson.S['processArguments'];
  Self.MinecraftArguments := Self.MinecraftVersionJson.S['minecraftArguments'];
  Self.MinimumLauncherVersion := Self.MinecraftVersionJson.I['minimumLauncherVersion'];
  Self.MainClass := Self.MinecraftVersionJson.S['mainClass'];

  if pro = nil then
  begin
    Self.profile := TProfile.Create(ID);
    Self.profile.HasGameDir := false;
    Self.profile.HasJavaDir := false;
    Self.profile.HasJavaArgs := false;
    Self.profile.HasResolution := false;
    Self.profile.HasAllowedReleaseTypes := false;
    Self.profile.HasLastVersionId := false;
  end
  else
  begin
    Self.profile := pro;
    if profile.HasGameDir then
      GameDir := profile.gameDir;
    if profile.HasJavaDir then
      JavaPath := profile.javaDir;
  end;

  lib := Self.MinecraftVersionJson.A['libraries'];
  LibraryCount := 0;
  for i := 0 to lib.Length - 1 do
  begin
    tmp := lib[i];
    if(SOFindField(tmp, 'natives') <> nil)then
    begin
      inc(UnpackingLibraryCount);
      UnpackingLibraries[UnpackingLibraryCount] :=
        TMinecraftUnpackingLibrary.Create;
      FormatUnpackingLibrary(tmp.S['name'],
        UnpackingLibraries[UnpackingLibraryCount],
        SOFindField(tmp, 'rules'), SOFindField(tmp, 'natives'));
    end else
    begin
      inc(LibraryCount);
      Libraries[LibraryCount] := TMinecraftLibrary.Create;
      FormatLibrary(tmp.S['name'],
                    Libraries[LibraryCount],
                    SOFindField(tmp, 'rules'));
    end;
  end;
end;

procedure TMinecraftLoader.FormatLibrary
  (name:string; var res:TMinecraftLibrary; Rules:ISuperObject);
var s:TStringList; str:string; j: Integer;
    rule, os: ISuperObject; rulesArr: TSuperArray;
begin
  res.OldText := name;
  s := SplitString(res.OldText, ':');
  str := s[0];
  for j := 1 to length(str) do
    if str[j] = '.' then
      str[j] := '\';
  str := str + '\' + s[1] + '\' + s[2] + '\' + s[1] + '-' + s[2] + '.jar';
  res.Formatted := str;

  if(rules <> nil) then
  begin
    rulesArr := rules.AsArray;
    res.RuleCount := rulesArr.Length;
    for j := 0 to rulesArr.Length - 1 do
    begin
      rule := rulesArr[j];
      res.RulesAction[j+1] := rule.S['action'];
      if SOFindField(rule, 'os') <> nil then
      begin
        os := rule['os'];
        res.RulesOSName[j+1] := os.S['name'];
        res.RulesOSVersion[j+1] := os.S['version'];
      end
      else
      begin
        res.RulesOSName[j+1] := '';
        res.RulesOSVersion[j+1] := '';
      end;
    end;
  end;
end;

procedure TMinecraftLoader.FormatUnpackingLibrary
  (name:string; var res: TMinecraftUnpackingLibrary; Rules, Natives:ISuperObject);
var s:TStringList; str:string; j: Integer;
    rule, os, nat: ISuperObject; rulesArr: TSuperArray;
begin
  res.OldText := name;
  s := SplitString(res.OldText, ':');
  str := s[0];
  for j := 1 to length(str) do
    if str[j] = '.' then
      str[j] := '\';

  if Natives<>nil then
  begin
    nat := SOFindField(Natives, 'windows');
    if nat <> nil then
      res.NativeWindows := nat.AsString
    else
      res.NativeWindows := 'natives-windows';
    nat := SOFindField(Natives, 'linux');
    if nat <> nil then
      res.NativeLinux := nat.AsString
    else
      res.NativeLinux := 'natives-linux';
    if nat <> nil then
      res.NativeOSX := nat.AsString
    else
      res.NativeOSX := 'natives-osx';
  end;

  str := str + '\' + s[1] + '\' + s[2] + '\' + s[1] + '-' + s[2] + '-' + res.NativeWindows + '.jar';
  res.Formatted := str;

  if(rules <> nil) then
  begin
    rulesArr := rules.AsArray;
    res.RuleCount := rulesArr.Length;
    for j := 0 to rulesArr.Length - 1 do
    begin
      rule := rulesArr[j];
      res.RulesAction[j+1] := rule.S['action'];
      if SOFindField(rule, 'os') <> nil then
      begin
        os := rule['os'];
        res.RulesOSName[j+1] := os.S['name'];
        res.RulesOSVersion[j+1] := os.S['version'];
      end
      else
      begin
        res.RulesOSName[j+1] := '';
        res.RulesOSVersion[j+1] := '';
      end;
    end;
  end;
end;

function TMinecraftLoader.GenerateLaunchString;
var res, t, pa:string;
  i, j: Integer;
  flag: Boolean;
begin
  res := '"';
  pa := Trim(JavaPath);
  if UseJava then
    if length(pa) = 0 then
      res := res + 'java.exe'
    else
      res := res + TFileUtilities.AddSeparator(pa) + 'java.exe'
  else
    if length(pa) = 0 then
      res := res + 'javaw.exe'
    else
      res := res + TFileUtilities.AddSeparator(pa) + 'javaw.exe';
  res := res + '" ';
  if profile.HasJavaArgs then
  begin
    if pos(profile.javaArgs, '-d') = 0 then
      res := res + LaunchMode + ' ';
    if pos(profile.javaArgs, '-Xmx') = 0 then
      res := res + '-Xmx' + IntegerToString(MaxMemory) + 'm ';
    res := res + profile.javaArgs + ' ';
  end
  else
  begin
    res := res + LaunchMode + ' -Xincgc -Xmx';
    res := res + IntegerToString(MaxMemory) + 'm ';
  end;
  res := res + '-Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true ';
  res := res + '-Djava.library.path="';
  res := res + TFileUtilities.AddSeparator(MinecraftPath) + 'versions\' + ID + '\' + ID + '-natives"'  + ' -cp ';
  for i := 1 to LibraryCount do
  begin
    flag := false;
    if(Libraries[i].RuleCount = 0)then
      flag := true;
    for j := 1 to Libraries[i].RuleCount do
      if Libraries[i].RulesAction[j] = 'disallow' then
      begin
        if (Libraries[i].RulesOSName[j] = '')
         or(Trim(LowerCase(Libraries[i].RulesOSName[j])) = 'windows') then
        begin
          flag := false;
          break;
        end;
      end
      else
      begin
        if (Libraries[i].RulesOSName[j] = '')
         or(Trim(LowerCase(Libraries[i].RulesOSName[j])) = 'windows') then
        begin
          flag := true;
          break;
        end;
      end;
    if flag then
      res := res + '"' + TFileUtilities.AddSeparator(MinecraftPath) + 'libraries\' + Libraries[i].Formatted + '";';
  end;
  res := res + '"' + MinecraftPath + '\versions\' + ID + '\' + ID + '.jar" ';
  res := res + MainClass + ' ';
  t := MinecraftArguments;
  t := StringReplace(t, '${auth_player_name}', PlayerName, [rfReplaceAll]);
  t := StringReplace(t, '${auth_session}', Session, [rfReplaceAll]);
  t := StringReplace(t, '${version_name}', VersionName, [rfReplaceAll]);
  t := StringReplace(t, '${game_directory}', '"' + GameDir + '"', [rfReplaceAll]);
  t := StringReplace(t, '${game_assets}', '"' + GameAssets + '"', [rfReplaceAll]);
  if profile.HasResolution then
    t := t + ' --height ' + IntegerToString(profile.Height) + ' --width ' + IntegerToString(profile.Width);
  res := res + t;
  //--username ' + PlayerName + ' --version ' + VersionName + ' --gameDir ' + GameDir + ' --assetsDir ' + GameAssets;
  exit(res);
end;

end.
