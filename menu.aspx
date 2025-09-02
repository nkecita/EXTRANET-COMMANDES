<%@  MasterPageFile="~/MainMasterPage.master" %>

<script runat="server">
   
    Function affiche_menu() As System.Data.DataSet
        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
    
        Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)
    
        Dim queryString As String = "SELECT [menu].* FROM [menu]" & " where codepays=" & "'" & Session("langue") & "'"
        Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        dbCommand.CommandText = queryString
        dbCommand.Connection = dbConnection
		
        Dim dataAdapter As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
        dataAdapter.SelectCommand = dbCommand
        Dim dataSet As System.Data.DataSet = New System.Data.DataSet
        dataAdapter.Fill(dataSet)
    
        If dataSet.Tables(0).Rows.Count() > 0 Then
            
            Response.Write("<table border='0' cellspacing='0' width='400px' class='main_menu'>")
            Response.Write("<tr>")
            Response.Write("<td class='e_menu_title'>")
            
            Dim mytrad As New Tool_fichet
            
            Response.Write("<div>" & mytrad.traduction(Session("langue"), "MENU", "TITRE1") & "</font></div>")
            
            Response.Write("</td>")
            Response.Write("</tr>")
            
    
            Dim i As Integer
            Dim url_menu As String
            Response.Write("<tr>")
            Response.Write("<td class='e_color_back'>")
            Response.Write("<div align='left'><ul>")
            For i = 1 To dataSet.Tables(0).Columns.Count - 1
               
                If IsDBNull(dataSet.Tables(0).Rows(0).Item(i)) = False Then
          
                    url_menu = dataSet.Tables(0).Rows(0).Item(i)
                    url_menu = url_menu.Replace("client=", "client=" & Session("client"))
                    url_menu = url_menu.Replace("tarif=", "tarif=" & Session("tarif"))
                    url_menu = url_menu.Replace("frais=", "frais=" & Session("frais"))
                    url_menu = url_menu.Replace("tva=", "tva=" & Session("tva"))
                    url_menu = url_menu.Replace("langue=", "langue=" & Session("langue"))
                    If url_menu.Length > 1 Then
                        Response.Write("<li style='padding-top:10px'>" & url_menu & "</li>")
                    End If
                
                End If
                
                
            Next i
            
            ' traitement des clients Valideur
            
            Dim commandtext As String
            commandtext = "Select clients_new.CodeClient,num_commande,dtcomm,societe,modele,prix_valideur,prix_pointfort,langue FROM commandes_portes "
            commandtext = commandtext + " LEFT OUTER JOIN clients_new ON clients_new.CodeClient = commandes_portes.num_client "
            commandtext = commandtext + " LEFT OUTER JOIN signature ON signature.CodeClient = clients_new.CodeClient "
            commandtext = commandtext + " WHERE (signature.CodeValideur = '" & Session("client") & "' AND (commandes_portes.status = '0')"
            commandtext = commandtext + " AND (transfert = 'non' or transfert is null)) "



            Dim connectionString2 As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
    
            Dim dbConnection2 As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString2)

            Dim dbCommand2 As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
            dbCommand2.CommandText = commandtext
            dbCommand2.Connection = dbConnection2

            Dim dataAdapter2 As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
            dataAdapter2.SelectCommand = dbCommand2
            Dim dataSet2 As System.Data.DataSet = New System.Data.DataSet
            dataAdapter2.Fill(dataSet2)

            If dataSet2.Tables(0).Rows.Count() > 0 Then
                Response.Write("<li style='padding-top:10px'><u><a href='commandes_validation.aspx'>" & mytrad.traduction(Session("langue"), "MENU", "VALIDEUR") & "</a></u></font></li>")
                    
            End If
            Response.Write("</ul></div>")
            
            Response.Write("</td>")
            
            Response.Write("</tr>")
          
            Response.Write("</table>")

        End If
    
    End Function

</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    <% = affiche_menu()%>
</asp:Content>