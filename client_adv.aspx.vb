Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Partial Class client_adv
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("client") = "" Then
            Response.Redirect("login.aspx")
        End If
        Customers.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")
		customers.selectcommand = "SELECT codeclient,codeclient + ' ' + raisonsociale as client FROM [clients_new] Where left(codeclient,1)<>'E' and bu='" & session("charte") & "' And BlocageAx=0 order by raisonsociale"
		
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
'			response.write("SELECT * from clients_new WHERE codeclient ='" & Me.DropDownList1.SelectedValue & "' And BlocageAx=0 order by codeclient")        
'			response.write("login.aspx?codeclient=" & dtClients.Rows(0).Item("codeclient") & "&password=" & dtClients.Rows(0).Item("password"))
	  
        Else
'response.write("SELECT * from clients_new WHERE codeclient ='" & Me.DropDownList1.SelectedValue & "' And BlocageAx=0 order by codeclient")        
'response.write("login.aspx?codeclient=" & dtClients.Rows(0).Item("codeclient") & "&password=" & dtClients.Rows(0).Item("password"))
		Response.Redirect("login.aspx")
        End If



    End Sub

 
End Class
