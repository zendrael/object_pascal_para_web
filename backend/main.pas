unit main;

{$mode objfpc}{$H+}

interface

uses
	SysUtils, Classes, httpdefs, fpHTTP, fpWeb, iniwebsession,
    //contsantes e globais
    globals,
    //controllers
    untIndexController, untLoginController, untProdutoController;

type

	{ TwbmMain }

 TwbmMain = class(TFPWebModule)
        actGetHTML : TFPWebAction; //ação padrão
        actLogin : TFPWebAction;
		actLogout: TFPWebAction;
        actMenus : TFPWebAction;

        constructor CreateNew(AOwner:Tcomponent; CreateMode: Integer); override;

		procedure getHTMLRequest(Sender: TObject; ARequest: TRequest;
			AResponse: TResponse; var Handled: Boolean);

        procedure loginRequest(Sender: TObject; ARequest: TRequest;
			AResponse: TResponse; var Handled: Boolean);

        procedure logoutRequest(Sender: TObject; ARequest: TRequest;
			AResponse: TResponse; var Handled: Boolean);

        procedure menusRequest(Sender: TObject; ARequest: TRequest;
			AResponse: TResponse; var Handled: Boolean);
	private
		{ private declarations }
	public
		{ public declarations }
	end;

var
	wbmMain: TwbmMain;

implementation

{ TwbmMain }

constructor TwbmMain.CreateNew(AOwner: Tcomponent; CreateMode: Integer);
begin
	inherited;

    //prepara a sessão
    CreateSession := true;

    //configurar actions
    actGetHTML :=  TFPWebAction.create( Actions );
    actLogin :=  TFPWebAction.create( Actions );
    actLogout :=  TFPWebAction.create( Actions );
    actMenus :=  TFPWebAction.create( Actions );

    //nomear ações
    actGetHTML.name := 'getHTML';
    actLogin.name := 'login';
    actLogout.name := 'logout';
    actMenus.name := 'menus';

    //conectando eventos
    actGetHTML.OnRequest := @getHTMLRequest;
    actLogin.OnRequest := @loginRequest;
    actLogout.OnRequest := @logoutRequest;
    actMenus.OnRequest := @menusRequest;

    //configurar ação padrão
	actGetHTML.Default := true;
end;

procedure TwbmMain.getHTMLRequest(Sender: TObject; ARequest: TRequest;
	AResponse: TResponse; var Handled: Boolean);
var
    objIndex : TindexController;
    objProduto : TprodutoController;
begin
	//prepara resposta
 	AResponse.ContentType := 'text/html;charset=utf8';

    case ARequest.QueryFields.Values['form'] of
    	'produto' : begin
			//gerando formulário...
			objProduto :=  TprodutoController.Create;

			AResponse.Content := objProduto.gerarPagina( ARequest );

            //eliminar da memória
			FreeAndNil( objProduto );
		end;

        'cliente' : begin
			//gerando formulário...
		end;

        'fornecedor' : begin
            //gerando formulário...
		end;

        else
        	//gerando index
			objIndex :=  TindexController.Create;

			AResponse.Content := objIndex.gerarPagina();

            //eliminar da memória
		    FreeAndNil( objIndex );
	end;

    //informa que a ação foi realizada
    Handled:= true;
end;

procedure TwbmMain.loginRequest(Sender: TObject; ARequest: TRequest;
	AResponse: TResponse; var Handled: Boolean);
var
	objLogin : TloginController;
    strUsuario, strSenha : string;
begin
    //prepara resposta
 	AResponse.ContentType := 'text/html;charset=utf8';

    objLogin := TloginController.Create;

    //pega as informações vindas do formulário/AJAX
    strUsuario:= ARequest.ContentFields.Values['edtUsuario'];
    strSenha:= ARequest.ContentFields.Values['edtSenha'];

    if( objLogin.autenticar( strUsuario, strSenha ) ) then
    begin
        //inicializa a sessão e atribui os valores
        if( CreateSession and Assigned( Session ) ) then
        begin
            Session.Variables['idUsuario'] := objLogin.idUsuario;
            Session.Variables['nomeUsuario'] := objLogin.nomeUsuario;
		end;

        //retorna resposta do login
	    AResponse.Content:= '{"ERROR":"", "idusuario":"'+ objLogin.idUsuario +'", "nomeusuario":"'+ objLogin.nomeUsuario +'"}';
	end else
    begin
        //retorna resposta do login
	    AResponse.Content:= '{"ERROR":"Usuário não autenticado!", "idusuario":"", "nomeusuario":""}';
	end;

    FreeAndNil( objLogin );

    //ação realizada
    Handled:= true;
end;

procedure TwbmMain.logoutRequest(Sender: TObject; ARequest: TRequest;
	AResponse: TResponse; var Handled: Boolean);
begin
    //prepara resposta
 	AResponse.ContentType := 'text/html;charset=utf8';

    //encerra a sessão
    Session.Terminate;

    //retorna resposta do login
    AResponse.Content:= '{"ERROR":"", "mensagem":"Sistema encerrado!"}';

    //ação realizada
    Handled:= true;
end;

procedure TwbmMain.menusRequest(Sender: TObject; ARequest: TRequest;
	AResponse: TResponse; var Handled: Boolean);
begin
	//prepara resposta
 	AResponse.ContentType := 'text/html;charset=utf8';

    //retorna menus do usuário
    AResponse.Contents.add('<ul class="nav navbar-nav">');
	AResponse.Contents.add('<li>');
    //menu traz item correspondente
	AResponse.Contents.add('<a href="#" onclick="frmProduto.load();">Produtos</a>');
	AResponse.Contents.add('</li>');
	AResponse.Contents.add('<li>');
	AResponse.Contents.add('<a href="#">Clientes</a>');
	AResponse.Contents.add('</li>');
    AResponse.Contents.add('<li>');
	AResponse.Contents.add('<a href="#">Fornecedores</a>');
	AResponse.Contents.add('</li>');
	AResponse.Contents.add('</ul>');

    //ação realizada
    Handled:= true;
end;

initialization
	//RegisterHTTPModule('TFPWebModule1', TwbmMain);
	RegisterHTTPModule(TwbmMain, True);
end.

