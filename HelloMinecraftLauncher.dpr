program HelloMinecraftLauncher;


{$R *.dres}

uses
  Vcl.Forms,
  UForm1 in 'UForm1.pas',
  UProcessManager in 'UProcessManager.pas',
  UFrmMCVersions in 'UFrmMCVersions.pas',
  UFrmNews in 'UFrmNews.pas',
  UFrmAssets in 'UFrmAssets.pas',
  UFrmVersionManager in 'UFrmVersionManager.pas',
  UFrmInputBox in 'UFrmInputBox.pas',
  UMinecraftDownloader in 'UMinecraftDownloader.pas',
  UMinecraftOldVersionIncluder in 'UMinecraftOldVersionIncluder.pas',
  FrmModsManage in 'FrmModsManage.pas',
  kpSFXCfg in 'VCLZipPro451_1\kpSFXCfg.pas',
  VCLUnZip in 'VCLZipPro451_1\VCLUnZip.pas',
  VCLZip in 'VCLZipPro451_1\VCLZip.pas',
  SuperObject in 'superobject.pas',
  SuperXMLParser in 'superxmlparser.pas',
  UMinecraftVersionsLoader in 'UMinecraftVersionsLoader.pas',
  USettingsManager in 'USettingsManager.pas',
  UMinecraftLoader in 'UMinecraftLoader.pas',
  ULauncherProfileLoader in 'ULauncherProfileLoader.pas',
  UFileUtilities in 'UFileUtilities.pas',
  UOfficalLogin in 'UOfficalLogin.pas',
  UFrmInfo in 'UFrmInfo.pas' {FrmInfo},
  ULanguageLoader in 'ULanguageLoader.pas';

begin
  Application.Initialize;
//  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrmInfo, FrmInfo);
  Application.CreateForm(TFrmVersions, FrmVersions);
  Application.CreateForm(TFrmNews, FrmNews);
  Application.CreateForm(TFrmAssets, FrmAssets);
  Application.CreateForm(TFrmModManager, FrmModManager);
  Application.CreateForm(TFrmVersionManager, FrmVersionManager);
  Application.CreateForm(TFrmInputBox, FrmInputBox);
  Application.Run;
end.

