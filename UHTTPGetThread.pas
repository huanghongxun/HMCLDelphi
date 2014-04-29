unit UHTTPGetThread;
//Download by http://www.codefans.net
interface
uses classes, SysUtils, wininet, windows;


type
  TOnProgressEvent = procedure(TotalSize, Readed: Integer) of object;


  THTTPGetThread = class(TThread)

  private
    FTAcceptTypes: string; //接收文件类型 *.*
    FTAgent: string; //浏览器名  Nokia6610/1.0 (5.52) Profile/MIDP-1.0 Configuration/CLDC-1.02
    FTURL: string; // url
    FTFileName: string; //文件名
    FTStringResult: AnsiString;
    FTUserName: string; //用户名
    FTPassword: string; //密码
    FTPostQuery: string; //方法名,post或者get
    FTReferer: string;
    FTBinaryData: Boolean;
    FTUseCache: Boolean; //是否从缓存读数据
    FTMimeType: string; //Mime类型

    FTResult: Boolean;
    FTFileSize: Integer;
    FTToFile: Boolean; //是否文件

    BytesToRead,
      BytesReaded: LongWord;

    FTProgress: TOnProgressEvent;

    procedure ParseURL(URL: string; var HostName, FileName: string; var portNO: integer); //取得url的主机名和文件名
    procedure UpdateProgress;
    procedure setResult(FResult: boolean);
    function getResult(): boolean;
  protected
    procedure Execute; override;
  public

    function getFileName(): string;
    function getToFile(): boolean;
    function getFileSize(): integer;
    function getStringResult(): AnsiString;
    constructor Create(aAcceptTypes, aMimeType, aAgent, aURL, aFileName, aUserName, aPassword, aPostQuery, aReferer: string; aBinaryData, aUseCache: Boolean; aProgress: TOnProgressEvent; aToFile: Boolean);
  published
    property BResult: boolean read getResult write setResult;
  end;

implementation

{ THTTPGetThread }

constructor THTTPGetThread.Create(aAcceptTypes, aMimeType, aAgent, aURL, aFileName, aUserName, aPassword, aPostQuery, aReferer: string; aBinaryData, aUseCache: Boolean; aProgress: TOnProgressEvent; aToFile: Boolean);
begin
  FreeOnTerminate := True;
  inherited Create(True);

  FTAcceptTypes := aAcceptTypes;
  FTAgent := aAgent;
  FTURL := aURL;
  FTFileName := aFileName;
  FTUserName := aUserName;
  FTPassword := aPassword;
  //FTPostQuery := aPostQuery;
  FTPostQuery := StringReplace(aPostQuery, #13#10, '', [rfReplaceAll]);
  FTStringResult := '';
  FTReferer := aReferer;
  FTProgress := aProgress;
  FTBinaryData := aBinaryData;
  FTUseCache := aUseCache;
  FTMimeType := aMimeType;
  FTResult := false;
  FTToFile := aToFile;
  FTFileSize := 0;
  Resume;
end;

procedure THTTPGetThread.Execute;
var
  hSession: hInternet; //回话句柄
  hConnect: hInternet; //连接句柄
  hRequest: hInternet; //请求句柄
  Host_Name: string; //主机名
  File_Name: string; //文件名
  port_no: integer;

  RequestMethod: PChar;
  InternetFlag: longWord;
  AcceptType: PAnsiChar;
  dwBufLen, dwIndex: longword;
  Buf: Pointer; //缓冲区
  f: file;
  Data: array[0..$400] of Char;
  TempStr: AnsiString;
  mime_Head: string;

  procedure CloseHandles;
  begin
    InternetCloseHandle(hRequest);
    InternetCloseHandle(hConnect);
    InternetCloseHandle(hSession);
  end;

begin
  inherited;
  buf := nil;
  try
    try
      ParseURL(FTURL, Host_Name, File_Name, port_no);

      if Terminated then begin
        FTResult := False;
        Exit;
      end;
     //建立会话
      hSession := InternetOpen(pchar(FTAgent), //lpszCallerName指定正在使用网络函数的应用程序
        INTERNET_OPEN_TYPE_PRECONFIG, //参数dwAccessType指定访问类型
        nil, //服务器名（lpszProxyName）。 accesstype为GATEWAY_PROXY_INTERNET_ACCESS和CERN_PROXY_ACCESS时
        nil, //NProxyPort参数用在CERN_PROXY_INTERNET_ACCESS中用来指定使用的端口数。使用INTERNET_INVALID_PORT_NUMBER相当于提供却省的端口数。
        0); //设置额外的选择。你可以使用INTERNET_FLAG_ASYNC标志去指示使用返回句句柄的将来的Internet函数将为回调函数发送状态信息，使用InternetSetStatusCallback进行此项设置

     //建立连接
      hConnect := InternetConnect(hSession, //会话句柄
        PChar(Host_Name), //指向包含Internet服务器的主机名称（如http://www.mit.edu）或IP地址（如202.102.13.141）的字符串
        port_no, //INTERNET_DEFAULT_HTTP_PORT, //是将要连结到的TCP/IP的端口号
        PChar(FTUserName), //用户名
        PChar(FTPassword), //密码
        INTERNET_SERVICE_HTTP, //协议
        0, // 可选标记，设置为INTERNET_FLAG_SECURE，表示使用SSL/PCT协议完成事务
        0); //应用程序定义的值，用来为返回的句柄标识应用程序设备场境

      if FTPostQuery = '' then RequestMethod := 'GET'
      else RequestMethod := 'POST';

      if FTUseCache then InternetFlag := 0
      else InternetFlag := INTERNET_FLAG_RELOAD;

      AcceptType := PAnsiChar('Accept: ' + FTAcceptTypes);

    //建立一个http请求句柄
      hRequest := HttpOpenRequest(hConnect, //InternetConnect返回的HTTP会话句柄
        RequestMethod, //指向在申请中使用的"动词"的字符串，如果设置为NULL，则使用"GET"
        PChar(File_Name), //指向包含动词的目标对象名称的字符串，通常是文件名称、可执行模块或搜索说明符
        'HTTP/1.0', //指向包含HTTP版本的字符串，如果为NULL，则默认为"HTTP/1.0"；
        PChar(FTReferer), //指向包含文档地址（URL）的字符串，申请的URL必须是从该文档获取的
        @AcceptType, //指向客户接收的内容的类型
        InternetFlag,
        0);
      mime_Head := 'Content-Type: ' + FTMimeType;
      if FTPostQuery = '' then
        FTResult := HttpSendRequest(hRequest, nil, 0, nil, 0)
      else
    //发送一个指定请求到httpserver
        FTResult := HttpSendRequest(hRequest,
          pchar(mime_Head), //mime 头
          length(mime_Head), //头长度
          PChar(FTPostQuery), //附加数据缓冲区，可为空
          strlen(PChar(FTPostQuery))); //附加数据缓冲区长度

      if Terminated then
      begin
      //CloseHandles;
        FTResult := False;
        Exit;
      end;

      dwIndex := 0;
      dwBufLen := 1024;
      GetMem(Buf, dwBufLen);

    //接收header信息和一个http请求
      FTResult := HttpQueryInfo(hRequest,
        HTTP_QUERY_CONTENT_LENGTH,
        Buf, //指向一个接收请求信息的缓冲区的指针
        dwBufLen, //HttpQueryInfo内容的大小
        dwIndex); //读取的字节数

      if Terminated then begin
        FTResult := False;
        Exit;
      end;

      if FTResult or not FTBinaryData then begin //如果请求
        if FTResult then
          FTFileSize := StrToInt(string(StrPas(PAnsiChar(Buf))));

        BytesReaded := 0;

        if FTToFile then begin
          AssignFile(f, FTFileName);
          Rewrite(f, 1);
        end else FTStringResult := '';

        while True do begin
          if Terminated then begin
            FTResult := False;
            Exit;
          end;

          if not InternetReadFile(hRequest,
            @Data, //数据内容
            SizeOf(Data), //大小
            BytesToRead) //读取的字节数
            then Break
          else
            if BytesToRead = 0 then Break
            else begin
              if FTToFile then
                BlockWrite(f, Data, BytesToRead) //将读出的数据写入文件
              else begin
                TempStr := Data;
                SetLength(TempStr, BytesToRead);
                FTStringResult := FTStringResult + TempStr;
              end;

              inc(BytesReaded, BytesToRead);

              if Assigned(FTProgress) then //执行回调函数
                Synchronize(UpdateProgress);

            end;
        end;

        if FTToFile then
          FTResult := FTFileSize = Integer(BytesReaded)
        else begin
         // SetLength(FTStringResult, BytesReaded);
          FTResult := BytesReaded <> 0;
        end;

      end;
    except
    end;
  finally
    if FTToFile then CloseFile(f);

    if assigned(Buf) then FreeMem(Buf);
    CloseHandles;
  end;
end;



function THTTPGetThread.getFileName: string;
begin
  result := FTFileName;
end;

function THTTPGetThread.getFileSize: integer;
begin
  result := FTFileSize;
end;

function THTTPGetThread.getResult: boolean;
begin
  result := FTResult;
end;

function THTTPGetThread.getStringResult: AnsiString;
begin
  result := FTStringResult;
end;

function THTTPGetThread.getToFile: boolean;
begin
  result := FTToFile;
end;

procedure THTTPGetThread.ParseURL(URL: string; var HostName, FileName: string; var portNO: integer);
var
  i: Integer;
begin
  if Pos('http://', LowerCase(URL)) <> 0 then
    Delete(URL, 1, 7);

  i := Pos('/', URL);
  HostName := Copy(URL, 1, i);
  FileName := Copy(URL, i, Length(URL) - i + 1);

  i := pos(':', hostName);
  if i <> 0 then begin
    portNO := strtoint(copy(hostName, i + 1, length(hostName) - i - 1));
    hostName := copy(hostName, 1, i - 1);
  end else portNO := 80;

  if (Length(HostName) > 0) and (HostName[Length(HostName)] = '/') then SetLength(HostName, Length(HostName) - 1);
end;


procedure THTTPGetThread.setResult(FResult: boolean);
begin
  FTResult := FResult;
end;

procedure THTTPGetThread.UpdateProgress;
begin
  FTProgress(FTFileSize, BytesReaded);
end;

end.

