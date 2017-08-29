using System.Text;
using System.Net.Sockets;
using System.Xml;
using System.Xml.Xsl;
using System.Collections.Generic;

/// <summary>
/// Протокол передачі пакетів посереднику
/// </summary>
public class ProtocolWeb38
{
    /// <summary>
    /// Конструктор
    /// </summary>
	public ProtocolWeb38(){ /**/ }

    /// <summary>
    /// Конструктор
    /// </summary>
    /// <param name="member">Назва процедури чи функціїї в 1С</param>
    /// <param name="param">Масив параметрів у тій послідовності як вони йдуть в 1С</param>
    public ProtocolWeb38(string member, string[] param = null)
    {
        Member = member;
        Param = param;
    }

    /// <summary>
    /// Кодіровка windows-1251
    /// </summary>
    private static Encoding Win1251 = Encoding.GetEncoding("windows-1251");

    /// <summary>
    /// Відправка пакета. Результуючі дані будуть збережені в ReceiveXML
    /// </summary>
    /// <returns>Результат</returns>
    public string Send()
    {
        byte[] byffer = new byte[1024];
        byte[] msg = Win1251.GetBytes(BuildMessage());

        int bytesSend = 0;
        int bytesReceive = 0;

        bool isConnectAndReceive = false;

        using (Socket sender = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp))
        {
            try
            {
                sender.Connect("127.0.0.1", 5656);

                bytesSend = sender.Send(msg);
                bytesReceive = sender.Receive(byffer);

                sender.Shutdown(SocketShutdown.Both);
                sender.Close();

                isConnectAndReceive = true;
            }
            catch
            {

            }
        }

        if (isConnectAndReceive)
            ReceiveXML = Win1251.GetString(byffer, 0, bytesReceive);
        else
        {
            ReceiveXML = @"<?xml version=""1.0"" encoding=""windows-1251""?>
                           <root>
                                <state>0</state>
                                <info>Server close</info>
                           </root>";
        }

        //Загрузка отриманих даних в дерево ХМЛ
        XMLDoc = new XmlDocument();
        XMLDoc.LoadXml(ReceiveXML);

        //Розбор заголовків отриманого пакету
        ReceivePacket = new ReceivePacketInfo(XMLDoc);

        return ReceiveXML;
    }

    /// <summary>
    /// Відправити пакет та транформувати ХМЛ дані також записати результати в основний потік даних Response.OutputStream
    /// </summary>
    /// <param name="templatePath">Шлях до шаблону</param>
    /// <param name="responseStream">Потік куди записати результат трансформації</param>
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
    public void Transform(string templatePath, System.IO.Stream responseStream, Dictionary<string, object> xsltArgDictionary = null)
    {
        //Якщо отримані дані були загружені в дерево
        if (XMLDoc != null)
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

            //Трансформуєм хмл в нтмл
            xslt.Transform(XMLDoc.CreateNavigator(), XsltArg, responseStream);
        }
        else
            throw new System.Exception("Empty data");
    }

    /// <summary>
    /// Трансформувати ХМЛ дані отримані попередньою відправкою пакета та повернути результати без запису в основний потік 
    /// </summary>
    /// <param name="templatePath"></param>
    /// <param name="xsltArgDictionary"></param>
    /// <returns></returns>
    public string Transform(string templatePath, Dictionary<string, object> xsltArgDictionary = null)
    {
        //Якщо отримані дані були загружені в дерево
        if (XMLDoc != null)
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

            System.IO.MemoryStream memoryStreamToHTML = new System.IO.MemoryStream();

            //Трансформуєм хмл в нтмл
            xslt.Transform(XMLDoc.CreateNavigator(), XsltArg, memoryStreamToHTML);

            return Encoding.UTF8.GetString(memoryStreamToHTML.ToArray());
        }
        else
            throw new System.Exception("Empty data");
    }

    /// <summary>
    /// Побудова пакета
    /// </summary>
    /// <returns></returns>
    private string BuildMessage()
    {
        string message = @"<?xml version=""1.0"" encoding=""utf-8""?>";

        //Корінна вітка
        message += "<root>";

        //Назва процедури чи функції
        message += "<member>" + Member + "</member>";

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

    /// <summary>
    /// Назва процедури чи функції
    /// </summary>
    public string Member { get; set; }

    /// <summary>
    /// Список параметрів
    /// </summary>
    public string[] Param { get; set; }

    /// <summary>
    /// XML дані з 1С
    /// </summary>
    public string ReceiveXML { get; private set; }

    /// <summary>
    /// XmlDocument на основі XML даних отриманих з 1С
    /// </summary>
    public XmlDocument XMLDoc { get; private set; }

    /// <summary>
    /// Дані заголовку пакету з 1С (стан, унікальний ключ, додаткова інформація)
    /// </summary>
    public ReceivePacketInfo ReceivePacket { get; private set; }
}