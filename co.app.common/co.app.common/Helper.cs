using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace co.app.common
{
    static class ConfigurationManager
    {
        public static IConfiguration AppSetting { get; }

        static ConfigurationManager()
        {
            AppSetting = new ConfigurationBuilder()
                    .SetBasePath(Directory.GetCurrentDirectory())
                    .AddJsonFile("appsettings.json")
                    .Build();
        }
    }

    public static class Helper
    {
        public static string GetConnectionString => ConfigurationManager.AppSetting["ConnectionStrings:MSSDatabase"].ToString();

        public static string GetLoggingConnectionString => ConfigurationManager.AppSetting["ConnectionStrings:LoggingDatabase"].ToString();


        public static string GetDecryptPassword => ConfigurationManager.AppSetting["AppSetting:DecryptPassword"].ToString();

        public static string DecryptValue(string cipherText)
        {
            string password = GetDecryptPassword;

            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                // extract salt (first 16 bytes)
                var salt = cipherBytes.Take(16).ToArray();
                // extract iv (next 16 bytes)
                var iv = cipherBytes.Skip(16).Take(16).ToArray();
                // the rest is encrypted data
                var encrypted = cipherBytes.Skip(32).ToArray();
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(password, salt, 100);
                encryptor.Key = pdb.GetBytes(32);
                encryptor.Padding = PaddingMode.PKCS7;
                encryptor.Mode = CipherMode.CBC;
                encryptor.IV = iv;
                // you need to decrypt this way, not the way in your question
                using (MemoryStream ms = new MemoryStream(encrypted))
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Read))
                    {
                        using (var reader = new StreamReader(cs, Encoding.UTF8))
                        {
                            return reader.ReadToEnd();
                        }
                    }
                }
            }
        }

        public static string GetClientIP
        {
            get
            {

                string Str = "";
                Str = System.Net.Dns.GetHostName();
                IPHostEntry ipEntry = System.Net.Dns.GetHostEntry(Str);
                IPAddress[] addr = ipEntry.AddressList;

                if (addr != null && addr.Length > 0)
                    return addr[addr.Length - 1].ToString();
                else
                    return "";
            }
        }

    }
}
