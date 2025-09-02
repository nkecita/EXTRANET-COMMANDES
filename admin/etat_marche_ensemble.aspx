<%@ Page MasterPageFile="~/admin/AdminMasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
    
    Public sPATH As String = ""
    Public tabName As String() = New String(1) {}
    
    Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session.Abandon()
        Response.Redirect("../login.aspx")
    End Sub
    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
        Dim MaTrad As New Tool_fichet
        Me.Label1.Text = "Liste des marches-ensembles"
        SqlDataSource1.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon")
    End Sub
    
    Private Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Dim MaTrad As New Tool_fichet
        If e.Row.RowType = DataControlRowType.Header Then
     
            e.Row.Cells(0).Text = "Commandes"
            e.Row.Cells(1).Text = "Cylindre"
            e.Row.Cells(2).Text = "Principal"
            e.Row.Cells(3).Text = "Contrôle"
            e.Row.Cells(4).Text = "Date"
            e.Row.Cells(5).Text = "Client"
            e.Row.Cells(6).Text = "Société"

        End If

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim Lblcde As Label
            Lblcde = e.Row.FindControl("cde")
            Dim ToolRecup As New Tool_fichet
            tabName = getlongName(Lblcde.Text.ToString().PadLeft(7, "0"))
            'e.Row.Cells(0).Text = "<a href='" & "http://econ.fichet-pointfort.fr/commandes/CEW" & Lblcde.Text.ToString().PadLeft(7, "0") & "_TC.HTML" & "' target='_BLANK'>" & Lblcde.Text & "</A>" & IIf(ToolRecup.get_commande_marche_ensemble(Lblcde.Text).ToString.Trim <> "", " - " & ToolRecup.get_commande_marche_ensemble(Lblcde.Text), "")
            e.Row.Cells(0).Text = "<a href='" & sPATH & "/commandes/" & tabName(0) & "/" & tabName(1) & "/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_TC.HTML" & "' target='_BLANK'>" & Lblcde.Text & "</A>" & IIf(ToolRecup.get_commande_marche_ensemble(Lblcde.Text).ToString.Trim <> "", " - " & ToolRecup.get_commande_marche_ensemble(Lblcde.Text), "")
           
            
           
           
        End If
    End Sub

    Private Function getlongName(ByVal p As String) As String()
        Dim tabName As String() = New String(1) {}
        tabName(0) = p.Substring(0, 3)
        tabName(1) = p.Substring(3, 2)


        Return tabName
    End Function
   
</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    <div class="e_menu_title" style="width: 90%">
        <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label><br />
    </div>
    <br />
    <br />
    <div align="center">
        <asp:GridView ID="GridView1" runat="server" CellPadding="4" AutoGenerateColumns="False"
            ForeColor="#333333" AllowPaging="True"
            DataSourceID="SqlDataSource1" AllowSorting="True">
            <FooterStyle BackColor="#5D7B9D" ForeColor="White" Font-Bold="True" />
            <RowStyle ForeColor="#333333" BackColor="#F7F6F3" />
            <Columns>
                <asp:HyperLinkField DataTextField="num_commande" />
                <asp:BoundField DataField="cp_cylindre_label"></asp:BoundField>
                <asp:BoundField DataField="principal"></asp:BoundField>
                <asp:BoundField DataField="control"></asp:BoundField>
                <asp:BoundField DataField="dtcomm"></asp:BoundField>
                <asp:BoundField DataField="num_client"></asp:BoundField>
                <asp:BoundField DataField="societe"></asp:BoundField>
                <asp:TemplateField Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="cde" runat="server" Text='<%# Bind("num_commande") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>
            </Columns>
            <PagerStyle BackColor="#999999" ForeColor="White" HorizontalAlign="Center" />
            <HeaderStyle BackColor="#999999" Font-Bold="True" ForeColor="White" />
            <EditRowStyle BackColor="#999999" />
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        </asp:GridView>
        <br />
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="" ProviderName="System.Data.SqlClient"
            SelectCommand="SELECT num_client,num_commande,dtcomm,societe,cp_cylindre_label,cp_march_id,cc_march_id,cp_cc_nocde ,
                                CASE cp_march_id when 'EXTERN' then 'OUI' else '' end as principal,
                                CASE cc_march_id when 'PORTE' then 'OUI' else '' end as control
                                FROM commandes_portes
                                WHERE (cp_march_id='EXTERN' or cc_march_id='PORTE') and cp_cc_nocde is  null
                                ORDER BY  CONVERT(datetime, dtcomm, 103)  DESC"></asp:SqlDataSource>
    </div>
</asp:Content>
