#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* ---------------------------------------------------
Nome: DIVA001
Rotina para cadastro de pacientes.
Autor: Douglas Sousa
Data: 12/12/2024
---------------------------------------------------- */

Static cTitulo   := "Cadastro de Pacientes"
Static cAlias    := "ZA1"

User Function DIVA001()
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

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.DIVA001" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.DIVA001" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.DIVA001" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluír"      ACTION "VIEWDEF.DIVA001" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imprimir"     ACTION "VIEWDEF.DIVA001" OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"       ACTION "VIEWDEF.DIVA001" OPERATION 9 ACCESS 0
Return aRotina

//--DIFINIÇÃO DO MODELO DE DADOS
Static Function ModelDef()
    Local oModel  := Nil
    Local oStruct := FWFormStruct(1, cAlias)
    Local bPre    := Nil
    Local bPos    := Nil
    Local bCommit := Nil
    Local bCancel := Nil

    oModel := MPFormModel():New("PACIENTM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZA1MASTER", /*cOwner*/, oStruct)
    oModel:SetDescription("Cadastro de Pacientes")
    oModel:GetModel("ZA1MASTER"):SetDescription("Cadastro de Pacientes")
    oModel:SetPrimaryKey({})
Return oModel

//--CAMADA VISUAL DA TABELA
Static Function ViewDef()
    Local oModel  := FWLoadModel("DIVA001")
    Local oStruct := FWFormStruct(2, cAlias)
    Local oView   := Nil

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZA1", oStruct, "ZA1MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_ZA1", "TELA")
Return oView
