<%@ Page MasterPageFile="~/LoginMasterPage.master" %>

<script runat="server">
    
    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)





   If Request.QueryString("CleEcon") <> "" Then
            If Request.QueryString("CleEcon") = Session("CleEcon") Then
                ' Response.Redirect("menu.aspx")
                Response.Redirect("confirmation.aspx")
            End If
        End If
        
        If Request.QueryString("codeclient") <> "" Then
        
            If IsPostBack = False Then
                UserName.Text = Request.QueryString("codeclient")
                UserPass.Text = Request.QueryString("password")
  
                LoginBtn_Click(Sender, E)
            End If
        Else
            If Session("client") <> "" Then
              
				Response.Redirect("menu.aspx")
            End If
        End If
        
        UserName.Focus()
        
    End Sub
    Sub LoginBtn_Click(ByVal Sender As Object, ByVal E As EventArgs)
        
        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)
        
     
        Dim cSql As String
        cSql = "select * from admin where login = '" & Replace(UserName.Text, "'", "''") & "'"
        cSql = cSql & " and password = '" & Replace(UserPass.Text, "'", "''") & "'"
        
        Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        dbCommand.CommandText = cSql
        dbCommand.Connection = dbConnection
    
        Dim dataAdapter As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
        dataAdapter.SelectCommand = dbCommand
        Dim dataSet As System.Data.DataSet = New System.Data.DataSet
        dataAdapter.Fill(dataSet)
    
    
    
        If dataSet.Tables(0).Rows.Count() > 0 Then
           
            ' Gestion des comptes administrateurs - partie Admin du site
            
            Session("charte") = "FICH"
            Session("client") = "ADMIN"
            Session("filtre") = dataSet.Tables(0).Rows(0).Item("filtre").ToString.Trim
            Session("droits") = dataSet.Tables(0).Rows(0).Item("droits").ToString.Trim.ToUpper
            Session("langue") = "fr-FR"
            Response.Redirect("admin/login_admin.asp?login=" & dataSet.Tables(0).Rows(0).Item("login").ToString.Trim & "&passwd=" & dataSet.Tables(0).Rows(0).Item("password").ToString.Trim & "&filtre=" & dataSet.Tables(0).Rows(0).Item("filtre").ToString.Trim & "&droits=" & dataSet.Tables(0).Rows(0).Item("droits").ToString.Trim.ToUpper)
        
            
        
        End If
      
	       
dim CurrentDomain as string
CurrentDomain = request.ServerVariables("SERVER_NAME")
 Dim mytool As New Tool_fichet
 
 'response.write(mytool.get_info_visiteur(CurrentDomain,"BU"))
	  
		' 16/06/2025 avant les modification
        'cSql = "select * from clients_new where codeclient = '" & Replace(UserName.Text, "'", "''") & "'"
        'cSql = cSql & " and password = '" & Replace(UserPass.Text, "'", "''") & "'"
		'cSql = cSql & " AND bu='"& mytool.get_info_visiteur(CurrentDomain,"BU") & "'"
		
		
		
		'cSql = "SELECT  MP.[CodeClient],MP.[MotDePasse],CN.BU,CN.adv,CN.CodePays,CN.Langue,cn.CodeTarif"
		'cSql = cSql & " FROM [FICHET_AX].[dbo].[MotDePasse] MP "
		'cSql = cSql & "inner join [FICHET_AX].[dbo].clients_new CN on CN.codeclient=MP.CodeClient where MP.codeclient='" 
		'cSql = cSql & Replace(UserName.Text, "'", "''") & "'"
		'cSql = cSql & " and motdepasse = '" & Replace(UserPass.Text, "'", "''") & "'"
		
		cSql = "select "
		cSql = cSql & "Cn.CodeClient, cn.password,MP.MotDePasse,cn.Bu,CN.adv,CN.CodePays,CN.Langue,cn.CodeTarif"
		cSql = cSql & " FROM [FICHET_AX].[dbo].clients_new CN"
		cSql = cSql & " LEFT join [FICHET_AX].[dbo].[MotDePasse] MP on CN.codeclient=MP.CodeClient where CN.codeclient='" 
		cSql = cSql & Replace(UserName.Text, "'", "''") & "'" 
		cSql = cSql & " and (cn.password = '" & Replace(UserPass.Text, "'", "''") & "'"
		cSql = cSql & " or MP.motdepasse = '" & Replace(UserPass.Text, "'", "''") & "')"
      
		
        'Response.Write(cSql)
        ' Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        dbCommand.CommandText = cSql
        dbCommand.Connection = dbConnection
    
        '   Dim dataAdapter As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
        dataAdapter.SelectCommand = dbCommand
        '   Dim dataSet As System.Data.DataSet = New System.Data.DataSet
        dataAdapter.Fill(dataSet)
    
     
        
    
        If dataSet.Tables(0).Rows.Count() > 0 Then
           
		   ' Mise à jour du mot de passe
			
			Dim PwdObj as object=dataSet.Tables(0).Rows(0).Item("password")
			Dim MotDePasseObj  as object=dataSet.Tables(0).Rows(0).Item("Motdepasse")
			
			if isdbnull(PwdObj) OrElse trim(PwdObj.tostring())=String.empty Then
				Dim sqldatasourceDB As New SqlDataSource
				With sqldatasourceDB
					.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")
					dim cmdsql as string =	"update clients_new set password='" & MotDePasseObj &"' where codeclient='" & dataSet.Tables(0).Rows(0).Item("codeclient") & "'"
					.UpdateCommand = cmdsql
					.update()
				End With
			Else
			
			end if
		   
		   
		   ' Dim mytool As New Tool_fichet
           
            'A(VOIR)
            'If dataSet.Tables(0).Rows(0).Item("blocage") > 1 Then

            '    Msg.Text = mytool.traduction(dataSet.Tables(0).Rows(0).Item("langue"), "LOGIN", "MSG")
            'Else
                  
            Session.Timeout = 40
                
            Session("charte") = dataSet.Tables(0).Rows(0).Item("bu")
            Session("pays") = dataSet.Tables(0).Rows(0).Item("codepays") ' Récupération du pays
            Session("langue") = dataSet.Tables(0).Rows(0).Item("langue").ToString() ' Langue du client
            Session("client") = dataSet.Tables(0).Rows(0).Item("codeclient") ' code du client
            Session("tarif") = dataSet.Tables(0).Rows(0).Item("codetarif") ' récupération du code tarif
            'Session("frais") = dataSet.Tables(0).Rows(0).Item("frais") ' récupération des frais
            'Session("tva") = dataSet.Tables(0).Rows(0).Item("tva") ' récupération de la tva du client
            If UserPass.Text = "fichet" And dataSet.Tables(0).Rows(0).Item("adv") = False Then
                Response.Redirect("modif_passe.aspx?maj=1")
            Else
                If Session("client").ToString.ToUpper = "E88888" Then
                    Response.Redirect("menu.aspx")
                End If
                    
                If Session("client").ToString.Substring(0, 1) = "E" And dataSet.Tables(0).Rows(0).Item("adv") = True Then
                    Session("adv") = "OUI"
                    Response.Redirect("client_adv.aspx")
                Else
                    Response.Redirect("menu.aspx")
                    Session("adv") = "NON"
                End If
            End If
            'End If
        Else
           
            Msg.Text = "Les informations sont incorrectes, Veuillez recommencer."
            UserName.Focus()
        End If
        dataSet.Clear()
    End Sub

</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    <table cellspacing="0" cellpadding="0" border="0">
        <tr>
            <td style="height: 25px" colspan="3">
            </td>
        </tr>
        <tr>
            <td colspan="3" align="center">
                Cette page vous permet d'accéder à l'outil de gestion des commandes<br />
                par le configurateur de produits.
            </td>
        </tr>
        <tr>
            <td style="height: 15px" colspan="3">
            </td>
        </tr>
        <tr>
            <td colspan="3" align="center">
                L'accès à ce site est exclusivement réservé aux concessionnaires<br />
                du groupe.
            </td>
        </tr>
        <tr>
            <td style="height: 30px" colspan="3">
            </td>
        </tr>
        <tr>
            <td colspan="3" align="center" style="height: 30px; background-color: #999999; color: #ffffff;" class='e_menu_title'>
                Merci de bien vouloir vous identifier
            </td>
        </tr>
        <tr style="background-color: #f5f5f5">
            <td style="height: 30px" colspan="3">
            </td>
        </tr>
        <tr style="background-color: #f5f5f5">
            <td align="left" style="width: 100px; padding-left: 50px">
                <font size="2"><b>Code Client</b></font> :
            </td>
            <td align="left">
                <asp:TextBox ID="UserName" runat="server" Width="150px"></asp:TextBox>
            </td>
            <td align="left">
                <asp:RequiredFieldValidator ID="Requiredfieldvalidator1" runat="server" ControlToValidate="UserName"
                    Display="Static" ErrorMessage="Obligatoire"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr style="background-color: #f5f5f5">
            <td style="height: 5px" colspan="3">
            </td>
        </tr>
        <tr style="background-color: #f5f5f5">
            <td align="left" style="width: 100px; padding-left: 50px">
                <font size="2"><b>Mot de passe</b></font> :
            </td>
            <td align="left">
                <asp:TextBox ID="UserPass" runat="server" TextMode="Password" Width="150px"></asp:TextBox>
            </td>
            <td align="left">
                <asp:RequiredFieldValidator ID="Requiredfieldvalidator2" runat="server" ControlToValidate="UserPass"
                    Display="Static" ErrorMessage="Obligatoire"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr style="background-color: #f5f5f5">
            <td style="height: 60px" colspan="3" align="center">
                <asp:Button ID="LoginBtn" OnClick="LoginBtn_Click" runat="server" Text="Entrer">
                </asp:Button>
            </td>
        </tr>
    </table>
    <br />
    <p>
        <asp:Label ID="Msg" runat="server" ForeColor="Red"></asp:Label>
    </p>
</asp:Content>
