using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace CygwinPortableCS
{
    class Helpers
    {
        public static JObject CombineJson(JObject object1, JObject object2)
        {
            object1.Merge(object2, new JsonMergeSettings
            {
                MergeArrayHandling = MergeArrayHandling.Union
            });
            return object1;
        }

        public static JObject MergeCsDictionaryAndSave(JObject csDictionary, string filePath)
        {
            //Create Config File if not exists
            if (!File.Exists(filePath))
            {
                System.IO.File.WriteAllText(filePath, JsonConvert.SerializeObject(csDictionary, Formatting.Indented));
            }

            JObject binConfigFile = JObject.Parse(System.IO.File.ReadAllText(filePath));
            JObject combinedDictJson = Helpers.CombineJson(csDictionary, binConfigFile);

            string jsonToFile = JsonConvert.SerializeObject(combinedDictJson, Formatting.Indented);
            System.IO.File.WriteAllText(filePath, jsonToFile);
            return combinedDictJson;
        }
    }
}
