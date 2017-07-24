unit untIndexController;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils,
    //model
    untIndexModel,
    //view
    untIndexView;

type

	{ TindexController }

  TindexController = class
    	private
          //
        public
          //
          function gerarPagina() : string;
	end;

implementation

{ TindexController }

function TindexController.gerarPagina: string;
var
	objView : TindexView;
    //objModel : TindexModel;
    strAux : string;
begin
	//preparar o view
  	objView := TindexView.Create;

    strAux:= objView.exibir();

    //liberar a memória
    FreeAndNil( objView );

    //retorna resposta final
    Result:= strAux;

end;

end.

