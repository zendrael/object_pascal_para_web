unit untDataAccess;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, sqldb, sqlite3conn,
    //globals
    globals;

type

	{ TDataAccess }

  TDataAccess = class
    	private
          //
        public
          { public declarations }
    	  class function Connect(): boolean;
    	  class function Disconnect(): boolean;

          constructor Create;
          destructor Destroy; override;
	end;

var
    SQLite3Con: TSQLite3Connection;
    SQLQuery: TSQLQuery;
    SQLTrans: TSQLTransaction;

implementation

{ TDataAccess }

class function TDataAccess.Connect: boolean;
begin
    try
        //cria componentes
        SQLite3Con:= TSQLite3Connection.Create(nil);
        SQLQuery:= TSQLQuery.Create(nil);
        SQLTrans:= TSQLTransaction.Create(nil);

        //configura componentes
        SQLite3Con.DatabaseName:= DATABASEPATH + DATABASE;

        SQLTrans.DataBase:= SQLite3Con;
    	SQLQuery.Database := SQLite3Con;
		SQLQuery.Transaction := SQLTrans;

        //ativa e faz a conexão
        SQLite3Con.Open;

        Result:= true;

    except
        Result:= false;
    end;
end;

class function TDataAccess.Disconnect: boolean;
begin
    try
       SQLite3Con.Close;

       SQLite3Con.Free;
       SQLQuery.Free;
       SQLTrans.Free;

       Result:= true;
   except
       Result:= false;
   end;
end;

constructor TDataAccess.Create;
begin
    //
end;

destructor TDataAccess.Destroy;
begin
	inherited Destroy;
end;

end.

