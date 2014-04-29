unit NewButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Math, ExtCtrls ;

type
  TBtnState =(Leave,Enter,Down,Up);
  TNewButton = class(TGraphicControl)
  private
    FStep:integer;
    FAnimateStep:integer;
    FR,FG,FB,FR1,FG1,FB1,FR2,FG2,FB2:integer;
    FBtnState:TBtnState;
    FGlyph: TBitmap;
    FCaption: String;
    FColor:TColor;
    FShowCaption: Boolean;
    FModalResult: TModalResult;
    FInterval:integer;
    FFont:TFont;
    FTimer:ttimer;
    procedure SetInterval(value:integer);
    procedure SetAnimateStep(Value:integer);
    procedure SetColor(Value:TColor);
    procedure TimerProc(Sender: TObject);
    procedure SetGlyph(Value: TBitMap);
    procedure SetCaption(Value:String);
    procedure Resize(Sender: TObject);
    procedure SetShowCaption(Value:Boolean);
    procedure DrawCaption;
    procedure SetFont(Value:TFont);
    procedure DrawBtn(ACanvas:tcanvas);
  protected
    procedure paint;override;
    procedure MouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
                      X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Glyph:TBitMap read FGlyph write SetGlyph;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property Caption: String read FCaption write SetCaption;
    property ShowCaption:Boolean read FShowCaption write SetShowCaption;
    property Font:TFont read FFont write SetFont;
    property AnimateRate:integer read Finterval write SetInterval;
    property AnimateStep:integer read FAnimateStep write SetAnimateStep;
    property Action;
    property Anchors;
    property Color:TColor read FColor write SetColor;
    property Enabled;
    property Hint;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WDN Soft', [TNewButton]);
end;

procedure TNewButton.DrawBtn(ACanvas:tcanvas);
  var i,j:integer;
  begin
    acanvas.Brush.Style:=bssolid;
    acanvas.Brush.Color:=clwhite;
    acanvas.FillRect(acanvas.ClipRect );
    for i:= 0 to height div 3 do
    begin
      acanvas.Brush.Color:=rgb(fr+(fr1-fr)*i*3 div height,
                               fg+(fg1-fg)*i*3 div height,
                               fb+(fb1-fb)*i*3 div height );
      acanvas.FillRect(rect(0,i,width,i+1));
    end;
    for i:= height div 3 to height do
    begin
      acanvas.Brush.Color:=rgb(fr1+(fr2-fr1)*(i-height div 3)*3 div 2 div height,
                               fg1+(fg2-fg1)*(i-height div 3)*3 div 2 div height,
                               fb1+(fb2-fb1)*(i-height div 3)*3 div 2 div height );
      acanvas.FillRect(rect(0,i,width,i+1));
    end;

end;

constructor TNewButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 32;
  Height := 32;
  finterval:=50;
  fanimatestep:=10;
  fcolor:=clsilver;
  setcolor(fcolor);
  FGlyph:=tbitmap.Create;
  FGlyph.Transparent:=true;
  OnResize:=Resize;
  ftimer:=ttimer.Create(nil);
  ftimer.Interval:=finterval;
  ftimer.OnTimer:=timerproc;
  ftimer.Enabled:=false;

  With Canvas.Font do
  begin
    Charset:=GB2312_CHARSET;
    Color:= clWindowText;
    Height:=-12;
    Name:='����';
    Pitch:=fpDefault;
    Size:=9;
  end;
  FFont:=Canvas.Font;
end;

destructor TNewButton.Destroy;
begin
  ftimer.Enabled:=false;
  ftimer.Free;
  FGlyph.Free;
  inherited Destroy;
end;

procedure TNewButton.TimerProc;
var r1,g1,b1,r2,g2,b2:integer;
begin
  if (fstep>=fanimatestep) and (fbtnstate=enter) then
  begin
    ftimer.Enabled:=false;
    exit;
  end;
  if (fstep<=0 ) and (fbtnstate=leave) then
  begin
    ftimer.Enabled:=false;
    exit;
  end;
  if fbtnstate=enter then
    inc(fstep)
  else if fbtnstate=leave then
    dec(fstep);
  r1:=127+127*fstep div fanimatestep;
  g1:=127+127*fstep div fanimatestep;
  b1:=127+127*fstep div fanimatestep;
  r2:=127-127*fstep div fanimatestep;
  g2:=127-127*fstep div fanimatestep;
  b2:=127-127*fstep div fanimatestep;
  canvas.Pen.Mode:=pmcopy;
  canvas.Pen.Color:=rgb(r1,g1,b1);
  canvas.MoveTo(0,height-1);
  canvas.LineTo(0,0);
  canvas.LineTo(width-1,0);
  canvas.LineTo(width-2,1);
  canvas.LineTo(1,1);
  canvas.LineTo(1,height-2);
  canvas.Pen.Color:=rgb(r2,g2,b2);
  canvas.MoveTo(3,height-2);
  canvas.LineTo(width-2,height-2);
  canvas.LineTo(width-2,2);
  canvas.LineTo(width-1,1);
  canvas.LineTo(width-1,height-1);
  canvas.LineTo(0,height-1);

end;

procedure TNewButton.paint;
const
  XorColor = $00FFD8CE;
var x,y:integer;
    r:trect;
    bmp:tbitmap;
begin
  r.Left:= (width-fglyph.Width) div 2;
  r.Top:=  (height-fglyph.Height)div 2;
  r.Right:=r.Left +fglyph.Width;
  r.Bottom:=r.Top +fglyph.Height;
  with Canvas do
  begin
    if not fglyph.Empty then
    begin
      x:=(width-fglyph.Width ) div 2;
      y:=(height-fglyph.Height ) div 2;
    end;

    if not Enabled then
    begin
      canvas.Brush.Color:=fcolor;
      canvas.FillRect(canvas.ClipRect);
      bmp:=tbitmap.Create;
      bmp.Transparent:=true;
      bmp.Width:=fglyph.Width;
      bmp.Height:=fglyph.Height;
      bmp.canvas.CopyMode:= cmnotsrccopy;
      bmp.Canvas.CopyRect(bmp.Canvas.ClipRect,fglyph.Canvas,fglyph.Canvas.ClipRect );
      if not fglyph.Empty then
        canvas.Draw(r.Left,r.Top,bmp);
      bmp.Free;
    end
    else
      case fbtnstate of
      enter:begin
              drawbtn(canvas);
              fglyph.Transparent:=true;
              canvas.Draw(r.Left,r.Top,fglyph);
              canvas.Brush.Color:=rgb(127,127,127);
              canvas.FrameRect(canvas.ClipRect );
              with canvas.ClipRect do
                 canvas.FrameRect(rect(left+1,top+1,right-1,bottom-1));
            end;
      leave:begin
              drawbtn(canvas);
              fglyph.Transparent:=true;
              canvas.Draw(r.Left,r.Top,fglyph);
              canvas.Brush.Color:=rgb(127,127,127);
              canvas.FrameRect(canvas.ClipRect );
              with canvas.ClipRect do
                 canvas.FrameRect(rect(left+1,top+1,right-1,bottom-1));
            end;
      down: begin
              drawbtn(canvas);
              fglyph.Transparent:=true;
              canvas.Draw(r.Left+1,r.Top+1,fglyph);
              canvas.Pen.Color:=clblack;
              canvas.Pen.Mode:=pmcopy;
              canvas.MoveTo(0,height-1);
              canvas.LineTo(0,0);
              canvas.LineTo(width-1,0);
              canvas.LineTo(width-2,1);
              canvas.LineTo(1,1);
              canvas.LineTo(1,height-2);
              canvas.Pen.Color:=clwhite;
              canvas.MoveTo(3,height-2);
              canvas.LineTo(width-2,height-2);
              canvas.LineTo(width-2,2);
              canvas.LineTo(width-1,1);
              canvas.LineTo(width-1,height-1);
              canvas.LineTo(0,height-1);

            end;
      up:   begin
              drawbtn(canvas);
              fglyph.Transparent:=true;
              canvas.Draw(r.Left,r.Top,fglyph);
              canvas.Pen.Color:=clwhite;
              canvas.Pen.Mode:=pmcopy;
              canvas.MoveTo(0,height-1);
              canvas.LineTo(0,0);
              canvas.LineTo(width-1,0);
              canvas.LineTo(width-2,1);
              canvas.LineTo(1,1);
              canvas.LineTo(1,height-2);
              canvas.Pen.Color:=clblack;
              canvas.MoveTo(3,height-2);
              canvas.LineTo(width-2,height-2);
              canvas.LineTo(width-2,2);
              canvas.LineTo(width-1,1);
              canvas.LineTo(width-1,height-1);
              canvas.LineTo(0,height-1);
            end;
      end;

    DrawCaption;
  end;
end;

procedure TNewButton.SetColor(Value:TColor);
begin
  fcolor:=value;
    fr:= getrvalue(colortorgb(value) );
    fg:= getgvalue(colortorgb(value) );
    fb:= getbvalue(colortorgb(value) );
    fr1:= fr+(255-fr)*2 div 3 ;
    fg1:= fg+(255-fg)*2 div 3 ;
    fb1:= fb+(255-fb)*2 div 3 ;
    fr2:= fr div 2;
    fg2:= fg div 2;
    fb2:= fb div 2;
  invalidate;
end;

procedure TNewButton.SetAnimateStep(Value:integer);
begin
  if fanimatestep<>value then
  begin
    fanimatestep:=value;

  end;
end;

procedure TNewButton.SetGlyph(Value:TBitMap);
begin
  FGlyph.Assign(Value);
  Invalidate;
end;

procedure TNewButton.SetInterval(Value:integer);
begin
  FInterval:=value;
  ftimer.Interval:=value;
end;

procedure TNewButton.SetCaption(Value:String);
begin
  FCaption:=Value;
  Invalidate;
end;

procedure TNewButton.SetShowCaption(Value:Boolean);
begin
  FShowCaption:=Value;
  Invalidate;
end;

procedure TNewButton.SetFont(Value:TFont);
begin
  FFont:=Value;
  Canvas.Font:=Value;
  Invalidate;
end;

procedure TNewButton.Resize(Sender:TObject);
begin
  Invalidate;
end;

procedure TNewButton.DrawCaption;
var
  x,y:integer;
begin
  if FShowCaption then
  begin
    if fbtnstate =down then
    with Canvas do
    begin
      Brush.Style := bsClear;
      x:=Round((Width-TextWidth(Caption))/2);
      y:=Round((Height-TextHeight(Caption))/2);
      TextOut(x+1,y+1,Caption);
    end
    else
    with Canvas do
    begin
      Brush.Style := bsClear;
      x:=Round((Width-TextWidth(Caption))/2);
      y:=Round((Height-TextHeight(Caption))/2);
      TextOut(x,y,Caption);
    end;
  end;
end;

procedure TNewButton.MouseEnter(var Msg:TMessage);
begin
  if Enabled then
  begin
    fbtnstate:=enter;
    ftimer.Enabled:=true;
    //invalidate;
  end;
end;

procedure TNewButton.MouseLeave(var Msg:TMessage);
begin
  if Enabled then
  begin
    fbtnstate:=leave;
    ftimer.Enabled:=true;
    //Invalidate;
  end;
end;

procedure TNewButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
                               X, Y: Integer);
begin
  if Enabled and ( button = mbLeft) then
  begin
    fbtnstate:=down;
    ftimer.Enabled:=false;
    paint;
    //invalidate;
  end;
  inherited;
end;

procedure TNewButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                             X, Y: Integer);
begin
  if Enabled and ( button = mbLeft) then
  begin
    fbtnstate:= up;
    ftimer.Enabled:=false;
    paint;
    //invalidate;
  end;
  inherited;
end;

end.
