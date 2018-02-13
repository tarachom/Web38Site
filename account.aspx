<%@ Page Language="C#" %>

<%@ Register Src="~/HeaderAndLeft.ascx" TagPrefix="uc1" TagName="HeaderAndLeft" %>
<%@ Register Src="~/Footer.ascx" TagPrefix="uc1" TagName="Footer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    /// <summary>
    /// Інформації про акаунт
    /// </summary>
    protected void ReadAccountInfo()
    {
        //ReadAccountInfo(Ключ, ІПАдреса)
        ProtocolWeb38 Web38 = new ProtocolWeb38("ReadAccountInfo",
            new string[]
            {
                (Session["USER_GUID"] != null ? Session["USER_GUID"].ToString() : ""),
                Request.UserHostAddress
            });

        Web38.Send();

        switch (Web38.Packet.StateCode)
        {
            case "200":
                {
                    //ОК
                    UserLogin.Text = Web38.Packet.UserInfo.Code;
                    UserName.Text = Web38.Packet.UserInfo.Name;

                    Contragent сontragent = new Contragent(Web38.XmlDoc);
                    ContragentName.Text = сontragent.Name;
                    ContragentСontacty.Text = сontragent.Contacty;

                    Label labmsg = new Label();
                    labmsg.Style.Add("color", "green");

                    PlaceHolderMsg.Controls.Add(labmsg);

                    break;
                }
            case "400":
                {
                    //Потрібно пройти авторизацію
                    Session.Abandon();
                    Response.Redirect("login.aspx");

                    break;
                }
            case "500":
                {
                    //1C Error
                    Label labmsg = new Label();
                    labmsg.Style.Add("color", "red");
                    labmsg.Text = "Error: " + Web38.Packet.StateCode;

                    PlaceHolderMsg.Controls.Add(labmsg);

                    break;
                }
            default:
                {
                    //Connection error
                    Label labmsg = new Label();
                    labmsg.Style.Add("color", "red");
                    labmsg.Text = "Error: " + Web38.Packet.StateCode;

                    PlaceHolderMsg.Controls.Add(labmsg);

                    break;
                }
        }

        HeaderAndLeft.WriteUserName(Web38.Packet.UserInfo);
    }

    /// <summary>
    /// Запис
    /// </summary>
    protected void UpdateAcaunt_Click(object sender, EventArgs e)
    {
        //UpdateAccount(Ключ, ІПАдреса, Назва, ЕмайлТаТелефон, СтарийПароль, Пароль)
        ProtocolWeb38 Web38 = new ProtocolWeb38("UpdateAccount",
            new string[]
            {
               (Session["USER_GUID"] != null ? Session["USER_GUID"].ToString() : ""),
                Request.UserHostAddress,
                UserName.Text,
                ContragentСontacty.Text,
                UserOldPassword.Text,
                UserPassword.Text
            });

        Web38.Send();

        switch (Web38.Packet.StateCode)
        {
            case "200":
                {
                    //ОК 
                    Label labmsg = new Label();
                    labmsg.Style.Add("color", "green");
                    labmsg.Text = Web38.Packet.Info;

                    PlaceHolderMsg.Controls.Add(labmsg);

                    //Перечитати інформацію з бази даних
                    ReadAccountInfo();

                    break;
                }
            case "300":
                {
                    //Не заповнені всі поля
                    Label labmsg = new Label();
                    labmsg.Style.Add("color", "red");
                    labmsg.Text = Web38.Packet.Info;

                    PlaceHolderMsg.Controls.Add(labmsg);

                    break;
                }
            case "400":
                {
                    //Потрібно пройти авторизацію
                    Session.Abandon();
                    Response.Redirect("login.aspx");

                    break;
                }
            case "500":
                {
                    //Помилка
                    Label labmsg = new Label();
                    labmsg.Style.Add("color", "red");
                    labmsg.Text = Web38.Packet.Info;

                    PlaceHolderMsg.Controls.Add(labmsg);

                    break;
                }
            default:
                {
                    Label labmsg = new Label();
                    labmsg.Style.Add("color", "red");
                    labmsg.Text = Web38.Packet.Info;

                    PlaceHolderMsg.Controls.Add(labmsg);

                    break;
                }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.HttpMethod != "POST")
        {
            ReadAccountInfo();
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Налаштування</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
    <link href="/css/style.css" rel="stylesheet" type="text/css" />
</head>
<body>

    <uc1:HeaderAndLeft runat="server" ID="HeaderAndLeft" />

    <h2><img alt="Налаштування" src="/img/ico/settings.png" /> Налаштування</h2>

    <form id="form1" runat="server">

        <table width="700" border="0" cellpadding="0" cellspacing="0" class="form">
            <col width="30%" />
            <col width="70%" />
            <caption>
                <asp:PlaceHolder ID="PlaceHolderMsg" runat="server"></asp:PlaceHolder>
            </caption>
            <tr>
                <td align="right" valign="middle">Логін:</td>
                <td>
                    <asp:TextBox Width="90%" CssClass="textboxfield2" ID="UserLogin" TextMode="SingleLine" runat="server" Enabled="false"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right" valign="middle">Контрагент:</td>
                <td>
                    <asp:TextBox Width="90%" CssClass="textboxfield2" ID="ContragentName" TextMode="SingleLine" runat="server" Enabled="false"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right" valign="middle"><span class="span_red">*</span> Назва користувача:</td>
                <td>
                    <asp:TextBox Width="90%" CssClass="textboxfield2" ID="UserName" TextMode="SingleLine" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right" valign="middle"><span class="span_red">*</span> Email та телефон:</td>
                <td>
                    <asp:TextBox Width="90%" CssClass="textboxfield2" ID="ContragentСontacty" TextMode="SingleLine" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="clear"></td>
                <td class="clear">Заповніть якщо вам потрібно змінити пароль:</td>
            </tr>
            <tr>
                <td align="right" valign="middle">Пароль:</td>
                <td>
                    <asp:TextBox Width="90%" CssClass="textboxfield2" ID="UserOldPassword" TextMode="Password" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right" valign="middle">Новий пароль:</td>
                <td>
                    <asp:TextBox Width="90%" CssClass="textboxfield2" ID="UserPassword" TextMode="Password" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="clear"></td>
                <td class="clear">
                    <asp:Button ID="UpdateAcaunt" Text="Записати" runat="server" Width="150px" Height="30px" OnClick="UpdateAcaunt_Click" />
                </td>
            </tr>
        </table>

    </form>

    <uc1:Footer runat="server" ID="Footer" />

</body>
</html>
