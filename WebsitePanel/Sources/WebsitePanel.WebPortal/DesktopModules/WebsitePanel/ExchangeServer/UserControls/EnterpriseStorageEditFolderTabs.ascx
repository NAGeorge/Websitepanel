﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnterpriseStorageEditFolderTabs.ascx.cs" Inherits="WebsitePanel.Portal.ExchangeServer.UserControls.EnterpriseStorageEditFolderTabs" %>

<table width="100%" cellpadding="0" cellspacing="1">
    <tr>
        <td class="Tabs">                 
            <asp:DataList ID="esTabs" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" EnableViewState="false">
                <ItemStyle Wrap="False" />
                <ItemTemplate >
                    <asp:HyperLink ID="lnkTab" runat="server" CssClass="Tab" NavigateUrl='<%# Eval("Url") %>' OnClick="return tabClicked();">
                        <%# Eval("Name") %>
                    </asp:HyperLink>
                </ItemTemplate>
                <SelectedItemStyle Wrap="False" />
                <SelectedItemTemplate>
                    <asp:HyperLink ID="lnkSelTab" runat="server" CssClass="ActiveTab" NavigateUrl='<%# Eval("Url") %>' OnClick="return tabClicked;">
                        <%# Eval("Name") %>
                    </asp:HyperLink>
                </SelectedItemTemplate>                
            </asp:DataList>
        </td>
    </tr>
</table>
<br />

<script type="text/javascript">
    function tabClicked() {
        ShowProgressDialog('Loading');
        ShowProgressDialogInternal();
        return true;
    }
</script>