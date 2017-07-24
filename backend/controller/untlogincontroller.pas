unit untLoginController;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils,
    //model
    untLoginModel;

type

	{ TloginController }

  TloginController = class
    	idUsuario : String;
        nomeUsuario : String;
    	private
          //
        public
          //
          function autenticar( strUsuario: String; strSenha: String ) : Boolean;
	end;

implementation

{ TloginController }

function TloginController.autenticar(strUsuario: String; strSenha: String): Boolean;
var
  objModel : TloginModel;
  arrUsuario : array[1..2] of String;
begin

	objModel := TloginModel.Create;

	arrUsuario := objModel.autenticaUsuario(strUsuario, strSenha);

	if( arrUsuario[1] = EmptyStr ) then
	begin
		Result:= false;
	end else
    begin
		//atribui os valores vindos do BD as propriedades
		Self.idUsuario:= arrUsuario[1];
        Self.nomeUsuario:= arrUsuario[2];

        Result := true;
	end;

end;

end.

