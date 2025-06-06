#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* ---------------------------------------------------
Nome: TARMVC.PRW
Rotina para cadastro de Tarefas.
Autor: Douglas Sousa
Data: 22/05/2025
---------------------------------------------------- */

User Function TARMVC()
    Local oBrowse

    oBrowse := FWmBrowse():New()
    oBrowse:SetAlias('Z01')
    oBrowse:SetDescription( 'Apontamento de Tarefas' )

    oBrowse:AddLegend("Z01->Z01_STATUS == '1'", "BR_VERDE"     , "Em Aberto")
    oBrowse:AddLegend("Z01->Z01_STATUS == '2'", "BR_VERMELHO"  , "Concluído")
    oBrowse:AddLegend("Z01->Z01_STATUS == '3'", "BR_AMARELO"   , "Em Andamento")

    oBrowse:DisableDetails()

    oBrowse:Activate()
Return

//--DEFINE OS MENUS DO BROWSE
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"          ACTION "VIEWDEF.TARMVC"          OPERATION 2  ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"             ACTION "VIEWDEF.TARMVC"          OPERATION 3  ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"             ACTION "VIEWDEF.TARMVC"          OPERATION 4  ACCESS 0
    ADD OPTION aRotina TITLE "Excluír"             ACTION "VIEWDEF.TARMVC"          OPERATION 5  ACCESS 0
    ADD OPTION aRotina TITLE "Legenda"             ACTION "U_Z01LEG"                OPERATION 6  ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"              ACTION "VIEWDEF.TARMVC"          OPERATION 9  ACCESS 0
    ADD OPTION aRotina TITLE "Efetivar"            ACTION "U_XTRIGGERS('EFTTAR')"   OPERATION 10 ACCESS 0
    ADD OPTION aRotina TITLE "Cancelar Efetivação" ACTION "U_XTRIGGERS('CANEFT')"   OPERATION 11 ACCESS 0
Return aRotina

//--DIFINIÇÃO DO MODELO DE DADOS
Static Function ModelDef()
    Local oStruZ01  := FWFormStruct(1, 'Z01',,)
    Local oStruZ02  := FWFormStruct(1, 'Z02',,)
    Local oModel    := Nil

    oModel := MPFormModel():New('CADTAFM',{|oModel| U_XTRIGGERS('TARAND', oModel)},,,)
    oModel:AddFields('Z01MASTER', /*cOwner*/, oStruZ01)
    oModel:AddGrid('Z02DETAIL', 'Z01MASTER', oStruZ02)

    oModel:SetRelation('Z02DETAIL', {{'Z02_FILIAL', 'xFilial("Z02")'}, {'Z02_COD', 'Z01_COD'}}, Z02->( IndexKey( 1 )))
    oModel:SetDescription('Cadastro de Tarefas')

    oModel:GetModel('Z01MASTER'):SetDescription('Cadastro de Tarefas')
    oModel:GetModel('Z02DETAIL'):SetDescription('Tarefas')

    oModel:SetPrimaryKey({'Z01_FILIAL', 'Z01_COD'})

Return oModel

//--CAMADA VISUAL DA TABELA
Static Function ViewDef()
    Local oStruZ01  := FWFormStruct(2, 'Z01')
    Local oStruZ02  := FWFormStruct(2, 'Z02')
    Local oModel    := FWLoadModel('TARMVC')
    Local oView     := Nil

    oView := FWFormView():New()
    oView:SetModel(oModel)

    oView:AddField('VIEW_Z01', oStruZ01, 'Z01MASTER')
    oView:AddGrid('VIEW_Z02', oStruZ02, 'Z02DETAIL')

    oView:CreateHorizontalBox('SUPERIOR', 40)
    oView:CreateHorizontalBox('INFERIOR', 60)

    oView:SetOwnerView('VIEW_Z01', 'SUPERIOR')
    oView:SetOwnerView('VIEW_Z02', 'INFERIOR')

    oView:AddIncrementField('VIEW_Z02', 'Z02_ITEM')

    oView:EnableTitleView('VIEW_Z02','Tarefas')
    oView:SetViewProperty('VIEW_Z02', 'GRIDSEEK', {.T.})

    oStruZ02:Removefield('Z02_COD')

Return oView


/*/
--------------------------------------------------------------------------
{Protheus.doc} Z01LEG()
LEGENDA COLORIDA DO BROWSE INDICANDO O STATUS
@type user function
@author Douglas Sousa
@since 23/05/2025
@version version
--------------------------------------------------------------------------
/*/
User Function Z01LEG()
    Local aLegenda  := {}

    aAdd(aLegenda, {"BR_VERDE"     , "Em Aberto"})
    aAdd(aLegenda, {"BR_VERMELHO"  , "Concluído"})
    aAdd(aLegenda, {"BR_AMARELO"   , "Em Andamento"})

    BrwLegenda("Status", "Tarefas", aLegenda)

Return(aLegenda)
