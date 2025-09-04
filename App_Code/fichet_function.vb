Imports System
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web
Imports System.Data.OleDb
Imports System.Collections
Imports Microsoft.VisualBasic
Imports System.Net.Mail





Public Class Tool_fichet

    Public sPATH As String = ""
    Public tabName As String() = New String(1) {}

    Public Function get_valideur_info(ByVal wClient As String, ByVal wInfo As String) As String

        Dim dvValideur As New DataView
        Dim dtValideur As New DataTable
        Dim DsValideur As New SqlDataSource
        DsValideur.ID = "tmp_Valideur"
        DsValideur.DataSourceMode = SqlDataSourceMode.DataSet

        DsValideur.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")

        DsValideur.SelectCommand = " SELECT signature.CodeValideur, clients_new.CodeClient, clients_new.RaisonSociale" & _
                                  " FROM signature INNER JOIN" & _
                                  " clients_new ON clients_new.CodeClient = signature.CodeValideur" & _
                                  " WHERE     (signature.CodeClient = '" & wClient & "')"

        dvValideur = DsValideur.Select(DataSourceSelectArguments.Empty)
        dtValideur = dvValideur.ToTable()

        ' Récupération de la config dans la structure StructConfig

        If dtValideur.Rows.Count() = 1 Then

            Return dtValideur.Rows(0).Item(wInfo).tostring
        End If

        Return ""

    End Function

    Public Function is_customer_test(ByVal wCust As String) As Boolean
        Dim R() As String

        Dim i As Integer

        Dim cust As String
        cust = wCust


        R = Split(System.Configuration.ConfigurationManager.AppSettings("clienttest"), ",")
        For i = 1 To Len(R)

        Next

        Return False




    End Function


    Public Function get_customer_info(ByVal wClient As String, ByVal wInfo As String) As String


        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")

        Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)

        Dim queryString As String

        queryString = "SELECT " & wInfo.Trim() & " From clients_new where codeclient='" & wClient.Trim() & "'"


        Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        dbCommand.CommandText = queryString

        dbCommand.Connection = dbConnection

        Dim dataAdapter As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
        dataAdapter.SelectCommand = dbCommand
        Dim dataSet As System.Data.DataSet = New System.Data.DataSet
        dataAdapter.Fill(dataSet)

        Return dataSet.Tables(0).Rows(0).Item(0)


    End Function

    Public Function get_order_info(ByVal wOrder As String, ByVal wInfo As String) As String


        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")

        Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)

        Dim queryString As String

        queryString = "SELECT " & wInfo.Trim() & " From commandes_portes where num_commande=" & wOrder



        Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        dbCommand.CommandText = queryString

        dbCommand.Connection = dbConnection

        Dim dataAdapter As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
        dataAdapter.SelectCommand = dbCommand
        Dim dataSet As System.Data.DataSet = New System.Data.DataSet
        dataAdapter.Fill(dataSet)
        If IsDBNull(dataSet.Tables(0).Rows(0).Item(0)) Then
            Return ""
        Else
            Return dataSet.Tables(0).Rows(0).Item(0).tostring
        End If



    End Function
	
	
    Public Function send_email(ByVal wFrom As String, ByVal wTo As String, ByVal wSubject As String, ByVal wBody As String) As String

	Dim client As New System.Net.Mail.SmtpClient
 Dim message As New System.Net.Mail.MailMessage
 client.Credentials = New System.Net.NetworkCredential("nkecita@ciage.fr", "U71J5OKwaMmCnxYI")

        Try
          
          client.Port = 587 'définition du port 
          client.Host = "smtp-relay.sendinblue.com" 'définition du serveur smtp
          client.EnableSsl = True 
          message.From = New System.Net.Mail.MailAddress(wFrom)
          message.To.Add(wTo)
         
           
           
          message.Subject = wSubject
          message.Body = wBody

          client.Send(message) 'envoi du mail
Catch ex As Exception
'TODO traiter les erreurs
End Try
    End Function
	
    Public Function send_emailold(ByVal wFrom As String, ByVal wTo As String, ByVal wSubject As String, ByVal wBody As String) As String

        ' TODO: Update the ConnectionString for your application
        Dim ConnectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionStringAdmin")

        ' TODO: Updatd the name of the Stored Procedure for your application
        Dim CommandText As String = "send_email"

        Dim myConnection As New SqlConnection(ConnectionString)
        Dim myCommand As New SqlCommand(CommandText, myConnection)
        Dim workParam As New SqlParameter()

        myCommand.CommandType = CommandType.StoredProcedure

        ' TODO: Set the input parameter, if necessary, for your application
        myCommand.Parameters.Add("@From", SqlDbType.VarChar).Value = wFrom
        myCommand.Parameters.Add("@To", SqlDbType.VarChar).Value = wTo
        myCommand.Parameters.Add("@Subject", SqlDbType.VarChar).Value = wSubject
        myCommand.Parameters.Add("@Body", SqlDbType.VarChar).Value = wBody



        myConnection.Open()
        myCommand.ExecuteNonQuery()
        Return ""

    End Function


    Public Function traduction(ByVal wPays As String, ByVal wPage As String, ByVal wElement As String) As String

        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")

        Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)

        Dim queryString As String

        queryString = "SELECT * " & _
            "FROM pays_libelle" & " where upper(codelangue)=" & "'" & wPays.ToUpper() & "'" & " And " & _
            "nom_page=" & "'" & wPage & "'" & " And " & _
            "codelibelle=" & "'" & wElement & "'"

        Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        dbCommand.CommandText = queryString

        dbCommand.Connection = dbConnection

        Dim dataAdapter As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
        dataAdapter.SelectCommand = dbCommand
        Dim dataSet As System.Data.DataSet = New System.Data.DataSet
        dataAdapter.Fill(dataSet)

        Try
            traduction = dataSet.Tables(0).Rows(0).Item(3)
        Catch ex As Exception
            traduction = ""

        End Try
    End Function

    Public Function url_econ(ByVal Wproduct As String,Byval wDomaine as string) As String
	Dim mytool As New Tool_fichet
	
	dim spath as string
	If Not HttpContext.Current.Session("charte") Is Nothing Then
            Select Case HttpContext.Current.Session("charte").ToString().ToUpper()
               Case "FICH"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") 
				Case "TEST"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") 
				Case "ABLO"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconabloy") 	
				Case "STRE"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconstremler") 				
				Case "VACH"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconvachette")
				Case "YALE"
					sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconyale") 
				Case "SHER"
					sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconsherlock") 
				Case "REHAB"
					sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconrehab") 
                Case "FSBA"
					sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconrehab") 
				Case Else
					
						sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon")
			End Select
		
		ELSE
		
						sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") 
		end if
 

        HttpContext.Current.Session("chaine_econ") = sPATH & "/" &  mytool.get_info_visiteur(wDomaine,"url_econ")  & "/econEnginehtml.aspx"
		
        HttpContext.Current.Session("chaine_econ") = HttpContext.Current.Session("chaine_econ") & "?environment=" &  mytool.get_info_visiteur(wDomaine,"environnement") 
	

        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)

        Dim queryString As String



        'queryString = "SELECT * FROM  " & mytool.get_info_visiteur(wDomaine, "base") & ".dbo.FichetModele where id='MAIN'"
        queryString = "  select 'DEVIS' as model,'10' as version"

        Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        dbCommand.CommandText = queryString

        dbCommand.Connection = dbConnection

        Dim dataAdapter As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
        dataAdapter.SelectCommand = dbCommand
        Dim dataSet As System.Data.DataSet = New System.Data.DataSet
        dataAdapter.Fill(dataSet)


        HttpContext.Current.Session("chaine_econ") = HttpContext.Current.Session("chaine_econ") & "&model=" & dataSet.Tables(0).Rows(0).Item("model").ToString.TrimEnd()

        HttpContext.Current.Session("chaine_econ") = HttpContext.Current.Session("chaine_econ") & "&modelversion=" & dataSet.Tables(0).Rows(0).Item("version").ToString.TrimEnd()
        HttpContext.Current.Session("chaine_econ") = HttpContext.Current.Session("chaine_econ") & "&language=" & HttpContext.Current.Session("langue").ToString.TrimEnd()
        HttpContext.Current.Session("chaine_econ") = HttpContext.Current.Session("chaine_econ") & "&customer=" & HttpContext.Current.Session("client").ToString.TrimEnd()
        HttpContext.Current.Session("chaine_econ") = HttpContext.Current.Session("chaine_econ") & "&product=" & Wproduct.ToString.TrimEnd()



        queryString = "UPDATE [clients_new] SET [CleEcon]=@CleEcon where codeclient=" & "'" & HttpContext.Current.Session("client") & "'"

        dbCommand.CommandText = queryString
        dbCommand.Connection = dbConnection

        HttpContext.Current.Session("cleEcon") = HttpContext.Current.Session("client") & "-" & DateTime.Now.ToString.Replace(" ", "-")

        Dim dbParam_cleEcon As System.Data.IDataParameter = New System.Data.SqlClient.SqlParameter
        dbParam_cleEcon.ParameterName = "@CleEcon"
        dbParam_cleEcon.Value = HttpContext.Current.Session("cleEcon")
        dbParam_cleEcon.DbType = System.Data.DbType.[String]
        dbCommand.Parameters.Add(dbParam_cleEcon)

        Dim rowsAffected As Integer = 0
        dbConnection.Open()
        Try
            rowsAffected = dbCommand.ExecuteNonQuery
        Finally
            dbConnection.Close()
        End Try


    End Function

    Public Function get_commande_marche_ensemble(ByVal wCommande As String) As String
	dim sPath as string
	
		If Not HttpContext.Current.Session("charte") Is Nothing Then
            Select Case HttpContext.Current.Session("charte").ToString().ToUpper()
                Case "FICH"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes/"
				Case "TEST"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes_test/"
				Case "ABLO"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconabloy") & "/commandes_abloy/"	
				Case "STRE"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconstremler") & "/commandes_stremler/"					
				Case "VACH"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconvachette") & "/commandes_vachette/"
				Case "YALE"
					sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconyale") & "/commandes_yale/"
				Case "SHER"
					sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconsherlock") & "/commandes_sherlock/"
				Case "REHAB"
					sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/commandes_rehab/"
                Case "FSBA"
					sPATH =  System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/commandes_rehab/"
				Case Else
                    
						sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon")
            End Select
		
		ELSE
		
						sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon")
		end if
      

        Dim dvMarcheEnsemble As New DataView
        Dim dtMarcheEnsemble As New DataTable
        Dim DsMarcheEnsemble As New SqlDataSource
        DsMarcheEnsemble.ID = "tmp_MarcheEnsemble"
        DsMarcheEnsemble.DataSourceMode = SqlDataSourceMode.DataSet

        DsMarcheEnsemble.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")

        DsMarcheEnsemble.SelectCommand = " SELECT num_commande" & _
                                         " FROM commandes_portes " & _
                                         " where (cp_march_id='EXTERN' or cc_march_id='PORTE') " & _
                                         " AND     (commandes_portes.cp_cc_nocde= '" & wCommande & "')"



        dvMarcheEnsemble = DsMarcheEnsemble.Select(DataSourceSelectArguments.Empty)
        dtMarcheEnsemble = dvMarcheEnsemble.ToTable()

        ' Récupération de la config dans la structure StructConfig
        Dim i As Integer
        Dim cListeCommande As String
        cListeCommande = ""

        If dtMarcheEnsemble.Rows.Count() > 0 Then
            For i = 0 To dtMarcheEnsemble.Rows.Count - 1
                tabName = getlongName(dtMarcheEnsemble.Rows(i).Item("num_commande").ToString.Trim.PadLeft(7, "0"))
                If i = dtMarcheEnsemble.Rows.Count() - 1 Then
                    cListeCommande = cListeCommande & "<a href='" & sPATH  & tabName(0) & "/" & tabName(1) & "/CEW" & dtMarcheEnsemble.Rows(i).Item("num_commande").ToString.Trim.PadLeft(7, "0") & "_TC.HTML" & "' target='_BLANK'>" & dtMarcheEnsemble.Rows(i).Item("num_commande").ToString & "</A>"
                Else
                    cListeCommande = cListeCommande & "<a href='" & sPATH  & tabName(0) & "/" & tabName(1) & "/CEW" & dtMarcheEnsemble.Rows(i).Item("num_commande").ToString.Trim.PadLeft(7, "0") & "_TC.HTML" & "' target='_BLANK'>" & dtMarcheEnsemble.Rows(i).Item("num_commande").ToString & "</A>" & " - "
                End If




            Next


        End If

        Return cListeCommande

    End Function

   
    Public Function SavePage(ByVal Url As String, ByVal FilePath As String) As String

        Dim iMessage As CDO.Message = New CDO.Message
        iMessage.CreateMHTMLBody(Url, _
        CDO.CdoMHTMLFlags.cdoSuppressNone, "", "")
        Dim adodbstream As ADODB.Stream = New ADODB.Stream
        adodbstream.Type = ADODB.StreamTypeEnum.adTypeText
        adodbstream.Charset = "US-ASCII"
        adodbstream.Open()
        iMessage.DataSource.SaveToObject(adodbstream, "_Stream")
        adodbstream.SaveToFile(FilePath, _
        ADODB.SaveOptionsEnum.adSaveCreateOverWrite)
    End Function

    Private Function getlongName(ByVal p As String) As String()
        Dim tabName As String() = New String(1) {}
        tabName(0) = p.Substring(0, 3)
        tabName(1) = p.Substring(3, 2)


        Return tabName
    End Function


Public Function get_info_visiteur(ByVal wDomaine As String,ByVal wInfo as string) As String

        Dim dvVisiteur As New DataView
        Dim dtVisiteur As New DataTable
        Dim DsVisiteur As New SqlDataSource
        DsVisiteur.ID = "tmp_Visiteur"
        DsVisiteur.DataSourceMode = SqlDataSourceMode.DataSet

        DsVisiteur.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")

        DsVisiteur.SelectCommand = "SELECT " & wInfo & " FROM ENVIRONNEMENTS " & _
                                   "WHERE     (Web = '" & wDomaine & "')"

        dvVisiteur = DsVisiteur.Select(DataSourceSelectArguments.Empty)
        dtVisiteur = dvVisiteur.ToTable()

        ' Récupération de la config dans la structure StructConfig

        If dtVisiteur.Rows.Count() = 1 Then

            Return dtVisiteur.Rows(0).Item(wInfo).tostring
        End If

        Return ""

    End Function



End Class

