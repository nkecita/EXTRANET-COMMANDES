<%@ Page MasterPageFile="~/MainMasterPage.master" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.SqlClient" %>


<script runat="server">

    Public sPATH As String = ""
    Public tabName As String() = New String(1) {}

    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)

        Select Case Session("charte").ToString().ToUpper()
            Case "FICH"
                sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes_fichet/"
            Case "TEST"
                sPATH =  System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes_test/"
            Case "ABLO"
                sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconabloy") & "/commandes_abloy/"
            Case "STRE"
                sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconstremler") & "/commandes_stremler/"
            Case "VACH"
                sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconvachette") & "/commandes_vachette/"
            Case "YALE"
                sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconyale") & "/commandes_yale/"
            Case "SHER"
                sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconsherlock") & "/commandes_sherlock/"
            Case "REHAB"
                sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/commandes_rehab/"
            Case Else

                sPATH =  System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes"
        End Select


        Dim querystring As String
        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)
        Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        querystring = "UPDATE [commandes_portes] SET [vue_commande]='oui' where num_commande=" & "'" & Request.QueryString("num_commande") & "'"

        dbCommand.CommandText = querystring

        dbCommand.Connection = dbConnection
        dbConnection.Open()
        dbCommand.ExecuteNonQuery()
        Dim url As String

        Dim ToolRecup As New Tool_fichet
        Dim id_Cmd As String
        id_Cmd = Request.QueryString("num_commande").ToString()
        'tabName = getlongName("00"&Request.QueryString("num_commande").ToString())
        tabName = getlongName(id_Cmd.Trim.PadLeft(7, "0"))


        ' If ToolRecup.get_order_info(Request.QueryString("num_commande"), "environnement").ToLower = "default" Then
        'url = "http://econ.fichet-pointfort.fr/commandes/CEW"
        url = sPATH  & tabName(0) & "/" & tabName(1) & "/CEW"
        'Else
        'url = "http://econ.fichet-pointfort.fr/commandes_test/CEW"
        '   url = sPATH & "/commandes_test/" & tabName(0) & "/" & tabName(1) & "/CEW"
        'End If

        url = url & id_Cmd.Trim.PadLeft(7, "0")
        url = url & "_" & Request.QueryString("type")
        Response.Redirect(url)
    End Sub

    Private Function getlongName(ByVal p As String) As String()
        Dim tabName As String() = New String(1) {}
        tabName(0) = p.Substring(0, 3)
        tabName(1) = p.Substring(3, 2)


        Return tabName
    End Function

</script>

