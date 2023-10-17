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
        public static string GetConnectionString => ConfigurationManager.AppSetting["ConnectionStrings:CrocsDatabase"].ToString();

        public static string GetLoggingConnectionString => ConfigurationManager.AppSetting["ConnectionStrings:BaseLoggingDatabase"].ToString();


        public static string GetDecryptPassword => ConfigurationManager.AppSetting["AppSetting:DecryptPassword"].ToString();

        public static string DecryptValue(string cipherText)
        {
            string password = GetDecryptPassword;

            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using Aes encryptor = Aes.Create();
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
            using MemoryStream ms = new(encrypted);
            using CryptoStream cs = new(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Read);
            using var reader = new StreamReader(cs, Encoding.UTF8);
            return reader.ReadToEnd();
        }


        public static string EncryptValue(string plainText)
        {
            string password = GetDecryptPassword; // Replace with your password retrieval logic

            using Aes encryptor = Aes.Create();
            encryptor.Padding = PaddingMode.PKCS7;
            encryptor.Mode = CipherMode.CBC;

            // Generate a random salt
            byte[] salt = new byte[16];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }

            // Generate a random IV
            byte[] iv = new byte[16];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(iv);
            }

            // Derive the encryption key from the password and salt
            using Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(password, salt, 10000, HashAlgorithmName.SHA256);
            encryptor.Key = pdb.GetBytes(32);

            // Perform encryption
            using MemoryStream ms = new();
            using CryptoStream cs = new(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write);
            using var writer = new StreamWriter(cs, Encoding.UTF8);
            writer.Write(plainText);
            writer.Flush();
            cs.FlushFinalBlock();

            byte[] encryptedBytes = ms.ToArray();

            // Combine salt, IV, and ciphertext into a single byte array
            byte[] resultBytes = new byte[salt.Length + iv.Length + encryptedBytes.Length];
            Array.Copy(salt, 0, resultBytes, 0, salt.Length);
            Array.Copy(iv, 0, resultBytes, salt.Length, iv.Length);
            Array.Copy(encryptedBytes, 0, resultBytes, salt.Length + iv.Length, encryptedBytes.Length);

            // Convert the result to a base64 string
            string result = Convert.ToBase64String(resultBytes);
            return result;
        }


        public static string GetClientIP
        {
            get
            {
                string Str = Dns.GetHostName();
                IPHostEntry ipEntry = System.Net.Dns.GetHostEntry(Str);
                IPAddress[] addr = ipEntry.AddressList;

                if (addr != null && addr.Length > 0)
                    return addr[^1].ToString();
                else
                    return "";
            }
        }

    }
}
