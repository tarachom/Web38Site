using System;
using System.Xml;
using System.Collections.Generic;

/// <summary>
/// Параметри
/// </summary>
public class Settings
{
    /// <summary>
    /// Констуктор
    /// </summary>
    /// <param name="XmlDoc">ХМЛ документ</param>
    public Settings(XmlDocument XmlDoc)
    {
        SettingsCollect = new Dictionary<string, string>();

        foreach (XmlNode itemNode in XmlDoc.SelectNodes("/root//settings/item"))
            SettingsCollect.Add(itemNode.Attributes["id"].Value, itemNode.InnerText);
    }

    public Dictionary<string, string> SettingsCollect { get; private set; }
}