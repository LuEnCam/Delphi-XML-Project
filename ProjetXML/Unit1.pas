unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.xmldom, Xml.XMLIntf, Xml.omnixmldom,
  Xml.XMLDoc, Vcl.StdCtrls, Data.DB, MemDS, DBAccess, MyAccess,msxml,
  Xml.Win.msxmldom;

type
  TForm1 = class(TForm)
  XMLDocument1: TXMLDocument;
    Button1: TButton;
    MyConnection1: TMyConnection;
    MyQuery1: TMyQuery;
    XMLCreated: TXMLDocument;
    label_connection: TLabel;
    button_connect: TButton;
    edit_username: TEdit;
    edit_password: TEdit;
    label_username: TLabel;
    label_password: TLabel;
    edit_server: TEdit;
    edit_database: TEdit;
    label_server: TLabel;
    label_database: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ReadFromXML(_FileName: String);
    procedure CreateFromXML(_filename:String);
    procedure checkChildNodes(_node: IXMLNode);
    procedure Button1Click(Sender: TObject);
    procedure button_connectClick(Sender: TObject);
    function ValidXML(const xmlFile: String; out err: IXMLDOMParseError): Boolean;
    procedure CreateFromXML2(_filename:String);


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
    // Default connection is local
    MyConnection1.Server := '127.0.0.1';
    MyConnection1.Username := 'root';
    MyConnection1.Database := 'wincontr04';
    MyConnection1.Connect;

    //ReadFromXML('C:\Users\Luca\Documents\GitHub\Delphi-XML-Project\ProjetXML\41101000000215139_QR-IBAN.xml');
    edit_server.Enabled := false;
    edit_database.Enabled := false;
    edit_username.Enabled := false;
    edit_password.Enabled := false;
    button_connect.Enabled := false;
  except
    showmessage('Unable to connect do database.'+#13#10+'Please try to connect mannually');
    label_connection.Caption := 'Unable to connect...';
  end;
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
  MyQuery1.SQL.Clear;
  MyQuery1.SQL.Add('SELECT * FROM wincontr04.sqladres');
  MyQuery1.Execute;

  MyQuery1.First;

  CreateFromXML('.\XMLCreated.xml');
  //CreateFromXML2('.\XMLCreated2.xml');
  //ShowMessage(MyQuery1.FieldByName('cfadcode').asstring);
  ShowMessage(XMLCreated.XML.Text);
end;

procedure TForm1.button_connectClick(Sender: TObject);
begin

  if not MyConnection1.Connected then
  begin
    MyConnection1.Server := Trim(edit_server.Text);
    MyConnection1.Database := trim(edit_database.Text);
    MyConnection1.Username := Trim(edit_username.Text);
    MyConnection1.Password := trim(edit_password.Text);
    try
      MyConnection1.Connect;
      showmessage('Connected !');
      edit_server.Clear;
      edit_database.Clear;
      edit_username.Clear;
      edit_password.Clear;
      edit_server.Enabled := false;
      edit_database.Enabled := false;
      edit_username.Enabled := false;
      edit_password.Enabled := false;
      button_connect.Enabled := false;
      label_connection.Caption := 'Connected to '+MyConnection1.Server+' - '+MyConnection1.Database+' ';
    except
      showmessage('Unable to connect.');
    end;

  end;

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
const
  CIndentation = '      ';
var
  nodeToAdd : IXMLNode;
  Leaf : IXMLNode;
  temp : IXMLDocument;
  stream : TStream;

  Vpn_ii : integer;

begin

  stream := TStream.Create();
  XMLCreated.Active := true;
  XMLCreated.FileName := _filename;

  nodeToAdd := XMLCreated.CreateNode('Data');

  Leaf := nodeToAdd.AddChild('Codes','');
  Vpn_ii := 0;

  while not MYQuery1.Eof do
  begin
    //Leaf.AddChild('Code_'+inttostr(Vpn_ii)+'',Vpn_ii);
    Leaf.AddChild('Code_'+inttostr(Vpn_ii));
    Leaf.ChildNodes.FindNode('Code_'+inttostr(Vpn_ii)).AddChild('Test').Text := MyQuery1.FieldByName('cfadcode').asstring;
    //nodeToAdd.ChildNodes.Add(Leaf);
    inc(VPn_ii);
    MyQuery1.Next;
  end;

  //nodeToAdd.ChildNodes.Add(Leaf);

  XMLCreated.AddChild('Test');
  XMLCreated.ChildNodes.FindNode('Test').ChildNodes.Add(nodeToAdd);
  //XMLCreated.ChildNodes.Last.ChildNodes.Add(Leaf);

  //Formattage de XML avec indentation correcte:
  temp := TXMLDocument.Create(nil);
  temp.LoadFromXML(XMLCreated.XML.Text);
  temp.XML.Text:=Xml.XMLDoc.FormatXMLData(temp.XML.Text);
  temp.Active := true;
  temp.SaveToFile(_filename);

end;


//source from https://stackoverflow.com/questions/446635/schema-validation-with-msxml-in-delphi
function TForm1.ValidXML(const xmlFile: String; out err: IXMLDOMParseError): Boolean;
var
  xml, xsd: IXMLDOMDocument2;
  cache: IXMLDOMSchemaCollection;
begin
  xsd := CoDOMDocument40.Create;
  xsd.Async := False;
  xsd.load('http://the.uri.com/schemalocation/schema.xsd');

  cache := CoXMLSchemaCache40.Create;
  cache.add('http://the.uri.com/schemalocation', xsd);

  xml := CoDOMDocument40.Create;
  xml.async := False;
  xml.schemas := cache;

  Result := xml.load(xmlFile);
  if not Result then
  begin
    err := xml.parseError
  end else
  begin
    err := nil;
  end;

end;

procedure TForm1.CreateFromXML2(_filename:String);
var
  LDocument: IXMLDocument;
  LNodeElement, NodeCData, NodeText: IXMLNode;
  temp : IXMLDocument;
begin
  LDocument := TXMLDocument.Create(nil);
  LDocument.Active := True;

  { Define document content. }
  LDocument.DocumentElement := LDocument.CreateNode('ThisIsTheDocumentElement', ntElement, '');
  LDocument.DocumentElement.Attributes['attrName'] := 'attrValue';
  LNodeElement := LDocument.DocumentElement.AddChild('ThisElementHasText', -1);
  LNodeElement.Text := 'Inner text.';
  NodeCData := LDocument.CreateNode('any characters here', ntCData, '');
  LDocument.DocumentElement.ChildNodes.Add(NodeCData);
  NodeText := LDocument.CreateNode('This is a text node.', ntText, '');
  LDocument.DocumentElement.ChildNodes.Add(NodeText);

  //Formattage de XML avec indentation correcte:
  temp := TXMLDocument.Create(nil);
  temp.LoadFromXML(LDocument.XML.Text);
  temp.XML.Text:=Xml.XMLDoc.FormatXMLData(temp.XML.Text);
  temp.Active := true;
  temp.SaveToFile(_filename);
end;

end.


