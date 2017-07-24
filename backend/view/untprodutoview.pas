unit untProdutoView;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, HTTPDefs, fphttp, fpWeb, fpTemplate,
    //globais do sistema
    globals;

type

	{ TprodutoView }

  TprodutoView = class( TFPTemplate )
    	private
          //
        public
          //
          procedure tagReplace(Sender:TObject; const TagString:String;
            TagParams: TStringList; Out ReplaceText:String);

          function exibir() : string;

          function botoes() : string;

          function lista( arrLista : TStringMatrix ) : string;

          constructor Create;
	end;


implementation

{ TtestView }

procedure TprodutoView.tagReplace(Sender: TObject; const TagString: String;
	TagParams: TStringList; out ReplaceText: String);
var
	dia, mes, ano: word;
begin
    //substituições padrão
	if AnsiCompareText(TagString, 'titulo') = 0 then
    begin
      ReplaceText := 'Produtos';
	end;

    if AnsiCompareText(TagString, 'lista') = 0 then
    begin
      ReplaceText := '';//lista();
	end;

    if AnsiCompareText(TagString, 'botoes') = 0 then
    begin
      ReplaceText := botoes();
	end;

    //substituição de conteúdo
    if AnsiCompareText(TagString, 'conteudo') = 0 then
    begin
      self.FileName := FORMPATH + 'frmProduto.html';
      ReplaceText := self.GetContent;
	end;

end;

function TprodutoView.exibir: string;
begin
	Result := self.GetContent;
end;

function TprodutoView.botoes: string;
var
    strBotoes : String;
begin
	strBotoes:= '<button id="btnNovo" type="button" class="btn btn-primary" onclick="frmProduto.novo();">Novo</button>';
    strBotoes:= strBotoes + '<button id="btnAlterar" type="button" class="btn btn-warning" onclick="frmProduto.salvar();">Salvar</button>';
    strBotoes:= strBotoes + '<button id="btnExcluir" type="button" class="btn btn-danger" onclick="frmProduto.Delete();">Excluir</button>';
    strBotoes:= strBotoes + '<button id="btnRelatorio" type="button" class="btn btn-info" onclick="frmProduto.relatorio();">Relatório</button>';

    Result := strBotoes;
end;

function TprodutoView.lista( arrLista : TStringMatrix ): string;
var
	strAux : String;
    i: integer;
begin
    strAux := '<table>';
	strAux := strAux + '	<thead>';
	strAux := strAux + '		<tr>';
	strAux := strAux + '			<th width="200">Nome</th>';
	strAux := strAux + '	        <th>Tipo</th>';
	strAux := strAux + '	        <th>Marca</th>';
	strAux := strAux + '	        <th>Qtd.</th>';
    strAux := strAux + '	        <th>Preco</th>';
    strAux := strAux + '	        <th colspan="2">Ações</th>';
	strAux := strAux + '		</tr>';
	strAux := strAux + '	</thead>';
    strAux := strAux + '	<tbody>';

    //cria itens
    for i:=0 to Length( arrLista )-1 do
    begin
        strAux := strAux + '<tr>';
		strAux := strAux + '	<td>'+ arrLista[i,1] +'</td>';
        strAux := strAux + '	<td>'+ arrLista[i,2] +'</td>';
        strAux := strAux + '	<td>'+ arrLista[i,3] +'</td>';
        strAux := strAux + '	<td>'+ arrLista[i,4] +'</td>';
        strAux := strAux + '	<td>'+ arrLista[i,5] +'</td>';
        strAux := strAux + '	<td>';
        strAux := strAux + '		<button class="btn btn-default" type="button" onclick="frmProduto.selecionar('+ arrLista[i,0] +');">';
		strAux := strAux + '			<span class="glyphicon glyphicon-edit"></span>';
		strAux := strAux + '		</button>';
        strAux := strAux + '	</td>';
        strAux := strAux + '	<td>';
        strAux := strAux + '		<button class="btn btn-default" type="button" onclick="frmProduto.Delete('+ arrLista[i,0] +');">';
		strAux := strAux + '			<span class="glyphicon glyphicon-trash"></span>';
		strAux := strAux + '		</button>';
		strAux := strAux + '	<td>';
        strAux := strAux + '</tr>';
    end;

    //finaliza GRID/tabela
    strAux := strAux + '	</tbody>';
	strAux := strAux + '</table>';

    Result:= strAux;

end;

constructor TprodutoView.Create;
begin
	self.AllowTagParams := true;

    self.StartDelimiter := '<%';
    self.EndDelimiter := '%>';
    self.ParamStartDelimiter := ' ';
  	self.ParamEndDelimiter := '"';
  	self.ParamValueSeparator := '="';

    self.FileName :=  TEMPLATEPATH + THEME + '/window.html';

    self.OnReplaceTag := @tagReplace;
end;

end.

