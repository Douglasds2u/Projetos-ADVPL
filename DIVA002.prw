#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* ---------------------------------------------------
Nome: DIVA002
Rotina para cadastro de Médicos.
Autor: Douglas Sousa
Data: 18/12/2024
---------------------------------------------------- */

Static cTitulo   := "Cadastro de Médicos"
Static cAlias    := "ZA2"

User Function DIVA002()
    Local aArea := GetArea()
    Local oBrowse := Nil
    Private aRotina := {}

    //--DEFINIÇÃO DOS MENUS
    aRotina := MenuDef()

    //--INSTANCIA O BROWSE
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAlias)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()

    oBrowse:Activate()

    RestArea(aArea)
Return

//--DEFINE OS MENUS DO BROWSE
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.DIVA002" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.DIVA002" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.DIVA002" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluír"      ACTION "VIEWDEF.DIVA002" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imprimir"     ACTION "VIEWDEF.DIVA002" OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"       ACTION "VIEWDEF.DIVA002" OPERATION 9 ACCESS 0
Return aRotina

//--DIFINIÇÃO DO MODELO DE DADOS
Static Function ModelDef()
    Local oModel  := Nil
    Local oStruct := FWFormStruct(1, cAlias)
    Local bPre    := Nil
    Local bPos    := Nil
    Local bCommit := Nil
    Local bCancel := Nil

    oModel := MPFormModel():New("MEDICOSM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZA2MASTER", /*cOwner*/, oStruct)
    oModel:SetDescription("Cadastro de Médicos")
    oModel:GetModel("ZA2MASTER"):SetDescription("Cadastro de Médicos")
    oModel:SetPrimaryKey({})
Return oModel

//--CAMADA VISUAL DA TABELA
Static Function ViewDef()
    Local oModel  := FWLoadModel("DIVA002")
    Local oStruct := FWFormStruct(2, cAlias)
    Local oView   := Nil

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZA2", oStruct, "ZA2MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_ZA2", "TELA")
Return oView 
