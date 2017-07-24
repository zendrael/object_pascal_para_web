unit untTestModel;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils;

type

	{ TtestModel }

  TtestModel = class
    	private
          //
        public
          //

        constructor Create;
        destructor Destroy;
	end;


implementation

{ TtestModel }

constructor TtestModel.Create;
begin
    //conecta ao BD
end;

destructor TtestModel.Destroy;
begin
	//desconecta do BD...
end;

end.

