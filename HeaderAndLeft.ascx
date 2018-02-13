<%@ Control Language="C#" ClassName="HeaderAndLeft" %>

<script runat="server">

    public void WriteUserName(UserInfo userInfo)
    {
        if (userInfo != null)
        {
            UserInfo.Text = "Користувач: " + userInfo.Name;
        }
    }

</script>

<div id="container">
    <div id="header">

        <div class="logo">
            <a href="/account.aspx">
                НАЗВА
            </a>
        </div>

        <div class="userinfo">
            <asp:Label ID="UserInfo" runat="server"></asp:Label>
        </div>        

        <div class="clear"></div>
    </div>

    <div id="left">
        <ul class="leftmenu">
            <li>
                <a href="/account.aspx"><img src="/img/ico/settings.png" /></a>
                <a href="/account.aspx">Налаштування</a>
            </li>
            <li>
                <a href="/logoff.aspx"><img src="/img/ico/logout.png" /></a> 
                <a href="/logoff.aspx">Вийти</a>
            </li>
        </ul>
    </div>

    <div id="content">
        <div id="content_in">

            <!-- ... -->
