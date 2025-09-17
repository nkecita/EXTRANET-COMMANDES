<%@ Page MasterPageFile="~/MainMasterPageToken.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">

    Public sPATH As String = ""
    Public tabName As String() = New String(1) {}
    Public libcde as string =""
    Public info_valideur as string =""
    Public  req_nCmde  as String = ""





    Sub ApplyFilter_Click(ByVal Sender As Object, ByVal E As EventArgs)

        IF Session("charte").ToString().ToUpper() = "REHAB" then
            libcde="commandes_portes_rehab"
        Else
            libcde="commandes_portes"
        End If


        ' TODO: update the ConnectionString value for your application
        Dim ConnectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        Dim CommandText As String

        ' get the filter value from the DropDownList
        Dim filterValue As String = Session("client")

        ' TODO: update the CommandText value for your application

        CommandText = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,ref_client,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from " & libcde
        CommandText = CommandText + " left join clients_new on clients_new.codeclient = " & libcde & ".num_client"
        CommandText = CommandText + "  where num_client = '" & filterValue & "'"

        If datedeb.Text <> "" And datefin.Text <> "" Then
            CommandText = CommandText + " and CONVERT(datetime, dtcomm, 103) >='" & datedeb.Text & "'"
            CommandText = CommandText + " and CONVERT(datetime, dtcomm, 103) <='" & datefin.Text & "'"
        End If
        If datedeb.Text <> "" And datefin.Text = "" Then
            CommandText = CommandText + " and CONVERT(datetime, dtcomm, 103) >='" & datedeb.Text & "'"
        End If
        If datedeb.Text = "" And datefin.Text <> "" Then
            CommandText = CommandText + " and CONVERT(datetime, dtcomm, 103) <='" & datefin.Text & "'"
        End If
        '  CommandText = CommandText + " and transfert = 'oui' "
        CommandText = CommandText + " order by CONVERT(datetime, dtcomm, 103) desc,numerocde desc"
        'Response.Write(CommandText)



        SqlDataSource3.SelectCommand = CommandText
        SqlDataSource3.Select(DataSourceSelectArguments.Empty)
        SqlDataSource3.DataBind()






        GridView2.DataBind()

        If GridView2.Rows.Count = 0 Then
            GridView2.Visible = False
            Label3.Visible = False

        Else
            Dim MaTrad As New Tool_fichet
            Label3.Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "CDECLI")
            GridView2.Visible = True
        End If



    End Sub

    Sub Disp(ByVal Sender As Object, ByVal E As EventArgs) Handles GridView2.DataBound
        Dim MaTrad As New Tool_fichet
        If GridView2.Rows.Count = 0 Then
            GridView2.Visible = False
            Label3.Visible = False

        Else

            Label3.Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "CDECLI")
            GridView2.Visible = True
        End If
    End Sub

    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
        If Session("charte").ToString() = "" Then
            Session.Clear()
            Session.Abandon()
        End If

        '' Response.Redirect("loginnew.aspx")
        If Session("charte").ToString().ToUpper() = "REHAB" then
            libcde="commandes_portes_rehab"
        Else
            libcde="commandes_portes"
        End If


        SqlDataSource3.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        SqlDataSource1.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")

        SqlDataSource3.SelectCommand = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,ref_client,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from  " & libcde   & _
        "     left join clients_new " & _
        " on clients_new.codeclient = " & libcde & ".num_client " & _
        " where num_client = '" & Session("client") & "' order by numerocde desc "

        SqlDataSource1.SelectCommand = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,Ref_valideur,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from  " & libcde   & _
        " LEFT OUTER JOIN signature ON " & libcde & ".num_client = signature.CodeClient " & _
        " left join clients_new on clients_new.codeclient = " & libcde & ".num_client " & _
        " where signature.Codevalideur =  '" & Session("client") &  "' order by numerocde desc"

        If Session("client") = "" Then
            Response.Redirect("login.aspx")
        End If
        Dim MaTrad As New Tool_fichet
        Button1.Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "BUTTON1")
        Button2.Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "BUTTON2")
        Item1.Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "ITEM1")
        Item2.Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "ITEM2")

        Dim ToolRecup As New Tool_fichet
        Dim recupvalideur As String
        recupvalideur = ""
        recupvalideur = ToolRecup.get_valideur_info(Session("client"), "codeclient")

        If recupvalideur <> "" Then

            GridView1.Columns(5).Visible = False
            GridView1.Columns(7).Visible = False
        End If

        GridView1.Columns(2).Visible = False

    End Sub
    Private Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Dim MaTrad As New Tool_fichet
        If e.Row.RowType = DataControlRowType.Header Then


            e.Row.Cells(0).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL1")
            e.Row.Cells(1).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL2")
            e.Row.Cells(2).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL3")
            e.Row.Cells(3).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL4")
            e.Row.Cells(4).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL5")
            e.Row.Cells(5).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COLPRIX")
            e.Row.Cells(6).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL8")
            e.Row.Cells(7).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL7")
            e.Row.Cells(8).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL6")
            e.Row.Cells(9).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL9")
            e.Row.Cells(10).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL10")
            e.Row.Cells(11).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL11")
            'e.Row.Cells(12).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL11")


        End If

        If e.Row.RowType = DataControlRowType.DataRow Then



            Dim Lblcde As Label

            Lblcde = e.Row.FindControl("cde")
            tabName = getlongName(Lblcde.Text.Trim.PadLeft(7, "0"))


            Dim ToolRecup As New Tool_fichet
            Dim cUrl as string

            Select Case Session("charte").ToString().ToUpper()
                Case "FICH"
                    cUrl = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes_fichet/"
                Case "TEST"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes_test/"
                Case "ABLO"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconabloy") & "/commandes_abloy/"
                Case "STRE"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconstremler") & "/commandes_stremler/"
                Case "VACH"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconvachette") & "/commandes_vachette/"
                Case "YALE"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconyale") & "/commandes_yale/"
                Case "SHER"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconsherlock") & "/commandes_sherlock/"
                Case "REHAB"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/commandes_rehab/"
                Case "FSBA"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/commandes_rehab/"
                Case Else

                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes"
            End Select
            ' recupération de la souche
            ' Récupérer la valeur de num_commande (lié à ton HyperLinkField)
            Dim numCommande As String = DataBinder.Eval(e.Row.DataItem, "num_commande").ToString()

            ' Extraire la souche (3 premiers caractères)
            Dim Souche As String = Left(numCommande, 3)

            e.Row.Cells(5).Text = "<a href='" & curl  & tabName(0) & "/" & tabName(1) & "/" & souche &Lblcde.Text.Trim.PadLeft(7, "0") & "_TA.HTML" & "' target='_BLANK'>" & e.Row.Cells(5).Text & "</a>"
            e.Row.Cells(14).Text = "<a href='" & cUrl &  tabName(0) & "/" & tabName(1) & "/" &souche & Lblcde.Text.Trim.PadLeft(7, "0") & "_TC.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"


            Dim Lblstatut As Label
            Lblstatut = e.Row.FindControl("statut")

            Select Case Lblstatut.Text.Trim
                Case "-1"
                    e.Row.Cells(11).Text = "<img src='images/statut_annulee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUTM1") & "'>"
                Case "0"
                    e.Row.Cells(11).Text = "<img src='images/statut_attente_distributeur.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT0") & "'>"
                Case "1"
                    e.Row.Cells(11).Text = "<img src='images/statut_attente.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT1") & "'>"
                Case "2"
                    e.Row.Cells(11).Text = "<img src='images/statut_prise-en-compte.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT2") & "'>"
                Case "3"
                    e.Row.Cells(11).Text = "<img src='images/statut_confirmee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT3") & "'>"
                Case "4"
                    e.Row.Cells(11).Text = "<img src='images/statut_fabriquee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT4") & "'>"
                Case "5"
                    e.Row.Cells(11).Text = "<img src='images/statut_expediee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT5") & "'>"
                Case "2R"
                    e.Row.Cells(11).Text = "<img src='../images/statut_refusee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT2R") & "'>"
                Case "6"
                    e.Row.Cells(11).Text = "<img src='../images/statut_livree.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT6") & "'>"
                Case Else
                    e.Row.Cells(11).Text = ""
            End Select
            ' If affiche_commande(Lblcde.Text) = False Then
            '    e.Row.Cells(10).Text = "A"
            'End If
        End If
    End Sub

    Private Sub GridView2_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView2.RowDataBound
        Dim MaTrad As New Tool_fichet
        If e.Row.RowType = DataControlRowType.Header Then

            e.Row.Cells(0).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL1")
            e.Row.Cells(1).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL2")
            e.Row.Cells(2).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL3")
            e.Row.Cells(3).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL4")
            e.Row.Cells(4).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL5")
            e.Row.Cells(5).Text = "Prix"
            e.Row.Cells(6).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL8")
            e.Row.Cells(7).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL7")
            e.Row.Cells(8).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL6")
            e.Row.Cells(9).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL9")
            e.Row.Cells(10).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL10")
            e.Row.Cells(11).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL11")
            'e.Row.Cells(12).Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "COL11")





        End If
        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim Lblstatut As Label
            Lblstatut = e.Row.FindControl("statut")

            Select Case Lblstatut.Text.Trim
                Case "-1"
                    e.Row.Cells(11).Text = "<img src='images/statut_annulee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUTM1") & "'>"
                Case "0"
                    e.Row.Cells(11).Text = "<img src='images/statut_attente_distributeur.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT0") & "'>"
                Case "1"
                    e.Row.Cells(11).Text = "<img src='images/statut_attente.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT1") & "'>"
                Case "2"
                    e.Row.Cells(11).Text = "<img src='images/statut_prise-en-compte.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT2") & "'>"
                Case "3"
                    e.Row.Cells(11).Text = "<img src='images/statut_confirmee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT3") & "'>"
                Case "4"
                    e.Row.Cells(11).Text = "<img src='images/statut_fabriquee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT4") & "'>"
                Case "5"
                    e.Row.Cells(11).Text = "<img src='images/statut_expediee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT5") & "'>"
                Case "2R"
                    e.Row.Cells(11).Text = "<img src='../images/statut_refusee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT2R") & "'>"
                Case "6"
                    e.Row.Cells(11).Text = "<img src='../images/statut_livree.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT6") & "'>"
                Case Else
                    e.Row.Cells(11).Text = ""
            End Select


            Dim Lblcde As Label
            Lblcde = e.Row.FindControl("cde")

            tabName = getlongName(Lblcde.Text.Trim.PadLeft(7, "0"))
            Dim ToolRecup As New Tool_fichet
            Dim cUrl as string

            Select Case Session("charte").ToString().ToUpper()
                Case "FICH"
                    cUrl = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes_fichet/"
                Case "TEST"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes_test/"
                Case "ABLO"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconabloy") & "/commandes_abloy/"
                Case "STRE"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconstremler") & "/commandes_stremler/"
                Case "VACH"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconvachette") & "/commandes_vachette/"
                Case "YALE"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconyale") & "/commandes_yale/"
                Case "SHER"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconsherlock") & "/commandes_sherlock/"
                Case "REHAB"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/commandes_rehab/"
                Case "FSBA"
                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/commandes_rehab/"
                Case Else

                    cUrl =  System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes"
            End Select

            e.Row.Cells(5).Text = "<a href='" & curl  & tabName(0) & "/" & tabName(1) & "/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_TA.HTML" & "' target='_BLANK'>" & e.Row.Cells(5).Text & "</a>"
            'e.Row.Cells(13).Text = "<a href='" & curl & tabName(0) & "/" & tabName(1) & "/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_TC.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"

        End If

    End Sub
    Dim test_unit As String = ""

    Sub ApplyFilter_ByCmdeClick(ByVal Sender As Object, ByVal E As EventArgs)

        IF Session("charte").ToString().ToUpper() = "REHAB" then
            libcde="commandes_portes_rehab"
        Else
            libcde="commandes_portes"
        End If


        ' TODO: update the ConnectionString value for your application
        Dim ConnectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        Dim CommandText As String
        Dim NumCmde  As String
        Dim  choix_commande  As String
        choix_commande = "0"
        Dim Valideur As New Tool_fichet


        ' get the filter value from the DropDownList
        Dim filterValue As String = Session("client")

        ' TODO: update the CommandText value for your application

        If Valideur.get_valideur_info(Session("client").ToString(),"CodeValideur") = "" Then
            If idCmd.Text <> "" Then
                NumCmde =  Trim(idCmd.Text)
                Dim  trigramme  As String = NumCmde.Substring(0, 4)
                trigramme = UCase(trigramme)
                If  String.Compare(trigramme, "CEW0") = 0 Then
                    NumCmde = NumCmde.Replace(NumCmde.Substring(0, 4) ,"")
                End IF
                trigramme  = NumCmde.Substring(0, 3)
                trigramme = UCase(trigramme)
                If  String.Compare(trigramme, "CEW") = 0 Then
                    NumCmde = NumCmde.Replace(NumCmde.Substring(0, 3) ,"")
                    req_nCmde= NumCmde
                End IF






                If choixCmde.SelectedItem.Value.ToString() = "0" Then
                    CommandText = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,ref_client,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from " & libcde
                    CommandText = CommandText + " left join clients_new on clients_new.codeclient = " & libcde & ".num_client"
                    CommandText = CommandText + "  where num_client = '" & filterValue & "'" & " AND num_commande = '" & NumCmde  & "'"
                    CommandText = CommandText + " order by CONVERT(datetime, dtcomm, 103) desc,numerocde desc"
                    SqlDataSource3.SelectCommand = CommandText
                    SqlDataSource3.Select(DataSourceSelectArguments.Empty)
                    SqlDataSource3.DataBind()
                    SqlDataSource1.SelectCommand = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,Ref_valideur,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from  " & libcde   & _
                        " LEFT OUTER JOIN signature ON " & libcde & ".num_client = signature.CodeClient " & _
                        "   left join clients_new on clients_new.codeclient = " & libcde & ".num_client " & _
                        " where signature.Codevalideur =  '" & Session("client") &  "' order by numerocde desc"

                End If
                If choixCmde.SelectedItem.Value.ToString() = "1" Then
                    SqlDataSource1.SelectCommand = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,Ref_valideur,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue from  " & libcde   & _
                     " LEFT OUTER JOIN signature ON " & libcde & ".num_client = signature.CodeClient " & _
                     " left join clients_new on clients_new.codeclient = " & libcde & ".num_client " & _
                     " where signature.Codevalideur =  '" & Session("client") &  "'  AND num_commande = '"& NumCmde & "' order by num_commande desc"
                    SqlDataSource3.SelectCommand = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,ref_client,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from  " & libcde   & _
                    " left join clients_new " & _
                    " on clients_new.codeclient = " & libcde & ".num_client " & _
                    " where num_client = '" & Session("client") & "' order by numerocde desc "

                End If
                'End If
            Else

                SqlDataSource3.SelectCommand = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,ref_client,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from  " & libcde   & _
                               " left join clients_new " & _
                               " on clients_new.codeclient = " & libcde & ".num_client " & _
                               " where num_client = '" & Session("client") & "' order by numerocde desc "

                SqlDataSource1.SelectCommand = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,Ref_valideur,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from  " & libcde   & _
                                " LEFT OUTER JOIN signature ON " & libcde & ".num_client = signature.CodeClient " & _
                                "   left join clients_new on clients_new.codeclient = " & libcde & ".num_client " & _
                                " where signature.Codevalideur =  '" & Session("client") &  "' order by numerocde desc"


            End If
            'End if input search

        Else
            If idCmd.Text <> "" Then
                NumCmde =  Trim(idCmd.Text)
                Dim  trigramme  As String = NumCmde.Substring(0, 4)
                trigramme = UCase(trigramme)
                If  String.Compare(trigramme, "CEW0") = 0 Then
                    NumCmde = NumCmde.Replace(NumCmde.Substring(0, 4) ,"")
                End IF
                trigramme  = NumCmde.Substring(0, 3)
                trigramme = UCase(trigramme)
                If  String.Compare(trigramme, "CEW") = 0 Then
                    NumCmde = NumCmde.Replace(NumCmde.Substring(0, 3) ,"")
                    req_nCmde= NumCmde
                End IF
                CommandText = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,ref_client,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from " & libcde
                CommandText = CommandText + " left join clients_new on clients_new.codeclient = " & libcde & ".num_client"
                CommandText = CommandText + "  where num_client = '" & filterValue & "'" & " AND num_commande = '" & NumCmde  & "'"
                CommandText = CommandText + " order by CONVERT(datetime, dtcomm, 103) desc,numerocde desc"
                SqlDataSource3.SelectCommand = CommandText
                SqlDataSource3.Select(DataSourceSelectArguments.Empty)
                SqlDataSource3.DataBind()
                SqlDataSource1.SelectCommand = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,Ref_valideur,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from  " & libcde   & _
                    " LEFT OUTER JOIN signature ON " & libcde & ".num_client = signature.CodeClient " & _
                    "   left join clients_new on clients_new.codeclient = " & libcde & ".num_client " & _
                    " where signature.Codevalideur =  '" & Session("client") &  "' order by numerocde desc"
            Else
                SqlDataSource3.SelectCommand = "select [souche]+cast([num_commande] as varchar) as num_commande,dtcomm,societe,modele,ref_client,prix_pointfort,date_usine,montant_usine,nom_usine,date_tournee,heure_tournee,status,langue,num_commande as numerocde from  " & libcde   & _
                            " left join clients_new " & _
                            " on clients_new.codeclient = " & libcde & ".num_client " & _
                            " where num_client = '" & Session("client") & "' order by numerocde desc "


            End If

        End If
        'End is Valideur	 	

        'Dim myConnection As New SqlConnection(ConnectionString)
        'Dim myCommand As New SqlCommand(CommandText, myConnection)

        'myConnection.Open()

        'GridView1.DataSource = myCommand.ExecuteReader(CommandBehavior.Default)

        ' GridView1.DataBind()

        'GridView2.DataBind()

        If GridView2.Rows.Count = 0 Then
            GridView2.Visible = False
            Label3.Visible = False

        Else
            Dim MaTrad As New Tool_fichet
            Label3.Text = MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "CDECLI")
            GridView2.Visible = True
        End If



    End Sub


    Private Function affiche_commande(ByVal wCde As String) As Boolean
        Dim cSql As String


        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")

        Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)

        cSql = " SELECT * FROM " &libcde & _
                            " INNER JOIN portes_confirmation ON " & libcde & ".produit_url = portes_confirmation.produit_url " & _
                                " WHERE     (portes_confirmation.confirmation = 1) and (num_commande=" & wCde & ") AND " & libcde & ".status in ('0','1','2','3','4','5')"



        Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        dbCommand.CommandText = cSql
        dbCommand.Connection = dbConnection

        Dim dataAdapter As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
        dataAdapter.SelectCommand = dbCommand
        Dim dsCommande As System.Data.DataSet = New System.Data.DataSet
        dataAdapter.Fill(dsCommande)



        Dim i As Integer

        For i = 0 To dsCommande.Tables(0).Rows.Count - 1
            ' Console.WriteLine(dsCommande.Tables(0).Rows(i).Item(3).ToString)


            Dim connectionString2 As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")

            Dim dbConnection2 As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString2)

            cSql = "SELECT content FROM econelements WHERE econelements.name='" & _
                                 dsCommande.Tables(0).Rows(i).Item("configuration").ToString & _
                                  "' AND modelversion>='9'"



            Dim dbCommand2 As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
            dbCommand2.CommandText = cSql
            dbCommand2.Connection = dbConnection

            Dim dataAdapter2 As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
            dataAdapter2.SelectCommand = dbCommand
            Dim dsEcon As System.Data.DataSet = New System.Data.DataSet
            dataAdapter.Fill(dsEcon)





            If dsEcon.Tables(0).Rows.Count = 1 Then
                Return True
            End If
            Return False



        Next
    End Function

    Private Function getlongName(ByVal p As String) As String()
        Dim tabName As String() = New String(1) {}
        tabName(0) = p.Substring(0, 3)
        tabName(1) = p.Substring(3, 2)


        Return tabName
    End Function

</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
<div class="row">	
   <div class="col">
    <table cellpadding="0" cellspacing="0" width="400px" class="e_color_back" border="0">
        <tr>
            <td class="e_menu_title" colspan="3">
			          <%  Dim MaTrad As New Tool_fichet
                    Response.Write(MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "TITRE1"))%>
            </td>
        </tr>
        <tr>
            <td style="height: 10px" colspan="3">
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td align="left">
                <% Response.Write(MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "TITRE2"))%>
            </td>
        </tr>
        <tr>
            <td style="height: 5px" colspan="3">
            </td>
        </tr>
        <tr>
            <td align="left">
                <% Response.Write(MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "TEXT1"))%>
            </td>
            <td>
            </td>
            <td align="left">
                <asp:TextBox ID="datedeb" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td align="left">
                <% Response.Write(MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "TEXT2"))%>
            </td>
            <td>
            </td>
            <td align="left">
                <asp:TextBox ID="datefin" runat="server"> </asp:TextBox>&nbsp;
                <asp:Button ID="Button1" OnClick="ApplyFilter_Click" runat="server" Text="Afficher"
                    Style="text-align: center"></asp:Button>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                &nbsp; &nbsp;
            </td>
        </tr>
		 <tr>
            <td style="height: 5px" colspan="3">
            </td>
        </tr>
    </table>
	</div>

	<div class="col">
	<table cellpadding="0" cellspacing="0" width="400px" class="e_color_back" border="0">
        <tr>
            <td class="e_menu_title" colspan="3">
		         <% Response.Write(MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "TITRE3"))%>
            </td>
        </tr>
        <tr>
            <td style="height: 10px" colspan="3">
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td align="left">
              
            </td>
        </tr>
        <tr>
            <td style="height: 5px;" colspan="3" class="radio_input">
			 <% If MaTrad.get_valideur_info(Session("client").ToString(),"CodeValideur") = "" AND GridView2.Visible Then %> 
	            <asp:RadioButtonList ID="choixCmde" runat="server">
                    <asp:ListItem  ID="Item1" Text="Mes commandes" Value="0" Selected="True" />
                    <asp:ListItem  ID="Item2" Text="Commandes clients" Value="1" />
                </asp:RadioButtonList>
						
			 <%  End If%> 
            </td>
        </tr>
        <tr>
            <td align="left" style="padding-left:10px;">
            <% Response.Write(MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "TEXT3"))%> :
			
            </td>
            <td>
			
            </td>
            <td align="left">
			   <asp:TextBox ID="idCmd" runat="server"></asp:TextBox>
               <asp:Button ID="Button2" OnClick="ApplyFilter_ByCmdeClick" runat="server" Text="Afficher"     Style="text-align: center"></asp:Button>
            </td>
        </tr>
        <tr>
            <td align="left">
                &nbsp; &nbsp;
            </td>
            <td>
            </td>
            <td align="left">
              
            </td>
        </tr>
        <tr>
            <td colspan="3">
                &nbsp; &nbsp;
            </td>
        </tr>
		 <tr>
            <td colspan="3">
                &nbsp; 
            </td>
        </tr>
		
    </table>
    </div>
</div>	
<div class="clear"></div>	
    <br />
    <asp:GridView ID="GridView1" runat="server" CellPadding="4" AutoGenerateColumns="False"
        ForeColor="#333333" AllowPaging="True"
        DataSourceID="SqlDataSource3" AllowSorting="True">
        <FooterStyle BackColor="#5D7B9D" ForeColor="White" Font-Bold="True" />
        <RowStyle ForeColor="#333333" BackColor="#F7F6F3" />
        <Columns>
            <asp:HyperLinkField DataTextField="num_commande" DataNavigateUrlFormatString="affiche_commande.aspx?num_commande={0}&type=LG.aspx"
                DataNavigateUrlFields="numerocde,langue" Target="_blank" />
            <asp:BoundField DataField="dtcomm"></asp:BoundField>
            <asp:BoundField DataField="societe"></asp:BoundField>
            <asp:BoundField DataField="modele"></asp:BoundField>
            <asp:BoundField DataField="Ref_Client"></asp:BoundField>
			 <asp:BoundField DataField="prix_pointfort" DataFormatString="{0:C2}">
                <HeaderStyle Width="100px" />
                <ItemStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                    Font-Underline="False" HorizontalAlign="Right" />
            </asp:BoundField>			
            <asp:BoundField DataField="nom_usine" Visible="False"/>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("montant_usine") %>'></asp:Label>
                    &#8364;
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>
			
            <asp:BoundField DataField="Date_Usine"></asp:BoundField>
            <asp:BoundField DataField="date_tournee" />
            <asp:BoundField DataField="heure_tournee" />
            <asp:ImageField>
            </asp:ImageField>
            <asp:TemplateField Visible="False">
                <ItemTemplate>
                    <asp:Label ID="statut" runat="server" Text='<%# Bind("status") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>
            <asp:TemplateField Visible="False">
                <ItemTemplate>
                    <asp:Label ID="cde"  runat="server" Text='<%# Bind("numerocde") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>
		
            <asp:TemplateField></asp:TemplateField>
        </Columns>
        <PagerStyle BackColor="#999999" ForeColor="White" HorizontalAlign="Center" />
        <HeaderStyle BackColor="#999999" Font-Bold="True" ForeColor="White" />
        <EditRowStyle BackColor="#999999" />
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
    </asp:GridView>
    <div>
        &nbsp;<br />
        <asp:Label ID="Label3" runat="server" Text="Label"></asp:Label>
        <br />
    </div>
    <asp:GridView  ID="GridView2" runat="server" CellPadding="4" AutoGenerateColumns="False"
        ForeColor="#333333" AllowPaging="True"
        DataSourceID="SqlDataSource1" AllowSorting="True">
        <FooterStyle BackColor="#5D7B9D" ForeColor="White" Font-Bold="True" />
        <RowStyle ForeColor="#333333" BackColor="#F7F6F3" />
        <Columns>
            <asp:HyperLinkField DataTextField="num_commande" DataNavigateUrlFormatString="affiche_commande.aspx?num_commande={0}&type=VL.aspx"
                DataNavigateUrlFields="num_commande,langue" Target="_blank"  />
            <asp:BoundField DataField="dtcomm"></asp:BoundField>
            <asp:BoundField DataField="societe"></asp:BoundField>
            <asp:BoundField DataField="modele"></asp:BoundField>
            <asp:BoundField DataField="Ref_valideur"></asp:BoundField>
			 
			 <asp:BoundField DataField="prix_pointfort" DataFormatString="{0:C2}">
                <HeaderStyle Width="100px" />
                <ItemStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                    Font-Underline="False" HorizontalAlign="Right" />
            </asp:BoundField>			
            <asp:BoundField DataField="nom_usine" Visible="False"/>			
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("montant_usine") %>'></asp:Label>
                    &#8364;
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>
            <asp:BoundField DataField="Date_Usine"></asp:BoundField>
            <asp:BoundField DataField="date_tournee" />
            <asp:BoundField DataField="heure_tournee" />
            <asp:ImageField>
            </asp:ImageField>
            <asp:TemplateField Visible="False">
                <ItemTemplate>
                    <asp:Label ID="statut" runat="server" Text='<%# Bind("status") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>	
            <asp:TemplateField Visible="False">
                <ItemTemplate>
                    <asp:Label ID="cde" runat="server" Text='<%# Bind("numerocde") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>			
 
            
        </Columns>
        <PagerStyle BackColor="#999999" ForeColor="White" HorizontalAlign="Center" />
        <HeaderStyle BackColor="#999999" Font-Bold="True" ForeColor="White" />
        <EditRowStyle BackColor="#999999" />
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
    </asp:GridView>
    </p> </div>
    <p align="left">
        <br />
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="" ProviderName="System.Data.SqlClient"
            SelectCommand="">
            <SelectParameters>
                <asp:SessionParameter SessionField="client" Name="client" Type="string" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="" ProviderName="System.Data.SqlClient"
            SelectCommand="">
            <SelectParameters>
                <asp:SessionParameter SessionField="client" Name="client" Type="string" />
            </SelectParameters>
        </asp:SqlDataSource>
        <br />
</asp:Content>

