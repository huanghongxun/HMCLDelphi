unit UHttpGet;
//Download by http://www.codefans.net
interface

uses UHTTPGetThread, windows;

type
  TOnDoneFileEvent = procedure(FileName: string; FileSize: Integer) of object;
  TOnDoneStringEvent = procedure(Result: AnsiString) of object;


  THttpGet = class
  private
    F_URL: string; //目标url
    F_GetURLThread: THTTPGetThread; //取数据的线程

    F_Accept_Types: string;
    F_Agent: string;
    F_Binary_Data: Boolean;
    F_Use_Cache: Boolean; //是否读缓存
    F_File_Name: string;
    F_User_Name: string; //用户名
    F_Password: string; //密码
    F_PostQuery: string; //方法名
    F_Referer: string;
    F_Mime_Type: string;

    F_Wait_Thread: Boolean;

    FResult: Boolean;

    FProgress: TOnProgressEvent;
    FDoneFile: TOnDoneFileEvent;
    FDoneString: TOnDoneStringEvent;

    procedure ThreadDone(Sender: TObject);
    procedure progress(TotalSize, Readed: Integer);
  public
    constructor Create();
    destructor Destroy(); override;
    procedure getFile();
    procedure GetString();
    procedure Abort();
  published
    property WaitThread: Boolean read F_Wait_Thread write F_Wait_Thread;
    property AcceptTypes: string read F_Accept_Types write F_Accept_Types;
    property Agent: string read F_Agent write F_Agent;
    property BinaryData: Boolean read F_Binary_Data write F_Binary_Data;
    property URL: string read F_URL write F_URL;
    property UseCache: Boolean read F_Use_Cache write F_Use_Cache;
    property FileName: string read F_File_Name write F_File_Name;
    property UserName: string read F_User_Name write F_User_Name;
    property Password: string read F_Password write F_Password;
    property PostQuery: string read F_PostQuery write F_PostQuery;
    property Referer: string read F_Referer write F_Referer;
    property MimeType: string read F_Mime_Type write F_Mime_Type;

    property OnDoneFile: TOnDoneFileEvent read FDoneFile write FDoneFile;
    property OnDoneString: TOnDoneStringEvent read FDoneString write FDoneString;
  end;

implementation



{ THttpGet }

procedure THttpGet.Abort;
begin
  if Assigned(F_GetURLThread) then
  begin
    F_GetURLThread.Terminate;
    F_GetURLThread.BResult := false;
  end;
end;

constructor THttpGet.Create;
begin
  F_Accept_Types := '*/*';
  F_Agent := 'Nokia6610/1.0 (5.52) Profile/MIDP-1.0 Configuration/CLDC-1.02';
  FProgress := progress;
end;

destructor THttpGet.Destroy;
begin

end;

procedure THttpGet.getFile;
var
  Msg: TMsg;
begin
  if not Assigned(F_GetURLThread) then
  begin
    F_GetURLThread := THTTPGetThread.Create(F_Accept_Types, F_Mime_Type, F_Agent, F_URL, F_File_Name, F_User_Name, F_Password, F_PostQuery, F_Referer, F_Binary_Data, F_Use_Cache, FProgress, true);
    F_GetURLThread.OnTerminate := ThreadDone;
    if F_Wait_Thread then
      while Assigned(F_GetURLThread) do
        while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
        begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        end;
  end
end;

procedure THttpGet.GetString;
var
  Msg: TMsg;
begin
  if not Assigned(F_GetURLThread) then
  begin
    F_GetURLThread := THTTPGetThread.Create(F_Accept_Types, F_Mime_Type, F_Agent, F_URL, F_File_Name, F_User_Name, F_Password, F_PostQuery, F_Referer, F_Binary_Data, F_Use_Cache, FProgress, False);
    F_GetURLThread.OnTerminate := ThreadDone;
    if F_Wait_Thread then
      while Assigned(F_GetURLThread) do
        while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        end;
  end
end;


procedure THttpGet.progress(TotalSize, Readed: Integer);
begin

end;


procedure THttpGet.ThreadDone(Sender: TObject);
begin
  try
    FResult := F_GetURLThread.BResult;

    if FResult then
      if F_GetURLThread.getToFile then begin
        if Assigned(FDoneFile) then
          FDoneFile(F_GetURLThread.getFileName, F_GetURLThread.getFileSize)
      end else begin
        if Assigned(FDoneString) then
          FDoneString(F_GetURLThread.getStringResult);
      end;
  except
    //messagebox(0, 'error', 'error', $0);
  end;
    //end else if Assigned(FError) then FError(Self);
  F_GetURLThread := nil;

end;

end.

