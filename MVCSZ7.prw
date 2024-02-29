#include "Protheus.ch"
#include "FwMvcDef.ch"

/*Função principal para construção da tela de solicitação de compras da empresa 
Protheuzeiro Strong S/A, com base em uma proposta ficticia, com a necessidade em trazer
Fornecedor no cabeçalho e Produtos em itens, gravando as infromções na mesma tabela (SZ7)*/

User Function MVCSZ7()

Local aArea   := GetArea()

Local oBrowse := FwmBrowse():New()

oBrowse:SetAlias("SZ7")
oBrowse:SetDescription("Solicitação de Compras")

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

//Objeto responsável pela criação da estrutura Temporária do cabeçalho
Local oStCabec      := FwFormModelStruct():New()

//Objeto responsável pela estrutura do itens
Local oStItens      := FwFormStruct(1,"SZ7")

Local bVldPos       := {|| u_VldSZ7()} //Chamada da User Function Pos Validation que validará a inclusão ante de ir para o Grid

Local bVldCom       := {|| u_GrvSZ7()} //chamada da User Function Commit que validará a Inclusão/Alteração/Exclusão

//Objeto responsavel pela características do dicionario de dados, como também é resposável pela estrutura de tabelas campos e registros
Local oModel        := MpFormModel():New("MVCSZ7m",/*bPre*/,bVldPos/*bPos*/,bVldCom/*bComit*/,/*bCancel*/)

//Variáveis que armazenarão a estrutura da Trigger dos campos quantidade e preço, que irá gerar o conteúdo do campo valor total
Local aTrigQuant  := {}
Local aTrigPreco  := {}


//Criação da Tabela temporária que será utilizada no cabeçalho
oStCabec:AddTable("SZ7",{"Z7_FILIAL","Z7_NUM","Z7_ITEM"},"Cabeçalho SZ7")

//Criação dos campos da tabela temporária
oStCabec:AddField(;
    "Filial",;                                                                                  // [01]  C   Titulo do campo
    "Filial",;                                                                                  // [02]  C   ToolTip do campo
    "Z7_FILIAL",;                                                                               // [03]  C   Id do Field
    "C",;                                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_FILIAL")[1],;                                                                    // [05]  N   Tamanho do campo
    0,;                                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                                       // [07]  B   Code-block de validação do campo
    Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
    {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_FILIAL,FWxFilial('SZ7'))" ),;   // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .F.)                                                                                        // [14]  L   Indica se o campo é virtual

oStCabec:AddField(;
    "Pedido",;                                                                                  // [01]  C   Titulo do campo
    "Pedido",;                                                                                  // [02]  C   ToolTip do campo
    "Z7_NUM",;                                                                                  // [03]  C   Id do Field
    "C",;                                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_NUM")[1],;                                                                       // [05]  N   Tamanho do campo
    0,;                                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                                       // [07]  B   Code-block de validação do campo
    Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
    {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD, 'Iif(!INCLUI,SZ7->Z7_NUM,GETSXENUM("SZ7","Z7_NUM"))' ),;                    // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .F.)                                                                                        // [14]  L   Indica se o campo é virtual

oStCabec:AddField(;
    "Emissao",;                                                                                 // [01]  C   Titulo do campo
    "Emissao",;                                                                                 // [02]  C   ToolTip do campo
    "Z7_EMISSAO",;                                                                              // [03]  C   Id do Field
    "D",;                                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_EMISSAO")[1],;                                                                   // [05]  N   Tamanho do campo
    0,;                                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                                       // [07]  B   Code-block de validação do campo
    Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
    {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_EMISSAO,dDataBase)" ),;         // [11]  B   Code-block de inicializacao do campo
    .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .F.)                                                                                        // [14]  L   Indica se o campo é virtual


oStCabec:AddField(;
    "Fornecedor",;                                                              // [01]  C   Titulo do campo
    "Fornecedor",;                                                              // [02]  C   ToolTip do campo
    "Z7_FORNECE",;                                                              // [03]  C   Id do Field
    "C",;                                                                       // [04]  C   Tipo do campo
    TamSX3("Z7_FORNECE")[1],;                                                   // [05]  N   Tamanho do campo
    0,;                                                                         // [06]  N   Decimal do campo
    Nil,;                                                                       // [07]  B   Code-block de validação do campo
    Nil,;                                                                       // [08]  B   Code-block de validação When do campo
    {},;                                                                        // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_FORNECE,'')" ),;// [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                       // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .F.)                                                                        // [14]  L   Indica se o campo é virtual

oStCabec:AddField(;
    "Loja",;                                                                      // [01]  C   Titulo do campo
    "Loja",;                                                                      // [02]  C   ToolTip do campo
    "Z7_LOJA",;                                                                   // [03]  C   Id do Field
    "C",;                                                                         // [04]  C   Tipo do campo
    TamSX3("Z7_LOJA")[1],;                                                        // [05]  N   Tamanho do campo
    0,;                                                                           // [06]  N   Decimal do campo
    Nil,;                                                                         // [07]  B   Code-block de validação do campo
    Nil,;                                                                         // [08]  B   Code-block de validação When do campo
    {},;                                                                          // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                         // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_LOJA,'')" ),;     // [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                         // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                         // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .F.)                                                                          // [14]  L   Indica se o campo é virtual

oStCabec:AddField(;
    "Usuario",;                                                                     // [01]  C   Titulo do campo
    "Usuario",;                                                                     // [02]  C   ToolTip do campo
    "Z7_USER",;                                                                     // [03]  C   Id do Field
    "C",;                                                                           // [04]  C   Tipo do campo
    TamSX3("Z7_USER")[1],;                                                          // [05]  N   Tamanho do campo
    0,;                                                                             // [06]  N   Decimal do campo
    Nil,;                                                                           // [07]  B   Code-block de validação do campo
    Nil,;                                                                           // [08]  B   Code-block de validação When do campo
    {},;                                                                            // [09]  A   Lista de valores permitido do campo
    .T.,;                                                                           // [10]  L   Indica se o campo tem preenchimento obrigatório
    FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,SZ7->Z7_USER,__cuserid)" ),;// [11]  B   Code-block de inicializacao do campo
    .F.,;                                                                           // [12]  L   Indica se trata-se de um campo chave
    .F.,;                                                                           // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    .F.)                                                                            // [14]  L   Indica se o campo é virtual

//Tratando a estrutura dos Itens, que serão utilizados no Grid da aplicação

//Modificando Inicializadores Padrao,  para não dar mensagem de colunas vazias
oStItens:SetProperty("Z7_NUM",      MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
oStItens:SetProperty("Z7_USER",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '__cUserId')) //Trazer o usuário automatico
oStItens:SetProperty("Z7_EMISSAO",  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'dDatabase')) //Trazer a data automática
oStItens:SetProperty("Z7_FORNECE",  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
oStItens:SetProperty("Z7_LOJA",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))

//Chamo a função FwStructTrigger para montar o bloco de código
aTrigQuant  := FwStruTrigger(;
"Z7_QUANT",;  //Campo que irá disparar o gatilho/trigger
"Z7_TOTAL",;  //Campo que irá receber o conteúdo do  gatilho
"M->Z7_QUANT * M->Z7_PRECO",; //Conteúdo que irá para o campo Z7_TOTAL
.F.)

aTrigPreco  := FwStruTrigger(;
"Z7_PRECO",;  //Campo que irá disparar o gatilho/trigger
"Z7_TOTAL",;  //Campo que irá receber o conteúdo do  gatilho
"M->Z7_QUANT * M->Z7_PRECO",; //Conteúdo que irá para o campo Z7_TOTAL
.F.)

//Adicionando as Triggers á minha estrutura de items 
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


//União das estruturas vinculando cabeçalho com itens 
//também a vinculação da estrutura de dados dos itens  ao modelo

oModel:AddFields("SZ7MASTER",,oStCabec)

oModel:AddGrid("SZ7DETAIL","SZ7MASTER",oStItens,,,,,)

//Adicionando model de totalizadores á aplicação

            //IDMODELO          MASTER CABEC.   DETALHE GRID    CAMPO CALC.     NOMEPERSONALIZADO CAMPO  OPERAÇÃO    NOME TOTALIZADOR   
oModel:AddCalc("CALCTOTAL",     "SZ7MASTER",    "SZ7DETAIL",    "Z7_PRODUTO",       "QTDITENS",           "COUNT",,,  "Numero de Pedidos" )
oModel:AddCalc("CALCTOTAL",     "SZ7MASTER",    "SZ7DETAIL",    "Z7_QUANT",       "QTDTOTAL",             "SUM"  ,,,    "Total de Itens" )
oModel:AddCalc("CALCTOTAL",     "SZ7MASTER",    "SZ7DETAIL",    "Z7_TOTAL",       "VALORTOTAL",           "SUM"  ,,,    "Valor Total Solicitação" )
//Definindo a relação entre cabeçalho e item, através dos campos de Grid ao Cabeçalho
aRelations := {}        //Cabeçalho
aAdd(aRelations,{"Z7_FILIAL",'IIF(!INCLUI, SZ7->Z7_FILIAL, FwxFilial("SZ7"))'})
aAdd(aRelations,{"Z7_NUM","SZ7->Z7_NUM"})
                      //Grid Recebe
oModel:SetRelation("SZ7DETAIL",aRelations,SZ7->(IndexKey(1)))

//Definição de chave primária  
oModel:SetPrimaryKey({})

//Impedindo que o campo se repita
oModel:GetModel("SZ7DETAIL"):SetUniqueline({"Z7_ITEM"})

//Definição de titulo do Cabeçalho
oModel:GetModel("SZ7MASTER"):SetDescription("CABEÇALHO DA SOLICITAÇÃO DE COMPRAS")

//Definição de titulo do Grid
oModel:GetModel("SZ7DETAIL"):SetDescription("ITENS DA SOLICITAÇÃO DE COMPRAS")

//Finalizando a função do model
oModel:GetModel("SZ7DETAIL"):SetUseOldGrid(.T.) //Finalizando setando o modelo antigo de Grid, que permite pegar aHeader e aCols

Return oModel

//Objeto de visualizção do fonte MVC
Static Function ViewDef()

Local oView     := Nil

Local oModel        := FwLoadModel("MVCSZ7")

//Objeto encarregado de montar a estrutura temporária do cabeçalho da View
Local oStCabec      := FwFormViewStruct():New()

//Etrutura de dados para os totalizadores
Local oStTotais := FwCalcStruct(oModel:GetModel('CALCTOTAL'))

/* Objeto responsável por montar a parte de estrutura dos itens/grid
Como estou usando FwFormStruct, ele traz a estrutura de TODOS OS CAMPOS, sendo assim
caso eu não queira que algum campo, apareça na minha grid, eu devo remover este campo com RemoveField
*/
Local oStItens      := FwFormStruct(2,"SZ7") //1 Para estrutura Model / 2 para estrutura View

//Crio dentro da estrutura da View, os campos do cabeçalho

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
    .F.,;    	                // [10]  L   Indica se o campo é alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo é virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)                        // [18]  L   Indica pulo de linha após o campo

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
    Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo é alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo é virtual
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
    Iif(INCLUI, .T., .F.),;         // [10]  L   Indica se o campo é alteravel
    Nil,;                           // [11]  C   Pasta do campo
    Nil,;                           // [12]  C   Agrupamento do campo
    Nil,;                           // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                           // [14]  N   Tamanho maximo da maior opção do combo
    Nil,;                           // [15]  C   Inicializador de Browse
    Nil,;                           // [16]  L   Indica se o campo é virtual
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
    Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo é alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo é virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil)

oStCabec:AddField(;
    "Z7_USER",;                 // [01]  C   Nome do Campo
    "05",;                      // [02]  C   Ordem
    "Usuário",;                 // [03]  C   Titulo do campo
    X3Descric('Z7_USER'),;      // [04]  C   Descricao do campo
    Nil,;                       // [05]  A   Array com Help
    "C",;                       // [06]  C   Tipo do campo
    X3Picture("Z7_USER"),;      // [07]  C   Picture
    Nil,;                       // [08]  B   Bloco de PictTre Var
    Nil,;                       // [09]  C   Consulta F3
    .F.,;                       // [10]  L   Indica se o campo é alteravel
    Nil,;                       // [11]  C   Pasta do campo
    Nil,;                       // [12]  C   Agrupamento do campo
    Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
    Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
    Nil,;                       // [15]  C   Inicializador de Browse
    Nil,;                       // [16]  L   Indica se o campo é virtual
    Nil,;                       // [17]  C   Picture Variavel
    Nil) 

oStItens:RemoveField("Z7_NUM")
oStItens:RemoveField("Z7_EMISSAO")
oStItens:RemoveField("Z7_FORNECE")            
oStItens:RemoveField("Z7_LOJA")      
oStItens:RemoveField("Z7_USER") 

//Bloqueando a edição dos campos   ITEM E TOTAL da grid
oStItens:SetProperty("Z7_ITEM",   MVC_VIEW_CANCHANGE,.F.)
oStItens:SetProperty("Z7_TOTAL",  MVC_VIEW_CANCHANGE,.F.)

/*Segunda parte da ViewDef, onde amarramos as estruturas de dados, montadas acima
com o objeto oView, e passamos para a nossa aplicação todas as características visuais do projetos
*/

//Instancio a classe FwFormView para o objeto view
oView := FwFormView():New()

//Passo para o objeto View o modelo de dados que quero atrelar à ele Modelo + Visualização
oView:SetModel(oModel)

//Monto a estrutura de visualização do Master e do Detalhe (Cabeçalho e Itens)
oView:AddField("VIEW_SZ7M",oStCabec,"SZ7MASTER") //Cabeçalho/Master
oView:AddGrid("VIEW_SZ7D", oStItens,"SZ7DETAIL") //Itens/Grid

oView:AddField("VIEW_TOTAL",oStTotais,"CALCTOTAL")//View dos totalizadores

//Deixando o campo item incremental, adiciona + 1 a proximo item formando uma senquencia 1, 2, 3..
oView:AddIncrementField("SZ7DETAIL","Z7_ITEM")

//Criação da Tela, dividindo proporcionalmente o tamanho do cabeçalho e o tamanho do Grid
oView:CreateHorizontalBox("CABEC",30)
oView:CreateHorizontalBox("GRID", 50)
oView:CreateHorizontalBox("TOTAL", 20)

/*Definindo para onde vão cada View Criada, VIEW_SZ7M irá para a cabec
VIEW_SZ7D irá para GRID... Sendo assim, eu associo o View à cada Box criado
*/
oView:SetOwnerView("VIEW_SZ7M","CABEC") 
oView:SetOwnerView("VIEW_SZ7D","GRID") 
oView:SetOwnerView("VIEW_TOTAL","TOTAL")

//Ativar o títulos de cada VIEW/Box criado
oView:EnableTitleView("VIEW_SZ7M","Cabeçalho Solicitação de Compras")
oView:EnableTitleView("VIEW_SZ7D","Itens de Solicitacao de Compras")
oView:EnableTitleView("VIEW_TOTAL","Resumo da Solicitaçãode Compras Totalizada")

/*Metodo que seta um bloco de código para verificar se a janela deve ou não
ser fechada após a execução do botão OK.
*/
oView:SetCloseOnOk({|| .T.})

Return oView

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$//
//Função com retorno logical .T./.F. Para validação de Inclusão, Alteração ou Exclusão
User Function GrvSZ7()

Local lRet := .T.
Local aArea     := GetArea()

//Captura o oModel ativo, atráves do função FwModelActive() 
Local oModel    := FwModelActive() 

//Acesso oModelo capturando o modelo de Cabeçalho
Local oModelCabec   := oModel:GetModel("SZ7MASTER")

/*Acesso oModelo capturando o modelo de Itens
Modelo responsalvél pela estrutura aHeader e aCols do Grid*/
Local oModelItem    := oModel:GetModel("SZ7DETAIL")


/*Captiura de valores do cabeçalho, através do método GetValue 
Carregando as variáveis que serão utilizadas para inserir os registros no banco de dados
*/
Local cFilSZ7     := oModelCabec:GetValue("Z7_FILIAL")
Local cNum        := oModelCabec:GetValue("Z7_NUM")
Local dEmissao    := oModelCabec:GetValue("Z7_EMISSAO")
Local cFornece    := oModelCabec:GetValue("Z7_FORNECE")
Local cLoja       := oModelCabec:GetValue("Z7_LOJA")
Local cUser       := oModelCabec:GetValue("Z7_USER")

//Variáveis que farão a captura dos dados com base no aHeader e aCols
Local aHeaderAux  := oModelItem:aHeader
Local aColsAux    := omodelItem:aCols

/*Captura de valores do Grid, usando aScan para localizar a posição dos campos*/

Local nPosItem    := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_ITEM")})
Local nPosProd    := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRODUTO")})
Local nPosQtd     := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_QUANT")})
Local nPosPrc     := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRECO")})
Local nPosTotal   := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_TOTAL")})

//Variável para marcar a linha que está posicionado
Local nLinAtu     := 0

//Variável para indentificar qual o tipo de operação (INCLUSÃO/ALTERAÇÃO/EXCLUSÃO)
Local cOption     := oModelCabec:GetOperation()

//Selecionar a área de Registro
DbSelectArea("SZ7")
SZ7->(DbSetOrder(1))

/*$$$$$$$$$$ ESTRUTURA PARA INSERIR/GRAVAR OS REGISTROS NO BANCONDE DADOS $$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
IF cOption == MODEL_OPERATION_INSERT //Se a operação for uma inclusão 
    For nLinAtu := 1 to Len(aColsAux)//Da linha 1 ao tamanho total das colunas

        IF !aColsAux[nLinAtu][Len(aHeaderAux)+1] //Expressão para verificar se há linhas excluídas no aCols
       
            RecLock("SZ7",.T.) //Reclock pra gravação no banco .T. para Incluir .F. para Alteração/Exclusão

                //Dados do Cabeçalho
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

ELSEIF cOption == MODEL_OPERATION_UPDATE //$$$$$$$$$$ ESTRUTURA DE ALTERAÇÃO DE REGISTROS $$$$$$$$$$$$$$$$$$$ 
    For nLinAtu := 1 to Len(aColsAux)//Da linha 1 ao tamanho total das colunas

        IF aColsAux[nLinAtu][Len(aHeaderAux)+1] //Expressão para verificar se há linhas excluídas no aCols
            
            //Verificação se a linha excluida ja está inclusa ou não
            SZ7->(DbSetOrder(2))//ÍNDICE FILIAL/NUMERO PEDIDO/ITEM 
            IF SZ7->(DbSeek(cFilSZ7+cNum+aColsAux[nLinAtu,nPosItem])) //Caso encontre o registro será deletado
                RecLock("SZ7",.F.)
                DBDELETE()
                SZ7->(MSUNLOCK())
            ENDIF
        
        ELSE//Após a verificação de itens deletados, seguimos como alteração de items 
            SZ7->(DbSetOrder(2))//ÍNDICE FILIAL/NUMERO PEDIDO/ITEM
            IF SZ7->(DbSeek(cFilSZ7+cNum+aColsAux[nLinAtu,nPosItem])) //Caso encontre o registro será alterado 

                RecLock("SZ7",.F.) //Reclock pra gravação no banco .T. para Incluir .F. para Alteração/Exclusão

                    //Dados do Cabeçalho
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
            ELSE//Após a verificação de detados e alteração, caso tenha novos itens para serem registrados no  banco
                  RecLock("SZ7",.T.) //Reclock pra gravação no banco .T. para Incluir .F. para Alteração/Exclusão

                    //Dados do Cabeçalho
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

    //Busca no banco, enquanto não chegar ao final da tabela, busca por Filial e Numero = ao selicionado na tela para deletar 
    WHILE !SZ7->(EOF()) .AND. SZ7->Z7_FILIAL = cFilSZ7 .AND. SZ7->Z7_NUM = cNum  
        RecLock("SZ7",.F.)
            DbDelete()
        SZ7->(MsUnlock())
    SZ7->(DbSkip())
    ENDDO
ENDIF    
RestArea(aArea)

Return lRet 


//$$$$$$$$$$$$$$$$$ VALIDAÇÃO DE INCLUSÃO DO CABEÇALHO $$$$$$$$$$$$$$$$$$$$$$$
//Função para imperdir que repita o numero de pedido
User Function VldSZ7()

Local lRet    := .T.
Local aArea   := GetArea()

Local oModel  := FwModelActive() //Trazendo o modelo ativo para a função

Local oModelCabec := oModel:GetModel("SZ7MASTER") //Load do Cabeçalho


Local cFilSZ7     := oModelCabec:GetValue("Z7_FILIAL") //Captura os valores do cabeçalho
Local cNum        := oModelCabec:GetValue("Z7_NUM")

Local nOption     := oModelCabec:GetOperation()

IF nOption == MODEL_OPERATION_INSERT
    DbSelectArea("SZ7")
    SZ7->(DbSetOrder(1))//Índice 1 FILIAL+NUMERO PEDIDO

    IF SZ7->(DbSeek(cFilSZ7+cNum))

        Help(NIL,NIL,"Escolha outro numero de pedido",NIL,"Este pedido/solicitação de compra já existe em nosso sistema",1,0,NIL,NIL,NIL,NIL,NIL,{"ATENÇÃO"})
        lRet := .F.
    ENDIF
ENDIF
RestArea(aArea)
Return lRet
