using System;
using System.Text;

/// <summary>
/// Статичний конфігураційний клас
/// </summary>
public static class Config
{
    /// <summary>
    /// IP Адреса
    /// </summary>
    public static string Web38ServerIP = "127.0.0.1";

    /// <summary>
    /// Порт
    /// </summary>
    public static int Web38ServerPort = 5656;

    /// <summary>
    /// Кодіровка windows-1251
    /// </summary>
    public static Encoding Win1251 = Encoding.GetEncoding("windows-1251");

    public static string ParseDate(string date)
    {
        if (!String.IsNullOrWhiteSpace(date))
        {
            try
            {
                return DateTime.Parse(date).ToString("dd.MM.yyyy");
            }
            catch
            {
                return "";
            }
        }
        else return "";
    }
}