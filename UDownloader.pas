unit UDownloader;

interface

uses
  WinApi.Windows, WinApi.Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, XPMan, IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  WinApi.URLmon;

type

  IDownloadCallBack = interface(IBindStatusCallBack)
    procedure OnStatus(status:string);
  end;

  TFileDownloadThread = class(TThread)
  private
     FSourceURL: string;
     FSaveFileName: string;
     FProgress,FProgressMax:Cardinal;
     callback:IDownloadCallBack;
   protected
      procedure Execute; override;
  end;

  TDownloader = Class

  private
    t: TFileDownloadThread;

  public
    http: TIDHTTP;
    DownloadURL:string;
    Constructor Create(url:string);
    Procedure DownFileAsync(fileuRL:string; cb: IDownloadCallBack);
    Procedure DownFile(fileURL:String; cb: IDownloadCallBack);
  End;

var
  IdHTTP1: TIdHTTP;
  IdAntiFreeze1: TIdAntiFreeze;
  startIndex:Integer;
  IsStop:Boolean;       //”√ªß «∑Ò÷’÷π
implementation

procedure TFileDownloadThread.Execute;
var ret: HRESULT;
begin
  inherited;
  ret := URLDownloadToFile(nil, PWideChar(WideString(FSourceURL)), PWideChar(WideString(FSaveFileName)), 0, callback);
  if callback <> nil then

    if ret = S_OK then
      callback.OnStatus('Downloaded')
    else
      callback.OnStatus('Download Failed');
end;

constructor TDownloader.Create(url: string);
begin
  DownloadURL := url;
  t := TFileDownloadThread.Create(true);
  t.FSourceURL := url;
end;

function IntegerToString(i:Integer):string;
var t:string;
begin
  str(i,t);
  exit(t);
end;

Procedure TDownloader.DownFileAsync(fileuRL:string; cb: IDownloadCallback);
begin
  try
    t.FSaveFileName := fileuRL;
    t.callback := cb;
    t.Start;
  except
  end;
end;

Procedure TDownloader.DownFile(fileURL: string; cb: IDownloadCallBack);
var ret: HRESULT;
begin
  if FileExists(fileURL) then
    DeleteFile(fileURL);
  ret := URLDownloadToFile(nil, PWideChar(WideString(DownloadURL)), PWideChar(WideString(fileURL)), 0, cb);
  if cb <> nil then
    if ret = S_OK then
      cb.OnStatus('Downloaded')
    else
      cb.OnStatus('Download Failed');
end;

end.
