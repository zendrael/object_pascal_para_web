/*
	Sistema TAL
		frmProduto.js
			ações lado cliente para Produtos
	Autor: Fulano <mail@fulano.com>
	Data: 10/11/2014
*/

//inicia a classe/objeto frmProduto
frmProduto = {
	
	strCodigo : '0',
	strNome : null,
	strTipo : null,
	strMarca : null,
	strQuantidade : null,
	strPreco : null,
	
	/*
		load
			carrega janela do produto
		Parâmetros :
			null
		Retorno : 
			null
		Uso :
			frmProduto.load();
	*/
	load : function(){
		//carrega ajanela processada
		$.ajax({
			type: "GET",
			//ação padrão da ENGINE é getHTML
			url: ENGINE + '?form=produto',
			success: function( resposta ){
				//exibe resposta HTML
				$("#secConteudo").html( resposta );
				
				//configura ações
				frmProduto.setAcoes();
				
				//mostra janela
				$('#janelaPadrao').modal('show');
		
			}
					
		}); //fim ajax
	},
	
	/*
		setAcoes
			configura cliques dos botões e tabs
		Parâmetros :
			null
		Retorno : 
			null
		Uso :
			frmProduto.setAcoes();
	*/
	setAcoes : function(){
		//configura tab de lista
		$("#tabProduto li:eq(1) a").click( function( e ){
			e.preventDefault();
			
			//preenche a lista
			$.ajax({
				type: "POST",
				//ação padrão da ENGINE é getHTML
				url: ENGINE + '?form=produto&action=lista',
				success: function( resposta ){
					$('#lista').html( resposta );
				},
				error: function(jqXHR, textStatus, errorThrown){
					$('#lista').html( 'Não foi possível exibir a lista!' );
				}
						
			}); //fim ajax
			
		}); //fim click tab Lista		
	},
	
	/*
		getCampos
			pega os valores dos campos digitados
		Parâmetros :
			null
		Retorno : 
			null
		Uso :
			frmProduto.getCampos();
	*/
	getCampos : function(){
		//pega campos e seta valores
		this.strCodigo = $("#hdnCodigo").val();
		this.strNome = $("#edtNome").val();
		this.strTipo = $("#edtTipo").val();
		this.strMarca = $("#edtMarca").val();
		this.strQuantidade = $("#edtQuantidade").val();
		this.strPreco = $("#edtPreco").val();		
	},
	
	/*
		novo
			zera informações na tela
		Parâmetros :
			null
		Retorno : 
			null
		Uso :
			frmProduto.novo();
	*/
	novo : function(){
		//pega campos e seta valores
		$("#hdnCodigo").val('0');
		$("#edtNome").val('');
		$("#edtTipo").val('');
		$("#edtMarca").val('');
		$("#edtQuantidade").val('');
		$("#edtPreco").val('');
		
		//foco
		$("#edtNome").focus();
	},
	
	/*
		salvar
			salva o que foi digitado nos campos ou altera
		Parâmetros :
			null
		Retorno : 
			null
		Uso :
			frmProduto.salvar();
	*/
	salvar : function(){
		//se é produto novo
		if( $("#hdnCodigo").val() == '0' ){
			this.Create();
		//senão é atualização
		}else{
			this.Update();
		}
		
	},
	
	/*
		selecionar
			seleciona o item a ser alterado
		Parâmetros :
			strItem : string : código do item
		Retorno : 
			null
		Uso :
			frmProduto.selecionar( '2' );
	*/
	selecionar : function( strItem ){
		//marca o código do item
		$("#hdnCodigo").val( strItem );
		
		//carrega o item
		this.strCodigo = strItem;
		this.Read();
		
		//foco na aba principal
		$('#tabProduto a:first').tab('show'); 
		
		//foco
		$("#edtNome").focus();
		
	},
	
	/*
		Create
			cria/salva informações do formulário no BD
		Parâmetros :
			null
		Retorno : 
			null
		Uso :
			frmProduto.Create();
	*/
	Create : function(){
		//pega campos
		this.getCampos();
		
		//envia para o ENGINE
		$.ajax({
			type: "POST",
			//ação padrão da ENGINE é getHTML
			url: ENGINE + '?form=produto&action=create',
			data : { //passa todos os campos e valores
				edtNome : this.strNome,
				edtTipo : this.strTipo,
				edtMarca : this.strMarca,
				edtQuantidade : this.strQuantidade,
				edtPreco : this.strPreco
			},
			success: function( resposta ){
				//oculta erro caso tenha aparecido anteriormente
				$('#msgErro').css({display :'none'});
				
				resposta = JSON.parse( resposta );
				
				if( resposta.ERROR == '' ){
					//mensagem de sucesso
					$("#msgSucesso").html('Item inserido com sucesso!');
		
					//exibe 
					$('#msgSucesso').css({display :'block'});
				} else {
					//informa qual o erro
					$("#msgErro").html('<strong>Erro:</strong> '+ resposta.ERROR );
					$('#msgErro').css({display :'block'});
				}
		
			},
			error: function(jqXHR, textStatus, errorThrown){
				//oculta sucesso caso tenha aparecido anteriormente
				$('#msgSucesso').css({display :'none'});				
				
				//informa qual o erro
				$("#msgErro").html('<strong>Erro:</strong> ' + errorThrown);
				$('#msgErro').css({display :'block'});
				
			}
					
		}); //fim ajax
	},
	
	/*
		Read
			lê informações do BD
		Parâmetros :
			null
		Retorno : 
			null
		Uso :
			frmProduto.Read();
	*/
	Read : function(){
		//envia para o ENGINE
		$.ajax({
			type: "POST",
			//ação padrão da ENGINE é getHTML
			url: ENGINE + '?form=produto&action=read',
			data : { //passa todos os campos e valores
				strCodigo : this.strCodigo
			},
			success: function( resposta ){
				
				//oculta erro caso tenha aparecido anteriormente
				$('#msgErro').css({display :'none'});
				
				//parsing da resposta
				resposta = JSON.parse( resposta );
				
				if( resposta.ERROR == '' ){
					//preenche os campos
					$("#edtNome").val( resposta.nome );
					$("#edtTipo").val( resposta.tipo );
					$("#edtMarca").val( resposta.marca );
					$("#edtQuantidade").val( resposta.quantidade );
					$("#edtPreco").val( resposta.preco );
					
					//foco
					$("#edtNome").focus();	
				} else {
					$("#msgErro").html('<strong>Erro:</strong> ' + resposta.ERROR );
					$('#msgErro').css({display :'block'});
				}
		
			},
			error: function(jqXHR, textStatus, errorThrown){
				//oculta sucesso caso tenha aparecido anteriormente
				$('#msgSucesso').css({display :'none'});				
				
				//informa qual o erro
				$("#msgErro").html('<strong>Erro:</strong> ' + errorThrown);
				$('#msgErro').css({display :'block'});
				
			}
					
		}); //fim ajax
	},
	
	/*
		Update
			atualiza informações no BD
		Parâmetros :
			null
		Retorno : 
			null
		Uso :
			frmProduto.Update();
	*/
	Update : function(){
		//pega campos
		this.getCampos();
		
		//envia para o ENGINE
		$.ajax({
			type: "POST",
			//ação padrão da ENGINE é getHTML
			url: ENGINE + '?form=produto&action=update',
			data : { //passa todos os campos e valores
				strCodigo : this.strCodigo,
				edtNome : this.strNome,
				edtTipo : this.strTipo,
				edtMarca : this.strMarca,
				edtQuantidade : this.strQuantidade,
				edtPreco : this.strPreco
			},
			success: function( resposta ){
				//oculta erro caso tenha aparecido anteriormente
				$('#msgErro').css({display :'none'});
				
				//parsing da resposta
				resposta = JSON.parse( resposta );
				
				if( resposta.ERROR == '' ){
					//mensagem de sucesso
					$("#msgSucesso").html('Item Atualizado com sucesso!');
					//exibe
					$('#msgSucesso').css({display :'block'});		
					
				} else {
					$("#msgErro").html('<strong>Erro:</strong> ' + resposta.ERROR );
					$('#msgErro').css({display :'block'});
				}
		
			},
			error: function(jqXHR, textStatus, errorThrown){
				//oculta sucesso caso tenha aparecido anteriormente
				$('#msgSucesso').css({display :'none'});				
				
				//informa qual o erro
				$("#msgErro").html('<strong>Erro:</strong> ' + errorThrown);
				$('#msgErro').css({display :'block'});
				
			}
					
		}); //fim ajax
	},
	
	/*
		Delete
			exclui/desativa item no BD
		Parâmetros :
			null
		Retorno : 
			null
		Uso :
			frmProduto.Delete();
	*/
	Delete : function(){
		//pega campos
		this.getCampos();
		
		//envia para o ENGINE
		$.ajax({
			type: "POST",
			//ação padrão da ENGINE é getHTML
			url: ENGINE + '?form=produto&action=delete',
			data : { //passa todos os campos e valores
				strCodigo : this.strCodigo
			},
			success: function( resposta ){
				//oculta erro caso tenha aparecido anteriormente
				$('#msgErro').css({display :'none'});
				
				//parsing da resposta
				resposta = JSON.parse( resposta );
				
				if( resposta.ERROR == '' ){
					//mensagem de sucesso
					$("#msgSucesso").html('Item Excluído com sucesso!');
					//exibe
					$('#msgSucesso').css({display :'block'});
					
					//limpa campos e cria item novo
					frmProduto.novo();		
					
				} else {
					$("#msgErro").html('<strong>Erro:</strong> ' + resposta.ERROR );
					$('#msgErro').css({display :'block'});
				}
		
			},
			error: function(jqXHR, textStatus, errorThrown){
				//oculta sucesso caso tenha aparecido anteriormente
				$('#msgSucesso').css({display :'none'});				
				
				//informa qual o erro
				$("#msgErro").html('<strong>Erro:</strong> ' + errorThrown);
				$('#msgErro').css({display :'block'});
				
			}
					
		}); //fim ajax
	}
	
};//fim objeto frmProduto
//EOF




