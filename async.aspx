<%@ Page Language="C#" %>

<script runat="server">

    /* Асинхронна загрузка даних з  1С */

    protected void Page_Load(object sender, EventArgs e)
    {
        //Команда
        string command = Request.QueryString["cmd"];

        switch (command)
        {
            case "region_list": //Регіони
                {
                    //GetRegions_Async()
                    ProtocolWeb38 Web38 = new ProtocolWeb38("GetRegions_Async",
                        new string[]
                        {
                             (Session["USER_GUID"] != null ? Session["USER_GUID"].ToString() : ""),
                             Request.UserHostAddress
                        });

                    Web38.Send();

                    if (Web38.Packet.StateCode == "200")
                    {
                        Web38.Transform(Server.MapPath("App_Data/xslt/async/region_list.xslt"), Response.OutputStream);
                    }

                    break;
                }

            case "settlements_list": //Населені пункти
                {
                    string code = Request.QueryString["code"];

                    //GetSettlements_Async(РегионВладелецКод)
                    ProtocolWeb38 Web38 = new ProtocolWeb38("GetSettlements_Async",
                        new string[]
                        {
                            (Session["USER_GUID"] != null ? Session["USER_GUID"].ToString() : ""),
                             Request.UserHostAddress,
                             Server.HtmlEncode(code)
                        });

                    Web38.Send();

                    if (Web38.Packet.StateCode == "200")
                    {
                        Web38.Transform(Server.MapPath("App_Data/xslt/async/settlements_list.xslt"), Response.OutputStream);
                    }

                    break;
                }

            default:
                {
                    break;
                }
        }
    }

</script>
