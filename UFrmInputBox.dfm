object FrmInputBox: TFrmInputBox
  Left = 0
  Top = 0
  Caption = #38190#20837
  ClientHeight = 90
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblCaption: TLabel
    Left = 8
    Top = 8
    Width = 47
    Height = 13
    Caption = 'lblCaption'
  end
  object txtInput: TEdit
    Left = 8
    Top = 32
    Width = 262
    Height = 21
    TabOrder = 0
  end
  object BtnOK: TButton
    Left = 96
    Top = 59
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 195
    Top = 59
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = BtnCancelClick
  end
end
