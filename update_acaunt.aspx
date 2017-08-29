<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void ReadAcauntInfo()
    {
        //ReadAcauntInfo(Ключ, ІПАдреса)
        ProtocolWeb38 Web38 = new ProtocolWeb38("ReadAcauntInfo",
            new string[]
            {
                (Session["USER_GUID"] != null ? Session["USER_GUID"].ToString() : ""),
                Request.UserHostAddress
            });

        Web38.Send();

        if (Web38.ReceivePacket.StateCode == "200")
        {
            //Код 200 значить що все ОК
            UserLogin.Text = Web38.XMLDoc.SelectSingleNode("/root/contragent/login").InnerText;
            UserName.Text = Web38.XMLDoc.SelectSingleNode("/root/contragent/name").InnerText;
            UserСontacty.Text = Web38.XMLDoc.SelectSingleNode("/root/contragent/contacty").InnerText;

            Label labmsg = new Label();
            labmsg.Style.Add("color","green");
            labmsg.Text = Web38.Transform(Server.MapPath("xslt/lite.xslt"));

            PlaceHolderMsg.Controls.Add(labmsg);
        }
        else if (Web38.ReceivePacket.StateCode == "404")
        {
            //Код 404 значить що потрібно пройти авторизацію
            Session.Abandon();
            Response.Redirect("login.aspx");
        }
        else
        {
            Label labmsg = new Label();
            labmsg.Style.Add("color","red");
            labmsg.Text = "Error: " + Web38.ReceivePacket.StateCode;

            PlaceHolderMsg.Controls.Add(labmsg);
        }
    }

    protected void UpdateAcaunt_Click(object sender, EventArgs e)
    {
        //UpdateAcaunt(Ключ, ІПАдреса, Назва, ЕмайлТаТелефон, СтарийПароль, Пароль)
        ProtocolWeb38 Web38 = new ProtocolWeb38("UpdateAcaunt",
            new string[]
            {
               (Session["USER_GUID"] != null ? Session["USER_GUID"].ToString() : ""),
                Request.UserHostAddress,
                UserName.Text,
                UserСontacty.Text,
                UserOldPassword.Text,
                UserPassword.Text
            });

        Response.Write("<!--\n\n\n" + Web38.Send() + "\n\n\n-->" + "\n\n");

        if (Web38.ReceivePacket.StateCode == "200")
        {
            //Код 200 значить що все ОК, 
            Label labmsg = new Label();
            labmsg.Style.Add("color","blue");
            labmsg.Text = Web38.ReceivePacket.Info;

            PlaceHolderMsg.Controls.Add(labmsg);

            ReadAcauntInfo();
        }
        else if (Web38.ReceivePacket.StateCode == "301")
        {
            //Код 301 значить що не заповнені всі поля
            Label labmsg = new Label();
            labmsg.Style.Add("color","red");
            labmsg.Text = Web38.ReceivePacket.Info;

            PlaceHolderMsg.Controls.Add(labmsg);
        }
        else if (Web38.ReceivePacket.StateCode == "404")
        {
            //Код 404 значить що потрібно пройти авторизацію
            Session.Abandon();
            Response.Redirect("login.aspx");
        }
        else
        {
            Label labmsg = new Label();
            labmsg.Style.Add("color","red");
            labmsg.Text = Web38.ReceivePacket.Info;

            PlaceHolderMsg.Controls.Add(labmsg);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.HttpMethod != "POST")
        {
            ReadAcauntInfo();
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Обновлення даних</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
    <link href="css/global.css" rel="stylesheet" type="text/css" />
    <link href="css/login.css" rel="stylesheet" type="text/css" />
</head>
<body>

    <!-- #include file="~/menu.html" -->

    <form id="form1" runat="server">
        <div>
            <div class="content">

                <div style="text-align: center;">
                    <h1>Обновлення даних</h1>
                </div>
                <div>
                    <center>
                        <asp:PlaceHolder ID="PlaceHolderMsg" runat="server"></asp:PlaceHolder>
                    </center>
                    <table width="99%" border="0" cellpadding="0" cellspacing="0" class="form">
                        <col width="15%" />
                        <col width="84%" />
                        <tr>
                            <td align="right" valign="middle">Логін:
                            </td>
                            <td>
                                <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserLogin" TextMode="SingleLine" runat="server" Enabled="false"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="middle">Назва:
                            </td>
                            <td>
                                <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserName" TextMode="SingleLine" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="middle">Email та телефон:
                            </td>
                            <td>
                                <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserСontacty" TextMode="SingleLine" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="middle">Пароль:
                            </td>
                            <td>
                                <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserOldPassword" TextMode="Password" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="middle">Новий пароль:
                            </td>
                            <td>
                                <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserPassword" TextMode="Password" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="clear"></td>
                            <td class="clear">
                                <asp:Button CssClass="command" ID="UpdateAcaunt" Text="Готово" runat="server" Width="150px" Height="30px" OnClick="UpdateAcaunt_Click" />
                            </td>
                        </tr>
                    </table>
                </div>

            </div>
        </div>
    </form>
</body>
</html>
