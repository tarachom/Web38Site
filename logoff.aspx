<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //LogOff(Ключ, ІПАдреса)
        ProtocolWeb38 Web38 = new ProtocolWeb38("LogOff",
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
                    Session.Abandon();
                    Response.Redirect("login.aspx");

                    break;
                }
            case "500":
                {
                    //1C Error
                    Session.Abandon();
                    Response.Write("Error: " + Web38.Packet.StateCode);

                    break;
                }
            default:
                {
                    //Connection error
                    Session.Abandon();
                    Response.Write("Error: " + Web38.Packet.StateCode);

                    break;
                }
        }
    }

</script>
