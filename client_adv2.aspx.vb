Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Partial Class client_adv2
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("client") = "" Then
            Response.Redirect("login.aspx")
        End If
        Dim cSql As String
        cSql = "SELECT  cn.CodeClient, cn.CodeClient + ' (' + cn.CodeRFR + ')    ' + cn.RaisonSociale AS client	FROM clients_new cn "

        cSql = cSql & "INNER JOIN clients_groupe cg ON cg.client = cn.CodeClient "

        cSql = cSql & "WHERE cg.groupe IN (SELECT groupe FROM clients_groupe_adv WHERE client = '" & Session("client") & "') "

        cSql = cSql & "AND cn.Bu = (SELECT Bu FROM clients_new WHERE CodeClient = '" & Session("client") & "') "

        cSql = cSql & "AND cn.Adv = 0 "

        cSql = cSql & " AND cn.BlocageAx =0 "

        cSql = cSql & "AND cn.BlocageWeb = 0 "

        cSql = cSql & "ORDER BY cg.groupe, cn.RaisonSociale ASC"

        Customers.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        Customers.SelectCommand = cSql

		
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click



        Dim dvClients As New DataView
        Dim dtClients As New DataTable


        Dim DsClients As New SqlDataSource

        DsClients.ID = "tmp_Clients"
        DsClients.DataSourceMode = SqlDataSourceMode.DataSet
        DsClients.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        DsClients.SelectCommand = "SELECT * from clients_new" & _
                                       " WHERE codeclient ='" & Me.DropDownList1.SelectedValue & "' And BlocageAx=0 order by codeclient"


        dvClients = DsClients.Select(DataSourceSelectArguments.Empty)
        dtClients = dvClients.ToTable()

        Dim Advurl As String

        If dtClients.Rows.Count() = 1 Then
            Advurl = "login.aspx?codeclient=" & dtClients.Rows(0).Item("codeclient") & "&password=" & dtClients.Rows(0).Item("password")
            Response.Redirect(Advurl)
        Else
            Response.Redirect("login.aspx")
        End If



    End Sub

 
End Class
