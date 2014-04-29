unit UFrmAssets;

interface

uses
  WinApi.Windows, Classes, Generics.Collections, SuperXMLParser, SuperObject,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UDownloader, Winapi.ActiveX, WinApi.UrlMon,
  Vcl.Controls, XmlDoc, XMLDom, IdBaseComponent, IdComponent, UFileUtilities,
  IdTCPConnection, IdTCPClient, IdHTTP, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

const
  MC_RESOURCES_URL = 'https://s3.amazonaws.com/Minecraft.Resources/';

type
  TFrmAssets = class(TForm)
    BtnDownloadAll: TButton;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    procedure BtnDownloadAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  type
    TBindStatusCallback = class(TInterfacedObject, IDownloadCallback)
      v:TFrmAssets;
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
      constructor Create(v:TFrmAssets);
    end;
  private
    d: TDownloader;
    doc: ISuperObject;
    cb: TBindStatusCallBack;
    procedure ParseXML(xml:string);
  public
  end;



var
  FrmAssets: TFrmAssets;

implementation

{$R *.dfm}

constructor TFrmAssets.TBindStatusCallback.Create(v: TFrmAssets);
begin
  Self.v := v;
end;

function TFrmAssets.TBindStatusCallback.GetBindInfo( out grfBINDF: DWORD; var bindinfo: TBindInfo ): HResult;
begin
result := S_OK;
end;

function TFrmAssets.TBindStatusCallback.GetPriority( out nPriority ): HResult;
begin
Result := S_OK;
end;

function TFrmAssets.TBindStatusCallback.OnDataAvailable( grfBSCF, dwSize: DWORD; formatetc: PFormatEtc; stgmed: PStgMedium ): HResult;
begin
Result := S_OK;
end;

function TFrmAssets.TBindStatusCallback.OnLowResource( reserved: DWORD ): HResult;
begin
Result := S_OK;
end;

function TFrmAssets.TBindStatusCallback.OnObjectAvailable( const iid: TGUID; punk: IInterface ): HResult;
begin
Result := S_OK;
end;

function TFrmAssets.TBindStatusCallback.OnStartBinding( dwReserved: DWORD; pib: IBinding ): HResult;
begin
Result := S_OK;
end;
function TFrmAssets.TBindStatusCallback.OnStopBinding( hresult: HResult; szError: LPCWSTR ): HResult;
var s:String;
begin
  s := TFileUtilities.ReadToEnd('resources.xml');
  v.ParseXML(s);
  Result := S_OK;
end;

function TFrmAssets.TBindStatusCallback.OnProgress( ulProgress, ulProgressMax, ulStatusCode: ULONG;szStatusText: LPCWSTR): HResult;
begin
end;

procedure TFrmAssets.TBindStatusCallBack.OnStatus(status: string);
begin

end;

procedure TFrmAssets.ParseXML(xml:string);
var i: Integer;
  item: TSuperObjectIter;
begin
  doc := XMLParseString(xml);
  ShowMessage(XML);
  if ObjectFindFirst(doc, item) then
  repeat
    ShowMessage(item.val.AsJSon);
  until ObjectFindNext(item);
end;

procedure TFrmAssets.BtnDownloadAllClick(Sender: TObject);
begin
  cb := TBindStatusCallback.Create(self);
  d := TDownloader.Create(MC_RESOURCES_URL);
  d.DownFileAsync('resources.xml', cb);
end;

procedure TFrmAssets.FormCreate(Sender: TObject);
begin
  Idhttp1.IOHandler := Self.IdSSLIOHandlerSocketOpenSSL1;
  Idhttp1.Request.ContentType := 'application/x-www-form-urlencoded';
  Idhttp1.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; Maxthon; .NET CLR 1.1.4322)';
end;

end.