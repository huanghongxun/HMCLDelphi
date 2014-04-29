object Form1: TForm1
  Left = 251
  Top = 274
  Caption = #19979#36733#25991#20214#65292#26029#28857#32493#20256
  ClientHeight = 383
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 12
    Top = 40
    Width = 60
    Height = 12
    Caption = #25991#20214#22320#22336#65306
  end
  object Label2: TLabel
    Left = 12
    Top = 136
    Width = 101
    Height = 13
    AutoSize = False
    Caption = #36830#25509#29366#24577
  end
  object Label3: TLabel
    Left = 260
    Top = 164
    Width = 54
    Height = 12
    Caption = #25991#20214#22823#23567':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Lab_Size: TLabel
    Left = 320
    Top = 164
    Width = 133
    Height = 12
    AutoSize = False
    Caption = '0KB'
  end
  object Label5: TLabel
    Left = 260
    Top = 196
    Width = 42
    Height = 12
    Caption = #24050#19979#36733':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Lab_CurNum: TLabel
    Left = 320
    Top = 196
    Width = 133
    Height = 12
    AutoSize = False
    Caption = '0KB'
  end
  object Lab_Over: TLabel
    Left = 260
    Top = 232
    Width = 64
    Height = 15
    Caption = #19979#36733#23436#27605
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edit_Url: TEdit
    Left = 80
    Top = 36
    Width = 393
    Height = 20
    TabOrder = 0
    Text = 'http://hb.onlinedown.net/down/Thunder5.9.18.1364.zip'
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 366
    Width = 497
    Height = 17
    Align = alBottom
    TabOrder = 1
  end
  object Btn_Start: TButton
    Left = 148
    Top = 96
    Width = 75
    Height = 25
    Caption = #19979#36733
    TabOrder = 2
    OnClick = Btn_StartClick
  end
  object Btn_Stop: TButton
    Left = 252
    Top = 96
    Width = 75
    Height = 25
    Caption = #20572#27490
    Enabled = False
    TabOrder = 3
    OnClick = Btn_StopClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 152
    Width = 233
    Height = 213
    ItemHeight = 12
    TabOrder = 4
  end
  object IdHTTP1: TIdHTTP
    OnStatus = IdHTTP1Status
    OnWorkBegin = IdHTTP1WorkBegin
    OnWorkEnd = IdHTTP1WorkEnd
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeInstanceLength = -1
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 16
    Top = 72
  end
  object IdAntiFreeze1: TIdAntiFreeze
    OnlyWhenIdle = False
    Left = 80
    Top = 72
  end
  object XPManifest1: TXPManifest
    Left = 152
    Top = 64
  end
end
