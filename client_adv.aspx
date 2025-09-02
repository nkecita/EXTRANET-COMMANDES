<%@ Page AutoEventWireup="false" CodeFile="client_adv.aspx.vb" Inherits="client_adv"
    MasterPageFile="~/MainMasterPage.master" %>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
   
	<asp:SqlDataSource ID="Customers" runat="server" ConnectionString="" SelectCommand="">
    </asp:SqlDataSource>
    <table style="width: 400px;">
        <tr>
            <td >
                Choisissez un client : 
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td >
                <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="Customers" DataTextField="client"
                    DataValueField="codeclient">
                </asp:DropDownList>
            </td>
            <td style="text-align: left">
                <asp:Button ID="Button1" runat="server" Text="Connexion" />
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
