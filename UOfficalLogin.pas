unit UOfficalLogin;

interface

uses IdSSL, IdSSLOpenSSL, Classes, IdHTTP;

type
  ILogin = interface
    function Login(usr, pwd: String):Boolean;
  end;

  TOfficalLogin = class(TInterfacedObject, ILogin)
  public
    Session, ProfileId, ProfileName: String;
    function Login(usr, pwd: String):Boolean;
  end;

implementation

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

function TOfficalLogin.Login(usr: string; pwd: string):Boolean;
var
  ssl:TIdSSLIOHandlerSocketOpenSSL;
  http: TIDHttp;
  ans: String;
  sl: TStringList;
  postDataStream, paramData: TStringStream;
begin
  paramData := TStringStream.Create('user=' + usr + '&password=' + pwd + '&version=13');
  postDataStream := TStringStream.Create('');
  ssl := TIdSSLIOHandlerSocketOpenSSL.Create;
  http := TIDHttp.Create;
  http.IOHandler := ssl;
  http.Post('https://login.minecraft.net', paramData, postDataStream);
  postDataStream.Position := 0;
  ans := postDataStream.DataString;
  sl := SplitString(ans, ':');
  if sl.Count = 5 then
  begin
    ProfileName := sl[2];
    Session  := sl[3];
    ProfileId := sl[4];
    exit(true);
  end
  else
    exit(false);
end;

end.
