<%@  MasterPageFile="~/MainMasterPagetoken.master" %>

<script runat="server">
 
    Dim mytrad As New Tool_fichet
   
    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
        Msg.Text = ""
        Button1.Text = mytrad.traduction(Session("langue"), "MODIF_PASSE", "BUTTON1")
    End Sub
    
    
    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        
        If oldpass.Text = "" Then
            Msg.Text = mytrad.traduction(Session("langue"), "MODIF_PASSE", "MSG5")
        ElseIf newpass.Text = "" Then
            Msg.Text = mytrad.traduction(Session("langue"), "MODIF_PASSE", "MSG6")
        ElseIf confpass.Text = "" Then
            Msg.Text = mytrad.traduction(Session("langue"), "MODIF_PASSE", "MSG7")
        ElseIf newpass.Text <> confpass.Text Then
            Msg.Text = mytrad.traduction(Session("langue"), "MODIF_PASSE", "MSG1")
        Else
            ' Modification autorisée
            
            Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
            Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)

            Dim queryString As String = "UPDATE [clients_new] SET [password]=@password"
            queryString = queryString & " where codeclient = '" & Session("client") & "'"
            queryString = queryString & " and password = '" & oldpass.Text & "'"

			'Dim queryString As String = "UPDATE [motdepasse] SET [motdepasse]=@password"
            'queryString = queryString & " where codeclient = '" & Session("client") & "'"
            'queryString = queryString & " and motdepasse = '" & oldpass.Text & "'"


            Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
            dbCommand.CommandText = queryString
            dbCommand.Connection = dbConnection

            Dim dbParam_password As System.Data.IDataParameter = New System.Data.SqlClient.SqlParameter
            dbParam_password.ParameterName = "@password"
            dbParam_password.Value = newpass.Text
            dbParam_password.DbType = System.Data.DbType.[String]
            dbCommand.Parameters.Add(dbParam_password)

            Dim rowsAffected As Integer = 0
            dbConnection.Open()
            Try
                rowsAffected = dbCommand.ExecuteNonQuery
            
               
           
            
				If rowsAffected = 1 Then
					Msg.Text = mytrad.traduction(Session("langue"), "MODIF_PASSE", "MSG4")
					Msg.ForeColor = Drawing.Color.Green
					
					dim Cmdsql as string = "UPDATE [motdepasse] SET motdepasse=@password where codeclient = '" & Session("client") & "'"
					dbCommand.CommandText = Cmdsql
					'dbParam_password.ParameterName = "@password"
					dbParam_password.Value = newpass.Text
					'dbParam_password.DbType = System.Data.DbType.[String]
					'dbCommand.Parameters.Add(dbParam_password)
					dbCommand.ExecuteNonQuery
					
				Else
					Msg.Text = mytrad.traduction(Session("langue"), "MODIF_PASSE", "MSG3")
					Msg.ForeColor = Drawing.Color.Red
				End If
				
             Finally
                dbConnection.Close()
            End Try
            
            
            
        End If
      
        
    End Sub
</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    <table border="0" cellpadding="0" cellspacing="2" width="400px" class="e_color_back">
        <tr>
            <td class="e_menu_title">
                <%  If Request("maj") = "1" Then
                        Response.Write(mytrad.traduction(Session("langue"), "MODIF_PASSE", "MSG2"))
                        oldpass.Text = "fichet"
                    End If%>
                <%
                    Response.Write(mytrad.traduction(Session("langue"), "MODIF_PASSE", "TITRE1"))
                %>
            </td>
        </tr>
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="8">
                    <tr>
                        <td align="left">
                            <%
                                Response.Write(mytrad.traduction(Session("langue"), "MODIF_PASSE", "TEXT1"))
                            %>
                        </td>
                        <td width="60">
                            <asp:TextBox ID="oldpass" runat="server" Style="text-align: left"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <%
                                Response.Write(mytrad.traduction(Session("langue"), "MODIF_PASSE", "TEXT2"))
                            %>
                        </td>
                        <td>
                            <div align="right">
                                <asp:TextBox ID="newpass" runat="server" Style="text-align: left"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <%
                                Response.Write(mytrad.traduction(Session("langue"), "MODIF_PASSE", "TEXT3"))
                            %>
                        </td>
                        <td>
                            <div align="right">
                                <font size="2">
                                    <asp:TextBox ID="confpass" runat="server"></asp:TextBox>
                                </font>
                            </div>
                        </td>
                    </tr>
                </table>
                    <asp:Label ID="Msg" runat="server" ForeColor="Red"></asp:Label>
                    <br />
            </td>
        </tr>
        <tr>
            <td align="right">
                &nbsp;<asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Style="height: 26px"
                    Text="Button" />
                
            </td>
        </tr>
        <tr>
        <td>&nbsp; &nbsp;</td></tr>
    </table>
</asp:Content>
