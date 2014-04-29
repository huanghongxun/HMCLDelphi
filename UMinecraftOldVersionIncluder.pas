unit UMinecraftOldVersionIncluder;

interface

uses SysUtils, Classes, ULauncherProfileLoader, SuperObject,
     USettingsManager, UFileUtilities, WinApi.Windows;

type
  TMinecraftOldVersionIncluder = class
  private
    path, name:String;
  public
    constructor Create(path, name:String);
    procedure Include;
  end;

implementation

constructor TMinecraftOldVersionIncluder.Create(path: string; name: string);
begin
  Self.path := path;
  Self.name := name;
end;

procedure TMinecraftOldVersionIncluder.Include;
var inc, pa, f, na, newname:String;
    jso, lib, native: ISuperObject;
    libs: ISuperObject;
    s: TStringList;
    i: Integer;
    pro: TProfile;
begin
  inc := TFileUtilities.AddSeparator(SMPMinecraftPath);
  newname := name;
  for i := 1 to length(newname) do
    if newname[i] = '.' then
      newname[i] := '\';
  ForceDirectories(inc + 'versions\' + name);
  pa := TFileUtilities.AddSeparator(path);
  CopyFile(PWideChar(WideString(pa + 'bin\minecraft.jar')), PWideChar(WideString(inc + 'versions\' + name + '\' + name + '.jar')), false);
  ForceDirectories(inc + 'libraries\' + newname + '\natives\HML');
  TFileUtilities.Zip(0, 0, inc + 'libraries\' + newname + '\natives\HML\' + 'natives-HML-natives-windows.jar', pa + 'bin\natives');

  if DirectoryExists(pa + 'mods') then
  begin
    TFileUtilities.CopyDir(pa + 'mods', inc + 'versions\' + name + '\mods');
  end;
  if DirectoryExists(pa + 'coremods') then
  begin
    TFileUtilities.CopyDir(pa + 'coremods', inc + 'versions\' + name + '\coremods');
  end;
  if DirectoryExists(pa + 'config') then
  begin
    TFileUtilities.CopyDir(pa + 'config', inc + 'versions\' + name + '\config');
  end;

  jso := TSuperObject.Create;
  jso['id'] := SO('"' + name + '"');
  jso['time'] := SO('""');
  jso['releaseTime'] := SO('""');
  jso['minecraftArguments'] := SO('"${auth_player_name} ${auth_session}"');
  jso['minimumLauncherVersion'] := SO(0);
  jso['mainClass'] := SO('"net.minecraft.client.Minecraft"');
  s := TFileUtilities.FindAllFiles(pa + 'bin');
  libs := SA([]);
  for i := 0 to s.Count - 1 do
  begin
    f := ExtractFileName(s[i]);
    na := copy(f, 1, length(f) - 4);
    if f <> 'minecraft.jar' then
    begin
      ForceDirectories(inc + 'libraries\' + newname + '\' + na + '\HML');
      CopyFile(PWideChar(WideString(pa + 'bin\' + s[i])), PWideChar(WideString(inc + 'libraries\' + newname + '\' + na + '\HML\' + na + '-HML.jar')), false);
      lib := TSuperObject.Create;
      lib['name'] := SO('"' + name + ':' + na + ':HML' + '"');
      libs.AsArray.Add(lib);
    end;
  end;
  lib := TSuperObject.Create;
  lib['name'] := SO('"' + name + ':' + 'natives:HML"');
  native := TSuperObject.Create;
  native['windows'] := SO('"natives-windows"');
  lib['natives'] := SO(native);
  libs.AsArray.Add(lib);

  jso['libraries'] := SO(libs);
  TFileUtilities.WriteToFile(inc + 'versions\' + name + '\' + name + '.json', jso.AsJSon);

  pro := TProfile.Create(name);
  pro.lastVersionId := name;
  TProfilesManager.Add(pro);
  TProfilesManager.Savesss;
end;

end.
