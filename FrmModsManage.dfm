object FrmModManager: TFrmModManager
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Mod'#31649#29702
  ClientHeight = 309
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sWebLabel1: TsWebLabel
    Left = 8
    Top = 288
    Width = 194
    Height = 13
    Caption = '>> Minecraft Forge '#23448#26041#32593#31449#19979#36733#22320#22336
    OnClick = sWebLabel1Click
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    HoverFont.Charset = DEFAULT_CHARSET
    HoverFont.Color = clWindowText
    HoverFont.Height = -11
    HoverFont.Name = 'Tahoma'
    HoverFont.Style = []
  end
  object sWebLabel2: TsWebLabel
    Left = 247
    Top = 288
    Width = 99
    Height = 13
    Caption = '>> MCBBS Mod'#26495#22359
    OnClick = sWebLabel2Click
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    HoverFont.Charset = DEFAULT_CHARSET
    HoverFont.Color = clWindowText
    HoverFont.Height = -11
    HoverFont.Name = 'Tahoma'
    HoverFont.Style = []
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 433
    Height = 274
    TabOrder = 0
  end
end
