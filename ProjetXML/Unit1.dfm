object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'XML Project'
  ClientHeight = 488
  ClientWidth = 595
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 288
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object XMLDocument1: TXMLDocument
    FileName = 'C:\Users\Luca\Desktop\ProjetXML\41101000000215139_QR-IBAN.xml'
    Left = 72
    Top = 24
    DOMVendorDesc = 'Omni XML'
  end
  object MyConnection1: TMyConnection
    BeforeConnect = MyConnection1BeforeConnect
    Left = 432
    Top = 24
  end
  object MyQuery1: TMyQuery
    Connection = MyConnection1
    Left = 168
    Top = 32
  end
  object XMLCreated: TXMLDocument
    Left = 528
    Top = 24
    DOMVendorDesc = 'Omni XML'
  end
end
