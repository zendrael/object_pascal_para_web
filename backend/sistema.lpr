program sistema;

{$mode objfpc}{$H+}

uses
  fpCGI, main, untTestController, untTestModel, untTestView, globals, 
untIndexController, untIndexModel, untIndexView, untDataAccess, 
untLoginController, untLoginModel, untProdutoController, untProdutoView, 
untProdutoModel;

begin
  Application.Initialize;
  Application.Run;
end.

