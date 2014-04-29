unit UFileUtilities;

interface

uses Classes, SysUtils, Forms, Dialogs, WinApi.Windows, VCLZip;

type
  TFileUtilities = class
  public
    class function FindAllDirectory(InDirectory:String):TStringList;static;
    class function FindAllFiles(InDirectory:String):TStringList;static;
    class function Zip(ZipMode, PackSize:Integer; ZipFile, UnzipDir: String):Boolean; static;
    class function ExtractLastDirectory(Dir:string):String;
    class function IsSeparator(ch:char):boolean;static;
    class function RemoveLastSeparator(Dir:string):string;
    class function ReadToEnd(fileName:String):string;
    class function AddSeparator(st:String):String;
    class procedure WriteToFile(fileName, content:String);
    class function CopyDir(sDirName, sToDirName:String):Boolean;
    class procedure DeleteDir(sDirectory:String);

    class function CurrentDir:String;
  end;

implementation

class function TFileUtilities.CurrentDir:String;
begin
  exit(ExtractFilePath(Application.ExeName));
end;

class function TFileUtilities.IsSeparator(ch: Char):Boolean;
begin
  exit((ch = '/') or (ch = '\'));
end;

class function TFileUtilities.RemoveLastSeparator(Dir:string):string;
var ch:char;
begin
  Dir := Trim(Dir);
  ch := Dir[length(Dir)];
  if IsSeparator(ch) then
    delete(Dir, length(Dir), 1);
  exit(Dir);
end;

class function TFileUtilities.FindAllDirectory(InDirectory:String):TStringList;
var
SR: TSearchRec;
begin
  FindAllDirectory := TStringList.Create;
  if InDirectory[Length(InDirectory)] <> '\' then
  InDirectory := InDirectory + '\';
  if FindFirst(InDirectory+'*.*', FADirectory, SR) = 0 then
  repeat
     if (SR.Attr and FADirectory) <> 0 then
     if (SR.Name <> '.') and (SR.Name <> '..') then
     begin
       FindAllDirectory.Add(SR.Name);
     end;
     Application.ProcessMessages;
  until FindNext(SR) <> 0;
  SysUtils.FindClose(SR);
end;

class function TFileUtilities.FindAllFiles(InDirectory:String):TStringList;
var
SR: TSearchRec;
begin
  FindAllFiles := TStringList.Create;
  if InDirectory[Length(InDirectory)] <> '\' then
  InDirectory := InDirectory + '\';
  if FindFirst(InDirectory+'*.*', FaAnyFile, SR) = 0 then
  repeat
     if (SR.Attr and FADirectory) = 0 then
      FindAllFiles.Add(sr.Name);
     Application.ProcessMessages;
  until FindNext(SR) <> 0;
  SysUtils.FindClose(SR);
end;

class function TFileUtilities.Zip(ZipMode,PackSize:Integer;ZipFile,UnzipDir:String):Boolean; //压缩或解压缩文件
var ziper:TVCLZip;
begin
  //函数用法：Zip(压缩模式，压缩包大小，压缩文件，解压目录)
  //ZipMode为0：压缩；为1：解压缩 PackSize为0则不分包；否则为分包的大小
  try
    if copy(UnzipDir, length(UnzipDir), 1) = '\' then
      UnzipDir := copy(UnzipDir, 1, length(UnzipDir) - 1); //去除目录后的“\”
    ziper:=TVCLZip.Create(application); //创建zipper
    ziper.DoAll:=true; //加此设置将对分包文件解压缩有效
    //ziper.OverwriteMode:=TUZOverwriteMode.Always; //总是覆盖模式
    if PackSize<>0 then begin //如果为0则压缩成一个文件，否则压成多文件
      //ziper.MultiZipInfo.MultiMode:=TMultiMode.mmBlocks; //设置分包模式
      ziper.MultiZipInfo.SaveZipInfoOnFirstDisk:=True; //打包信息保存在第一文件中
      ziper.MultiZipInfo.FirstBlockSize:=PackSize; //分包首文件大小
      ziper.MultiZipInfo.BlockSize:=PackSize; //其他分包文件大小
    end;
    ziper.FilesList.Clear;
    ziper.ZipName := ZipFile; //获取压缩文件名
    if ZipMode=0 then begin //压缩文件处理
      ziper.FilesList.Add(UnzipDir+'\*.*'); //添加解压缩文件列表
      Application.ProcessMessages; //响应WINDOWS事件
      ziper.Zip; //压缩
    end else begin
      ziper.DestDir:= UnzipDir; //解压缩的目标目录
      ziper.UnZip; //解压缩
    end;
    ziper.Free; //释放压缩工具资源
    Result:=True; //执行成功
  except
    Result:=False;//执行失败
  end;
end;

class function TFileUtilities.AddSeparator(st:string):string;
begin
  st := Trim(st);
  if st[length(st)] = '\' then
    exit(st)
  else
    exit(st+'\');
end;

class function TFileUtilities.ExtractLastDirectory(Dir: string): string;
var i:integer;
begin
  Dir := TFileUtilities.RemoveLastSeparator(Dir);
  i := length(Dir);
  while (i >= 1) and (Not IsSeparator(Dir[i]))  do
  begin
    Dec(i);
  end;
  if i <= 0 then raise Exception.Create('Error Path');
  exit(copy(Dir, i + 1, length(Dir) - i))
end;

function AnsiStringToWideString(const ansi: AnsiString): WideString;
var len:Integer;
begin
  Result := '';
  if ansi = '' then exit;
  len := MultiByteToWideChar(936, MB_PRECOMPOSED, @ansi[1], -1, nil, 0);
  SetLength(result, len - 1);
  if Len > 1 then
    MultiByteToWideChar(936, MB_PRECOMPOSED, @ansi[1], -1, PWideChar(@result[1]), len - 1);
end;

class function TFileUtilities.ReadToEnd(fileName: String): string;
var f: TextFile; j: String;
begin
  if not fileexists(fileName) then
    result := ''
  else
  begin
    AssignFile(f, fileName);
    ReSet(f);
    while not eof(f) do
    begin
      readln(f, j); result := result + j;
    end;
    CloseFile(f);
  end;
end;

class procedure TFileUtilities.WriteToFile(fileName, content: string);
var f: TextFile;
begin
  ForceDirectories(ExtractFilePath(fileName));
  AssignFile(f, fileName);
  Rewrite(f);
  Writeln(f,content);
  CloseFile(f);
end;

class function TFileUtilities.CopyDir(sDirName:String;sToDirName:String):Boolean;
var
hFindFile:Cardinal;
t,tfile:String;
sCurDir:String[255];
FindFileData:WIN32_FIND_DATA;
begin
  //记录当前目录
  sCurDir:=GetCurrentDir;
  ChDir(sDirName);
  hFindFile:=FindFirstFile('*.*',FindFileData);
  if hFindFile<>INVALID_HANDLE_VALUE then
  begin
    if not DirectoryExists(sToDirName) then
    ForceDirectories(sToDirName);
    repeat
      tfile:=FindFileData.cFileName;
      if (tfile='.') or (tfile='..') then
        continue;
      if FindFileData.dwFileAttributes = FILE_ATTRIBUTE_DIRECTORY then
      begin
        t:=sToDirName+'\'+tfile;
        if not DirectoryExists(t) then
          ForceDirectories(t);
        if sDirName[Length(sDirName)]<>'\' then
          CopyDir(sDirName+'\'+tfile,t)
        else
          CopyDir(sDirName+tfile,sToDirName+tfile);
      end
      else
      begin
        t:=sToDirName+'\'+tFile;
        CopyFile(PChar(tfile),PChar(t),True);
      end;
    until FindNextFile(hFindFile,FindFileData)=false;
    /// FindClose(hFindFile);
  end
  else
  begin
    ChDir(sCurDir);
    result:=false;
    exit;
  end;
  //回到当前目录
  ChDir(sCurDir);
  result:=true;
end;

class procedure TFileUtilities.DeleteDir(sDirectory:String);
var
  sr:TSearchRec;
  sPath,sFile:String;
begin
  //检查目录名后面是否有'\'
  if Copy(sDirectory,Length(sDirectory),1)<>'\'then
    sPath:=sDirectory+'\'
  else
    sPath:=sDirectory;
  //------------------------------------------------------------------
  if FindFirst(sPath+'*.*',faAnyFile,sr)=0 then
  begin
    repeat
      sFile:=Trim(sr.Name);
      if sFile='.' then Continue;
      if sFile='..' then Continue;
      sFile:=sPath+sr.Name;
      if(sr.Attr and faDirectory)<>0 then
        DeleteDir(sFile)
      else if(sr.Attr and faAnyFile)=sr.Attr then
        DeleteFile(PWideChar(WideString(sFile)));//删除文件
    until FindNext(sr)<>0;
    SysUtils.FindClose(sr);
  end;
  RemoveDir(sPath);
end;

end.
