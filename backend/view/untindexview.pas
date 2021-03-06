unit untIndexView;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, HTTPDefs, fphttp, fpWeb, fpTemplate,
    //globais do sistema
    globals;

type

	{ TindexView }

  TindexView = class( TFPTemplate )
    	private
          //
        public
          //
          procedure tagReplace(Sender:TObject; const TagString:String;
            TagParams: TStringList; Out ReplaceText:String);

          function exibir() : string;

          constructor Create;
	end;


implementation

{ TtestView }

procedure TindexView.tagReplace(Sender: TObject; const TagString: String;
	TagParams: TStringList; out ReplaceText: String);
var
	dia, mes, ano: word;
begin
	if AnsiCompareText(TagString, 'data') = 0 then
    begin
      decodedate( now, ano, mes, dia );
      ReplaceText := Format('%s, %d de %s de %d',[aSemana[DayOfWeek(now)], dia, aMes[mes], ano]);
	end;

    if AnsiCompareText(TagString, 'template') = 0 then
    begin
      ReplaceText:= 'skin/temastrap/';
	end;
end;

function TindexView.exibir: string;
begin
	Result := self.GetContent;
end;

constructor TindexView.Create;
begin
	self.AllowTagParams := true;

    self.StartDelimiter := '<%';
    self.EndDelimiter := '%>';

    self.FileName := '../../sistema/skin/temastrap/main.html';

    self.OnReplaceTag := @tagReplace;
end;

end.

