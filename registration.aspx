<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Registration_Click(object sender, EventArgs e)
    {
        ProtocolWeb38 Web38 = new ProtocolWeb38("Registration",
            new string[]
            {
                Request.UserHostAddress,
                UserName.Text,
                UserEmail.Text,
                UserPhone.Text,
                UserPassword.Text
            });

        Web38.Send();

        if (Web38.ReceivePacket.StateCode == "200")
        {
            //Код 200 значить що все ОК, 
            //дані записані і потрібно перенаправити користувача на сторінку редагування особистих даних
            Session["USER_GUID"] = Web38.ReceivePacket.Guid;
            Response.Redirect("update_acaunt.aspx");
        }
        else if (Web38.ReceivePacket.StateCode == "301")
        {
            //Код 301 значить що не заповнені всі поля
            Label labmsg = new Label();
            labmsg.Text = Web38.ReceivePacket.Info;

            PlaceHolderMsg.Controls.Add(labmsg);
        }
        else
        {
            Label labmsg = new Label();
            labmsg.Text = "Error: " + Web38.ReceivePacket.StateCode;

            PlaceHolderMsg.Controls.Add(labmsg);
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Реєстрація</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
    <link href="css/global.css" rel="stylesheet" type="text/css" />
    <link href="css/login.css" rel="stylesheet" type="text/css" />
</head>
<body>
<form id="form1" runat="server">
<div>
    <div class="content">
        <div style="text-align:center;">
            <h1>Реєстрація</h1>
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
                    <td align="right" valign="middle">Як Вас звати:</td>
                    <td>
                        <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserName" TextMode="SingleLine" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" valign="middle">Email:</td>
                    <td>
                        <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserEmail" TextMode="SingleLine" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" valign="middle">Телефон:</td>
                    <td>
                        <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserPhone" TextMode="SingleLine" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" valign="middle">Пароль:</td>
                    <td>
                        <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserPassword" TextMode="Password" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="clear"> </td>
                    <td class="clear">
                        <asp:Button CssClass="command" ID="Registration" Text="Готово" runat="server" Width="150px" Height="30px" OnClick="Registration_Click" />               
                    </td>
                </tr>
            </table>
        </div>
		
    </div>
</div>
</form>
</body>
</html>
