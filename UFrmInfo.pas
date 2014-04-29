unit UFrmInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sLabel, SuperObject, ULanguageLoader;

type
  TFrmInfo = class(TForm)
    lblContent: TsLabelFX;
  private
    { Private declarations }
  public
    { Public declarations }
    Content: String;
    ll: TLanguageLoader;
    procedure ChangeEvent(c:String);
    procedure SetActiveLanguage(LanguageName:string);
  end;

var
  FrmInfo: TFrmInfo;

implementation

{$R *.dfm}

procedure TFrmInfo.ChangeEvent(c: string);
begin
  Content := c;
  lblContent.Caption := c;
  lblContent.Left := (Self.ClientWidth - lblContent.Width) div 2;
  lblContent.Top := (Self.ClientHeight - lblContent.Height) div 2;
end;

procedure TFrmInfo.SetActiveLanguage(LanguageName:string);
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

end.
