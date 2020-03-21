object frmTesteSoftplanQ1: TfrmTesteSoftplanQ1
  Left = 439
  Top = 165
  Caption = ' Teste Softplan Q1'
  ClientHeight = 417
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object lblArquivo: TLabel
    Left = 16
    Top = 16
    Width = 41
    Height = 13
    Caption = 'Arquivo:'
  end
  object edtArquivo: TEdit
    Left = 16
    Top = 32
    Width = 400
    Height = 21
    TabOrder = 0
    TextHint = '< Clique no bot'#227'o abaixo para selecionar o arquivo >'
  end
  object btnProcessar: TButton
    Left = 132
    Top = 64
    Width = 169
    Height = 25
    Caption = 'Processar Inclus'#227'o'
    TabOrder = 1
    OnClick = btnProcessarClick
  end
  object grdDados: TDBGrid
    Left = 16
    Top = 95
    Width = 400
    Height = 308
    DataSource = DataSource
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Codigo'
        Title.Alignment = taCenter
        Title.Caption = 'C'#243'digo'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Nome'
        Title.Alignment = taCenter
        Width = 153
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Cidade'
        Title.Alignment = taCenter
        Width = 153
        Visible = True
      end>
  end
  object DataSource: TDataSource
    AutoEdit = False
    DataSet = ClientDataSet
    Left = 256
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    PersistDataPacket.Data = {
      5D0000009619E0BD0100000018000000030000000000030000005D0006436F64
      69676F0400010000000000044E6F6D6501004900000001000557494454480200
      0200500006436964616465010049000000010005574944544802000200500000
      00}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 144
    Top = 208
    object ClientDataSetCodigo: TIntegerField
      DisplayWidth = 9
      FieldName = 'Codigo'
    end
    object ClientDataSetNome: TStringField
      DisplayWidth = 19
      FieldName = 'Nome'
      Size = 80
    end
    object ClientDataSetCidade: TStringField
      DisplayWidth = 25
      FieldName = 'Cidade'
      Size = 80
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'CSV, JSON e XML|*.csv;*.json;*.xml|Somente CSV|*.csv|Somente JSO' +
      'N|*.json|Somente XML|*.xml'
    Left = 144
    Top = 144
  end
  object XMLDocument: TXMLDocument
    Left = 256
    Top = 144
  end
end
