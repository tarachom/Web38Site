<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //ReadAcauntInfo(Ключ, ІПАдреса)
        ProtocolWeb38 Web38 = new ProtocolWeb38("LogOff",
            new string[]
            {
                Session["USER_GUID"].ToString(),
                Request.UserHostAddress
            });

        Web38.Send();

        if (Web38.ReceivePacket.StateCode == "200")
        {
            //Код 200 значить що все ОК
            Session.Abandon();
            Response.Redirect("login.aspx");
        }
        else
        {
            Session.Abandon();
            Response.Write( "Error: " + Web38.ReceivePacket.StateCode);
        }
    }

</script>
