using System.Xml;

/// <summary>
/// Заголовки пакету з 1С
/// </summary>
public class ReceivePacketInfo
{
    /// <summary>
    /// Констуктор
    /// </summary>
    /// <param name="XmlDoc">ХМЛ документ</param>
    public ReceivePacketInfo(XmlDocument XmlDoc)
    {
        XmlNode RootNode = XmlDoc.SelectSingleNode("/root/state");
        if (RootNode != null)
        {
            StateCode = ReadNode(RootNode, "code");
            Guid = ReadNode(RootNode, "guid");
            Info = ReadNode(RootNode, "info");
        }
        else
            throw new System.Exception("No exist root");
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



}