object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'XML Project'
  ClientHeight = 269
  ClientWidth = 567
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
  object label_connection: TLabel
    Left = 32
    Top = 16
    Width = 147
    Height = 21
    Caption = 'label_connection'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object label_username: TLabel
    Left = 21
    Top = 115
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object label_password: TLabel
    Left = 21
    Top = 142
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object label_server: TLabel
    Left = 21
    Top = 57
    Width = 32
    Height = 13
    Caption = 'Server'
  end
  object label_database: TLabel
    Left = 21
    Top = 84
    Width = 46
    Height = 13
    Caption = 'Database'
  end
  object Button1: TButton
    Left = 21
    Top = 216
    Width = 516
    Height = 25
    Caption = 'Execute XML'
    TabOrder = 4
    OnClick = Button1Click
  end
  object button_connect: TButton
    Left = 229
    Top = 137
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 5
    OnClick = button_connectClick
  end
  object edit_username: TEdit
    Left = 75
    Top = 112
    Width = 148
    Height = 21
    TabOrder = 2
    Text = 'root'
  end
  object edit_password: TEdit
    Left = 75
    Top = 139
    Width = 148
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object edit_server: TEdit
    Left = 75
    Top = 54
    Width = 148
    Height = 21
    TabOrder = 0
    Text = '192.168.0.13'
  end
  object edit_database: TEdit
    Left = 75
    Top = 81
    Width = 148
    Height = 21
    TabOrder = 1
    Text = 'wincontr04'
  end
  object XMLDocument1: TXMLDocument
    FileName = 'C:\Users\Luca\Desktop\ProjetXML\41101000000215139_QR-IBAN.xml'
    Options = [doNodeAutoCreate, doNodeAutoIndent, doAttrNull, doAutoPrefix, doNamespaceDecl]
    Left = 344
    Top = 104
    DOMVendorDesc = 'MSXML'
  end
  object MyConnection1: TMyConnection
    Left = 432
    Top = 80
  end
  object MyQuery1: TMyQuery
    Connection = MyConnection1
    Left = 360
    Top = 32
  end
  object XMLCreated: TXMLDocument
    Left = 512
    Top = 96
    DOMVendorDesc = 'Omni XML'
  end
end
