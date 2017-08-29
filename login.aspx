<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void LogOn_Click(object sender, EventArgs e)
    {
        ProtocolWeb38 Web38 = new ProtocolWeb38("LogIn",
            new string[]
            {
                UserLogin.Text,
                UserPassword.Text,
                Request.UserHostAddress
            });

        Web38.Send();

        if (Web38.ReceivePacket.StateCode == "200")
        {
            //Код 200 значить що все ОК
            Session["USER_GUID"] = Web38.ReceivePacket.Guid;
            Response.Redirect("update_acaunt.aspx");
        }
        else
        {
            Label labmsg = new Label();
            labmsg.Text = Web38.ReceivePacket.Info;

            PlaceHolderMsg.Controls.Add(labmsg);
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Вхід</title>
    <link href="css/global.css" rel="stylesheet" type="text/css" />
    <link href="css/login.css" rel="stylesheet" type="text/css" />
</head>
<body>
<form id="form1" runat="server">
<div>
    <div class="content">
        <div style="text-align:center;">
            <h1>Вхід</h1>
        </div>
        <div>
            <center>
                <span style="color:red;">
                    <asp:PlaceHolder ID="PlaceHolderMsg" runat="server"></asp:PlaceHolder>
                </span>
            </center>
            <table width="99%" border="0" cellpadding="0" cellspacing="0" class="form">
                <col width="15%"/>
                <col width="84%"/>
                <tr>
                    <td align="right" valign="middle">
                        Логін:
                    </td>
                    <td>
                        <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserLogin" TextMode="SingleLine" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" valign="middle">
                        Пароль:
                    </td>
                    <td>
                        <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserPassword" TextMode="Password" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="clear"> </td>
                    <td class="clear">
                        <asp:Button CssClass="command" ID="LogOn" Text="Вхід" runat="server" Width="150px" Height="30px" OnClick="LogOn_Click" />               
                    </td>
                </tr>
            </table>
        </div>
		
    </div>
</div>
</form>
</body>
</html>
