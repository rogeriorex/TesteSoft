unit uTesteSoftplanQ1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, System.JSON, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc;

type
  TfrmTesteSoftplanQ1 = class(TForm)
    lblArquivo: TLabel;
    edtArquivo: TEdit;
    btnProcessar: TButton;
    grdDados: TDBGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    ClientDataSetCodigo: TIntegerField;
    ClientDataSetNome: TStringField;
    ClientDataSetCidade: TStringField;
    OpenDialog: TOpenDialog;
    XMLDocument: TXMLDocument;
    procedure btnProcessarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  {Interface que será comum a todos os objetos da cadeia}
  IImportarDados = interface
    procedure ConfigurarProximo(const AImportador: IImportarDados = nil);//Referência do próximo objeto do Chain of Responsability
    procedure Inserir(const ADados: string; ADataSet: TClientDataSet);   //Método para persistência
  end;

  TImportarCSV = class(TInterfacedObject, IImportarDados)
  private
    ProximoImportador: IImportarDados;                                   //Atributo que armazena informação do próximo objeto do Chain of Responsability
    procedure ConfigurarProximo(const AImportador: IImportarDados = nil);//Referência do próximo objeto do Chain of Responsability
    procedure Inserir(const ADados: string; ADataSet: TClientDataSet);   //Método para persistência
  public
  end;

  TImportarXML = class(TInterfacedObject, IImportarDados)
  private
    ProximoImportador: IImportarDados;                                    //Atributo que armazena informação do próximo objeto do Chain of Responsability
    procedure ConfigurarProximo(const AImportador: IImportarDados = nil); //Referência do próximo objeto do Chain of Responsability
    procedure Inserir(const ADados: string; ADataSet: TClientDataSet);    //Método para persistência
  public
  end;

  TImportarJSON = class(TInterfacedObject, IImportarDados)
  private
    ProximoImportador: IImportarDados;                                    //Atributo que armazena informação do próximo objeto do Chain of Responsability
    procedure ConfigurarProximo(const AImportador: IImportarDados = nil); //Referência do próximo objeto do Chain of Responsability
    procedure Inserir(const ADados: string; ADataSet: TClientDataSet);    //Método para persistência
  public
  end;

var
  frmTesteSoftplanQ1: TfrmTesteSoftplanQ1;

implementation

{$R *.dfm}

{ TImportarCSV }

procedure TImportarCSV.Inserir(const ADados: string;
  ADataSet: TClientDataSet);
var
  I: integer;
  slDados: TStringList;
  slLinha: TStringList;
begin
{verificando se o arquivo é do tipo esperado e passando para o próximo na cadeia, se necessário}
  if LowerCase(ExtractFileExt(ADados)) <> '.csv' then                     //Como o objetivo era testar o conhecimento em Chains of Responsability,
  begin                                                                   //não foi pensado em separar esse código, ficou repetido nas 3 procedures Inserir,
    if Assigned(ProximoImportador) then                                   //mudando apenas a extensão do arquivo, nem tratei por conteúdo, somente
      ProximoImportador.Inserir(ADados, ADataSet)                         //importei checando a extensão
    else
      MessageDlg('O arquivo ' + QuotedStr(ADados) + ', não tem uma extensão aceitavel para importação.'#13'Os arquivos válidos são CSV, XML, JSON',
        mtError, [mbOK],0);
    Exit;
  end;

  slDados := TStringList.Create;
  slLinha := TStringList.Create;

{processo de gravação de dados}
  try
    slDados.LoadFromFile(ADados);
    try
      for I := 0 to Pred(slDados.Count) do
      begin
        slLinha.Clear;
        ExtractStrings([','], [' '], PChar(slDados[I]), slLinha);         //Separando os dados para incluir na tabela,
        ADataSet.Append;                                                  //levando-se em consideração o arquivo modelo, dado pela SoftPlan,
        ADataSet.FieldByName('Codigo').AsString := slLinha[0];            //não será testado ponto e vírguta (;) e tabulação (Tab)
        ADataSet.FieldByName('Nome').AsString := slLinha[1];
        ADataSet.FieldByName('Cidade').AsString := slLinha[2];
        ADataSet.Post;
      end;
    except
      on e: EStringListError do                                           //caso haja erro no conteúdo do arquivo
        MessageDlg('Processo interrompido. Erro na linha ' + IntToStr(Succ(I)) +', no conteúdo do arquivo ' + QuotedStr(ADados), mtError, [mbOK], 0);
      on e: Exception do
        MessageDlg('Processo interrompido. O programa não pode importar o arquivo selecionado.', mtError, [mbOK], 0);
    end;
  finally
    FreeAndNil(slLinha);
    FreeAndNil(slDados);
  end;
end;

procedure TImportarCSV.ConfigurarProximo(const AImportador: IImportarDados = nil);
begin
  ProximoImportador := AImportador;
end;

{ TImportarXML }

procedure TImportarXML.Inserir(const ADados: string;
  ADataSet: TClientDataSet);
var
  I: Integer;
  XMLDocument: IXMLDocument; //utilizando IXMLDocument, IXMLNode não precisa destruir com FreeAndNil, pois o programa gerencia o uso dele na memória
  XMLNode: IXMLNode;         //como só existe um nó (dados) para a inclusão na tabela, não há necessidade de nomeá-lo com maior precisão
begin
{verificando se o arquivo é do tipo esperado e passando para o próximo na cadeia, se necessário}
  if LowerCase(ExtractFileExt(ADados)) <> '.xml' then                     //Como o objetivo era testar o conhecimento em Chains of Responsability,
  begin                                                                   //não foi pensado em separar esse código, ficou repetido nas 3 procedures Inserir,
    if Assigned(ProximoImportador) then                                   //mudando apenas a extensão do arquivo, nem tratei por conteúdo, somente
      ProximoImportador.Inserir(ADados, ADataSet)                         //importei checando a extensão
    else
      MessageDlg('O arquivo ' + QuotedStr(ADados) + ', não tem uma extensão aceitável para importação.'#13'Os arquivos válidos são CSV, XML, JSON',
        mtError, [mbOK],0);
    Exit;
  end;

{processo de gravação de dados}
  try

    XMLDocument := LoadXMLDocument(ADados);
    XMLDocument.Encoding := 'ISO-8859-1';                                 //abaixo o uso de ISO-8859-1 garante a acentuação corrente do arquivo
    XMLDocument.Active := True;

    for I := 0 to Pred(XMLDocument.DocumentElement.ChildNodes.Count) do   //Considerando que só existe um nó antes do nó dados, não houve necessidade de criar
    begin                                                                 //um XMLNode para o mesmo
      XMLNode := XMLDocument.DocumentElement.ChildNodes[I];
      ADataSet.Append;
      ADataSet.FieldByName('Codigo').AsString := XMLNode.ChildNodes['codigo'].Text;
      ADataSet.FieldByName('Nome').AsString := XMLNode.ChildNodes['nome'].Text;
      ADataSet.FieldByName('Cidade').AsString := XMLNode.ChildNodes['cidade'].Text;
      ADataSet.Post;
    end;
  except
    on e: EDOMParseError do                                               //Caso haja erro no conteúdo do arquivo
      MessageDlg('Processo interrompido. Caracteres inválidos encontrados no arquivo ' + QuotedStr(ADados), mtError, [mbOK], 0);
    on e: EXMLDocError do
      MessageDlg('Processo interrompido. Erro encontrado na estrutura arquivo ' + QuotedStr(ADados), mtError, [mbOK], 0);
    on e: Exception do
      MessageDlg('Processo interrompido. O programa não pode importar o arquivo selecionado.', mtError, [mbOK], 0);
  end;
end;

procedure TImportarXML.ConfigurarProximo(const AImportador: IImportarDados = nil);
begin
  ProximoImportador := AImportador;
end;

{ TImportarJSON }

procedure TImportarJSON.Inserir(const ADados: string;
  ADataSet: TClientDataSet);
var
  I: integer;
  JSONObject: TJSONObject;
  JSONArray: TJSONArray;
  slDados: TStringList;
begin
{verificando se o arquivo é do tipo esperado e passando para o próximo na cadeia, se necessário}
  if LowerCase(ExtractFileExt(ADados)) <> '.json' then                    //Como o objetivo era testar o conhecimento em Chains of Responsability
  begin                                                                   //Não foi pensado esse código ficou repetido nas 3 procedures Inserir
    if Assigned(ProximoImportador) then                                   //Mudando apenas a extensão do arquivo, nem tratar por conteúdo, somente por extensão
      ProximoImportador.Inserir(ADados, ADataSet)
    else
      MessageDlg('O arquivo ' + QuotedStr(ADados) + ', não tem uma extensão aceitavel para importação.'#13'Os arquivos válidos são CSV, XML, JSON',
        mtError, [mbOK],0);
    Exit;
  end;

  slDados := TStringList.Create;

{processo de gravação de dados}
  try
    try

      slDados.LoadFromFile(ADados);
                                                                          //abaixo o uso de TEncoding.ANSI garante a acentuação corrente do arquivo
      JSONObject := TJSONObject.ParseJSONValue(TEncoding.ANSI.GetBytes(slDados.Text),0) as TJSONObject;

      JSONArray := JSONObject.GetValue('dados') as TJSONArray;

      for I := 0 to Pred(JSONArray.Count) do
      begin
        JSONObject := JSONArray.Items[I] as TJSONObject;
        ADataSet.Append;
        ADataSet.FieldByName('Codigo').AsString := JSONObject.Pairs[0].JsonValue.ToString;
        ADataSet.FieldByName('Nome').AsString := JSONObject.Pairs[1].JsonValue.Value;
        ADataSet.FieldByName('Cidade').AsString := JSONObject.Pairs[2].JsonValue.Value;
        ADataSet.Post;
      end;
    except
      on e: EAccessViolation do                                           //caso haja erro no conteúdo do arquivo
        MessageDlg('Processo interrompido. Erro na estrutura do arquivo ou conteúdo de seus dados', mtError, [mbOK], 0);
      on e: Exception do
        MessageDlg('Processo interrompido. O programa não pode importar o arquivo selecionado.', mtError, [mbOK], 0);
    end;

  finally
    FreeAndNil(slDados);
  end;
end;

procedure TImportarJSON.ConfigurarProximo(const AImportador: IImportarDados = nil);
begin
  ProximoImportador := AImportador;
end;

procedure TfrmTesteSoftplanQ1.btnProcessarClick(Sender: TObject);
var
  ImportarCSV: IImportarDados;                                            //Criação dos objetos, mas pela interface
  ImportarXML: IImportarDados;
  ImportarJSON: IImportarDados;
begin
  if not OpenDialog.Execute then
    Exit;

  ClientDataSet.EmptyDataSet;
{construindo e configurando os objetos}
  ImportarJSON := TImportarJSON.Create;                                   //ImportarJSON não precisa informar o próximo, pois o padrão é nil

  ImportarXML := TImportarXML.Create;
  ImportarXML.ConfigurarProximo(ImportarJSON);

  ImportarCSV := TImportarCSV.Create;
  ImportarCSV.ConfigurarProximo(ImportarXML);

  ImportarCSV.Inserir(OpenDialog.FileName, ClientDataSet);                //iniciando processo
end;

end.

