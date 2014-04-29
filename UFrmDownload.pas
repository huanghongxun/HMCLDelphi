unit UFrmDownload;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, XPMan, IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    Label1: TLabel;
    Edit_Url: TEdit;
    XPManifest1: TXPManifest;
    ProgressBar1: TProgressBar;
    Btn_Start: TButton;
    Btn_Stop: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Lab_Size: TLabel;
    Label5: TLabel;
    Lab_CurNum: TLabel;
    ListBox1: TListBox;
    Lab_Over: TLabel;
    procedure Btn_StartClick(Sender: TObject);
    procedure IdHTTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure Btn_StopClick(Sender: TObject);
    procedure IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure FormCreate(Sender: TObject);
    procedure IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetURLFileName(aURL: string): string;  //返回下载地址的文件名
    procedure DownFile(fileUrl:string); //下载文件函数
  end;

var
  Form1: TForm1;
  startIndex:Integer;
  IsStop:Boolean;       //用户是否终止
implementation

{$R *.dfm}
procedure TForm1.FormCreate(Sender: TObject);
begin
  self.Lab_Over.Caption:='';
end;


function TForm1.GetURLFileName(aURL: string): string;
var
  i: integer;
  s: string;
begin
  s := aURL;
  i := Pos('/', s);
  while i <> 0 do //去掉"/"前面的内容剩下的就是文件名了
  begin
    Delete(s, 1, i);
    i := Pos('/', s);
  end;
  Result := s;
end;

//开始下载
procedure TForm1.Btn_StartClick(Sender: TObject);
begin
  IsStop:=false;  //用户是否终止
  DownFile(self.Edit_Url.Text);
end;

//停止
procedure TForm1.Btn_StopClick(Sender: TObject);
begin
  self.Lab_Over.Caption:='正在终止下载...';
  Application.ProcessMessages;
  IsStop:=true;//用户是否终止
end;

//连接状态
procedure TForm1.IdHTTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: String);
begin
  ListBox1.ItemIndex := ListBox1.Items.Add(AStatusText);
end;

//下载文件函数
procedure TForm1.DownFile(fileUrl: string);
var
  fileName:string;
  tStream: TFileStream;
begin
  fileName:=self.GetURLFileName(fileUrl); //从下载路径中获取文件名

  if FileExists(fileName) then            //如果文件已经存在
    tStream := TFileStream.Create(fileName, fmOpenWrite)
  else
    tStream := TFileStream.Create(fileName, fmCreate);

  if FileExists(fileName)=false then      //初次下载
  begin
    IdHTTP1.Request.ContentRangeStart:=0; //从指定文件偏移处请求下载文件
    startIndex:=0;
  end
  else begin                              //续传
    startIndex:=tStream.Size-1;
    if startIndex < 0 then startIndex:=0;
    IdHTTP1.Request.ContentRangeStart := startIndex;
    tStream.Position := startIndex ;      //移动到最后继续下载
    idhttp1.HandleRedirects := true;
    IdHTTP1.Head(fileUrl);                //发送HEAD请求
  end;

  try
    self.IdHTTP1.Get(fileUrl,tStream);
  except
  end;

  tStream.Free;
end;

//准备下载文件
procedure TForm1.IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  self.Lab_Over.Caption:='正在下载...';
  self.Lab_Size.Caption:=IntToStr(AWorkCountMax+startIndex)+'KB';
  self.Lab_CurNum.Caption:='0KB';
  self.ProgressBar1.Min:=0;
  self.ProgressBar1.Max:=AWorkCountMax+startIndex;
  self.ProgressBar1.Position:=0;
  self.Btn_Stop.Enabled:=true;  //停止按钮启用
  self.Btn_Start.Enabled:=false;//开始按钮禁用
end;


//下载连接结束
procedure TForm1.IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  if IsStop then
    self.Lab_Over.Caption:='下载已被终止!'
  else
    self.Lab_Over.Caption:='下载完毕!';

  self.Btn_Stop.Enabled:=false;  //停止按钮禁用
  self.Btn_Start.Enabled:=true;  //开始按钮启用
end;

//文件下载中
procedure TForm1.IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
  if IsStop then //用户是否终止
  begin
      self.IdHTTP1.Disconnect;
  end;

  self.Lab_CurNum.Caption:=IntToStr(AWorkCount+startIndex)+'KB';
  ProgressBar1.Position := AWorkCount+startIndex;
end;

end.
