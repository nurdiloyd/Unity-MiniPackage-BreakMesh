using System;
using System.Reflection;

namespace ElephantSDK
{
    // TODO implement external package version checks here
    public class VersionCheckUtils
    {
        private static VersionCheckUtils _instance;
        public string AdSdkVersion = "";

        public static VersionCheckUtils GetInstance()
        {
            return _instance ?? (_instance = new VersionCheckUtils {AdSdkVersion = GetAdSdkVersion()});
        }

        private static string GetAdSdkVersion()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            var adsSdkVersion = "";

            try
            {
                var type = Array.Find(assembly.GetTypes(),
                    typeToFind =>
                        typeToFind.FullName != null
                        && typeToFind.FullName.Equals("RollicGames.Advertisements.Version"));

                if (type == null) return adsSdkVersion;
                var fieldInfo = type.GetField("SDK_VERSION",
                    BindingFlags.NonPublic | BindingFlags.Static);

                if (fieldInfo == null) return adsSdkVersion;
                adsSdkVersion = fieldInfo.GetValue(null).ToString();

                return adsSdkVersion;
            }
            catch (Exception e)
            {
                return adsSdkVersion;
            }
        }
    }
}