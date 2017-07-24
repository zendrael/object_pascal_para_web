unit untProdutoModel;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils,
    //globais do sistema
    globals,
    //DAO
    untDataAccess;

type

  { TprodutoModel }

  TprodutoModel = class
    		strCodigo : Integer;
            strNome : String;
            strTipo : String;
            strMarca : String;
            strQuantidade : Integer;
            strPreco : Double;
            //guarda todos os itens
            strLista : TStringMatrix;
            //guarda mensagens de erro
            strError : String;
    	private
          //
        public
          //
          function CreateRegistro : Boolean;
          function Read: Boolean;
          function Update : Boolean;
          function Delete: Boolean;

          function ReadAll: Boolean;
	end;

implementation

{ TloginModel }


{ TprodutoModel }

function TprodutoModel.CreateRegistro: Boolean;
begin
    //
	if self.strNome = EmptyStr then
    begin
		//não pode cadastrar produto sem nome
        self.strError:= 'Preencha os campos corretamente!';
		Result := false;
	end else
    begin
		//tenta cadastrar produto
		if TDataAccess.Connect() then
	    begin

	    	try
	          	with SQLQuery do
				begin
                    Close;

					SQL.Add('INSERT INTO tbprodutos ');
	                SQL.Add('(nome, tipo, marca, quantidade, preco)');
	                SQL.Add('VALUES (:nome, :tipo, :marca, :quantidade, :preco)');

	                //verifica os parâmetros
	                ParamByName('nome').AsString:= self.strNome;
                    ParamByName('tipo').AsString:= self.strTipo;
                    ParamByName('marca').AsString:= self.strMarca;
                    ParamByName('quantidade').AsInteger:= self.strQuantidade;
	                ParamByName('preco').AsFloat:= self.strPreco;

	                ExecSQL;

					//realizou alterações, commit.
					SQLTrans.Commit;

	                if RecordCount > 0  then
                         Result := true
					else
	                     Result:= false;
				end;

			except
	            on E: Exception do
                begin
                    self.strError:= E.Message;
                    Result := false;
				end;
			end;

		end else
        	Result := false;

        //desconecta
	    TDataAccess.Disconnect();
	end;
end;

function TprodutoModel.Read: Boolean;
begin
	//
	if self.strCodigo = 0 then
    begin
		//não pode procurar produto sem código
        self.strError:= 'Selecione um item antes para obter informações!';
		Result := false;
	end else
    begin
		//tenta localizar produto
		if TDataAccess.Connect() then
	    begin

	    	try
	          	with SQLQuery do
				begin
                    Close;

					SQL.Add('SELECT nome, tipo, marca, quantidade, preco ');
	                SQL.Add('FROM tbprodutos ');
	                SQL.Add('WHERE id = :codigo');

	                //verifica os parâmetros
	                ParamByName('codigo').AsInteger:= self.strCodigo;

	                Open;

	                if RecordCount > 0  then
                    begin
						//configura o model
                        self.strNome := FieldByName('nome').AsString;
                        self.strTipo := FieldByName('tipo').AsString;
                        self.strMarca := FieldByName('marca').AsString;
                        self.strQuantidade := FieldByName('quantidade').AsInteger;
                        self.strPreco := FieldByName('preco').AsFloat;

                        Result := true
					end
					else
	                    Result:= false;
				end;

			except
	            on E: Exception do
                begin
                    self.strError:= E.Message;
                    Result := false;
				end;
			end;

		end else
        	Result := false;

        //desconecta
	    TDataAccess.Disconnect();
	end;
end;

function TprodutoModel.Update: Boolean;
begin
	//
	if self.strCodigo = 0 then
    begin
		//não pode atualizar produto sem código
        self.strError:= 'Selecione um item para atualizar!';
		Result := false;
	end else
    begin
		//tenta atualizar produto
		if TDataAccess.Connect() then
	    begin

	    	try
	          	with SQLQuery do
				begin
                    Close;

					SQL.Add('UPDATE tbprodutos');
	                SQL.Add('SET nome = :nome, tipo = :tipo, marca = :marca, quantidade = :quantidade, preco = :preco ');
	                SQL.Add('WHERE id = :codigo');

	                //verifica os parâmetros
	                ParamByName('codigo').AsInteger:= self.strCodigo;

                    ParamByName('nome').AsString:= self.strNome;
                    ParamByName('tipo').AsString:= self.strTipo;
                    ParamByName('marca').AsString:= self.strMarca;
                    ParamByName('quantidade').AsInteger:= self.strQuantidade;
                    ParamByName('preco').AsFloat:= self.strPreco;

	                ExecSQL;

                    //realizou alterações, commit.
					SQLTrans.Commit;

	                if RecordCount > 0  then
                        Result := true
					else
	                    Result:= false;
				end;

			except
	            on E: Exception do
                begin
                    self.strError:= E.Message;
                    Result := false;
				end;
			end;

		end else
        	Result := false;

        //desconecta
	    TDataAccess.Disconnect();
	end;
end;

function TprodutoModel.Delete: Boolean;
begin
	//
	if self.strCodigo = 0 then
    begin
		//não pode deletar produto sem código
        self.strError:= 'Selecione um item antes de excluir!';
		Result := false;
	end else
    begin
		//tenta atualizar produto
		if TDataAccess.Connect() then
	    begin

	    	try
	          	with SQLQuery do
				begin
                    Close;

					SQL.Add('DELETE FROM tbprodutos');
	                SQL.Add('WHERE id = :codigo');

	                //verifica os parâmetros
	                ParamByName('codigo').AsInteger:= self.strCodigo;

	                ExecSQL;

                    //realizou alterações, commit.
					SQLTrans.Commit;

	                if RecordCount > 0  then
                        Result := true
					else
	                    Result:= false;
				end;

			except
	            on E: Exception do
                begin
                    self.strError:= E.Message;
                    Result := false;
				end;
			end;

		end else
        	Result := false;

        //desconecta
	    TDataAccess.Disconnect();
	end;
end;

function TprodutoModel.ReadAll : Boolean;
var
  i: integer;
begin
	//tenta buscar todos os produtos
	if TDataAccess.Connect() then
    begin

    	try
          	with SQLQuery do
			begin
                Close;

				SQL.Add('SELECT id, nome, tipo, marca, quantidade, preco ');
                SQL.Add('FROM tbprodutos ');
                SQL.Add('ORDER BY id, nome, marca');

                Open;

                if RecordCount > 0  then
                begin
                    //configura a matriz de strings
                    //lista, linhas, colunas
                    SetLength( strLista, RecordCount, 6);

                    i := 0;

                    while not EOF do
                    //for i:=0 to RecordCount do
                    begin
                        //insere itens no array
                        strLista[i,0] := FieldByName('id').AsString;
                        strLista[i,1] := FieldByName('nome').AsString;
                        strLista[i,2] := FieldByName('tipo').AsString;
                        strLista[i,3] := FieldByName('marca').AsString;
                        strLista[i,4] := FieldByName('quantidade').AsString;
                        strLista[i,5] := FieldByName('preco').AsString;

                        //próximo registro
                        Inc( i );
                        Next;
					end;

                    //responde ok
                    Result := true
				end
				else
                    Result:= false;
			end;

		except
            on E: Exception do
            begin
                self.strError:= E.Message;
                Result := false;
			end;
		end;

	end else
    	Result := false;

    //desconecta
    TDataAccess.Disconnect();
end;

end.

