unit globals;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils;

const
  //caminho da base de dados
  DATABASEPATH = '../../sistema/db/';

  //nome da base de dados
  DATABASE = 'sistema.db';

  //caminho das skins em relação ao CGI
  TEMPLATEPATH = '../../sistema/skin/';

  //nome do template atual
  THEME = 'temastrap';

  //caminho dos formulários
  FORMPATH = '../../sistema/forms/';

  //arrays para formatar data e semana
  aMes: array[1..12] of string =
    ('Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
     'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro');

  aSemana: array[1..7] of string =
    ('Domingo', 'Segunda-feira', 'Terça-feira', 'Quarta-feira',
     'Quinta-feira', 'Sexta-feira', 'Sábado');

type
  TStringMatrix = Array of array of String;


implementation

end.

