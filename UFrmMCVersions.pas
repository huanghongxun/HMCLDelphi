unit UFrmMCVersions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, WinApi.URLMon, sLabel, sButton,
  UDownloader, IdBaseComponent, IdComponent, IdTCPConnection, SuperObject,
  IdTCPClient, IdHTTP, USettingsManager, UMinecraftVersionsLoader, UFileUtilities,
  UMinecraftDownloader, Vcl.ComCtrls, Winapi.ActiveX, IdIOHandler, ULanguageLoader,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, sListBox, sSkinManager, sGauge;

type


  TFrmVersions = class(TForm)
    pgsDownload: TsGauge;
    lstVersions: TsListBox;
    IdHTTP1: TIdHTTP;
    BtnDownload: TsButton;
    lstDownloadingState: TsListBox;
    lblDownloadingState: TsLabelFx;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    procedure BtnDownloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

  type
    TBindStatusCallback = class(TInterfacedObject, IDownloadCallback)
      v:TFrmVersions;
    protected
      function OnStartBinding( dwReserved: DWORD; pib: IBinding ): HResult; stdcall;
      function GetPriority( out nPriority ): HResult; stdcall;
      function OnLowResource( reserved: DWORD ): HResult; stdcall;
      function OnProgress( ulProgress, ulProgressMax, ulStatusCode: ULONG;
      szStatusText: LPCWSTR): HResult; stdcall;
      function OnStopBinding( hresult: HResult; szError: LPCWSTR ): HResult; stdcall;
      function GetBindInfo( out grfBINDF: DWORD; var bindinfo: TBindInfo ): HResult; stdcall;
      function OnDataAvailable( grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc;
      stgmed: PStgMedium ): HResult; stdcall;
      function OnObjectAvailable( const iid: TGUID; punk: IUnknown ): HResult; stdcall;
      procedure OnStatus(status:string);
    public
      constructor Create(v:TFrmVersions);
    end;
    TBindStatusCallback2 = class(TInterfacedObject, IDownloadCallback)
      v:TFrmVersions;
    protected
      function OnStartBinding( dwReserved: DWORD; pib: IBinding ): HResult; stdcall;
      function GetPriority( out nPriority ): HResult; stdcall;
      function OnLowResource( reserved: DWORD ): HResult; stdcall;
      function OnProgress( ulProgress, ulProgressMax, ulStatusCode: ULONG;
      szStatusText: LPCWSTR): HResult; stdcall;
      function OnStopBinding( hresult: HResult; szError: LPCWSTR ): HResult; stdcall;
      function GetBindInfo( out grfBINDF: DWORD; var bindinfo: TBindInfo ): HResult; stdcall;
      function OnDataAvailable( grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc;
      stgmed: PStgMedium ): HResult; stdcall;
      function OnObjectAvailable( const iid: TGUID; punk: IUnknown ): HResult; stdcall;
      procedure OnStatus(status:string);
    public
      constructor Create(v:TFrmVersions);
    end;
  public
    mvl : TMinecraftVersionsLoader;
    d:TDownloader;
    cb2: TBindStatusCallback2;
    ll: TLanguageLoader;
    procedure FormLoad;
    procedure onGetString(Result: AnsiString);
    procedure SetActiveLanguage(LanguageName:string);
  end;

var
  FrmVersions: TFrmVersions;

implementation

{$R *.dfm}

constructor TFrmVersions.TBindStatusCallback.Create(v: TFrmVersions);
begin
  Self.v := v;
end;

function TFrmVersions.TBindStatusCallback.GetBindInfo( out grfBINDF: DWORD; var bindinfo: TBindInfo ): HResult;
begin
result := S_OK;
end;

function TFrmVersions.TBindStatusCallback.GetPriority( out nPriority ): HResult;
begin
Result := S_OK;
end;

function TFrmVersions.TBindStatusCallback.OnDataAvailable( grfBSCF, dwSize: DWORD; formatetc: PFormatEtc; stgmed: PStgMedium ): HResult;
begin
Result := S_OK;
end;

function TFrmVersions.TBindStatusCallback.OnLowResource( reserved: DWORD ): HResult;
begin
Result := S_OK;
end;

function TFrmVersions.TBindStatusCallback.OnObjectAvailable( const iid: TGUID; punk: IInterface ): HResult;
begin
Result := S_OK;
end;

function TFrmVersions.TBindStatusCallback.OnStartBinding( dwReserved: DWORD; pib: IBinding ): HResult;
begin
Result := S_OK;
end;
function TFrmVersions.TBindStatusCallback.OnStopBinding( hresult: HResult; szError: LPCWSTR ): HResult;
begin
Result := S_OK;
end;

constructor TFrmVersions.TBindStatusCallback2.Create(v: TFrmVersions);
begin
  Self.v := v;
end;

function TFrmVersions.TBindStatusCallback2.GetBindInfo( out grfBINDF: DWORD; var bindinfo: TBindInfo ): HResult;
begin
result := S_OK;
end;

function TFrmVersions.TBindStatusCallback2.GetPriority( out nPriority ): HResult;
begin
Result := S_OK;
end;

function TFrmVersions.TBindStatusCallback2.OnDataAvailable( grfBSCF, dwSize: DWORD; formatetc: PFormatEtc; stgmed: PStgMedium ): HResult;
begin
Result := S_OK;
end;

function TFrmVersions.TBindStatusCallback2.OnLowResource( reserved: DWORD ): HResult;
begin
Result := S_OK;
end;

function TFrmVersions.TBindStatusCallback2.OnObjectAvailable( const iid: TGUID; punk: IInterface ): HResult;
begin
Result := S_OK;
end;

function TFrmVersions.TBindStatusCallback2.OnStartBinding( dwReserved: DWORD; pib: IBinding ): HResult;
begin
Result := S_OK;
end;
function TFrmVersions.TBindStatusCallback2.OnStopBinding( hresult: HResult; szError: LPCWSTR ): HResult;
var
  i: Integer;
begin
  v.mvl := TMinecraftVersionsLoader.Create(TFileUtilities.ReadToEnd(SMPMinecraftPath+'\versions\versions.json'));
  for i := 0 to v.mvl.Versions.Count - 1 do
  begin
    v.lstVersions.AddItem(v.mvl.Versions[i].id, nil);
  end;
  Result := S_OK;
end;
procedure TFrmVersions.TBindStatusCallback.OnStatus(status: string);
begin
  v.lstDownloadingState.AddItem(status, nil);
end;
procedure TFrmVersions.TBindStatusCallback2.OnStatus(status: string);
begin
  v.lstDownloadingState.AddItem(status, nil);
end;

function TFrmVersions.TBindStatusCallback.OnProgress(ulProgress: Cardinal; ulProgressMax: Cardinal; ulStatusCode: Cardinal; szStatusText: PWideChar): HResult;
begin
  v.pgsDownload.MinValue := 0;
  v.pgsDownload.MaxValue := ulProgressMax;
  v.pgsDownload.Progress := ulProgress;
end;

function TFrmVersions.TBindStatusCallback2.OnProgress(ulProgress: Cardinal; ulProgressMax: Cardinal; ulStatusCode: Cardinal; szStatusText: PWideChar): HResult;
begin
//  v.pgsDownload.MinValue := 0;
//  v.pgsDownload.MaxValue := ulProgressMax;
//  v.pgsDownload.Progress := ulProgress;
end;

function FindSelected(lst:TListBox): Integer;
var
  i: Integer;
begin
  for i := 0 to lst.Count - 1 do
  begin
    if(lst.Selected[i])then exit(i);
  end;
  exit(-1);
end;

procedure   TFrmVersions.SetActiveLanguage(LanguageName:string);
var
    frmComponent:TComponent;
    i:Integer;
    jso, tmp: ISuperObject;
    s:String;
    jts: TSuperTableString;
begin
  jso := ll.lang[ll.Find(LanguageName)];
  for   i:=0   to   ComponentCount-1 do   {   遍历Form组件   }
  begin
    frmComponent:=Components[i];
    tmp := SOFindField(jso, 'FrmMCVersions.' + frmComponent.Name + '.Caption');
    if tmp <> nil then
    begin
      s := WideStringToAnsiString(tmp.AsString);
      if frmComponent is TsLabelFx then   {   如果组件为TLabel型则当作TLabel处理，以下同   }
      begin
        (frmComponent as TsLabelFx).Caption:=s;
      end else
      if frmComponent is TsButton then
      begin
        (frmComponent as TsButton).Caption:=s;
      end;
    end;
  end;
end;

procedure TFrmVersions.BtnDownloadClick(Sender: TObject);
var index:integer;
  d: TMinecraftDownloader;
  cb: TBindStatusCallback;
begin
  index := FindSelected(lstVersions);
  if(index=-1)then
  begin
    ShowMessage(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'FrmMCVersions.NotSelectedAnyMinecraftVersion').AsString);
    exit;
  end;
  cb := TBindStatusCallback.Create(self);
  d := TMinecraftDownloader.Create(SMPMinecraftPath, lstVersions.Items[index], cb);
end;

procedure TFrmVersions.FormCreate(Sender: TObject);
begin
  ll := TLanguageLoader.Create(TFileUtilities.ReadToEnd('lang.json'));
end;

procedure TFrmVersions.FormLoad;
begin
end;

procedure TFrmVersions.FormShow(Sender: TObject);
var s:string; i, j:integer;
begin
  SetActiveLanguage(SMPLanguage);

  IDHTTP1.IOHandler := Self.IdSSLIOHandlerSocketOpenSSL1;

  cb2 := TBindStatusCallback2.Create(Self);

  d := TDownloader.Create('https://s3.amazonaws.com/Minecraft.Download/versions/versions.json');
  d.DownFileAsync(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'versions\versions.json', cb2);
  cb2.OnStatus('Getting versions...');

end;

procedure TFrmVersions.onGetString(Result: AnsiString);
begin
end;

end.
