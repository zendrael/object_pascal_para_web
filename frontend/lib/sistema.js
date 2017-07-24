/*
	Sistema TAL
		lib principal
	Autor: Fulano <mail@fulano.com>
	Data: 30/13/2099
*/

var ENGINE = '/cgi-bin/sistemaMVC/sistema'; //.cgi
var USUARIO = {id:'', nome:''}; //informações do usuário

// jQuery
$( document ).ready(function() {
	
	//apresenta tela de login
	$('#janelaLogin').modal('show'); //bootstrap
	
	//quando exibir a janela, dá o foco
	$('#janelaLogin').on('shown.bs.modal', function( event ) {
		//foco no login
		$( "#edtUsuario" ).focus();
	});
	
	//conecta eventos à janela de login
	$( "#btnLogin" ).click( function( event ) {
		
		//pega os campos
		strUsuario = $("#edtUsuario").val();
		strSenha = $("#edtSenha").val();

		//envia dados para verificar por AJAX
		$.ajax({
			type: "POST",
			url: ENGINE + '/login',
			data: { 
				edtUsuario : strUsuario,
				edtSenha : strSenha
			},
			beforeSend: function() {
				$('#msgAutentica').css({display :'block'});
			},
			success: function( resposta ){
				//converte resposta em JSON
				resposta = JSON.parse( resposta );
				
				//se não houverem erros
				if( resposta.ERROR === '' ){
					//pega informações do usuário
					USUARIO.id = resposta.idusuario;
					USUARIO.nome = resposta.nomeusuario;
				
					//carrega menus
					carregaMenus();
					
					//exibe nome do usuário logado
					configuraUsuario();
					
					//oculta a janela de login
					$('#janelaLogin').modal('hide');
							
				} else {
					
					$('#msgAutentica').css({display :'none'});
					$('#msgErro').html( resposta.ERROR );
					$('#msgErro').css({display :'block'});
					
				}
			
			},
			error: function(jqXHR, textStatus, errorThrown){
								
				$('#msgAutentica').css({display :'none'});
				
				$('#msgErro').css({display :'block'});
				
			}
			
		}); //fim ajax
		
	}); //fim btnLogin click
	
}); //fim document ready


/*
	carregaMenus
		exibe os menus através do BD
	Parâmetros :
		null
	Retorno : 
		null
	Uso :
		carregaMenus();
*/
function carregaMenus(){
	//encerra sessão
	$.ajax({
		type: "GET",
		url: ENGINE + '/menus',
		success: function( resposta ){
			//resposta
			$("#divSistemaMenus").html( resposta );
	
		}
				
	}); //fim ajax
	
}

/*
	configuraUsuario
		configura botão do usuário
	Parâmetros :
		null
	Retorno : 
		null
	Uso :
		configuraUsuario();
*/
function configuraUsuario(){
	
	//prepara o nome
	$("#spnUsuario").html( USUARIO.nome );
	
	//exibe botão dropdown
	$('#drpUsuario').css({display :'block'});
	
}

/*
	logout
		sai do sistema
	Parâmetros :
		null
	Retorno : 
		null
	Uso :
		logout();
*/
function logout(){
	//apaga menus
	$("#divSistemaMenus").html(' ');
	
	//oculta botão dropdown
	$('#drpUsuario').css({display :'none'});
	
	//zera variáveis do usuário
	USUARIO.id = null;
	USUARIO.nome = null;
	
	//encerra sessão
	$.ajax({
		type: "GET",
		url: ENGINE + '/logout',
		success: function( resposta ){
			//converte resposta em JSON
			resposta = JSON.parse( resposta );
			
			alert( resposta.mensagem );	
		}
				
	}); //fim ajax
	
}

//EOF

