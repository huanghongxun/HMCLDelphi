unit UFrmNews;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw;

type
  TFrmNews = class(TForm)
    wbMain: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmNews: TFrmNews;

implementation

{$R *.dfm}

procedure TFrmNews.FormCreate(Sender: TObject);
begin
  wbMain.Navigate('http://mcupdate.tumblr.com');
  wbMain.Silent := true;
end;

procedure TFrmNews.FormResize(Sender: TObject);
begin
  wbMain.Width := self.ClientWidth;
  wbMain.Height := self.ClientHeight;
end;

end.
