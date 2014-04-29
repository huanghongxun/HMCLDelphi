unit UFrmTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinManager, Vcl.StdCtrls,
  sSkinProvider, acTitleBar;

type
  TForm2 = class(TForm)
    sSkinManager1: TsSkinManager;
    Button1: TButton;
    sSkinProvider1: TsSkinProvider;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
