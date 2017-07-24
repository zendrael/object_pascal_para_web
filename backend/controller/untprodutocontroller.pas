unit untProdutoController;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, HTTPDefs, fpWeb,
    //model
    untProdutoModel,
    //view
    untProdutoView;

type

  { TprodutoController }

  TprodutoController = class
    	private
          //
        public
          //
          function gerarPagina( Arequest: TRequest) : string;
	end;

implementation

{ TprodutoController }

function TprodutoController.gerarPagina(Arequest: TRequest): string;
var
	objModel : TprodutoModel;
    objView : TprodutoView;
    strAux : String; //ajuda a montar respostas
begin
    objModel := TprodutoModel.Create;

	objView := TprodutoView.Create;

    //qual ação realizar?
    case Arequest.QueryFields.Values['action'] of
    	'create' : begin
			//configura os campos com as devidas conversões
			objModel.strNome:= Arequest.ContentFields.Values['edtNome'];
            objModel.strTipo:= Arequest.ContentFields.Values['edtTipo'];
            objModel.strMarca:= Arequest.ContentFields.Values['edtMarca'];
            objModel.strQuantidade:= StrToInt( Arequest.ContentFields.Values['edtQuantidade'] );
            objModel.strPreco:= StrToFloat( Arequest.ContentFields.Values['edtPreco'] );

            //cadastra no BD
            if objModel.CreateRegistro = true then
            	Result := '{"ERROR":""}'
            else
				Result := '{"ERROR":"'+ objModel.strError +'"}';
		end;

        'read' : begin
            //configura o model
            objModel.strCodigo:= StrToInt( Arequest.ContentFields.Values['strCodigo'] );

			//verifica se encontrou o item
            if objModel.Read = true then
            begin
                strAux:= '{"ERROR":"",';
                strAux:= strAux + '"nome":"' + objModel.strNome + '",';
                strAux:= strAux + '"tipo":"' + objModel.strTipo + '",';
                strAux:= strAux + '"marca":"' + objModel.strMarca + '",';
                strAux:= strAux + '"quantidade":"' + IntToStr( objModel.strQuantidade ) + '",';
                strAux:= strAux + '"preco":"' + FloatToStr( objModel.strPreco ) + '"}';

                Result:= strAux;
			end else
            	Result := '{"ERROR":"'+ objModel.strError +'"}';
		end;

        'update' : begin
			//configura os campos com as devidas conversões
            objModel.strCodigo:= StrToInt( Arequest.ContentFields.Values['strCodigo'] );
			objModel.strNome:= Arequest.ContentFields.Values['edtNome'];
            objModel.strTipo:= Arequest.ContentFields.Values['edtTipo'];
            objModel.strMarca:= Arequest.ContentFields.Values['edtMarca'];
            objModel.strQuantidade:= StrToInt( Arequest.ContentFields.Values['edtQuantidade'] );
            objModel.strPreco:= StrToFloat( Arequest.ContentFields.Values['edtPreco'] );

            //atualiza BD
            if objModel.Update = true then
            	Result := '{"ERROR":""}'
            else
				Result := '{"ERROR":"'+ objModel.strError +'"}';
		end;

        'delete' : begin
			//pega o item a ser excluído
            objModel.strCodigo:= StrToInt( Arequest.ContentFields.Values['strCodigo'] );

            //remove do BD
            if objModel.Delete = true then
            	Result := '{"ERROR":""}'
            else
				Result := '{"ERROR":"'+ objModel.strError +'"}';
		end;

        'lista' : begin
            //gera lista pelo model
            objModel.ReadAll;

            //constrói a lista
            Result:= objView.lista( objModel.strLista );
            //Result:= IntToStr( Length( objModel.strLista ) );
		end;

        else
            //exibe formulário padrão
        	Result := objView.exibir();
	end;

    FreeAndNil( objModel );

    FreeAndNil( objView );
end;

end.

