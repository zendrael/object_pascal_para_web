unit untTestController;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils,
    //model
    untTestModel,
    //view
    untTestView;

type

	{ TtestController }

  TtestController = class
    	private
          //
        public
          //
          function testar() : string;
	end;

implementation

{ TtestController }

function TtestController.testar: string;
var
	objView : TtestView;
    objModel : TtestModel;
    strAux : string;
begin
	//preparar o view
  	objView := TtestView.Create;

    strAux:= objView.exibir();

    //liberar a memória
    FreeAndNil( objView );

    //retorna resposta final
    Result:= strAux;

end;

end.

