<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void LogOn_Click(object sender, EventArgs e)
    {
        //LogIn(Логін, Пароль, ІПАдреса, СтарийКлюч) Экспорт
        ProtocolWeb38 Web38 = new ProtocolWeb38("LogIn",
            new string[]
            {
                Server.HtmlEncode( UserLogin.Text),
                Server.HtmlEncode(UserPassword.Text),
                Request.UserHostAddress,
                (Session["USER_GUID"] != null ? Session["USER_GUID"].ToString() : "")
            });

        Web38.Send();

        switch (Web38.Packet.StateCode)
        {
            case "200":
                {
                    //ОК
                    if (!String.IsNullOrWhiteSpace(Web38.Packet.Guid))
                    {
                        Session["USER_GUID"] = Web38.Packet.Guid;
                        Response.Redirect("account.aspx");
                    }

                    break;
                }
            case "500":
                {
                    //1C Error
                    Label labmsg = new Label();
                    labmsg.Text = Web38.Packet.Info;
                    PlaceHolderMsg.Controls.Add(labmsg);

                    break;
                }
            default:
                {
                    //Connection error
                    Label labmsg = new Label();
                    labmsg.Text = Web38.Packet.Info;

                    PlaceHolderMsg.Controls.Add(labmsg);

                    break;
                }
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Вхід</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <div class="content">
                
                <center>
                    <h1>Портал. Вхід</h1>
                </center>

                <div>
                    <center>
                        <span style="color: red;">
                            <asp:PlaceHolder ID="PlaceHolderMsg" runat="server"></asp:PlaceHolder>
                        </span>
                    </center>
                    <table width="99%" border="0" cellpadding="0" cellspacing="0" class="form">
                        <col width="15%" />
                        <col width="84%" />
                        <tr>
                            <td align="right" valign="middle">Логін:</td>
                            <td>
                                <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserLogin" TextMode="SingleLine" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="middle">Пароль:</td>
                            <td>
                                <asp:TextBox Width="95%" CssClass="textboxfield2" ID="UserPassword" TextMode="Password" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="clear" colspan="2">
                                <asp:Button CssClass="command" ID="LogOn" Text="Вхід" runat="server" Width="150px" Height="40px" OnClick="LogOn_Click" />
                            </td>
                        </tr>
                    </table>
                </div>

            </div>

        </div>
    </form>
</body>
</html>
