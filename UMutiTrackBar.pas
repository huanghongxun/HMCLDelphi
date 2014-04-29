unit UMutiTrackBar;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.ComCtrls, WinApi.Messages;

type
  TMutiTrackBar = class(TTrackBar)
  private
    MouseUp: TNotifyEvent;
    { Private declarations }
    procedure MouseUpProc(var mes:TWMLBUTTONUP); message WM_LBUTTONUP;

  protected
    { Protected declarations }
  public
    { Public declarations }

  published
    { Published declarations }
    property OnMouseUp:TNotifyEvent read mouseup write mouseup;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Standard', [TMutiTrackBar]);
end;

procedure TMutiTrackBar.MouseUpProc(var mes:TWMLBUTTONUP);
begin
  inherited;
  if(assigned(mouseup))then
    OnMouseUp(Self);
end;

end.
