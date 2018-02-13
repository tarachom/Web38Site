using System.Xml;

/// <summary>
/// Інформація про контрагента
/// </summary>
public class Contragent
{
    /// <summary>
    /// Констуктор
    /// </summary>
    /// <param name="XmlDoc">ХМЛ документ</param>
    public Contragent(XmlDocument XmlDoc)
    {
        XmlNode RootNode = XmlDoc.SelectSingleNode("/root/contragent");
        if (RootNode != null)
        {
            Login = ReadNode(RootNode, "login");
            Name = ReadNode(RootNode, "name");
            Contacty = ReadNode(RootNode, "contacty");
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
    /// Логін
    /// </summary>
    public string Login { get; set; }

    /// <summary>
    /// Назва
    /// </summary>
    public string Name { get; set; }

    /// <summary>
    /// Контакти
    /// </summary>
    public string Contacty { get; set; }
}