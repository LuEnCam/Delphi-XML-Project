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
    XMLCreated: TXMLDocument;
    procedure FormCreate(Sender: TObject);
    procedure ReadFromXML(_FileName: String);
    procedure CreateFromXML(_filename:String);
    procedure checkChildNodes(_node: IXMLNode);
    procedure Button1Click(Sender: TObject);
    procedure MyConnection1BeforeConnect(Sender: TObject);


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
  try
    MyConnection1.Connect;
    //ReadFromXML('C:\Users\Luca\Documents\GitHub\Delphi-XML-Project\ProjetXML\41101000000215139_QR-IBAN.xml');

  except
    showmessage('Unable to connect do database.');
  end;

  MyQuery1.SQL.Clear;
  MyQuery1.SQL.Add('SELECT * FROM wincontr04.sqladres');
  MyQuery1.Execute;

  MyQuery1.First;

  CreateFromXML('.\XMLCreated.xml');
  //ShowMessage(MyQuery1.FieldByName('cfadcode').asstring);
  ShowMessage(XMLCreated.XML.Text);


end;

procedure TForm1.MyConnection1BeforeConnect(Sender: TObject);
begin
  MyConnection1.Server := '127.0.0.1';
  MyConnection1.Username := 'root';
  MyConnection1.Database := 'wincontr04';
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

procedure TForm1.CreateFromXML(_filename:String);
var
  nodeToAdd : IXMLNode;
  Leaf : IXMLNode;
begin
  XMLCreated.Active := true;
  XMLCreated.FileName := _filename;

  nodeToAdd := XMLCreated.CreateNode('Data',ntElement);
  Leaf := XMLCreated.CreateElement('Code','');
  Leaf.NodeValue := MyQuery1.FieldByName('cfadcode').AsString;

  nodeToAdd.ChildNodes.Add(Leaf);

  XMLCreated.AddChild('Test');
  XMLCreated.ChildNodes.FindNode('Test').ChildNodes.Add(nodeToAdd);
  //XMLCreated.ChildNodes.Last.ChildNodes.Add(Leaf);

  XMLCreated.SaveToFile();
end;

end.


