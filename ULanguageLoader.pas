unit ULanguageLoader;

interface

uses SuperObject, WinApi.Windows;

type
  TLanguageLoader = class
  public
    count: Integer;
    name: array[0..100] of AnsiString;
    lang: array[0..100] of ISuperObject;
    jso: TSuperObject;
    constructor Create(text: string);
    function Find(lang: string):integer;
  end;

function WideStringToAnsiString(const strWide: WideString): AnsiString;

implementation

function WideStringToAnsiString(const strWide: WideString): AnsiString;
var
  Len: integer;
begin
  Result := '';
  if strWide = '' then Exit;

  Len := WideCharToMultiByte(GetACP,
    WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
    @strWide[1], -1, nil, 0, nil, nil);
  SetLength(Result, Len - 1);

  if Len > 1 then
    WideCharToMultiByte(GetACP,
      WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @strWide[1], -1, @Result[1], Len - 1, nil, nil);
end;

constructor TLanguageLoader.Create(text: string);
var
  i: Integer;
  item: TSuperObjectIter;
begin
  jso := SO(text) as TSuperObject;
  Count := 0;
  if ObjectFindFirst(jso, item) then
  repeat
    name[Count] := item.key;
    lang[Count] := item.val;
    inc(Count);
  until not ObjectFindNext(item);

{  for i := 0 to Count - 1 do
  begin
    name[i] := WideStringToAnsiString(jso.NameOf[i]);
    lang[i] := jso.FieldByIndex[i] as TlkJSONobject;
  end;}
  i := 1;
end;

function TLanguageLoader.Find(lang: string):integer;
var i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if lang = name[i] then
      exit(i);
  end;
  exit(-1);
end;

end.
