unit UMinecraftDownloader;

interface

uses UDownloader, SysUtils, Vcl.Dialogs, UMinecraftLoader;

const
  MC_DOWNLOAD_URL = 'http://s3.amazonaws.com/Minecraft.Download/versions/';

type
  TMinecraftDownloader = class
  private
    mcp, id:string;
    d: TDownloader;
  public
    Constructor Create(mcp, id:string; cb:IDownloadCallback);
  end;

implementation

procedure TryCreateDirectory(path:string);
begin
  if not DirectoryExists(path) then
    ForceDirectories(path);
end;

constructor TMinecraftDownloader.Create(mcp, id: string; cb:IDownloadCallBack);
var
  j, js:string;
  f: textfile;
  m:TMinecraftLoader;
  i: Integer;
begin
  self.mcp := mcp;
  self.id := id;
  cb.OnStatus('Creating directory: ' + mcp + '\\versions\\' + id);
  TryCreateDirectory(mcp + '\\versions\\' + id);
  d := TDownloader.Create(MC_DOWNLOAD_URL + id + '/' + id + '.json');
  cb.OnStatus('Downloading File: ' + mcp + '\\versions\\' + id + '\\' + id + '.json');
  d.DownFileAsync(mcp + '\\versions\\' + id + '\\' + id + '.json', cb);
  d := TDownloader.Create(MC_DOWNLOAD_URL + id + '/' + id + '.jar');
  cb.OnStatus('Downloading File: ' + mcp + '\\versions\\' + id + '\\' + id + '.jar');
  d.DownFileAsync(mcp + '\\versions\\' + id + '\\' + id + '.jar', cb);

  AssignFile(f, mcp + '\\versions\\' + id + '\\' + id + '.json');
  Reset(f); js:='';
  while(not Eof(f))do
  begin
    Readln(f,j);js:=js+j;
  end;
  CloseFile(f);
  cb.OnStatus(js);
  cb.OnStatus('Finding libraries');
  m := TMinecraftLoader.Create(mcp, js, '', '', '', 'no', 0, nil, false);
  for i := 1 to m.LibraryCount do
  begin
    if not FileExists(mcp+'\libraries\'+m.Libraries[i].Formatted) then
    begin
      d := TDownloader.Create('https://s3.amazonaws.com/Minecraft.Download/libraries/'+m.Libraries[i].Formatted);
      cb.OnStatus('Downloading File: ' + mcp+'\libraries\'+m.Libraries[i].Formatted);
      d.DownFileAsync(mcp+'\libraries\'+m.Libraries[i].Formatted, cb);
    end;
  end;
end;

end.
