unit UProcessManager;

interface

uses WinApi.ShellAPI, WinApi.Windows, SysUtils, Classes;

type
  IProcessCallBack = interface
    Procedure OnStart;
    Procedure OnExit;
    Procedure OnFail;
  end;

  TProcessThread = class(TThread)
  private
    cb:IProcessCallBack;
    pi:TProcessInformation;
  protected
    procedure Execute; override;
  public
    constructor Create(pi:TProcessInformation;cb: IProcessCallBack);
  end;

  TProcess = class
  public
    SecurityAttr:TSecurityAttributes;
    StartupInfo:TStartupInfo;
    ProcessInfo:TProcessInformation;
    ReadPipe, WritePipe: THandle;
    Show:Boolean;
    t:TProcessThread;
    Callback:IProcessCallBack;

    CommandLine, Environment:String;

    constructor Create(cmdln:string; show:boolean; env:String; cb: IProcessCallBack);
    procedure StartProcess;
  end;

implementation

  function ToWS(strAnsi:AnsiString):WideString;
  var
    Len: integer;
  begin
    Result := '';
    if strAnsi = '' then Exit;

    Len := MultiByteToWideChar(GetACP, MB_PRECOMPOSED, PAnsiChar(@strAnsi[1]), -1, nil, 0);
    SetLength(Result, Len - 1);

    if Len > 1 then
      MultiByteToWideChar(GetACP, MB_PRECOMPOSED, PAnsiChar(@strAnsi[1]), -1, PWideChar(@Result[1]), Len - 1);
  end;

  Constructor TProcessThread.Create(pi: TProcessInformation; cb: IProcessCallBack);
  begin
    inherited Create(true);
    self.pi := pi;
    self.cb := cb;
  end;

  procedure TProcessThread.Execute;
  begin
    inherited;
    if cb <> nil then
      cb.OnStart;
    WaitForSingleObject(pi.hProcess, INFINITE);
    if cb <> nil then
      cb.OnExit;
  end;

  Constructor TProcess.Create(cmdln: string; show: boolean; env: String; cb: IProcessCallBack);
  begin
    CommandLine := cmdln;
    Environment := env;
    Callback := cb;

    with SecurityAttr do
    begin
      nLength := sizeof(TSecurityAttributes);
      lpSecurityDescriptor := nil;
      bInheritHandle := true;
    end;

    with StartupInfo do
    begin
      cb := sizeof(StartupInfo);
      lpReserved := nil;
      lpReserved2 := nil;
      lpDesktop := nil;
      lpTitle := nil;
      dwX := 0; dwY := 0;
      dwXSize := 0; dwYSize := 0;
      dwXCountChars := 0; dwYCountChars := 0;
      dwFillAttribute := 0;
      cbReserved2 := 0;
      dwFlags := STARTF_USESHOWWINDOW;
      if Show then
        wShowWindow := 1
      else
        wShowWindow := 0;
    end;
  end;

  Procedure TProcess.StartProcess;
  begin
    if CreateProcess(nil, PWideChar(WideString(CommandLine)), @SecurityAttr, @SecurityAttr, true, NORMAL_PRIORITY_CLASS, nil, PWideChar(WideString(GetCurrentDir)), StartupInfo, ProcessInfo) then
    begin
      t := TProcessThread.Create(ProcessInfo, Callback);
      t.Start;
    end
    else if callback <> nil then
      callback.OnFail;
  end;

end.
