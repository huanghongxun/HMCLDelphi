unit UFrmInputBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrmInputBox = class(TForm)
    txtInput: TEdit;
    BtnOK: TButton;
    BtnCancel: TButton;
    lblCaption: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Caption, Default, Result:String;
    Execution: Boolean;
  end;

var
  FrmInputBox: TFrmInputBox;

implementation

{$R *.dfm}

procedure TFrmInputBox.BtnCancelClick(Sender: TObject);
begin
  Result := '';
  Execution := false;
  Close;
end;

procedure TFrmInputBox.BtnOKClick(Sender: TObject);
begin
  Result := txtInput.Text;
  Execution := true;
  Close;
end;

procedure TFrmInputBox.FormShow(Sender: TObject);
begin
  lblCaption.Caption := Caption;
  txtInput.Text := Default;
end;

end.
