using System.Xml;

/// <summary>
/// Заголовки пакету з 1С
/// </summary>
public class PacketState
{
    /// <summary>
    /// Констуктор
    /// </summary>
    /// <param name="XmlDoc">ХМЛ документ</param>
    public PacketState(XmlDocument XmlDoc)
    {
        XmlNode RootNode = XmlDoc.SelectSingleNode("/root/state");
        if (RootNode != null)
        {
            StateCode = ReadAttr(RootNode, "code");
            Guid = ReadAttr(RootNode, "guid");

            Info = ReadNode(RootNode, "info");
            Desc = ReadNode(RootNode, "desc");

            //Вітка user
            XmlNode userNode = RootNode.SelectSingleNode("user");
            if (userNode != null)
            {
                UserInfo = new UserInfo(
                    ReadNode(userNode, "code"),
                    ReadNode(userNode, "name")
                );
            }
        }
    }

    /// <summary>
    /// Зчитує дані вітки
    /// </summary>
    /// <param name="rootNode">Корінна вітка</param>
    /// <param name="node">Назва вітки, яку потрібно прочитати</param>
    /// <returns></returns>
    private string ReadNode(XmlNode rootNode, string node)
    {
        XmlNode ItemNode = rootNode.SelectSingleNode(node);

        if (ItemNode != null)
            return ItemNode.InnerText;
        else
            return "";
    }

    /// <summary>
    /// Зчитування атрибута
    /// </summary>
    /// <param name="rootNode">Вітка</param>
    /// <param name="attrName">Назва атрибута</param>
    /// <returns></returns>
    private string ReadAttr(XmlNode rootNode, string attrName)
    {
        XmlAttribute itemAttr = rootNode.Attributes[attrName];
        if (itemAttr != null)
            return itemAttr.Value;
        else
            return "";
    }

    /// <summary>
    /// Код статусу
    /// </summary>
    public string StateCode { get; private set; }

    /// <summary>
    /// Ункальний ключ
    /// </summary>
    public string Guid { get; private set; }

    /// <summary>
    /// Додаткова інформація
    /// </summary>
    public string Info { get; private set; }

    /// <summary>
    /// Розширена інформація
    /// </summary>
    public string Desc { get; private set; }

    /// <summary>
    /// Інформація про користувача
    /// </summary>
    public UserInfo UserInfo { get; private set; }
}