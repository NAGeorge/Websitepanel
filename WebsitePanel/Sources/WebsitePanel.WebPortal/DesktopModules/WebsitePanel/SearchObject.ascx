﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchObject.ascx.cs" Inherits="WebsitePanel.Portal.SearchObject" %>
<%@ Import Namespace="WebsitePanel.Portal" %>

<script>
    var estop = function (e) {
        if (!e) e = window.event;
        e.cancelBubble = true;
        if (e.stopPropagation) e.stopPropagation();
        return e;
    }

    var CPopupDialog = function (el, e) {
        if (typeof el == 'string')
            el = document.getElementById(el);
        e = estop(e);

        var oldclick = document.body.onclick;
        el.onclick = estop;

        function close() {
            el.style.display = "none";
            document.body.onclick = oldclick;
        }

        function show(x, y) {
            el.style.left = x ? x : e.clientX + document.documentElement.scrollLeft + "px";
            el.style.top = y ? y : e.clientY + document.documentElement.scrollTop + "px";
            el.style.display = "block";
            document.body.onclick = close;
        }

        show();
    };

    $(document).ready(function () {
        var loadFilters = function()
        {
            var typesSelected = JSON.parse($("#tbFilters").val());
            $("#mydialog input[rel]").each(function () {
                var rel = $(this).attr('rel');
                if (typesSelected.indexOf(rel) >= 0)
                    $(this).val("1");
            })
        }

        $("#btnSelectFilter").click(function(e)
        {
            var typesSelected = [];
            $("#mydialog input[rel]").each(function () {
                var val = $(this).attr("checked");
                if (val) typesSelected.push($(this).attr('rel'));
            });
            $("#tbFilters").val(JSON.stringify(typesSelected));
            document.forms[0].submit();
        })

        loadFilters();
    });

</script>

<asp:GridView id="gvObjects" runat="server" AutoGenerateColumns="False"
	AllowPaging="True" AllowSorting="True"
	CssSelectorClass="NormalGridView"
	DataSourceID="odsObjectsPaged" EnableViewState="False"
	EmptyDataText=<%# GetSharedLocalizedString("SearchObject.NOT_FOUND") %>>
	<Columns>
        <asp:TemplateField HeaderText="gvType" SortExpression="ColumnType">
            <HeaderTemplate>
                <a href="javascript: void(0)" onclick="CPopupDialog('mydialog',event)">Type</a>
            </HeaderTemplate>
            <ItemTemplate>
                <%# GetTypeDisplayName((string)Eval("ColumnType")) %>
            </ItemTemplate>
        </asp:TemplateField>
		<asp:TemplateField SortExpression="TextSearch" HeaderText="gvText" HeaderStyle-Wrap="false">
			<ItemTemplate>
	            <asp:hyperlink id=lnkUser runat="server" NavigateUrl='<%# GetItemPageUrl((string)Eval("FullType"), (string)Eval("ColumnType"), (int)Eval("ItemID"), (int)Eval("PackageID"), (int)Eval("AccountID")) %>'>
		            <%# Eval("TextSearch") %>
	            </asp:hyperlink>
            </ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField SortExpression="FullType" HeaderText="gvFullType" HeaderStyle-Wrap="false">
            <ItemTemplate>
                <%# GetTypeDisplayName((string)Eval("FullType")) %>
            </ItemTemplate>
        </asp:TemplateField>		
	</Columns>
</asp:GridView>

<asp:ObjectDataSource ID="odsObjectsPaged" runat="server" EnablePaging="True" SelectCountMethod="SearchObjectItemsPagedCount"
    SelectMethod="SearchObjectItemsPaged" SortParameterName="sortColumn" TypeName="WebsitePanel.Portal.PackagesHelper" OnSelected="odsObjectPaged_Selected" OnSelecting="odsObjectPaged_Selecting">
    <SelectParameters>
        <asp:QueryStringParameter Name="filterColumn" QueryStringField="Criteria" />
        <asp:QueryStringParameter Name="filterValue" QueryStringField="Query" />
        <asp:QueryStringParameter Name="fullType" QueryStringField="FullType" />
    </SelectParameters>
</asp:ObjectDataSource>

<asp:ObjectDataSource ID="odsObjectTypes" runat="server" EnablePaging="false"
    SelectMethod="SearchObjectTypes" SortParameterName="sortColumn" TypeName="WebsitePanel.Portal.PackagesHelper">
    <SelectParameters>
        <asp:QueryStringParameter Name="filterColumn" QueryStringField="Criteria" />
        <asp:QueryStringParameter Name="filterValue" QueryStringField="Query" />
        <asp:QueryStringParameter Name="fullType" QueryStringField="FullType" />
    </SelectParameters>
</asp:ObjectDataSource>

<div id="mydialog" class="ui-popupdialog">
	<div class="title">Select filter</div>
	<div class="content">
        <asp:GridView runat="server" DataSourceID="odsObjectTypes" SortParameterName="sortColumn" ShowHeader="false" AutoGenerateColumns="false">
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <input type="checkbox" runat="server" rel='<%# Eval("ColumnType") %>'></input>
                        <%# Eval("ColumnType") %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
	</div>
	<div class="actions">
		<a id="btnSelectFilter" href="javascript: void(0)" class="ui-button">Apply</a>
		<a onclick="document.body.onclick.apply(event)" href="javascript: void(0)" class="ui-button">Close</a>
		<div style="clear:both"></div>
	</div>
    <asp:TextBox ClientIDMode="Static" ID="tbFilters" type="hidden" runat="server"></asp:TextBox>
</div>