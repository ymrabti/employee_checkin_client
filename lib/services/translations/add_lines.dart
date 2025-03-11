// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';

// dart run lib/services/translations/add_lines.dart && flutter gen-l10n
Future<void> main() async {
  File file = File('lib/services/translations/add_lines.json');
  bool existsSync = file.existsSync();
  print(existsSync);
  if (!existsSync) return;
  String content = await file.readAsString();

  /// Decode JSON content
  Map<String, dynamic> languageMap = jsonDecode(content);

  // Iterate through each .arb file in the directory
  await Future.forEach(
    languageMap.entries,
    (MapEntry<String, dynamic> item) async {
      await addLanguageLines(
        item.key,
        Map<String, String>.fromEntries(
          (item.value as Map<String, dynamic>).entries.map(
                (MapEntry<String, dynamic> e) => MapEntry<String, String>(e.key, '${e.value}'),
              ),
        ),
        false,
      );
    },
  );

  print('Languages added to all .arb files.');
}

Future<void> addLanguageLines(String locale, Map<String, String> languageMap, bool override) async {
  File file = File('lib/services/translations/l10n/app_$locale.arb');
  if (!file.existsSync()) return;
  // Read the content of the .arb file
  String content = await file.readAsString();

  // Decode JSON content
  Map<String, dynamic> jsonContent = jsonDecode(content);

  // Add language mappings to the file content
  languageMap.forEach(
    (String key, String value) {
      if (!jsonContent.containsKey(key) || override) {
        jsonContent[key] = value;
      } else {
        jsonContent['${key}1'] = value;
      }
    },
  );

  // Save the modified content back to the file
  String modifiedContent = JsonEncoder.withIndent('  ').convert(jsonContent);
  await file.writeAsString(modifiedContent);

//   print('Updated ${file.path}');
}

Map<String, String> typical = <String, String>{
  // Amazigh with Latin letters
  "ar": "العربية (Arabe)", // Arabic
  "fr": "Français (Français)", // French
  "en": "English (Anglais)", // English
  "az_tifinagh": "ⵜⵉⴼⵉⵏⴰⵖ (Tifinagh)", // Amazigh in Tifinagh script
  "af_latin": "Tamazirt (Latin)", // Amazigh in Latin script
};
final Map<String, Map<String, String>> languageMap0 = <String, Map<String, String>>{
  "af": typical,
  "ar": <String, String>{
    // Arabic
    "ar": "العربية",
    "fr": "الفرنسية",
    "en": "الإنجليزية",
    "az_tifinagh": "الأمازيغية (بحروف تيفيناغ)",
    "af_latin": "الأمازيغية (بحروف لاتينية)",
  },
  "az": <String, String>{
    // Amazigh in Tifinagh script
    "ar": "ⴰⵎⴰⵣⵉⵖ (ⴰⵎⴰⵣⵉⵖ ⴷ ⵜⵉⴼⵉⵏⴰⵖ)",
    "fr": "ⴼⵔⴰⵏⴽⴰⵙ",
    "en": "ⴰⵏⴳⵍⵉⵣⴰⵡ",
    "az_tifinagh": "ⵜⵉⴼⵉⵏⴰⵖ",
    "af_latin": "ⴰⵎⴰⵣⵉⵖ (ⵉⵙ ⵍⴰⵜⵉⵏ)",
  },
  "en": <String, String>{
    // English
    "ar": "Arabic",
    "fr": "French",
    "en": "English",
    "az_tifinagh": "Amazigh (Tifinagh letters)",
    "af_latin": "Amazigh (Latin letters)",
  },
  "fr": <String, String>{
    // French
    "ar": "Arabe",
    "fr": "Français",
    "en": "Anglais",
    "az_tifinagh": "Amazigh (Lettres Tifinagh)",
    "af_latin": "Amazigh (Lettres latines)",
  },
};
final Map<String, Map<String, Object>> languageMap1 = <String, Map<String, Object>>{
  "fr": <String, Object>{
    "numOfYears": "{count, plural, =1{1 an} other{{count} ans}}",
    "@numOfYears": <String, Object>{
      "description": "Nombre d'années",
      "placeholders": <String, Map<String, String>>{
        "count": <String, String>{"example": "1"}
      }
    }
  },
  "ar": <String, Object>{
    "numOfYears": "{count, plural, =1{سنة واحدة} other{{count} سنوات}}",
    "@numOfYears": <String, Object>{
      "description": "عدد السنوات",
      "placeholders": <String, Map<String, String>>{
        "count": <String, String>{"example": "1"}
      }
    }
  },
  "az": <String, Object>{
    "numOfYears": "{count, plural, =1{ⴰⵙⴳⴰⵙ 1} other{{count} ⵙⴳⴰⵙⵏⵉⵏ}}",
    "@numOfYears": <String, Object>{
      "description": "ⵉⵖⵔⴻⵏ ⵏ ⵙⴳⴰⵙⵏⵉⵏ",
      "placeholders": <String, Map<String, String>>{
        "count": <String, String>{"example": "1"}
      }
    }
  },
  "en": <String, Object>{
    "numOfYears": "{count, plural, =1{1 year} other{{count} years}}",
    "@numOfYears": <String, Object>{
      "description": "Number of years",
      "placeholders": <String, Map<String, String>>{
        "count": <String, String>{"example": "1"}
      }
    }
  },
  "af": <String, Object>{
    "numOfYears": "{count, plural, =1{asgas 1} other{{count} isgasen}}",
    "@numOfYears": <String, Object>{
      "description": "Ighran n isgasen",
      "placeholders": <String, Map<String, String>>{
        "count": <String, String>{"example": "1"}
      }
    }
  }
};
