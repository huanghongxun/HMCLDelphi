unit UForm1;

interface

uses
  Winapi.Windows, System.Classes, Vcl.Forms, UFrmInfo, ULanguageLoader,
  UMinecraftLoader, Vcl.StdCtrls, UProcessManager, UDownloader,
  Vcl.Controls, Vcl.Dialogs, SysUtils, UFrmAssets, Generics.Collections,
  UFileUtilities, Vcl.ComCtrls, UMutiTrackBar, UFrmVersionManager,
  Vcl.FileCtrl, Vcl.Menus, USettingsManager, NewButton, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, UFrmMCVersions, UFrmNews, UOfficalLogin,
  Graphics, FrmModsManage, WinApi.ShellAPI, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ULauncherProfileLoader,
  UMinecraftOldVersionIncluder, UFrmInputBox, sSkinProvider, sSkinManager,
  sButton, sCheckBox, sListBox, sLabel, sEdit, sComboBox, acPNG, sScrollBar,
  sRadioButton, sGroupBox, WinApi.URLMon, WinApi.ActiveX, SuperObject;

type
  TForm1 = class(TForm)
    BtnRun: TsButton;
    txtMaxMemory: TsEdit;
    txtPlayerName: TsEdit;
    BtnMakeBat: TsButton;
    chkUseJava: TsCheckBox;
    rdo64Bit: TRadioButton;
    rdoNormal: TRadioButton;
    rdo32Bit: TRadioButton;
    BtnGoodMemory: TsButton;
    txtJavaPath: TsEdit;
    BtnSet: TsButton;
    dlgOpen: TOpenDialog;
    txtMinecraftPath: TsEdit;
    BtnSetMinecraftPath: TsButton;
    BtnMCVersions: TsButton;
    BtnNews: TsButton;
    BtnCurDir: TsButton;
    GroupBoxSettings: TGroupBox;
    BtnSettings: TsButton;
    BtnDownloads: TsButton;
    GroupBoxDownloads: TGroupBox;
    chkDebug: TsCheckBox;
    BtnMods: TsButton;
    BtnResources: TsButton;
    GroupBoxResources: TGroupBox;
    lstResources: TsListBox;
    BtnAddResource: TsButton;
    BtnDeleteResource: TsButton;
    BtnRefreshResources: TsButton;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Timer1: TTimer;
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    sWebLabel1: TsWebLabel;
    sLabelFX2: TsLabelFX;
    sLabelFX1: TsLabelFX;
    sLabelFX3: TsLabelFX;
    sLabelFX4: TsLabelFX;
    sLabelFX5: TsLabelFX;
    sLabelFX6: TsLabelFX;
    sLabelFX7: TsLabelFX;
    sLabelFX9: TsLabelFX;
    lblSysMemory: TsLabelFX;
    lblNowMemory: TsLabelFX;
    sLabelFX11: TsLabelFX;
    sLabelFX12: TsLabelFX;
    cboMinecrafts: TsComboBox;
    sLabelFX8: TsLabelFX;
    BtnIncludeOldVersion: TsButton;
    BtnManageVersion: TsButton;
    sWebLabel2: TsWebLabel;
    Image1: TImage;
    tkbMaxMemory: TsScrollBar;
    BtnSkins: TsButton;
    GroupBoxSkins: TGroupBox;
    sLabelFX10: TsLabelFX;
    BtnSetBackgroundPath: TsButton;
    txtBackgroundPath: TsEdit;
    chkShowBackground: TsCheckBox;
    sLabelFX13: TsLabelFX;
    txtSkinPath: TsEdit;
    BtnSetSkinPath: TsButton;
    cboSkinsList: TsComboBox;
    sLabelFX14: TsLabelFX;
    sLabelFX15: TsLabelFX;
    txtPassword: TsEdit;
    cboLang: TsComboBox;
    sLabelFX16: TsLabelFX;
    BtnSearch: TsButton;
    procedure BtnRunClick(Sender: TObject);
    procedure BtnSetClick(Sender: TObject);
    procedure BtnGoodMemoryClick(Sender: TObject);
    procedure BtnResourcesDownloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnSetMinecraftPathClick(Sender: TObject);
    procedure BtnMakeBatClick(Sender: TObject);
    procedure txtJavaPathExit(Sender: TObject);
    procedure txtMinecraftPathExit(Sender: TObject);
    procedure txtMaxMemoryExit(Sender: TObject);
    procedure rdo64BitClick(Sender: TObject);
    procedure rdo32BitClick(Sender: TObject);
    procedure rdoNormalClick(Sender: TObject);
    procedure txtMaxMemoryChange(Sender: TObject);
    procedure tkbMaxMemoryChange(Sender: TObject);
    procedure BtnMCVersionsClick(Sender: TObject);
    procedure BtnNewsClick(Sender: TObject);
    procedure BtnRefreshListClick(Sender: TObject);
    procedure BtnCurDirClick(Sender: TObject);
    procedure BtnSettingsClick(Sender: TObject);
    procedure BtnDownloadsClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnModsClick(Sender: TObject);
    procedure BtnResourcesClick(Sender: TObject);
    procedure BtnDeleteResourceClick(Sender: TObject);
    procedure BtnRefreshResourcesClick(Sender: TObject);
    procedure BtnAddResourceClick(Sender: TObject);
    procedure lblTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnManageVersionClick(Sender: TObject);
    procedure BtnIncludeOldVersionClick(Sender: TObject);
    procedure sWebLabel1Click(Sender: TObject);
    procedure tkbMaxMemoryMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnVersionManagerClick(Sender: TObject);
    procedure BtnSkinsClick(Sender: TObject);
    procedure BtnSetBackgroundPathClick(Sender: TObject);
    procedure chkShowBackgroundClick(Sender: TObject);
    procedure chkDebugClick(Sender: TObject);
    procedure chkUseJavaClick(Sender: TObject);
    procedure BtnSetSkinPathClick(Sender: TObject);
    procedure cboSkinsListChange(Sender: TObject);
    procedure txtPasswordExit(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cboLangChange(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
  public
    function GenerateLaunchString:TMinecraftLoader;
    function GenerateJavaPath:string;
    function GetLaunchMode:string;
    procedure SetActivePage(gb: TGroupBox; btn: TsButton);
    procedure ReloadBackground;
    procedure CheckPackingLibraries(l:TMinecraftLoader);
    procedure SetActiveLanguage(LanguageName:string);
  type
    TCB = class(TInterfacedObject, IProcessCallback)
    protected
      Procedure OnStart;
      Procedure OnExit;
      Procedure OnFail;
    end;
    TCB2 = class(TInterfacedObject, IDownloadCallBack)
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
    end;
  protected
    s:TResourceStream;
    p:TPicture;
    pro:TProcess;
    cb:TCB2;
    ll: TLanguageLoader;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$R res.res}

function TForm1.TCB2.GetBindInfo( out grfBINDF: DWORD; var bindinfo: TBindInfo ): HResult;
begin
result := S_OK;
end;

function TForm1.TCB2.GetPriority( out nPriority ): HResult;
begin
Result := S_OK;
end;

function TForm1.TCB2.OnDataAvailable( grfBSCF, dwSize: DWORD; formatetc: PFormatEtc; stgmed: PStgMedium ): HResult;
begin
Result := S_OK;
end;

function TForm1.TCB2.OnLowResource( reserved: DWORD ): HResult;
begin
Result := S_OK;
end;

function TForm1.TCB2.OnObjectAvailable( const iid: TGUID; punk: IInterface ): HResult;
begin
Result := S_OK;
end;

function TForm1.TCB2.OnStartBinding( dwReserved: DWORD; pib: IBinding ): HResult;
begin
Result := S_OK;
end;
function TForm1.TCB2.OnStopBinding( hresult: HResult; szError: LPCWSTR ): HResult;
begin
Result := S_OK;
end;
function TForm1.TCB2.OnProgress(ulProgress: Cardinal; ulProgressMax: Cardinal; ulStatusCode: Cardinal; szStatusText: PWideChar):HRESULT;
begin

end;
procedure TForm1.TCB2.OnStatus(status: string);
begin

end;

function IntegerToString(i:Integer): string;
var s:string;
begin
  str(i, s);
  exit(s);
end;

function FindSelectedIndex(lb:TsListBox):integer;
var
  i: Integer;
begin
  for i := 0 to lb.Count - 1 do
    if lb.Selected[i] then
      exit(i);
  exit(-1);
end;

procedure RefreshMinecraftVersions(mp:string; lb:TsComboBox; last:string);
var s:TStringList;
  i, j: Integer;
  pro: TProfile;
begin
  s:=TFileUtilities.FindAllDirectory(mp + '\versions\');
  lb.Clear;
  j := -1;
  for i := 0 to s.Count - 1 do
  begin
    lb.AddItem(s[i], nil);
    if TProfilesManager.Find(s[i]) = nil then
    begin
      pro := TProfile.Create(s[i]);
      pro.lastVersionId := s[i];
      TProfilesManager.Add(pro);
    end;
    if s[i] = last then
      j := i;
  end;
  if j <> -1 then
    lb.ItemIndex := j;
end;

procedure RefreshMinecraftResources(mp:string; lb:TsListBox);
var s:TStringList;
  i: Integer;
begin
  s:=TFileUtilities.FindAllFiles(mp + '\resourcepacks');
  lb.Clear;
  for i := 0 to s.Count - 1 do
    lb.AddItem(s[i], nil);
end;

function StringToInt(s:string):Integer;
var code, i:integer;
begin
  val(s,i,code); exit(i);
end;

//Returns Memory Size(MB)
function GetMemorySize: Int64;
var mse: TMemoryStatusEx;
begin
  mse.dwLength := sizeof(TMemoryStatusEx);
  GlobalMemoryStatusEx(mse);
  exit(mse.ullTotalPhys div 1024 div 1024);
end;

function GetLastMemorySize: Int64;
var mse: TMemoryStatusEx;
begin
  mse.dwLength := sizeof(TMemoryStatusEx);
  GlobalMemoryStatusEx(mse);
  exit(mse.ullAvailPhys div 1024 div 1024);
end;

procedure TForm1.SetActiveLanguage(LanguageName:string);
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
    tmp := SOFindField(jso, 'Form1.' + frmComponent.Name + '.Caption');
    if tmp <> nil then
    begin
      s := WideStringToAnsiString(tmp.AsString);
      if frmComponent is TsLabelFx then   {   如果组件为TLabel型则当作TLabel处理，以下同   }
      begin
        (frmComponent as TsLabelFx).Caption:=s;
      end else
      if frmComponent is TsWebLabel then   {   如果组件为TLabel型则当作TLabel处理，以下同   }
      begin
        (frmComponent as TsWebLabel).Caption:=s;
      end else
      if frmComponent is TsCheckBox then
      begin
        (frmComponent as TsCheckBox).Caption:=s;
      end else
      if frmComponent is TsButton then
      begin
        (frmComponent as TsButton).Caption:=s;
      end else
      if frmComponent is TRadioButton then
      begin
        (frmComponent as TRadioButton).Caption:=s;
      end else
      if frmComponent is TGroupBox then
      begin
        (frmComponent as TGroupBox).Caption:=s;
      end;
    end;
  end;
end;

procedure TForm1.CheckPackingLibraries(l:TMinecraftLoader);
var d:TDownloader;
  i, j: Integer;
  flag: Boolean;
begin
  for i := 1 to l.LibraryCount do
  begin
    flag := false;
    if(l.Libraries[i].RuleCount = 0)then
      flag := true;
    for j := 1 to l.Libraries[i].RuleCount do
      if l.Libraries[i].RulesAction[j] = 'disallow' then
      begin
        if (l.Libraries[i].RulesOSName[j] = '')
         or(Trim(LowerCase(l.Libraries[i].RulesOSName[j])) = 'windows') then
        begin
          flag := false;
          break;
        end;
      end
      else
      begin
        if (l.Libraries[i].RulesOSName[j] = '')
         or(Trim(LowerCase(l.Libraries[i].RulesOSName[j])) = 'windows') then
        begin
          flag := true;
          break;
        end;
      end;
    if flag then
      if Not FileExists(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'libraries\' + l.Libraries[i].Formatted) then
      begin
        d := TDownloader.Create('https://s3.amazonaws.com/Minecraft.Download/libraries/' + StringReplace(l.Libraries[i].Formatted, '\', '/', [rfReplaceAll]));
        ForceDirectories(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'libraries\' + ExtractFilePath(l.Libraries[i].Formatted));
        d.DownFile(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'libraries\' + l.Libraries[i].Formatted, cb);
      end;
  end;
end;

function CheckUnpackingLibraries(l:TMinecraftLoader):TList<TMinecraftUnPackingLibrary>;
var
  i, j: Integer;
  flag:Boolean;
begin
  Result := TList<TMinecraftUnPackingLibrary>.Create;
  for i := 1 to l.UnpackingLibraryCount do
  begin
    flag := false;
    if(l.UnpackingLibraries[i].RuleCount = 0)then
      flag := true;
    for j := 1 to l.UnpackingLibraries[i].RuleCount do
      if l.UnpackingLibraries[i].RulesAction[j] = 'disallow' then
      begin
        if (l.UnpackingLibraries[i].RulesOSName[j] = '')
         or(Trim(LowerCase(l.UnpackingLibraries[i].RulesOSName[j])) = 'windows') then
        begin
          flag := false;
          break;
        end;
      end
      else
      begin
        if (l.UnpackingLibraries[i].RulesOSName[j] = '')
         or(Trim(LowerCase(l.UnpackingLibraries[i].RulesOSName[j])) = 'windows') then
        begin
          flag := true;
          break;
        end;
      end;
    if flag then
    begin
      if FileExists(SMPMinecraftPath + '\libraries\' + l.UnpackingLibraries[i].Formatted) then
      begin
        Result.Add(l.UnpackingLibraries[i]);
      end;
    end;
  end;
end;

procedure TForm1.SetActivePage(gb: TGroupBox; btn: TsButton);
begin
  if gb.Visible then
  begin
    gb.Visible := false;
    btn.Down := false;
    exit;
  end;
  GroupBoxDownloads.Visible := false;
  GroupBoxResources.Visible := false;
  GroupBoxSettings.Visible := false;
  GroupBoxSkins.Visible := false;
  gb.Visible := true;
  BtnDownloads.Down := false;
  BtnResources.Down := false;
  BtnSettings.Down := false;
  BtnSkins.Down := False;
  btn.Down := true;
end;

procedure TForm1.TCB.OnExit;
var realpath:String;
    profile:TProfile;
begin
  realPath := TFileUtilities.AddSeparator(SMPMinecraftPath);
  if DirectoryExists(realpath + 'mods') then
  begin
    TFileUtilities.CopyDir(realpath + 'mods', realpath + 'versions\' + SMPLast + '\mods');
  end;
  if DirectoryExists(realpath + 'coremods') then
  begin
    TFileUtilities.CopyDir(realpath + 'coremods', realpath + 'versions\' + SMPLast + '\mods');
  end;
  if DirectoryExists(realpath + 'config') then
  begin
    TFileUtilities.CopyDir(realpath + 'config', realpath + 'versions\' + SMPLast + '\config');
  end;
  TSettingsManager.Save;
  TProfilesManager.Savesss;
  Application.Terminate;
end;

procedure TForm1.TCB.OnStart;
begin

end;

procedure TForm1.TCB.OnFail;
begin

end;

function TForm1.GenerateLaunchString:TMinecraftLoader;
var ml:TMinecraftLoader; s, tmp, pa, realpa:String;
  mm, code, i:integer; name:String;
  f: TextFile; login: TOfficalLogin;
  lst: TList<TMinecraftUnPackingLibrary>;
  prof: TProfile; flag: Boolean;
  auth: TAuthenticationDatabase;
begin

  Val(txtMaxMemory.Text, mm, code);
  pa := TFileUtilities.ExtractLastDirectory(SMPMinecraftPath);
  if (pa <> '.minecraft') or (Not DirectoryExists(SMPMinecraftPath)) then
  begin
    ShowMessage(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.NotSelectedAnyMinecraftVersion').AsString);
    exit(nil);
  end;
  name := cboMinecrafts.Text;
  if (name = '') then
  begin
    ShowMessage(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.NotSelectedTruthMinecraftVersion').AsString);
    exit(nil);
  end;
  FrmInfo.ChangeEvent(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.ReadingJSON').AsString);
  FrmInfo.Top := (Screen.Height - FrmInfo.Height) div 2;
  FrmInfo.Left := (Screen.Width - FrmInfo.Width) div 2;
  FrmInfo.Show;
  pa := SMPMinecraftPath + '\versions\' + name + '\' + name + '.json';
  AssignFile(f, pa);
  reset(f);
  while not eof(f) do
  begin
    ReadLn(f, tmp);
    s := s + tmp;
  end;
  CloseFile(f);

  login := TOfficalLogin.Create;
  prof := TProfilesManager.Find(name);
  if txtPassword.Text <> '' then
  begin
    if login.Login(txtPlayerName.Text, txtPassword.Text) then
    begin
      prof.playerUUID := login.ProfileId;
      prof.HasPlayerUUID := true;
      auth.username[auth.Count] := txtPlayerName.Text;
      auth.displayName[auth.Count] := login.ProfileName;
      auth.accessToken[auth.Count] := login.Session;
      auth.uuid[auth.Count] := login.ProfileId;
      inc(auth.Count);
      TProfilesManager.Savesss
    end
    else
    begin
      login.Session := 'no';
      login.ProfileName := txtPlayerName.Text
    end
  end
  else
  begin
    flag := false;
    with LPLoader.authenticationDatabase do
      for i := 0 to Count - 1 do
        if uuid[i] = prof.playerUUID then
        begin
          login.Session := accessToken[i];
          flag := true;
          break;
        end;
    if not flag then
    begin
      login.Session := 'no';
      login.ProfileName := txtPlayerName.Text;
    end;
  end;

  ml := TMinecraftLoader.Create(SMPMinecraftPath, s,SMPJavaPath,Self.GetLaunchMode,
                                login.ProfileName,login.Session,mm,prof,
                                chkUseJava.Checked);

  realpa := TFileUtilities.AddSeparator(SMPMinecraftPath);

  FrmInfo.ChangeEvent(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.CheckingLibraries').AsString);

  CheckPackingLibraries(ml);

  FrmInfo.ChangeEvent(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.UnzippingLibraries').AsString);

  lst := CheckUnpackingLibraries(ml);
  TFileUtilities.DeleteDir(realpa + 'versions\' + name + '\' + name + '-natives');
  if lst.Count > 0 then
  begin
    for i := 0 to lst.Count - 1 do
    begin
      ForceDirectories(realpa + 'versions\' + name + '\' + name + '-natives');
      //ShowMessage(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'libraries\' + lst[i].Formatted);
      TFileUtilities.Zip(1, 0, realpa + 'libraries\' + lst[i].Formatted, realpa + 'versions\' + name + '\' + name + '-natives');
    end;
  end;

  FrmInfo.ChangeEvent(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.MovingModules').AsString);

  if DirectoryExists(realpa + 'versions\' + name + '\mods') then
  begin
    TFileUtilities.DeleteDir(realpa + 'mods');
    TFileUtilities.CopyDir(realpa + 'versions\' + name + '\mods', realpa + 'mods');
  end;
  if DirectoryExists(realpa + 'versions\' + name + '\coremods') then
  begin
    TFileUtilities.DeleteDir(realpa + 'coremods');
    TFileUtilities.CopyDir(realpa + 'versions\' + name + '\coremods', realpa + 'coremods');
  end;
  if DirectoryExists(realpa + 'versions\' + name + '\config') then
  begin
    TFileUtilities.DeleteDir(realpa + 'config');
    TFileUtilities.CopyDir(realpa + 'versions\' + name + '\config', realpa + 'config');
  end;

  LPLoader.selectedProfile := name;
  TProfilesManager.Savesss;

  SMPLast := name;
  TSettingsManager.Save;

  FrmInfo.Hide;

  exit(ml);
end;
procedure TForm1.BtnSetClick(Sender: TObject);
begin
  dlgOpen.Filter := 'java.exe|java.exe|javaw.exe|javaw.exe';
  if dlgOpen.Execute(Self.Handle) then
  begin
    txtJavaPath.Text := ExtractFileDir(dlgOpen.FileName);
  end;
  SMPJavaPath := txtJavaPath.Text;
  TSettingsManager.Save;
end;

procedure TForm1.BtnSetMinecraftPathClick(Sender: TObject);
begin
  SelectDirectory(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.SelectMinecraftFolder').AsString, '', SMPMinecraftPath);
  txtMinecraftPath.Text := SMPMinecraftPath;
  RefreshMinecraftVersions(SMPMinecraftPath, cboMinecrafts, SMPLast);
  TSettingsManager.Save;
end;

procedure TForm1.BtnSetSkinPathClick(Sender: TObject);
var dir:String;
    i:Integer;
    sl:TStringList;
begin
  SelectDirectory(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.ChooseSkinPath').AsString, '', dir);
  SMPSkinPath := dir;
  txtSkinPath.Text := dir;
  TSettingsManager.Save;
  if(dir = '') then exit;
  sSkinManager1.SkinDirectory := dir;
  sl := TStringList.Create;
  sSkinManager1.GetSkinNames(sl);
  cboSkinsList.Clear;
  for i := 0 to sl.Count - 1 do
    cboSkinsList.Items.Add(sl[i]);
  if cboSkinsList.Items.Count = 0 then
  begin
    ShowMessage(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.NoSkin').AsString);
    exit;
  end;
end;

procedure TForm1.BtnSettingsClick(Sender: TObject);
begin
  SetActivePage(GroupBoxSettings, BtnSettings);
end;

procedure TForm1.BtnSkinsClick(Sender: TObject);
begin
  SetActivePage(GroupBoxSkins, BtnSkins);
end;

procedure TForm1.BtnVersionManagerClick(Sender: TObject);
begin
  FrmVersions.Show;
  FrmVersions.FormLoad;
end;

procedure TForm1.BtnResourcesClick(Sender: TObject);
begin
  SetActivePage(GroupBoxResources, BtnResources);
end;

procedure TForm1.BtnMakeBatClick(Sender: TObject);
var ml:TMinecraftLoader; s, tmp, pa:String;
  mm, code:integer;
  f: TextFile;
begin
  ml := GenerateLaunchString;
  if ml = nil then
    exit;
  s := ml.GenerateLaunchString;
  if s = '' then
    exit;
  AssignFile(f, 'launch.bat');
  Rewrite(f);
  Writeln(f,'set appdata=',SMPMinecraftPath + '\..');
  Writeln(f,s);
  if SMPDebug then
    Writeln(f,'pause');
  CloseFile(f);
end;

procedure TForm1.BtnManageVersionClick(Sender: TObject);
var i: Integer; name: String; p: TProfile;
begin
  name := cboMinecrafts.Text;

  if(name = '') then
  begin
    ShowMessage(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.NotSelectedTruthMinecraftVersion').AsString);
    exit;
  end;

  p := TProfilesManager.Find(name);

  if(p = nil)then
  begin
    ShowMessage(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.Failed').AsString);
    exit;
  end;

  FrmVersionManager.vername := name;
  FrmVersionManager.profile := p;
  FrmVersionManager.Show;
end;

procedure TForm1.BtnResourcesDownloadClick(Sender: TObject);
begin
//  ShowMessage('抱歉...尚未完全实现...卡在了读XML上了呢...读不出来内容呢...');
  FrmAssets.Show;
end;

procedure TForm1.cboLangChange(Sender: TObject);
begin
  SetActiveLanguage(cboLang.Items[cboLang.ItemIndex]);
  SMPLanguage := cboLang.Items[cboLang.ItemIndex];
  TSettingsManager.Save;
end;

procedure TForm1.cboSkinsListChange(Sender: TObject);
begin
  if cboSkinsList.Text = '' then
    exit;
  sSkinManager1.SkinName := cboSkinsList.Text;
  SMPSkinName := cboSkinsList.Text;
  TSettingsManager.Save;
end;

procedure TForm1.chkDebugClick(Sender: TObject);
begin
  SMPDebug := chkDebug.Checked;
  TSettingsManager.Save;
end;

procedure TForm1.chkShowBackgroundClick(Sender: TObject);
begin
  image1.Visible := chkShowBackground.Checked;
  SMPShowBackground := image1.Visible;
  TSettingsManager.Save;
end;

procedure TForm1.chkUseJavaClick(Sender: TObject);
begin
  SMPUseJava := chkUseJava.Checked;
  TSettingsManager.Save;
end;

procedure TForm1.ReloadBackground;
var b:TBitmap;
    png:TPNGImage;
begin
  if SMPBackgroundPath <> '' then
  begin
    Image1.Picture.LoadFromFile(SMPBackgroundPath);
    txtBackgroundPath.Text := SMPBackgroundPath;
  end
  else
  begin
    s := TResourceStream.Create(hInstance, 'background', RT_RCDATA);
    png:=TPNGIMAGE.Create;
    png.LoadFromStream(s);
    Image1.Picture.Assign(png);
    s.Free;
    txtBackgroundPath.Text := '';
  end;

  if SMPShowBackground then
  begin
    Image1.Visible := true;
    chkShowBackground.Checked := true;
  end
  else
  begin
    Image1.Visible := false;
    chkShowBackground.Checked := false;
  end;

  Image1.Left := (Self.ClientWidth - Image1.Width) div 2;
  Image1.Top := (Self.ClientHeight - Image1.Height) div 2;

{  b := TBitmap.Create;
  b.Assign(p);
  Self.Brush.Bitmap := b;}

end;

procedure TForm1.FormCreate(Sender: TObject);
var memSize: Int64; strSize:string;
  s: TResourceStream;
  p: TPngImage;
  b: TBitmap;
  Reg1, Reg2: THandle;
  i: Integer;
  j: Integer;
  sl: TStringList;
begin
  memSize := GetMemorySize;
  strSize := IntegerToString(memSize);

  TSettingsManager.Load;
  TProfilesManager.Load;
  txtMinecraftPath.Text := SMPMinecraftPath;
  txtJavaPath.Text := SMPJavaPath;
  txtPlayerName.Text := SMPPlayerName;
  txtMaxMemory.Text := strSize;
  chkUseJava.Checked := SMPUseJava;
  if SMPLaunchMode = 'Normal' then
  begin
    rdoNormal.Checked := true;
    rdo32bit.Checked := false;
    rdo64bit.Checked := false;
  end
  else if SMPLaunchMode = '32bit' then
  begin
    rdoNormal.Checked := false;
    rdo32bit.Checked := true;
    rdo64bit.Checked := false;
  end
  else if SMPLaunchMode = '64bit' then
  begin
    rdoNormal.Checked := false;
    rdo32bit.Checked := false;
    rdo64bit.Checked := true;
  end;

  tkbMaxMemory.Min := 0;
  tkbMaxMemory.Max := memSize;
  tkbMaxMemory.Position := SMPMaxMemory;

  RefreshMinecraftVersions(SMPMinecraftPath, cboMinecrafts, SMPLast);
  RefreshMinecraftResources(SMPMinecraftPath, lstResources);

  lblSysMemory.Caption := strSize + 'm';
  lblNowMemory.Caption := IntegerToString(GetLastMemorySize) + 'm';

  ReloadBackground;

  if (SMPSkinPath <> '') then
  begin
    txtSkinPath.Text := SMPSkinPath;
    if (SMPSkinName <> '') then
    begin
      sSkinManager1.SkinDirectory := SMPSkinPath;
      sSkinManager1.SkinName := SMPSkinName;
      sl := TStringList.Create;
      sSkinManager1.GetSkinNames(sl);
      cboSkinsList.Clear;
      j := -1;
      for i := 0 to sl.Count - 1 do
      begin
        cboSkinsList.Items.Add(sl[i]);
        if sl[i] = SMPSkinName then
          j := i;
      end;
      if j <> -1 then
        cboSkinsList.ItemIndex := j;
    end;
  end;

  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;

  ll := TLanguageLoader.Create(TFileUtilities.ReadToEnd('lang.json'));
  j := -1;
  for i := 0 to ll.Count - 1 do
  begin
    if ll.name[i] = SMPLanguage then
      j := i;
    cboLang.Items.Add(ll.name[i]);
  end;
  if j <> -1 then
    cboLang.ItemIndex := j;
  SetActiveLanguage(SMPLanguage);
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, 274, 61449, 0);
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
var i, j:Integer;
begin
//  Canvas.Draw(0, 0, p);

{  for j := 0 to self.Height do
  begin
    canvas.Pixels[0, j] := clBlack;
    canvas.Pixels[Self.Width - 1, j] := clBlack;
  end;
  for i := 0 to self.Width do
  begin
    canvas.Pixels[i, 0] := clBlack;
    canvas.Pixels[i, Self.Height - 1] := clBlack;
  end;     }
end;

function TForm1.GenerateJavaPath:string;
var exits:string;
begin
  if(chkUseJava.Checked)then
    if length(Trim(txtJavaPath.Text))=0 then
      exits:=('java.exe')
    else
      exits:=(txtJavaPath.Text + '\java.exe')
  else
    if length(Trim(txtJavaPath.Text))=0 then
      exits:=('javaw.exe')
    else
      exits:=(txtJavaPath.Text + '\javaw.exe');
  exit(exits);
end;

function TForm1.GetLaunchMode:string;
begin
  if rdo64Bit.Checked then
    exit('-d64')
  else if rdo32Bit.Checked then
    exit('-d32')
  else
    exit('');
end;
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, 274, 61449, 0);
  end;
end;

procedure TForm1.lblTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, 274, 61449, 0);
  end;
end;

procedure TForm1.rdo32BitClick(Sender: TObject);
begin
  SMPLaunchMode := '32bit';
  TSettingsManager.Save;
end;

procedure TForm1.rdo64BitClick(Sender: TObject);
begin
  SMPLaunchMode := '64bit';
  TSettingsManager.Save;
end;

procedure TForm1.rdoNormalClick(Sender: TObject);
begin
  SMPLaunchMode := 'Normal';
  TSettingsManager.Save;
end;

procedure TForm1.BtnSearchClick(Sender: TObject);
begin
  SMPJavaPath := GetJavaPath;
  txtJavaPath.Text := SMPJavaPath;
  TSettingsManager.Save;
end;

procedure TForm1.BtnSetBackgroundPathClick(Sender: TObject);
var dlg:TOpenDialog;
begin
  dlg := TOpenDialog.Create(self);
  dlg.Filter := '*.*';
  if dlg.Execute then
  begin
    SMPBackgroundPath := dlg.FileName;
    ReloadBackground;
    TSettingsManager.Save;
  end;
end;

procedure TForm1.sWebLabel1Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, PWideChar(WideString('http://www.mcbbs.net/forum-texture-1.html')), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.tkbMaxMemoryChange(Sender: TObject);
begin
  txtMaxMemory.Text := IntegerToString(tkbMaxMemory.Position);
end;

procedure TForm1.tkbMaxMemoryMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SMPMaxMemory := StringToInt(txtMaxMemory.Text);
  TSettingsManager.Save;
end;

procedure TForm1.txtJavaPathExit(Sender: TObject);
begin
  SMPJavaPath := txtJavaPath.Text;
  TSettingsManager.Save;
end;

procedure TForm1.txtMaxMemoryChange(Sender: TObject);
begin
  tkbMaxMemory.Position := StringToInt(txtMaxMemory.Text);
end;

procedure TForm1.txtMaxMemoryExit(Sender: TObject);
begin
  SMPMaxMemory := StringToInt(txtMaxMemory.Text);
  TSettingsManager.Save;
end;

procedure TForm1.txtMinecraftPathExit(Sender: TObject);
begin
  txtMinecraftPath.Text := TFileUtilities.RemoveLastSeparator(txtMinecraftPath.Text);
  SMPMinecraftPath := txtMinecraftPath.Text;
  TSettingsManager.Save;
  RefreshMinecraftVersions(SMPMinecraftPath, cboMinecrafts, SMPLast);
end;

procedure TForm1.txtPasswordExit(Sender: TObject);
begin
//  SMPPassword := .Text;
//  TSettingsManager.Save;
end;

procedure TForm1.BtnAddResourceClick(Sender: TObject);
var dlg : TOpenDialog;
begin
  dlg := TOpenDialog.Create(self);
  dlg.Filter := '*.zip';
  if dlg.Execute then
  begin
    CopyFile(PWideChar(dlg.FileName), PWideChar(WideString(SMPMinecraftPath + '\resourcepacks\' + ExtractFileName(dlg.FileName))), false);
    RefreshMinecraftResources(SMPMinecraftPath, lstResources);
  end;
end;

procedure TForm1.BtnCurDirClick(Sender: TObject);
begin
  txtMinecraftPath.Text := TFileUtilities.CurrentDir + '.minecraft';
  SMPMinecraftPath := txtMinecraftPath.Text;
  TSettingsManager.Save;
end;

procedure TForm1.BtnDeleteResourceClick(Sender: TObject);
var name, existingpath, newpath: String;
begin
  name := lstResources.Items[FindSelectedIndex(lstResources)];
  ForceDirectories(PWideChar(WideString(SMPMinecraftPath + '\resourcepacks-del\')));

  existingpath := SMPMinecraftPath + '\resourcepacks\' + name;
  newpath := SMPMinecraftPath + '\resourcepacks-del\' + name;
  MoveFile(PWideChar(WideString(existingpath)),
           PWideChar(WideString(newpath)));

  RefreshMinecraftResources(SMPMinecraftPath, lstResources);
end;

procedure TForm1.BtnDownloadsClick(Sender: TObject);
begin
  SetActivePage(GroupBoxDownloads, BtnDownloads);
end;

procedure TForm1.BtnGoodMemoryClick(Sender: TObject);
var s,b:string; k: int64;
begin
  k := GetMemorySize;
  str(k div 2, s);
  str(k, b);
  txtMaxMemory.Text := s;
  SMPMaxMemory := k div 2;
  TSettingsManager.Save;
end;

procedure TForm1.BtnIncludeOldVersionClick(Sender: TObject);
var mcp, name:String;
    l: TMinecraftOldVersionIncluder;
begin
  SelectDirectory(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.SelectMiencraftFolder').AsString, '', mcp);

  if Not FileExists(mcp + '\bin\minecraft.jar') then
  begin
    ShowMessage('');
    exit;
  end;

  name := InputBox(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.IncludeOldMinecraft').AsString,
                   SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.InputName').AsString, '');
  if DirectoryExists(TFileUtilities.AddSeparator(SMPMinecraftPath) + 'versions\' + name) then
  begin
    ShowMessage(SOFindField(ll.lang[ll.Find(SMPLanguage)], 'Form1.FoundMinecraft').AsString);
    exit;
  end;

  l := TMinecraftOldVersionIncluder.Create(mcp, name);
  l.Include;


  TSettingsManager.Save;

  RefreshMinecraftVersions(SMPMinecraftPath, cboMinecrafts, SMPLast);
end;

procedure TForm1.BtnMCVersionsClick(Sender: TObject);
begin
  FrmVersions.Show;
  FrmVersions.FormLoad;
end;

procedure TForm1.BtnModsClick(Sender: TObject);
begin
  FrmModManager.Version := cboMinecrafts.Items[cboMinecrafts.ItemIndex];
  FrmModManager.Show;
end;

procedure TForm1.BtnNewsClick(Sender: TObject);
begin
  FrmNews.Show;
end;

procedure TForm1.BtnRefreshListClick(Sender: TObject);
begin
  RefreshMinecraftVersions(SMPMinecraftPath, cboMinecrafts, SMPLast);
end;

procedure TForm1.BtnRefreshResourcesClick(Sender: TObject);
begin
  RefreshMinecraftResources(SMPMinecraftPath, lstResources);
end;

procedure TForm1.BtnRunClick(Sender: TObject);
var ml:TMinecraftLoader;
  s:TList<TMinecraftUnpackingLibrary>;
  res:String;
  i: Integer;
  cb:TCB;
begin
  ml := GenerateLaunchString;

  if(ml = nil) then exit;

  res:=ml.GenerateLaunchString;

  if res = '' then
    exit;

//  ShowMessage(res);

  SetEnvironmentVariable('APPDATA', PWideChar(WideString(SMPMinecraftPath + '\..')));

  cb := TCB.Create;

  pro := TProcess.Create(res, SMPDebug, PWideChar(WideString('appdata=' + SMPMinecraftPath + '\..')), cb);
  pro.StartProcess;
  Self.Hide;
end;

end.
