<%@ Page MasterPageFile="~/MainMasterPage.master" %>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    <div align="center" style="height: 800px; width: 810px">
        <br />
        <iframe name="I1" src="<%
                           
                               dim url as string
                               url = "bridgeasp.asp?"
                               url = url & "client=" & request.querystring("client")
                               url = url & "&tarif=" & request.querystring("tarif")
                               url = url & "&frais=" & request.querystring("frais")
                               url = url & "&tva=" & request.querystring("tva")
                               url = url & "&page=" & request.querystring("page")
                               
                                response.write(url)
                           
                            %>" frameborder="0" scrolling="no" style="height: 96%; width: 100%">
            Votre navigateur ne prend pas en charge les cadres insérés ou est actuellement configuré
            pour ne pas les afficher. </iframe>
    </div>
</asp:Content>
