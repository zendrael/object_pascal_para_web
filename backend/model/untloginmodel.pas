unit untLoginModel;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils,
    //DAO
    untDataAccess;

type

  TloginInfo = array [1..2] of String;

  { TloginModel }

  TloginModel = class
    	private
          //
        public
          //
          function autenticaUsuario( strLogin: String; strSenha: String ) : TloginInfo;
	end;

implementation

{ TloginModel }

function TloginModel.autenticaUsuario(strLogin: String; strSenha: String
	): TloginInfo;
var
  arrInfo : array[1..2] of String;
begin
    if TDataAccess.Connect() then
    begin

    	try
			//
          	with SQLQuery do
			begin

				SQL.Add('SELECT id, nome ');
                SQL.Add('FROM tbusuarios ');
                SQL.Add('WHERE login=:Login AND senha=:Senha');

                //verifica os parâmetros
                ParamByName('Login').AsString:= strLogin;
                ParamByName('Senha').AsString:= strSenha;

                //abre consulta
                Open;

                if RecordCount > 0  then
                begin
                    //joga para as propriedades o
                	arrInfo[1] := FieldByName('id').AsString;
                    arrInfo[2] := FieldByName('nome').AsString;

				end else
                begin
					arrInfo[1] := EmptyStr;
                    arrInfo[2] := EmptyStr;

                    Result:= arrInfo;
				end;

			end;

            Result := arrInfo;

		except
            {on E: Exception do raise;}
			arrInfo[1] := EmptyStr;
			arrInfo[2] := EmptyStr;

            Result := arrInfo;
		end;

	end;

    TDataAccess.Disconnect();
end;

end.

