unit ULauncherProfileLoader;

interface

uses SysUtils, UFileUtilities, SuperObject, USettingsManager, WinApi.Windows;

type
  TAuthenticationDatabase = class
  public
    Count:Integer;
    username, accessToken, uuid, displayName: Array[1..100]of String;
  end;

  TProfile = class
  public
    name, gameDir, javaDir, javaArgs, lastVersionId, playerUUID: String;
    HasGameDir, HasJavaDir, HasJavaArgs: Boolean;
    HasResolution, HasAllowedReleaseTypes: Boolean;
    HasLastVersionId, HasPlayerUUID: Boolean;
    Width, Height: Integer;

    constructor Create(name:String);
  end;

  TLauncherProfilesLoader = class
  public
    memory: array[1..1000]of integer;
    selectedProfile, clientToken:String;
    profiles:array[0..100]of TProfile;
    profileCount: Integer;
    authenticationDatabase: TAuthenticationDatabase;
    constructor Create(lp:string);
    function GenerateString:String;
  end;

  TProfilesManager = class
  public
    class procedure Load;
    class procedure Savesss;
    class procedure Add(p:TProfile);
    class function Find(name:String):TProfile;
  end;

var LPLoader: TLauncherProfilesLoader;
    LPLoaded: Boolean;

implementation

function GetGUID:string;
var g:TGUID;
begin
  CreateGUID(g);
  Result := GUIDToString(g);
  Result := Copy(Result, 2, Length(Result) - 2);
end;

function tryGet(j:ISuperObject;field,default:string;var has:Boolean):string;
var jso: ISuperObject;
begin
  jso := SOFindField(j, field);
  if jso = nil then
  begin
    has:=false;
    exit(default)
  end
  else
  begin
    has:=true;
    exit(jso.AsString);
  end;
end;

constructor TLauncherProfilesLoader.Create(lp:string);
var
  jso, pf, pp, res: ISuperObject;
  i: Integer; has:Boolean;
  item: TSuperObjectIter;
begin
  jso := SO(lp);

  if jso = nil then
  begin
    jso := TSuperObject.Create;
    jso['selectedProfile'] := SO('');
    jso['clientToken'] := SO(GetGUID);
  end;

  selectedProfile := tryGet(jso, 'selectedProfile', '(Default)', has);
  clientToken := tryGet(jso, 'clientToken', GetGUID, has);

  authenticationDatabase := TAuthenticationDatabase.Create;
  res := SOFindField(jso, 'authenticationDatabase');
  if res = nil then
  begin
    authenticationDatabase.Count := 0;
  end
  else
  begin
    i := 0;
    if ObjectFindFirst(res, item) then
    repeat
      pp := item.val;
      with authenticationDatabase do
      begin
        username[i] := pp['username'].AsString;
        accessToken[i] := pp['accessToken'].AsString;
        uuid[i] := pp['uuid'].AsString;
        displayName[i] := pp['displayName'].AsString;
      end;
      inc(i);
    until Not ObjectFindNext(item);
  end;

  pf := SOFindField(jso, 'profiles');

  if pf = nil then
    profileCount := 0
  else
  begin
    i := 0;
    if ObjectFindFirst(pf, item) then
    repeat
      pp := item.val;
      profiles[i] := TProfile.Create(pp.S['name']);
      profiles[i].gameDir := tryGet(pp, 'gameDir', '', profiles[i].HasGameDir);
      profiles[i].javaDir := tryGet(pp, 'javaDir', '', profiles[i].HasJavaDir);
      profiles[i].javaArgs := tryGet(pp, 'javaArgs', '', profiles[i].HasJavaArgs);
      profiles[i].lastVersionId := tryGet(pp, 'lastVersionId', '', profiles[i].HasLastVersionId);
      profiles[i].playerUUID := tryGet(pp, 'playerUUID', '', profiles[i].HasPlayerUUID);
      res := SOFindField(pp, 'resolution');
      if res = nil then
        profiles[i].HasResolution := false
      else
      begin
        profiles[i].HasResolution := true;
        profiles[i].Width := res['width'].AsInteger;
        profiles[i].Height := res['height'].AsInteger;
      end;
      if SOFindField(pp, 'allowedReleaseTypes') = nil then
        profiles[i].HasAllowedReleaseTypes := false
      else
        profiles[i].HasAllowedReleaseTypes := true;
      inc(i);
    until Not ObjectFindNext(item);
    profileCount := i;
  end;
//  MessageBox(0, PWideChar(WideString(TlkJSON.GenerateText(jso))), nil, MB_OK);
end;

function TLauncherProfilesLoader.GenerateString:String;
var jso, pro, procontent, resln, auth: ISuperObject;
  lst: ISuperobject; s:String;
  i: Integer;
begin
  jso := TSuperObject.Create;
  jso['selectedProfile'] := SO('"'+ParseSeparator(selectedProfile)+'"');
  jso['clientToken'] := SO('"'+clientToken+'"');
  auth := TSuperObject.Create;
  for i := 0 to authenticationDatabase.Count - 1 do
  begin
    resln := TSuperObject.Create;
    with authenticationDatabase do
    begin
      resln['username'] := SO('"'+username[i]+'"');
      resln['accessToken'] := SO('"'+accessToken[i]+'"');
      resln['uuid'] := SO('"'+uuid[i]+'"');
      resln['displayName'] := SO('"'+displayName[i]+'"');
      auth[uuid[i]] := resln;
    end;
  end;
  jso['authenticationDatabase'] := auth;

  pro := TSuperObject.Create;
  for i := 0 to profileCount - 1 do
  begin
    procontent := TSuperObject.Create;
    procontent['name'] := SO('"'+profiles[i].name+'"');
    if profiles[i].HasGameDir then
      procontent['gameDir'] := SO('"'+profiles[i].gameDir+'"');
    if profiles[i].HasJavaDir then
      procontent['javaDir'] := SO('"'+profiles[i].javaDir+'"');
    if profiles[i].HasJavaArgs then
      procontent['javaArgs'] := SO('"'+profiles[i].javaArgs+'"');
    if profiles[i].HasPlayerUUID then
      procontent['playerUUID'] := SO('"'+profiles[i].playerUUID+'"');
    if profiles[i].HasResolution then
    begin
      resln := TSuperObject.Create;
      resln['width'] := SO(SOString(profiles[i].Width));
      resln['height'] := SO(SOString(profiles[i].Height));
      procontent['resolution'] := resln;
    end;
    if profiles[i].HasAllowedReleaseTypes then
    begin
      lst := SA([]);
      lst.AsArray.Add(SO('"snapshot"'));
      lst.AsArray.Add(SO('"release"'));
      procontent['allowedReleaseTypes'] := lst;
    end;
    pro[ParseSeparator(profiles[i].name)] := procontent;
  end;
  jso['profiles'] := pro;
  s := jso.AsJSon;
  exit(s);
end;

class procedure TProfilesManager.Load;
var j: string;
begin
  j := TFileUtilities.ReadToEnd(SMPMinecraftPath + '\launcher_profiles.json');
  LPLoader := TLauncherProfilesLoader.Create(j);
  LPLoaded := true;
end;

class procedure TProfilesManager.Savesss;
begin
  if not LPLoaded then
    exit;
  TFileUtilities.WriteToFile(SMPMinecraftPath + '\launcher_profiles.json', LPLoader.GenerateString);
end;

class procedure TProfilesManager.Add(p: TProfile);
var
  i: Integer;

begin
  if p = nil then
    exit;
  for i := 0 to LPLoader.profileCount-1 do
    if LPLoader.profiles[i].name = p.name then
    begin
      LPLoader.profiles[i] := p;
      exit;
    end;
  LPLoader.profiles[LPLoader.profileCount] := p;
  Inc(LPLoader.profileCount);
end;

class function TProfilesManager.Find(name:String):TProfile;
var
  i: Integer;
begin
  for i := 0 to LPLoader.profileCount - 1 do
    if LPLoader.profiles[i].name = name then
      exit(LPLoader.profiles[i]);
  exit(nil);
end;

constructor TProfile.Create(name:String);
begin
  Self.name := name;
  Self.HasGameDir := false;
  Self.HasJavaDir := false;
  Self.HasJavaArgs := false;
  Self.HasResolution := false;
  Self.HasAllowedReleaseTypes := false;
  Self.HasLastVersionId := false;
  Self.HasPlayerUUID := false;
end;

end.
