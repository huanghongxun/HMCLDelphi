unit USettingsManager;

interface

uses
  SuperObject, SysUtils, WinApi.Windows, Classes, Generics.Collections,
  UFileUtilities, System.Win.Registry;

type
  TMCPath = class
    path, name:String;
  end;

var
  SMPPlayerName, SMPMinecraftPath, SMPJavaPath, SMPLaunchMode, SMPLast,
  SMPBackgroundPath, SMPSkinPath, SMPSkinName, SMPLanguage: String;
  SMPMaxMemory: Int64;
  SMPUseJava, SMPLoaded, SMPDebug, SMPShowBackground: Boolean;

type
  TSettingsManager = class
  public
    class procedure Load;
    class procedure Save;
  end;

function IntegerToString(i:Integer):string;
function BooleanTOString(b:Boolean):string;
function GetJavaPath:string;

implementation

  //Returns Memory Size(MB)
  function GetMemorySize: Int64;
  var mse: TMemoryStatusEx;
  begin
    mse.dwLength := sizeof(TMemoryStatusEx);
    GlobalMemoryStatusEx(mse);
    exit(mse.ullTotalPhys div 1024 div 1024);
  end;

  function GetJavaPath:String;
  var reg, reg1, reg2: TRegistry;
      cv: String;
  begin
    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('Software\JavaSoft\Java Runtime Environment') then
      cv := reg.ReadString('CurrentVersion');
      reg1 := TRegistry.Create;
      reg1.RootKey := HKEY_LOCAL_MACHINE;
      if reg1.OpenKeyReadOnly('Software\JavaSoft\Java Runtime Environment\' + cv) then
      begin
        exit(reg1.ReadString('JavaHome') + '\bin');
      end;
    if reg.OpenKeyReadOnly('Software\JavaSoft\Java Development Kit') then
    begin
      reg2 := TRegistry.Create;
      reg2.RootKey := HKEY_LOCAL_MACHINE;
      cv := reg2.ReadString('CurrentVersion');
      if reg2.OpenKeyReadOnly('Software\JavaSoft\Java Development Kit\' + cv) then
      begin
        exit(reg2.ReadString('JavaHome') + '\bin');
      end;
    end;
    reg.CloseKey;
    exit('');
  end;

  function IntegerToString(i:Integer):string;
  begin
    Str(i, Result);
  end;

  function BooleanTOString(b:Boolean):string;
  begin
    if b then
      exit('true')
    else
      exit('false');
  end;

  function DefaultMemory:string;
  var s:string;
  begin
    str(GetMemorySize div 2, s);
    exit(s);
  end;

  procedure tryGet(j:ISuperObject;name,default:String;var res:String);
  var jso: ISuperObject;
  begin
    jso := SOFindField(j, name);
    if jso = nil then
      res := default
    else
      res := jso.AsString;
  end;

  procedure tryGetBoolean(j:ISuperObject;name:string; default:Boolean; var res:Boolean);
  var jso: ISuperObject;
  begin
    jso := SOFindField(j, name);
    if jso = nil then
      res := default
    else
      res := jso.AsBoolean;
  end;

  procedure tryGetInteger(j:ISuperObject;name:string; default:Integer;var res:Integer);
  var jso: ISuperObject;
  begin
    jso := SOFindField(j, name);
    if jso = nil then
      res := default
    else
      res := jso.AsInteger;
  end;

  procedure tryGetInt64(j:ISuperObject;name:string; default:Int64;var res:Int64);
  var jso: ISuperObject;
  begin
    jso := SOFindField(j, name);
    if jso = nil then
      res := default
    else
      res := jso.AsInteger;
  end;

  class procedure TSettingsManager.Load;
  var t, jc:string; readfile:TextFile;
    jobj: ISuperObject; p:TMCPath;
  begin
    if FileExists(TFileUtilities.CurrentDir + 'settings.json') then
    begin
      AssignFile(ReadFile, TFileUtilities.CurrentDir + 'settings.json');
      ReSet(ReadFile);
      jc := '';
      while Not Eof(ReadFile) do
      begin
        ReadLn(ReadFile, t);
        jc := jc + t;
      end;
      Close(ReadFile);
      jobj := SO(jc);
      tryGet(jobj, 'PlayerName', 'Player007', SMPPlayerName);
      tryGet(jobj, 'MinecraftPath', TFileUtilities.CurrentDir + '.minecraft', SMPMinecraftPath);
      tryGet(jobj, 'LaunchMode', 'Normal', SMPLaunchMode);
      tryGet(jobj, 'JavaPath', GetJavaPath, SMPJavaPath);
      tryGet(jobj, 'Last', '', SMPLast);
      tryGet(jobj, 'BackgroundPath', '', SMPBackgroundPath);
      tryGet(jobj, 'SkinPath', '', SMPSkinPath);
      tryGet(jobj, 'SkinName', '', SMPSkinName);
      tryGet(jobj, 'Lang', 'zh_CN', SMPLanguage);
      tryGetInt64(jobj, 'MaxMemory', GetMemorySize div 2, SMPMaxMemory);
      tryGetBoolean(jobj, 'UseJava', false, SMPUseJava);
      tryGetBoolean(jobj, 'Debug', false, SMPDebug);
      tryGetBoolean(jobj, 'ShowBackground', false, SMPShowBackground);
      SMPLoaded := true;
    end
    else
    begin

      SMPPlayerName := 'Player007';
      SMPMinecraftPath := TFileUtilities.CurrentDir + '.minecraft';
      SMPMaxMemory := GetMemorySize div 2;
      SMPJavaPath := GetJavaPath;
      SMPUseJava := false;
      SMPDebug := false;
      SMPLast := '';
      SMPLaunchMode := 'Normal';
      SMPBackgroundPath := '';
      SMPSkinPath := '';
      SMPSkinName := '';
      SMPLanguage := 'zh_CN';

      SMPLoaded := true;
      TSettingsManager.Save;

    end;

  end;

  class procedure TSettingsManager.Save;
  var writefile:textfile; jobj: ISuperObject;
      content, path:String;
  begin
    if Not SMPLoaded then exit;

    path := TFileUtilities.CurrentDir;
    AssignFile(WriteFile, path + 'settings.json');
    ReWrite(WriteFile);
    jobj := TSuperObject.Create;
    jobj['PlayerName'] := SO('"' + ParseSeparator(SMPPlayerName) + '"');
    jobj['MinecraftPath'] := SO('"' + ParseSeparator(SMPMinecraftPath) + '"');
    jobj['JavaPath'] := SO('"' + ParseSeparator(SMPJavaPath) + '"');
    jobj['Last'] := SO('"' + ParseSeparator(SMPLast) + '"');
    jobj['MaxMemory'] := SO(SMPMaxMemory);
    jobj['UseJava'] := SO(SMPUseJava);
    jobj['Debug'] := SO(SMPDebug);
    jobj['ShowBackground'] := SO(SMPShowBackground);
    jobj['LaunchMode'] := SO('"' + ParseSeparator(SMPLaunchMode) + '"');
    jobj['BackgroundPath'] := SO('"' + ParseSeparator(SMPBackgroundPath) + '"');
    jobj['SkinPath'] := SO('"' + ParseSeparator(SMPSkinPath) + '"');
    jobj['SkinName'] := SO('"' + ParseSeparator(SMPSkinName) + '"');
    jobj['Lang'] := SO('"' + ParseSeparator(SMPLanguage) + '"');
    content:=jobj.AsJSon;
    Write(WriteFile,content);
    Close(WriteFile);
  end;


end.
