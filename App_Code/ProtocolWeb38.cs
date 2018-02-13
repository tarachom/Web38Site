using System;
using System.Text;
using System.Net.Sockets;
using System.Xml;
using System.Xml.Xsl;
using System.Collections.Generic;

/// <summary>
/// Протокол передачі пакетів
/// </summary>
public class ProtocolWeb38
{
    #region Для_відправки_1C

    /// <summary>
    /// Назва процедури чи функції в модулі зовнішнього з'єднання 1C
    /// </summary>
    public string Function { get; set; }

    /// <summary>
    /// Список параметрів процедури чи функції
    /// </summary>
    public string[] Param { get; set; }

    /// <summary>
    /// Побудова XML пакета для відправки
    /// </summary>
    /// <returns>ХМЛ дані</returns>
    private string BuildMessage()
    {
        string message = @"<?xml version=""1.0"" encoding=""utf-8""?>";

        //Корінна вітка
        message += "<root>";

        //Назва процедури чи функції
        message += "<function>" + Function + "</function>";

        if (Param != null)
        {
            //Параметри
            message += "<params>";

            foreach (string paramItem in Param)
                message += "<item><![CDATA[" + paramItem + "]]></item>";

            message += "</params>";
        }

        message += "</root>";

        return message;
    }

    #endregion

    #region Отримано_З_1C

    /// <summary>
    /// Заголовки отриманого пакету (стан, унікальний ключ, додаткова інформація)
    /// </summary>
    public PacketState Packet { get; private set; }

    /// <summary>
    /// Отримані XML дані
    /// </summary>
    public string ReceiveXml { get; private set; }

    /// <summary>
    /// XmlDocument на основі отриманих XML даних
    /// </summary>
    public XmlDocument XmlDoc { get; private set; }

    #endregion

    /// <summary>
    /// Конструктор
    /// </summary>
    public ProtocolWeb38(){ /**/ }

    /// <summary>
    /// Конструктор
    /// </summary>
    /// <param name="function">Назва процедури чи функціїї в 1С</param>
    /// <param name="param">Масив параметрів у тій послідовності як вони йдуть в 1С</param>
    public ProtocolWeb38(string function, string[] param = null)
    {
        Function = function;
        Param = param;
    }

    /// <summary>
    /// Відправка пакета. 
    /// Результуючі XML дані будуть збережені в ReceiveXML. 
    /// Заголовки зворотнього пакета в Packet.
    /// </summary>
    /// <returns>Результат</returns>
    public void Send()
    {
        ReceiveXml = "";
        XmlDoc = null;
        Packet = null;

        using (Socket sender = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp))
        {
            byte[] byffer = new byte[1024];
            byte[] msg = Config.Win1251.GetBytes(BuildMessage());

            int bytesSend = 0;
            int bytesReceive = 0;

            try
            {
                sender.Connect(Config.Web38ServerIP, Config.Web38ServerPort);

                //Відправляю дані
                bytesSend = sender.Send(msg);

                //Зчитую дані
                do
                {
                    bytesReceive = sender.Receive(byffer);
                    ReceiveXml += Config.Win1251.GetString(byffer, 0, bytesReceive);
                }
                while (sender.Available > 0);

                sender.Shutdown(SocketShutdown.Both);
                sender.Close();  
            }
            catch (Exception ex)
            {
                ReceiveXml = EmptyXMLReply("0", "Connection error", ex.Message);
            }
        }

        XmlDoc = new XmlDocument();

        try
        {
            //Загрузка отриманих даних в дерево ХМЛ
            XmlDoc.LoadXml(ReceiveXml);
        }
        catch (Exception ex)
        {
            ReceiveXml = EmptyXMLReply("1", "Load data error", ex.Message);
            XmlDoc.LoadXml(ReceiveXml);
        }

        //Розбор заголовків отриманого пакету
        Packet = new PacketState(XmlDoc);
    }

    /// <summary>
    /// Відправити пакет та транформувати ХМЛ дані також записати результати в основний потік даних Response.OutputStream
    /// </summary>
    /// <param name="templatePath">Шлях до шаблону</param>
    /// <param name="responseStream">Потік куди записати результат трансформації</param>
    /// <param name="xsltArgDictionary">Параметри для шаблону</param>
    public void SendAndTransform(string templatePath, System.IO.Stream responseStream, Dictionary<string, object> xsltArgDictionary = null)
    {
        //Відправка пакета
        Send();

        //Трансформація
        Transform(templatePath, responseStream, xsltArgDictionary);
    }

    /// <summary>
    /// Трансформувати ХМЛ дані отримані попередньою відправкою пакета та записати результати в основний потік даних Response.OutputStream
    /// </summary>
    /// <param name="templatePath">Шлях до шаблону</param>
    /// <param name="responseStream">Потік куди записати результат трансформації</param>
    /// <param name="xsltArgDictionary">Параметри для шаблону</param>
    public void Transform(string templatePath, System.IO.Stream responseStream, Dictionary<string, object> xsltArgDictionary = null)
    {
        //Якщо отримані дані були загружені в дерево
        if (XmlDoc != null)
        {
            //Загружаєм шаблон
            XslCompiledTransform xslt = new XslCompiledTransform();
            xslt.Load(templatePath);

            XsltArgumentList XsltArg = null;

            //Додаткові параметри в шаблон
            if (xsltArgDictionary != null)
            {
                XsltArg = new XsltArgumentList();

                foreach (KeyValuePair<string, object> xsltArgItem in xsltArgDictionary)
                    XsltArg.AddParam(xsltArgItem.Key, "", xsltArgItem.Value);
            }

            //Трансформуєм XML в HTML
            xslt.Transform(XmlDoc.CreateNavigator(), XsltArg, responseStream);
        }
    }

    /// <summary>
    /// Трансформувати ХМЛ дані отримані попередньою відправкою пакета та повернути результати без запису в основний потік 
    /// </summary>
    /// <param name="templatePath">Шлях до шаблону</param>
    /// <param name="xsltArgDictionary">Параметри для шаблону</param>
    /// <returns></returns>
    public string Transform(string templatePath, Dictionary<string, object> xsltArgDictionary = null)
    {
        //Якщо отримані дані були загружені в дерево
        if (XmlDoc != null)
        {
            //Загружаєм шаблон
            XslCompiledTransform xslt = new XslCompiledTransform();
            xslt.Load(templatePath);

            XsltArgumentList XsltArg = null;

            //Додаткові параметри в шаблон
            if (xsltArgDictionary != null)
            {
                XsltArg = new XsltArgumentList();

                foreach (KeyValuePair<string, object> xsltArgItem in xsltArgDictionary)
                    XsltArg.AddParam(xsltArgItem.Key, "", xsltArgItem.Value);
            }

            //Потік в памяті
            System.IO.MemoryStream memoryStreamToHTML = new System.IO.MemoryStream();

            //Трансформуєм XML в HTML
            xslt.Transform(XmlDoc.CreateNavigator(), XsltArg, memoryStreamToHTML);

            return Encoding.UTF8.GetString(memoryStreamToHTML.ToArray());
        }
        else
            return "";
    }

    /// <summary>
    /// Чистий ХМЛ пакет
    /// </summary>
    /// <param name="stateCode">Код статусу</param>
    /// <param name="stateInfo">Деталізуюча інформація</param>
    /// <param name="stateDesc">Деталізація</param>
    /// <returns>ХМЛ дані</returns>
    private string EmptyXMLReply(string stateCode, string stateInfo, string stateDesc = "")
    {
        return @"<?xml version=""1.0"" encoding=""utf-8""?>
                 <root>
                      <state code=""" + stateCode + @""" guid="""">" + @"
                            <info><![CDATA[" + stateInfo + @"]]></info>
                            <desc><![CDATA[" + stateDesc + @"]]></desc>
                      </state>
                 </root>";
    }
}