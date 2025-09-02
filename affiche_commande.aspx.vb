Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web
Imports System.Data.OleDb
Imports System.Collections
Imports Microsoft.VisualBasic

Partial Class _Default
    Inherits System.Web.UI.Page
    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)

        Dim querystring As String
        Dim connectionString As String = ConfigurationSettings.AppSettings("ConnectionString")
        Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)
        Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        querystring = "UPDATE [commandes_portes] SET [vue_commande]='oui' where num_commande=" & "'" & Request.QueryString("num_commande") & "'"

        dbCommand.CommandText = queryString

        dbCommand.ExecuteNonQuery()



        Dim url As String
        url = "http://econ.fichet-pointfort.fr/commandes/WP"
        url = url & Request.QueryString("num_commande")
        url = url & "_LG.html"
        Response.Redirect(url)
    End Sub
End Class
