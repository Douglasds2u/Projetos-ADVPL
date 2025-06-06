#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/
---------------------------------------------------------------------------
{Protheus.doc} XTRIGGERS()
BIBLIOTECA DE FUNCOES GENERICAS PARA GATILHOS

@author  Douglas Sousa
@since   05/06/2025
@version 1.0
@type    function
---------------------------------------------------------------------------
/*/

User Function XTRIGGERS(cReference, uParams)
    Local uRet  := NIL

    If AllTrim(Upper(cReference)) == 'EFTTAR'
        // --------------------------------------------------------------------
        // GATILHO P/ MUDAR COR DA LEGENDA A PARTIR DA EFETIVACAO DA TAREFA
        // --------------------------------------------------------------------
        uRet := EFTTAR()
    
    ElseIf AllTrim(Upper(cReference)) == 'TARAND'
        // --------------------------------------------------------------------
        // GATILHO P/ MUDAR COR DA LEGENDA QUANDO A TAREFA ESTIVER EM ANDAMENTO
        // --------------------------------------------------------------------
        uRet := TARAND(uParams)

    ElseIf AllTrim(Upper(cReference)) == 'CANEFT'
        // --------------------------------------------------------------------
        // GATILHO P/ MUDAR COR DA LEGENDA QUANDO A TAREFA FOR CANCELADA
        // --------------------------------------------------------------------
        uRet := CANEFT()

    ElseIf AllTrim(Upper(cReference)) == 'HRSAPON'
        // --------------------------------------------------------------------
        // GATILHO P/ QUANTIDADE DE HORAS APONTADAS
        // --------------------------------------------------------------------
        uRet := HRSAPON()

    EndIf



Return(uRet)


/*/
-----------------------------------------------------------------------------------
{Protheus.doc} EFTTAR()
GATILHA STATUS DA LEGENDA PARA EFETIVAÇÃO DA TAREFA

@type user function
@author user
@since 23/05/2025
@version version
-----------------------------------------------------------------------------------
/*/

Static Function EFTTAR()
    Local aArea     := GetArea()
    Local lRet      := .T.
    Local lConfirma := .F.
    Local dDtConc   := dDataBase
    Local cStatus   := Z01->Z01_STATUS    

    If !Empty(dDtConc) .and. cStatus == '2'
        FWAlertInfo("A Tarefa Selecionada: " + Z01->Z01_COD + " já foi efetivada! Posicione em uma Tarefa com a legenda na cor 'Verde' para realizar a efetivação.")
        Return(.F.)
    EndIf

    lConfirma := MsgYesNo("Deseja realmente efetivar a tarefa selecionada? Código: " + Z01->Z01_COD, "Efetivar Tarefa")

        If lConfirma

            RecLock('Z01', .F.)
                Z01->Z01_DTCONC := dDtConc
                Z01->Z01_STATUS := '2'
            Z01->(MsUnlock())

        EndIf

    RestArea(aArea)

Return(lRet)


/*/
-----------------------------------------------------------------------------------
{Protheus.doc} TARAND()
GATILHA LEGENDA AMARELA QUANDO A TAREFA ESTIVER EM ANDAMENTO
@type user function
@author DN
@since 04/06/2025
@version version
-----------------------------------------------------------------------------------
/*/

Static Function TARAND(oModel)
    Local aArea      := GetArea()
    Local aAreaZ02   := Z02->(GetArea())
    Local nOperation := oModel:GetOperation()
    Local oModelZ02  := oModel:GetModel('Z02DETAIL')
    Local cHoraIni   := ''
    Local nLinha     := 0
    Local aSaveLines := FWSaveRows()
    Local lRet       := .T.

    If nOperation == MODEL_OPERATION_INSERT .or. nOperation == MODEL_OPERATION_UPDATE

        For nLinha := 1 To oModelZ02:Length()

            oModelZ02:GoLine(nLinha)

            cHoraIni := oModelZ02:GetValue('Z02_HRINI')

            If !Empty(cHoraIni)
                oModel:GetModel("Z01MASTER"):SetValue("Z01_STATUS", "3")
            EndIf
        Next
    EndIf

    FWRestRows(aSaveLines)
    RestArea(aArea)
    RestArea(aAreaZ02)
Return(lRet)


/*/
-----------------------------------------------------------------------------------
{Protheus.doc} CANEFT()
CANCELA EFETIVAÇÃO DA TAREFA
@type user function
@author DN
@since 23/05/2025
@version version
-----------------------------------------------------------------------------------
/*/
Static Function CANEFT()
    Local aArea     := GetArea()
    Local lRet      := .T.
    Local lConfirma := .F.
    Local dDtConc   := Z01->Z01_DTCONC
    Local cStatus   := Z01->Z01_STATUS

    If Empty(dDtConc) .and. cStatus == '1'
        FWAlertInfo("A Tarefa selecionada: " + Z01->Z01_COD + " está em aberto! Posicione em uma tarefa com a legenda em 'Vermelho' para realizar o cancelamento.")
        Return(.F.)
    EndIf
    
    lConfirma := MsgYesNo("Deseja realmente cancelar a efetivação da tarefa selecionada? Código: " + Z01->Z01_COD, "Cancelar Efetivação")

        If lConfirma
            RecLock('Z01', .F.)
                Z01->Z01_DTCONC := CtoD("")
                Z01->Z01_STATUS := '1'
            Z01->(MsUnlock())
        EndIf

    RestArea(aArea)
    
Return(lRet)

/*/
-----------------------------------------------------------------------------------
{Protheus.doc} HRSAPON()
GATILHA QUANTIDADE DE HORAS APONTADAS
@type user function
@author DN
@since 04/06/2025
@version version
-----------------------------------------------------------------------------------
/*/

Static Function HRSAPON()
    Local aArea     := GetArea()
    Local aAreaZ02  := Z02->(GetArea())
    Local cHoraIni  := ''
    Local cHoraFin  := ''
    Local cHrDescon := ''
    Local cQtdHoras := ''
    Local cTotHoras := ''

    dbSelectArea('Z02')
    dbSetOrder(1)

    If Z02->(DbSeek(xFilial('Z02') + Z01->Z01_COD))
        cHoraIni    := Transform(FwFldGet('Z02_HRINI')    , "@R 99:99:99")
        cHoraFin    := Transform(FwFldGet('Z02_HRFIN')    , "@R 99:99:99")
        cHrDescon   := Transform(FwFldGet('Z02_DESCON')   , "@R 99:99:99")
        cQtdHoras   := ElapTime(cHoraIni, cHoraFin)

        If !Empty(cHoraIni) .and. !Empty(cHoraFin)
            cTotHoras := DecTime(cQtdHoras, Val(SubStr(cHrDescon, 1, 2)), Val(SubStr(cHrDescon, 4, 2)), Val(SubStr(cHrDescon, 7, 2)))
        EndIf

    EndIf

    RestArea(aArea)
    RestArea(aAreaZ02)
Return(cTotHoras)
