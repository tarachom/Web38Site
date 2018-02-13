using System;

/// <summary>
/// Інформація про користувача
/// </summary>
public class UserInfo
{
    /// <summary>
    /// Конструктор
    /// </summary>
    public UserInfo() {/**/}

    /// <summary>
    /// Конструктор
    /// </summary>
    /// <param name="code">Код</param>
    /// <param name="name">Назва</param>
    public UserInfo(string code, string name)
    {
        Code = code;
        Name = name;
    }

    /// <summary>
    /// Код
    /// </summary>
    public string Code { get; set; }

    /// <summary>
    /// Назва
    /// </summary>
    public string Name { get; set; }
}