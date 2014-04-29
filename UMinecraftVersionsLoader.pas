unit UMinecraftVersionsLoader;

interface

uses SuperObject, Classes, Generics.Collections, VCL.dialogs;

type
  TMinecraftVersion = class
  public
    id, time, releaseTime, mtype:string;
  end;
  TMinecraftVersionsLoader = class
  private
    JSON:string;
    jso:ISuperObject;
  public
    Snapshot, Release : string;
    Versions:TList<TMinecraftVersion>;
    constructor Create(j:string);
  end;

implementation

constructor TMinecraftVersionsLoader.Create(j:string);
var vers:ISuperObject;
  i: Integer; o:ISuperObject;
  v: TMinecraftVersion;
begin
  JSON := j;
  jso := SO(JSON);
  vers := jso['versions'];
  Versions := TList<TMinecraftVersion>.Create;
  for i := 0 to vers.AsArray.Length - 1 do
  begin
    v := TMinecraftVersion.Create;
    o := vers.AsArray[i];
    v.id := o.S['id'];
    v.time := o.S['time'];
    v.releaseTime := o.S['releaseTime'];
    v.mtype := o.S['type'];
    Versions.Add(v);
  end;
  o := jso['latest'];
  Snapshot := o.S['snapshot'];
  Release := o.S['release'];
end;

end.
