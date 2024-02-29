#include "Protheus.ch"
#include "FwMvcDef.ch"

/*Fun��o principal para constru��o da tela de solicita��o de compras da empresa 
Protheuzeiro Strong S/A, com base em uma proposta ficticia, com a necessidade em trazer
Fornecedor no cabe�alho e Produtos em itens, gravando as infrom��es na mesma tabela (SZ7)*/

User Function MVCSZ7()

Local aArea   := GetArea()

Local oBrowse := FwmBrowse():New()

oBrowse:SetAlias("SZ7")
oBrowse:SetDescription("Solicita��o de Compras")

oBrowse:Activate()

RestArea(aArea)


Return

Static Function MenuDef()

//Local aRotina := FwMvcMenu("MVCSZ7")
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.MVCSZ7'   OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.MVCSZ7'   OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.MVCSZ7'   OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.MVCSZ7'   OPERATION 5 ACCESS 0


Return aRotina


Static Function ModelDef()

//Objeto respons�vel pela cria��o da estrutura Tempor�ria do cabe�alho
Local oStCabec      := FwFormModelStruct():New()

//Objeto respons�vel pela estrutura do itens
Local oStItens      := FwFormStruct(1,"SZ7")

Local bVldPos       := {|| u_VldSZ7()} //Chamada da User Function Pos Validation que validar� a inclus�o ante de ir para o Grid

Local bVldCom       := {|| u_GrvSZ7()} //chamada da User Function Commit que validar� a Inclus�o/Altera��o/Exclus�o

//Objeto responsavel pela caracter�sticas do dicionario de dados, como tamb�m � respos�vel pela estrutura de tabelas campos e registros
Local oModel        := MpFormModel():New("MVCSZ7m",/*bPre*/,bVldPos/*bPos*/,bVldCom/*bComit*/,/*bCancel*/)

//Vari�veis que armazenar�o a estrutura da Trigger dos campos quantidade e pre�o, que ir� gerar o conte�do do campo valor total
Local aTrigQuant  := {}
Local aTrigPreco  := {}


//Cria��o da Tabela tempor�ria que ser� utilizada no cabe�alho
oStCabec:AddTable("SZ7",{"Z7_FILIAL","Z7_NUM","Z7_ITEM"},"Cabe�alho SZ7")

//Cria��o dos campos da tabela tempor�ria
oStCabec:AddField(;
    "Filial",;                                                                                  // [01]  C   Titulo do campo
    "Filial",;                                                                                  // [02]  C   ToolTip do campo
    "Z7_FILIAL",;                                                                               // [03]  C   Id do Field
    "C",;                                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_FILIAL")[1],;                                                                    // [05]  N   Tamanho do campo
    0,;                                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                                       // [07]  B   Code-block de valida��o do campo
    Nil,;                                                                                       // [08]  B   Code-block de valida��o When do campo
    {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_FILIAL,FWxFilial('SZ7'))" ),;   // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
    .F.)                                                                                        // [14]  L   Indica se o campo � virtual

oStCabec:AddField(;
    "Pedido",;                                                                                  // [01]  C   Titulo do campo
    "Pedido",;                                                                                  // [02]  C   ToolTip do campo
    "Z7_NUM",;                                                                                  // [03]  C   Id do Field
    "C",;                                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_NUM")[1],;                                                                       // [05]  N   Tamanho do campo
    0,;                                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                                       // [07]  B   Code-block de valida��o do campo
    Nil,;                                                                                       // [08]  B   Code-block de valida��o When do campo
    {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, 'Iif(!INCLUI,SZ7->Z7_NUM,GETSXENUM("SZ7","Z7_NUM"))' ),;                    // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
    .F.)                                                                                        // [14]  L   Indica se o campo � virtual

oStCabec:AddField(;
    "Emissao",;                                                                                 // [01]  C   Titulo do campo
    "Emissao",;                                                                                 // [02]  C   ToolTip do campo
    "Z7_EMISSAO",;                                                                              // [03]  C   Id do Field
    "D",;                                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_EMISSAO")[1],;                                                                   // [05]  N   Tamanho do campo
    0,;                                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                                       // [07]  B   Code-block de valida��o do campo
    Nil,;                                                                                       // [08]  B   Code-block de valida��o When do campo
    {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_EMISSAO,dDataBase)" ),;         // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
    .F.)                                                                                        // [14]  L   Indica se o campo � virtual


oStCabec:AddField(;
    "Fornecedor",;                                                              // [01]  C   Titulo do campo
    "Fornecedor",;                                                              // [02]  C   ToolTip do campo
    "Z7_FORNECE",;                                                              // [03]  C   Id do Field
    "C",;                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_FORNECE")[1],;                                                   // [05]  N   Tamanho do campo
    0,;                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                       // [07]  B   Code-block de valida��o do campo
    Nil,;                                                                       // [08]  B   Code-block de valida��o When do campo
    {},;                                                                        // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                       // [10]  L   Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_FORNECE,'')" ),;// [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                       // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
    .F.)                                                                        // [14]  L   Indica se o campo � virtual

oStCabec:AddField(;
    "Loja",;                                                                      // [01]  C   Titulo do campo
    "Loja",;                                                                      // [02]  C   ToolTip do campo
    "Z7_LOJA",;                                                                   // [03]  C   Id do Field
    "C",;                                                                         // [04]  C   Tipo do campo
    TamSX3("Z7_LOJA")[1],;                                                        // [05]  N   Tamanho do campo
    0,;                                                                           // [06]  N   Decimal do campo
    Nil,;                                                                         // [07]  B   Code-block de valida��o do campo
    Nil,;                                                                         // [08]  B   Code-block de valida��o When do campo
    {},;                                                                          // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                         // [10]  L   Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_LOJA,'')" ),;     // [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                         // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                         // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
    .F.)                                                                          // [14]  L   Indica se o campo � virtual

oStCabec:AddField(;
    "Usuario",;                                                                     // [01]  C   Titulo do campo
    "Usuario",;                                                                     // [02]  C   ToolTip do campo
    "Z7_USER",;                                                                     // [03]  C   Id do Field
    "C",;                                                                           // [04]  C   Tipo do campo
    TamSX3("Z7_USER")[1],;                                                          // [05]  N   Tamanho do campo
    0,;                                                                             // [06]  N   Decimal do campo
    Nil,;                                                                           // [07]  B   Code-block de valida��o do campo
    Nil,;                                                                           // [08]  B   Code-block de valida��o When do campo
    {},;                                                                            // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                           // [10]  L   Indica se o campo tem preenchimento obrigat�rio
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_USER,__cuserid)" ),;// [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                           // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                           // [13]  L   Indica se o campo pode receber valor em uma opera��o de update.
    .F.)                                                                            // [14]  L   Indica se o campo � virtual

//Tratando a estrutura dos Itens, que ser�o utilizados no Grid da aplica��o

//Modificando Inicializadores Padrao,  para n�o dar mensagem de colunas vazias
oStItens:SetProperty("Z7_NUM",      MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
oStItens:SetProperty("Z7_USER",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '__cUserId')) //Trazer o usu�rio automatico
oStItens:SetProperty("Z7_EMISSAO",  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'dDatabase')) //Trazer a data autom�tica
oStItens:SetProperty("Z7_FORNECE",  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
oStItens:SetProperty("Z7_LOJA",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))

//Chamo a fun��o FwStructTrigger para montar o bloco de c�digo
aTrigQuant  := FwStruTrigger(;
"Z7_QUANT",;  //Campo que ir� disparar o gatilho/trigger
"Z7_TOTAL",;  //Campo que ir� receber o conte�do do  gatilho
"M->Z7_QUANT * M->Z7_PRECO",; //Conte�do que ir� para o campo Z7_TOTAL
.F.)

aTrigPreco  := FwStruTrigger(;
"Z7_PRECO",;  //Campo que ir� disparar o gatilho/trigger
"Z7_TOTAL",;  //Campo que ir� receber o conte�do do  gatilho
"M->Z7_QUANT * M->Z7_PRECO",; //Conte�do que ir� para o campo Z7_TOTAL
.F.)

//Adicionando as Triggers � minha estrutura de items 
oStItens:AddTrigger(;
aTrigQuant[1],;
aTrigQuant[2],;
aTrigQuant[3],;
aTrigQuant[4])

oStItens:AddTrigger(;
aTrigPreco[1],;
aTrigPreco[2],;
aTrigPreco[3],;
aTrigPreco[4])


//Uni�o das estruturas vinculando cabe�alho com itens 
//tamb�m a vincula��o da estrutura de dados dos itens  ao modelo

oModel:AddFields("SZ7MASTER",,oStCabec)

oModel:AddGrid("SZ7DETAIL","SZ7MASTER",oStItens,,,,,)

//Adicionando model de totalizadores � aplica��o

            //IDMODELO          MASTER CABEC.   DETALHE GRID    CAMPO CALC.     NOMEPERSONALIZADO CAMPO  OPERA��O    NOME TOTALIZADOR   
oModel:AddCalc("CALCTOTAL",     "SZ7MASTER",    "SZ7DETAIL",    "Z7_PRODUTO",       "QTDITENS",           "COUNT",,,  "Numero de Pedidos" )
oModel:AddCalc("CALCTOTAL",     "SZ7MASTER",    "SZ7DETAIL",    "Z7_QUANT",       "QTDTOTAL",             "SUM"  ,,,    "Total de Itens" )
oModel:AddCalc("CALCTOTAL",     "SZ7MASTER",    "SZ7DETAIL",    "Z7_TOTAL",       "VALORTOTAL",           "SUM"  ,,,    "Valor Total Solicita��o" )
//Definindo a rela��o entre cabe�alho e item, atrav�s dos campos de Grid ao Cabe�alho
aRelations := {}        //Cabe�alho
aAdd(aRelations,{"Z7_FILIAL",'IIF(!INCLUI, SZ7->Z7_FILIAL, FwxFilial("SZ7"))'})
aAdd(aRelations,{"Z7_NUM","SZ7->Z7_NUM"})
                      //Grid Recebe
oModel:SetRelation("SZ7DETAIL",aRelations,SZ7->(IndexKey(1)))

//Defini��o de chave prim�ria  
oModel:SetPrimaryKey({})

//Impedindo que o campo se repita
oModel:GetModel("SZ7DETAIL"):SetUniqueline({"Z7_ITEM"})

//Defini��o de titulo do Cabe�alho
oModel:GetModel("SZ7MASTER"):SetDescription("CABE�ALHO DA SOLICITA��O DE COMPRAS")

//Defini��o de titulo do Grid
oModel:GetModel("SZ7DETAIL"):SetDescription("ITENS DA SOLICITA��O DE COMPRAS")

//Finalizando a fun��o do model
oModel:GetModel("SZ7DETAIL"):SetUseOldGrid(.T.) //Finalizando setando o modelo antigo de Grid, que permite pegar aHeader e aCols

Return oModel

//Objeto de visualiz��o do fonte MVC
Static Function ViewDef()

Local oView     := Nil

Local oModel        := FwLoadModel("MVCSZ7")

//Objeto encarregado de montar a estrutura tempor�ria do cabe�alho da View
Local oStCabec      := FwFormViewStruct():New()

//Etrutura de dados para os totalizadores
Local oStTotais := FwCalcStruct(oModel:GetModel('CALCTOTAL'))

/* Objeto respons�vel por montar a parte de estrutura dos itens/grid
Como estou usando FwFormStruct, ele traz a estrutura de TODOS OS CAMPOS, sendo assim
caso eu n�o queira que algum campo, apare�a na minha grid, eu devo remover este campo com RemoveField
*/
Local oStItens      := FwFormStruct(2,"SZ7") //1 Para estrutura Model / 2 para estrutura View

//Crio dentro da estrutura da View, os campos do cabe�alho

oStCabec:AddField(;
    "Z7_NUM",;                  // [01]  C   Nome do Campo
    "01",;                      // [02]  C   Ordem
    "Pedido",;                  // [03]  C   Titulo do campo
    X3Descric('Z7_NUM'),;       // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "C",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_NUM"),;       // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    .F.,;    	                // [10]  L   Indica se o campo � alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior op��o do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo � virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)                        // [18]  L   Indica pulo de linha ap�s o campo

oStCabec:AddField(;
    "Z7_EMISSAO",;                // [01]  C   Nome do Campo
    "02",;                      // [02]  C   Ordem
    "Emissao",;                  // [03]  C   Titulo do campo
    X3Descric('Z7_EMISSAO'),;    // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "D",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_EMISSAO"),;    // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo � alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior op��o do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo � virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)  

oStCabec:AddField(;
    "Z7_FORNECE",;                  // [01]  C   Nome do Campo
    "03",;                          // [02]  C   Ordem
    "Fornecedor",;                  // [03]  C   Titulo do campo
    X3Descric('Z7_FORNECE'),;       // [04]  C   Descricao do campo
    Nil,;                           // [05]  A   Array com Help
    "C",;                           // [06]  C   Tipo do campo
    X3Picture("Z7_FORNECE"),;       // [07]  C   Picture
    Nil,;                           // [08]  B   Bloco de PictTre Var
    "SA2",;                         // [09]  C   Consulta F3
    Iif(INCLUI, .T., .F.),;         // [10]  L   Indica se o campo � alteravel
    Nil,;                           // [11]  C   Pasta do campo
    Nil,;                           // [12]  C   Agrupamento do campo
    Nil,;                           // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                           // [14]  N   Tamanho maximo da maior op��o do combo
    Nil,;                           // [15]  C   Inicializador de Browse
    Nil,;                           // [16]  L   Indica se o campo � virtual
    Nil,;                           // [17]  C   Picture Variavel
    Nil) 

oStCabec:AddField(;
    "Z7_LOJA",;                 // [01]  C   Nome do Campo
    "04",;                      // [02]  C   Ordem
    "Loja",;                    // [03]  C   Titulo do campo
    X3Descric('Z7_LOJA'),;      // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "C",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_LOJA"),;      // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo � alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior op��o do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo � virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)

oStCabec:AddField(;
    "Z7_USER",;                 // [01]  C   Nome do Campo
    "05",;                      // [02]  C   Ordem
    "Usu�rio",;                 // [03]  C   Titulo do campo
    X3Descric('Z7_USER'),;      // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "C",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_USER"),;      // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    .F.,;                       // [10]  L   Indica se o campo � alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior op��o do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo � virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil) 

oStItens:RemoveField("Z7_NUM")
oStItens:RemoveField("Z7_EMISSAO")
oStItens:RemoveField("Z7_FORNECE")            
oStItens:RemoveField("Z7_LOJA")      
oStItens:RemoveField("Z7_USER") 

//Bloqueando a edi��o dos campos   ITEM E TOTAL da grid
oStItens:SetProperty("Z7_ITEM",   MVC_VIEW_CANCHANGE,.F.)
oStItens:SetProperty("Z7_TOTAL",  MVC_VIEW_CANCHANGE,.F.)

/*Segunda parte da ViewDef, onde amarramos as estruturas de dados, montadas acima
com o objeto oView, e passamos para a nossa aplica��o todas as caracter�sticas visuais do projetos
*/

//Instancio a classe FwFormView para o objeto view
oView := FwFormView():New()

//Passo para o objeto View o modelo de dados que quero atrelar � ele Modelo + Visualiza��o
oView:SetModel(oModel)

//Monto a estrutura de visualiza��o do Master e do Detalhe (Cabe�alho e Itens)
oView:AddField("VIEW_SZ7M",oStCabec,"SZ7MASTER") //Cabe�alho/Master
oView:AddGrid("VIEW_SZ7D", oStItens,"SZ7DETAIL") //Itens/Grid

oView:AddField("VIEW_TOTAL",oStTotais,"CALCTOTAL")//View dos totalizadores

//Deixando o campo item incremental, adiciona + 1 a proximo item formando uma senquencia 1, 2, 3..
oView:AddIncrementField("SZ7DETAIL","Z7_ITEM")

//Cria��o da Tela, dividindo proporcionalmente o tamanho do cabe�alho e o tamanho do Grid
oView:CreateHorizontalBox("CABEC",30)
oView:CreateHorizontalBox("GRID", 50)
oView:CreateHorizontalBox("TOTAL", 20)

/*Definindo para onde v�o cada View Criada, VIEW_SZ7M ir� para a cabec
VIEW_SZ7D ir� para GRID... Sendo assim, eu associo o View � cada Box criado
*/
oView:SetOwnerView("VIEW_SZ7M","CABEC") 
oView:SetOwnerView("VIEW_SZ7D","GRID") 
oView:SetOwnerView("VIEW_TOTAL","TOTAL")

//Ativar o t�tulos de cada VIEW/Box criado
oView:EnableTitleView("VIEW_SZ7M","Cabe�alho Solicita��o de Compras")
oView:EnableTitleView("VIEW_SZ7D","Itens de Solicitacao de Compras")
oView:EnableTitleView("VIEW_TOTAL","Resumo da Solicita��ode Compras Totalizada")

/*Metodo que seta um bloco de c�digo para verificar se a janela deve ou n�o
ser fechada ap�s a execu��o do bot�o OK.
*/
oView:SetCloseOnOk({|| .T.})

Return oView

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$//
//Fun��o com retorno logical .T./.F. Para valida��o de Inclus�o, Altera��o ou Exclus�o
User Function GrvSZ7()

Local lRet := .T.
Local aArea     := GetArea()

//Captura o oModel ativo, atr�ves do fun��o FwModelActive() 
Local oModel    := FwModelActive() 

//Acesso oModelo capturando o modelo de Cabe�alho
Local oModelCabec   := oModel:GetModel("SZ7MASTER")

/*Acesso oModelo capturando o modelo de Itens
Modelo responsalv�l pela estrutura aHeader e aCols do Grid*/
Local oModelItem    := oModel:GetModel("SZ7DETAIL")


/*Captiura de valores do cabe�alho, atrav�s do m�todo GetValue 
Carregando as vari�veis que ser�o utilizadas para inserir os registros no banco de dados
*/
Local cFilSZ7     := oModelCabec:GetValue("Z7_FILIAL")
Local cNum        := oModelCabec:GetValue("Z7_NUM")
Local dEmissao    := oModelCabec:GetValue("Z7_EMISSAO")
Local cFornece    := oModelCabec:GetValue("Z7_FORNECE")
Local cLoja       := oModelCabec:GetValue("Z7_LOJA")
Local cUser       := oModelCabec:GetValue("Z7_USER")

//Vari�veis que far�o a captura dos dados com base no aHeader e aCols
Local aHeaderAux  := oModelItem:aHeader
Local aColsAux    := omodelItem:aCols

/*Captura de valores do Grid, usando aScan para localizar a posi��o dos campos*/

Local nPosItem    := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_ITEM")})
Local nPosProd    := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRODUTO")})
Local nPosQtd     := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_QUANT")})
Local nPosPrc     := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRECO")})
Local nPosTotal   := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_TOTAL")})

//Vari�vel para marcar a linha que est� posicionado
Local nLinAtu     := 0

//Vari�vel para indentificar qual o tipo de opera��o (INCLUS�O/ALTERA��O/EXCLUS�O)
Local cOption     := oModelCabec:GetOperation()

//Selecionar a �rea de Registro
DbSelectArea("SZ7")
SZ7->(DbSetOrder(1))

/*$$$$$$$$$$ ESTRUTURA PARA INSERIR/GRAVAR OS REGISTROS NO BANCONDE DADOS $$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
IF cOption == MODEL_OPERATION_INSERT //Se a opera��o for uma inclus�o 
    For nLinAtu := 1 to Len(aColsAux)//Da linha 1 ao tamanho total das colunas

        IF !aColsAux[nLinAtu][Len(aHeaderAux)+1] //Express�o para verificar se h� linhas exclu�das no aCols
       
            RecLock("SZ7",.T.) //Reclock pra grava��o no banco .T. para Incluir .F. para Altera��o/Exclus�o

                //Dados do Cabe�alho
                Z7_FILIAL      := cFilSZ7
                Z7_NUM         := cNum
                Z7_EMISSAO     := dEmissao
                Z7_FORNECE     := cFornece
                Z7_LOJA        := cLoja
                Z7_USER        := cUser

                //Dados do Grid
                Z7_ITEM        := aColsAux[nLinAtu,nPosItem] //array aCols posicionado na linha atual
                Z7_PRODUTO     := aColsAux[nLinAtu,nPosProd]
                Z7_QUANT       := aColsAux[nLinAtu,nPosQtd]
                Z7_PRECO       := aColsAux[nLinAtu,nPosPrc]
                Z7_TOTAL       := aColsAux[nLinatu,nPosTotal]

            SZ7->(MsUnlock())
        ENDIF
    NEXT n //incremento de linha do For

ELSEIF cOption == MODEL_OPERATION_UPDATE //$$$$$$$$$$ ESTRUTURA DE ALTERA��O DE REGISTROS $$$$$$$$$$$$$$$$$$$ 
    For nLinAtu := 1 to Len(aColsAux)//Da linha 1 ao tamanho total das colunas

        IF aColsAux[nLinAtu][Len(aHeaderAux)+1] //Express�o para verificar se h� linhas exclu�das no aCols
            
            //Verifica��o se a linha excluida ja est� inclusa ou n�o
            SZ7->(DbSetOrder(2))//�NDICE FILIAL/NUMERO PEDIDO/ITEM 
            IF SZ7->(DbSeek(cFilSZ7+cNum+aColsAux[nLinAtu,nPosItem])) //Caso encontre o registro ser� deletado
                RecLock("SZ7",.F.)
                DBDELETE()
                SZ7->(MSUNLOCK())
            ENDIF
        
        ELSE//Ap�s a verifica��o de itens deletados, seguimos como altera��o de items 
            SZ7->(DbSetOrder(2))//�NDICE FILIAL/NUMERO PEDIDO/ITEM
            IF SZ7->(DbSeek(cFilSZ7+cNum+aColsAux[nLinAtu,nPosItem])) //Caso encontre o registro ser� alterado 

                RecLock("SZ7",.F.) //Reclock pra grava��o no banco .T. para Incluir .F. para Altera��o/Exclus�o

                    //Dados do Cabe�alho
                    Z7_FILIAL      := cFilSZ7
                    Z7_NUM         := cNum
                    Z7_EMISSAO     := dEmissao
                    Z7_FORNECE     := cFornece
                    Z7_LOJA        := cLoja
                    Z7_USER        := cUser

                    //Dados do Grid
                    Z7_ITEM        := aColsAux[nLinAtu,nPosItem] //array aCols posicionado na linha atual
                    Z7_PRODUTO     := aColsAux[nLinAtu,nPosProd]
                    Z7_QUANT       := aColsAux[nLinAtu,nPosQtd]
                    Z7_PRECO       := aColsAux[nLinAtu,nPosPrc]
                    Z7_TOTAL       := aColsAux[nLinatu,nPosTotal]

            
                SZ7->(MsUnlock())  
            ELSE//Ap�s a verifica��o de detados e altera��o, caso tenha novos itens para serem registrados no  banco
                  RecLock("SZ7",.T.) //Reclock pra grava��o no banco .T. para Incluir .F. para Altera��o/Exclus�o

                    //Dados do Cabe�alho
                    Z7_FILIAL      := cFilSZ7
                    Z7_NUM         := cNum
                    Z7_EMISSAO     := dEmissao
                    Z7_FORNECE     := cFornece
                    Z7_LOJA        := cLoja
                    Z7_USER        := cUser

                    //Dados do Grid
                    Z7_ITEM        := aColsAux[nLinAtu,nPosItem] //array aCols posicionado na linha atual
                    Z7_PRODUTO     := aColsAux[nLinAtu,nPosProd]
                    Z7_QUANT       := aColsAux[nLinAtu,nPosQtd]
                    Z7_PRECO       := aColsAux[nLinAtu,nPosPrc]
                    Z7_TOTAL       := aColsAux[nLinatu,nPosTotal]
            
                SZ7->(MsUnlock())  

            ENDIF          
        ENDIF
    NEXT n //incremento de linha do For


/*$$$$$$$$$$$$$$$$$$$$$ ESTRUTURA PARA DELETAR REGISTROS DA BASE $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
ELSEIF cOption == MODEL_OPERATION_DELETE
    SZ7->(DbSelectArea(1))

    //Busca no banco, enquanto n�o chegar ao final da tabela, busca por Filial e Numero = ao selicionado na tela para deletar 
    WHILE !SZ7->(EOF()) .AND. SZ7->Z7_FILIAL = cFilSZ7 .AND. SZ7->Z7_NUM = cNum  
        RecLock("SZ7",.F.)
            DbDelete()
        SZ7->(MsUnlock())
    SZ7->(DbSkip())
    ENDDO
ENDIF    
RestArea(aArea)

Return lRet 


//$$$$$$$$$$$$$$$$$ VALIDA��O DE INCLUS�O DO CABE�ALHO $$$$$$$$$$$$$$$$$$$$$$$
//Fun��o para imperdir que repita o numero de pedido
User Function VldSZ7()

Local lRet    := .T.
Local aArea   := GetArea()

Local oModel  := FwModelActive() //Trazendo o modelo ativo para a fun��o

Local oModelCabec := oModel:GetModel("SZ7MASTER") //Load do Cabe�alho


Local cFilSZ7     := oModelCabec:GetValue("Z7_FILIAL") //Captura os valores do cabe�alho
Local cNum        := oModelCabec:GetValue("Z7_NUM")

Local nOption     := oModelCabec:GetOperation()

IF nOption == MODEL_OPERATION_INSERT
    DbSelectArea("SZ7")
    SZ7->(DbSetOrder(1))//�ndice 1 FILIAL+NUMERO PEDIDO

    IF SZ7->(DbSeek(cFilSZ7+cNum))

        Help(NIL,NIL,"Escolha outro numero de pedido",NIL,"Este pedido/solicita��o de compra j� existe em nosso sistema",1,0,NIL,NIL,NIL,NIL,NIL,{"ATEN��O"})
        lRet := .F.
    ENDIF
ENDIF
RestArea(aArea)
Return lRet
