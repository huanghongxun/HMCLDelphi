unit FrmModsManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFileUtilities, Vcl.StdCtrls, SuperObject,
  Vcl.ComCtrls, USettingsManager, sButton, sListBox, sLabel, WinApi.ShellApi,
  ULanguageLoader;

type
  TFrmModManager = class(TForm)
    PageControl1: TPageControl;
    sWebLabel1: TsWebLabel;
    sWebLabel2: TsWebLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnAddCoreClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnDelCoreClick(Sender: TObject);
    procedure Refresh;
    procedure sWebLabel1Click(Sender: TObject);
    procedure sWebLabel2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SetActiveLanguage(LanguageName:string);
  private
    { Private declarations }
  public
    { Public declarations }
    TabMods, TabCoreMods : TTabSheet;
    lstMods, lstCoreMods : TsListBox;
    btnAdd, btnAddCore: TsButton;
    btnDel, btnDelCore: TsButton;

    Version, Cap:string;
    ll: TLanguageLoader;
    t, k: TTabSheet;
  end;

var
  FrmModManager: TFrmModManager;

implementation

{$R *.dfm}

function FindSelectedIndex(lb:TListBox):integer;
var
  i: Integer;
begin
  for i := 0 to lb.Count - 1 do
    if lb.Selected[i] then
      exit(i);
  exit(-1);
end;

procedure TFrmModManager.SetActiveLanguage(LanguageName:string);
var
    frmComponent:TComponent;
    i:Integer;
    jso, tmp: ISuperObject;
    s:String;
    jts: TSuperTableString;
begin
  jso := ll.lang[ll.Find(LanguageName)];
  tmp := SOFindField(jso, 'FrmModManager.Self.Caption');
  if tmp <> nil then
  begin
    cap := tmp.AsString;
    Self.Caption := Cap + Version;
  end;
  for   i:=0 to ComponentCount-1 do   {   遍历Form组件   }
  begin
    frmComponent:=Components[i];
    tmp := SOFindField(jso, 'FrmModManager.' + frmComponent.Name + '.Caption');
    if tmp <> nil then
    begin
      s := WideStringToAnsiString(tmp.AsString);
      if frmComponent is TsLabelFx then   {   如果组件为TLabel型则当作TLabel处理，以下同   }
      begin
        (frmComponent as TsLabelFx).Caption:=s;
      end else
      if frmComponent is TsWebLabel then
      begin
        (frmComponent as TsWebLabel).Caption:=s;
      end else
      if frmComponent is TsButton then
      begin
        (frmComponent as TsButton).Caption:=s;
      end;
    end;
  end;
  tmp := SOFindField(jso, 'FrmModManager.TabModsManage.Caption');
  if tmp <> nil then
  begin
    t.Caption := tmp.AsString;
  end;
  tmp := SOFindField(jso, 'FrmModManager.TabCoreModsManage.Caption');
  if tmp <> nil then
  begin
    k.Caption := tmp.AsString;
  end;
end;

procedure TFrmModManager.Refresh;
var s:TStringList;
    i:Integer;
begin
  lstMods.Clear;
  lstCoreMods.Clear;
  s := TFileUtilities.FindAllFiles(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'versions\' + Version + '\mods\');
  for i := 0 to s.Count - 1 do
    lstMods.AddItem(s[i], nil);
  s := TFileUtilities.FindAllFiles(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'versions\' + Version + '\coremods\');
  for i := 0 to s.Count - 1 do
    lstCoreMods.AddItem(s[i], nil);
end;

procedure TFrmModManager.sWebLabel1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, nil, PWideChar(WideString('http://files.minecraftforge.net/')), nil, nil, SW_SHOWNORMAL);
end;

procedure TFrmModManager.sWebLabel2Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, nil, PWideChar(WideString('http://www.mcbbs.net/forum-mod-1.html')), nil, nil, SW_SHOWNORMAL);

end;

procedure TFrmModManager.btnAddClick(Sender: TObject);
var dlg: TOpenDialog;
begin
  dlg := TOpenDialog.Create(self);
  dlg.Filter := 'Mod File|*.zip,*.jar';
  dlg.Title := '选择模组';
  if dlg.Execute then
  begin
    ForceDirectories(PWideChar(WideString(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'versions\' + Version + '\mods\')));
    CopyFile(PWideChar(WideString(dlg.FileName)), PWideChar(WideString(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'versions\' + Version + '\mods\' + ExtractFileName(dlg.FileName))), false);
  end;
  Refresh;
end;

procedure TFrmModManager.btnAddCoreClick(Sender: TObject);
var dlg: TOpenDialog;
begin
  dlg := TOpenDialog.Create(self);
  dlg.Filter := 'Mod File|*.zip,*.jar';
  dlg.Title := '选择模组';
  if dlg.Execute then
  begin
    ForceDirectories(PWideChar(WideString(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'versions\' + Version + '\coremods\')));
    CopyFile(PWideChar(WideString(dlg.FileName)), PWideChar(WideString(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'versions\' + Version + '\coremods\' + ExtractFileName(dlg.FileName))), false);
  end;
  Refresh;
end;

procedure TFrmModManager.btnDelClick(Sender: TObject);
var name, oldpath, newpath, realpath: String;
begin
  name := lstMods.Items[FindSelectedIndex(lstMods)];
  realPath := TFileUtilities.AddSeparator(SMPMinecraftPath);
  ForceDirectories(PWideChar(WideString(SMPMinecraftPath + '\mods-del\')));
  oldpath := realpath + 'versions\' + Version + '\mods\'+ name;
  newpath := realPath + 'versions\' + Version + '\mods-del\'+ name;
  MoveFile(PWideChar(WideString(oldpath)), PWideChar(WideString(newpath)));
  Refresh;
end;

procedure TFrmModManager.btnDelCoreClick(Sender: TObject);
var name, realpath, oldpath, newpath: String;
begin
  name := lstMods.Items[FindSelectedIndex(lstMods)];
  realPath := TFileUtilities.AddSeparator(SMPMinecraftPath);
  ForceDirectories(PWideChar(WideString(realPath + 'coremods-del\')));
  oldpath := realpath + 'versions\' + Version + '\coremods\'+ name;
  newpath := realpath + 'versions\' + Version + '\coremods-del\'+ name;
  MoveFile(PWideChar(WideString(oldpath)), PWideChar(WideString(newpath)));
  Refresh;
end;

procedure TFrmModManager.FormCreate(Sender: TObject);
var s:TStringList;
  i: Integer;
begin
  Self.Caption := Cap + Version;

  t := TTabSheet.Create(self);
  t.PageControl := PageControl1;
  t.TabVisible := true;
  t.Caption := 'Mods管理';
  t.Name := 'TabModsManage';

  lstMods := TsListBox.Create(t);
  lstMods.Parent := t;
  lstMods.Left := 8;
  lstMods.Top := 8;
  lstMods.Height := t.Height - 16;
  lstMods.Width := 200;
  lstMods.Name := 'lstMods';

  btnAdd := TsButton.Create(t);
  btnAdd.Parent := t;
  btnAdd.Top := 8;
  btnAdd.Left := 216;
  btnAdd.Caption := '增加';
  btnAdd.OnClick := btnAddClick;
  btnAdd.Name := 'btnAdd';

  btnDel := TsButton.Create(t);
  btnDel.Parent := t;
  btnDel.Top := 8*2+25;
  btnDel.Left := 216;
  btnDel.Caption := '删除';
  btnDel.OnClick := btnDelClick;
  btnDel.Name := 'btnDel';



  k := TTabSheet.Create(self);
  k.PageControl := PageControl1;
  k.TabVisible := true;
  k.Caption := 'CoreMods管理';
  k.Name := 'TabCoreModsManage';

  lstCoreMods := TsListBox.Create(k);
  lstCoreMods.Parent := k;
  lstCoreMods.Left := 8;
  lstCoreMods.Top := 8;
  lstCoreMods.Height := k.Height - 16;
  lstCoreMods.Width := 200;
  lstCoreMods.Name := 'lstCoreMods';

  btnAddCore := TsButton.Create(k);
  btnAddCore.Parent := k;
  btnAddCore.Top := 8;
  btnAddCore.Left := 216;
  btnAddCore.Caption := '增加';
  btnAddCore.OnClick := btnAddCoreClick;
  btnAddCore.Name := 'btnAddCore';

  btnDelCore := TsButton.Create(k);
  btnDelCore.Parent := k;
  btnDelCore.Top := 8*2+25;
  btnDelCore.Left := 216;
  btnDelCore.Caption := '删除';
  btnDelCore.OnClick := btnDelCoreClick;
  btnDelCore.Name := 'btnDelCore';

  Refresh;
  ll := TLanguageLoader.Create(TFileUtilities.ReadToEnd('lang.json'));
end;

procedure TFrmModManager.FormShow(Sender: TObject);
begin
  Refresh;
  SetActiveLanguage(SMPLanguage);
end;

end.
