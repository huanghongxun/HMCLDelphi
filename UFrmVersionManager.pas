unit UFrmVersionManager;

interface

uses
  Windows, Forms, Controls, Classes, ULauncherProfileLoader, FileCtrl,
  USettingsManager, UFileUtilities, ULanguageLoader,
  sCheckBox, sLabel, sEdit, sButton, SuperObject, Vcl.StdCtrls;

type
  TFrmVersionManager = class(TForm)
    chkGameDir: TsCheckBox;
    lblGameDir: TsLabelFx;
    txtGameDir: TsEdit;
    BtnGameDir: TsButton;
    chkJavaDir: TsCheckBox;
    lblJavaDir: TsLabelFx;
    txtJavaDir: TsEdit;
    BtnJavaDir: TsButton;
    chkJavaArgs: TsCheckBox;
    lblJavaArgs: TsLabelFx;
    txtJavaArgs: TsEdit;
    chkResolution: TsCheckBox;
    lblResolution: TsLabelFx;
    lblWidth: TsLabelFx;
    txtWidth: TsEdit;
    lblHeight: TsLabelFx;
    txtHeight: TsEdit;
    lblMul: TsLabelFx;
    procedure FormShow(Sender: TObject);
    procedure chkGameDirClick(Sender: TObject);
    procedure chkJavaDirClick(Sender: TObject);
    procedure chkJavaArgsClick(Sender: TObject);
    procedure chkResolutionClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnGameDirClick(Sender: TObject);
    procedure BtnJavaDirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    vername: String;
    profile: TProfile;
    ll: TLanguageLoader;

    procedure GameDirChanged;
    procedure JavaDirChanged;
    procedure JavaArgsChanged;
    procedure ResolutionChanged;
    procedure SetActiveLanguage(LanguageName:string);
  end;

var
  FrmVersionManager: TFrmVersionManager;

implementation

{$R *.dfm}

function IntegerToString(int:Integer):string;
begin
  str(int, Result);
end;

function StringToInteger(src:string):Integer;
var code:Integer;
begin
  val(src, result, code);
end;

procedure TFrmVersionManager.SetActiveLanguage(LanguageName:string);
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
    tmp := SOFindField(jso, 'FrmVersionManager.' + frmComponent.Name + '.Caption');
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

procedure TFrmVersionManager.GameDirChanged;
begin
  //chkGameDir.Checked := not chkGameDir.Checked;
  lblGameDir.Enabled := chkGameDir.Checked;
  txtGameDir.Enabled := chkGameDir.Checked;
  btnGameDir.Enabled := chkGameDir.Checked;
end;

procedure TFrmVersionManager.JavaDirChanged;
begin
  lblJavaDir.Enabled := chkJavaDir.Checked;
  txtJavaDir.Enabled := chkJavaDir.Checked;
  btnJavaDir.Enabled := chkJavaDir.Checked;
end;

procedure TFrmVersionManager.JavaArgsChanged;
begin
  lblJavaArgs.Enabled := chkJavaArgs.Checked;
  txtJavaArgs.Enabled := chkJavaArgs.Checked;
end;

procedure TFrmVersionManager.ResolutionChanged;
begin
  lblResolution.Enabled := chkResolution.Checked;
  lblMul.Enabled := chkResolution.Checked;
  lblWidth.Enabled := chkResolution.Checked;
  lblHeight.Enabled := chkResolution.Checked;
  txtWidth.Enabled := chkResolution.Checked;
  txtHeight.Enabled := chkResolution.Checked;
end;

procedure TFrmVersionManager.BtnGameDirClick(Sender: TObject);
begin
  SelectDirectory('选择游戏路径（.minecraft文件夹）', '', profile.gameDir);
  txtGameDir.Text := profile.gameDir;
end;

procedure TFrmVersionManager.BtnJavaDirClick(Sender: TObject);
begin
  SelectDirectory('选择Java路径（bin文件夹）', '', profile.javaDir);
  txtJavaDir.Text := profile.javaDir;
end;

procedure TFrmVersionManager.chkGameDirClick(Sender: TObject);
begin
  GameDirChanged;
end;

procedure TFrmVersionManager.chkJavaArgsClick(Sender: TObject);
begin
  JavaArgsChanged;
end;

procedure TFrmVersionManager.chkJavaDirClick(Sender: TObject);
begin
  JavaDirChanged;
end;

procedure TFrmVersionManager.chkResolutionClick(Sender: TObject);
begin
  ResolutionChanged;
end;

procedure TFrmVersionManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  profile.HasGameDir := chkGameDir.Checked;
  profile.GameDir := txtGameDir.Text;
  profile.HasJavaDir := chkJavaDir.Checked;
  profile.JavaDir := txtJavaDir.Text;
  profile.HasJavaArgs := chkJavaArgs.Checked;
  profile.JavaArgs := txtJavaArgs.Text;
  profile.HasResolution := chkResolution.Checked;
  profile.Width := StringToInteger(txtWidth.Text);
  profile.Height := StringToInteger(txtHeight.Text);
  TProfilesManager.Add(profile);
  TProfilesManager.Savesss;
end;

procedure TFrmVersionManager.FormCreate(Sender: TObject);
begin

  ll := TLanguageLoader.Create(TFileUtilities.ReadToEnd('lang.json'));
end;

procedure TFrmVersionManager.FormDestroy(Sender: TObject);
begin
  TProfilesManager.Add(profile);
  TProfilesManager.Savesss;
end;

procedure TFrmVersionManager.FormShow(Sender: TObject);
begin
  Self.Caption := 'Minecraft 版本管理-版本：' + vername;
  chkGameDir.Checked := profile.HasGameDir;
  if profile.HasGameDir then
  begin
    txtGameDir.Text := profile.gameDir;
  end;
  chkJavaDir.Checked := profile.HasJavaDir;
  if profile.HasJavaDir then
    txtJavaDir.Text := profile.javaDir;
  chkJavaArgs.Checked := profile.HasJavaArgs;
  if profile.HasJavaArgs then
    txtJavaArgs.Text := profile.javaArgs;
  chkResolution.Checked := profile.HasResolution;
  if profile.HasResolution then
  begin
    txtWidth.Text := IntegerToString(profile.Width);
    txtHeight.Text := IntegerToString(profile.Height);
  end;
  GameDirChanged;
  JavaDirChanged;
  JavaArgsChanged;
  ResolutionChanged;
  SetActiveLanguage(SMPLanguage);
end;

end.
