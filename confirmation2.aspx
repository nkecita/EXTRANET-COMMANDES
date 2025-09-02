<%@ Page MasterPageFile="~/MainMasterPage.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">

    
    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        
        
        If Session("client") <> "" Then
            If Request.QueryString("CleEcon") <> "" Then
                If Request.QueryString("CleEcon") = Session("CleEcon") Then
                    Dim MaTrad As New Tool_fichet
                    If Request.QueryString("document") = "commande" Then
                        Response.Redirect("http://econ.fichet-pointfort.fr/commandes/CEW" & Request.QueryString("no").ToString().Substring(6, 4).PadLeft(7, "0") & "_LG.aspx")
                        'Label1.Text = MaTrad.traduction(Session("langue"), "CONFIRMATION", "TEXT1") & " " & Request.QueryString("no").ToString()
                    End If
    
                    If Request.QueryString("document") = "config" Then
                        Label1.Text = MaTrad.traduction(Session("langue"), "CONFIRMATION", "TEXT2") & " " & Request.QueryString("no").ToString()
                    End If

                Else
                    'Response.Redirect("login.aspx")
                End If
            Else
                'Response.Redirect("login.aspx")
            End If

        Else

            'Response.Redirect("login.aspx")
        End If
    End Sub
</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    <%
        If Request.QueryString("document") = "commande" Then
            Select Case Session("langue")
          
                Case "it-IT"
                    Response.Write("<body onLoad='javascript:alert(" & "&quot;" & "Grazie ! Vostro ordine é registrato." & "&quot;" & ");' vlink='#00529c' alink='#7bac17' link='#00529c' bgproperties='fixed' bgcolor='#ffffff' >")
                Case Else
                    Response.Write("<body onLoad='javascript:alert(" & "&quot;" & "Merci ! Votre commande est enregistrée." & "&quot;" & ");' vlink='#00529c' alink='#7bac17' link='#00529c' bgproperties='fixed' bgcolor='#ffffff' >")
            End Select
        
        Else
            Response.Write("<body  vlink='#00529c' alink='#7bac17' link='#00529c' bgproperties='fixed' bgcolor='#ffffff' >")
        End If
       
    
    %>
    <table style="width: 100%;">
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td align='left'>
                <asp:Label ID="Label1" runat="server" Style="color: #003399; text-align: left;"></asp:Label>
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
    &nbsp;<asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Button"
        Visible="False" />
</asp:Content>
