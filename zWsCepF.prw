#include "protheus.ch"

/*/{Protheus.doc} User Function zWsCep
Exemplo de consumo de CEP usando FWRest
@type  Function
@author Douglas Sousa
@since 08/11/2024
/*/
User Function zWsCepF()
    Local aArea         := FWGetArea()
    Local aHeader       := {}
    Local cCep          := M->A2_CEP
    Local cRet          := ''
    Local oRestClient   := FWRest():New("https://viacep.com.br/ws")
    Local oJson         := JsonObject():New()
    Local oMdlActive    := Nil
    Local oMdlSA1       := Nil
    

    //Adiciona os headers que serão enviados via WS
    aAdd(aHeader,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
    aAdd(aHeader,'Content-Type: application/json; charset=utf-8')

 
    //Define a url conforme o CEP e aciona o método GET
    oRestClient:setPath("/"+cCep+"/json/")
    If oRestClient:Get(aHeader)
        oJson:FromJson(oRestClient:cResult)
        cRet        := oJson["logradouro"]
        
        oMdlActive  := FWModelActive()
        oMdlSA1     := oMdlActive:GetModel("SA1MASTER")

        oMdlSA1:SetValue('A1_BAIRRO', oJson["bairro"])
        oMdlSA1:SetValue('A1_EST',    oJson["uf"])
        oMdlSA1:SetValue('A1_COD_MUN', SubStr(oJson["ibge"], 3, 5))


    //Senão, pega os erros, e exibe em um Alert
    Else
        cLastError := oRestClient:GetLastError()
        cErrorDetail := oRestClient:GetResult()
        Alert(cErrorDetail)
    Endif  

    FWRestArea(aArea)
Return
