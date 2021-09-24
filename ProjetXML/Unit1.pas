unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.xmldom, Xml.XMLIntf, Xml.omnixmldom,
  Xml.XMLDoc, Vcl.StdCtrls, Data.DB, MemDS, DBAccess, MyAccess;

type
  TForm1 = class(TForm)
  XMLDocument1: TXMLDocument;
    Button1: TButton;
    MyConnection1: TMyConnection;
    MyQuery1: TMyQuery;
    procedure FormCreate(Sender: TObject);
    procedure ReadFromXML(_FileName: String);
    procedure checkChildNodes(_node: IXMLNode);
    procedure Button1Click(Sender: TObject);


  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReadFromXML('C:\Users\Luca\Documents\GitHub\Delphi-XML-Project\ProjetXML\41101000000215139_QR-IBAN.xml');
end;

procedure TForm1.ReadFromXML(_FileName: String);
var
  tmp :  IXMLNode;
begin

  XMLDocument1.FileName := _FileName;

  XMLDocument1.Active := true;

  with XMLDocument1.ChildNodes.Nodes['Envelope'].ChildNodes do
  begin
    tmp:=Nodes['Header'];

    while tmp.HasChildNodes do
    begin

      if tmp.ChildNodes.Count <> 0 then checkChildNodes(tmp);

      tmp:=tmp.NextSibling;

    end;
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  showmessage('Hello');
end;

procedure TForm1.checkChildNodes(_node: IXMLNode);
var
  VPn_i : integer;
  VPn_cpt : integer;
begin
  VPn_cpt:=_node.ChildNodes.Count;

  for VPn_i := 0 to VPn_cpt - 1 do
  begin
    try
      ShowMessage(_node.ChildValues[_node.ChildNodes.Get(Vpn_i).NodeName]);
    except
      checkChildNodes(_node.ChildNodes.Get(VPn_i));
      break;
    end;
  end;

end;

end.


