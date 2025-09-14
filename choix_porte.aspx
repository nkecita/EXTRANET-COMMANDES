<%@  MasterPageFile="~/MainMasterPageToken.master" ClassName="fichet" %>

<script runat="server">

    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
        If Session("client") = "" Then
            Response.Redirect("loginnew.aspx")
        End If

        If IsPostBack = False Then
            Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
            Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)

            Dim queryStringZoneFr As String = "SELECT LEFT(a.CodePostal, 2) " & _
            "FROM dbo.clients_new c " & _
            "INNER JOIN dbo.adresses_new a ON c.CodeClient = a.CodeClient AND CodeAdresse = '000000' " & _
            "WHERE c.CodePays = 'FR' AND c.CodeClient NOT LIKE 'I%' AND c.CodeClient LIKE '" & Session("client") & "' "

            Dim dbCommandCodePostal As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
            dbCommandCodePostal.CommandText = queryStringZoneFr
            dbCommandCodePostal.Connection = dbConnection

            Dim zone As String = ""
            dbConnection.Open()
            Using reader As System.Data.SqlClient.SqlDataReader = dbCommandCodePostal.ExecuteReader()
                If reader.Read() Then
                    zone = reader(0)
                End If
            End Using

            Session("zone") = zone

            Dim queryString As String
            If zone <> "" And Not zone Is Nothing Then
                queryString = "SELECT p.produit_url, pl.libelle " & _
                "FROM dbo.portes_libelle pl " & _
                "INNER JOIN dbo.portes p ON p.produit_url = pl.produit_url AND pl.Langue = '" & Session("langue") & "' " & _
                "INNER JOIN dbo.portes_commercial pc ON p.produit_url = pc.produit_url " & _
                "INNER JOIN dbo.zones z ON z.Commercial = pc.Commercial AND z.Langue = '" & Session("langue") & "' AND z.Zone = '" & Session("zone") &"' " & _
                "WHERE p.codetarif =  '" & Session("tarif") & "' " & _
                "AND (p.codepays = '" & Session("pays") & "') " & _
                "GROUP BY  p.produit_url,  pl.libelle " & _
                "ORDER BY pl.libelle"
            Else
                queryString = "SELECT  dbo.portes.produit_url,dbo.portes_libelle.libelle" & _
                       " FROM         dbo.portes_libelle INNER JOIN" & _
                "                      dbo.portes ON dbo.portes_libelle.produit_url = dbo.portes.produit_url" & _
                "  WHERE     (dbo.portes.codetarif =  " & "'" & Session("tarif") & "'" & ")" & "  AND (dbo.portes_libelle.Langue = " & "'" & Session("langue") & "'" & ")" & _
                " AND (dbo.portes.codepays = " & "'" & Session("pays") & "'" & ")" & _
                " GROUP by  dbo.portes.produit_url,  dbo.portes_libelle.libelle order by dbo.portes_libelle.libelle"
                'Response.Write(queryString)
            End If

            Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
            dbCommand.CommandText = queryString
            dbCommand.Connection = dbConnection

            Dim dataAdapter As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
            dataAdapter.SelectCommand = dbCommand
            Dim dataSet As System.Data.DataSet = New System.Data.DataSet
            dataAdapter.Fill(dataSet)
            DropDownList1.DataSource = dataSet
            '  dropdownlist1.datatextfield = dataset.Tables(0).rows(0).item(1)
            DropDownList1.DataTextField = "libelle"
            DropDownList1.DataValueField = "produit_url"
            DropDownList1.DataBind()
        End If
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        ' Récupération des éléments pour construire la chaine d'apple à E-con
        dim CurrentDomain as string
        CurrentDomain = request.ServerVariables("SERVER_NAME")

        Dim MyTool As New Tool_fichet
        MyTool.url_econ(DropDownList1.SelectedItem.Value.ToString(), CurrentDomain)
        ' Response.Write("toto")
        Response.Redirect("econ.aspx")

    End Sub
</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
	
    <table cellspacing="0" cellpadding="0" width="500px" border="0">
        <tr>
            <td class="e_menu_title">
                <%
                    Dim MaTrad As New Tool_fichet
                    Response.Write(MaTrad.traduction(Session("langue"), "CHOIX_PORTE", "TITRE1"))
                %>
            </td>
        </tr>
        <tr>
            <td class="e_color_back" align="center">
                <br />
                <br />
                <br />
                <%
                    Dim MaTrad2 As New Tool_fichet
                                                    
                    Response.Write(MaTrad2.traduction(Session("langue"), "CHOIX_PORTE", "LIBELLE1"))
                                                 
                %>
                &nbsp;
                <asp:DropDownList ID="DropDownList1" runat="server">
                </asp:DropDownList>
                <br />
                <br />
                <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Ok" />
                <br />
                <br />
            </td>
        </tr>
    </table>
</asp:Content>
