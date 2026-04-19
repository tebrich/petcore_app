import 'package:get/get.dart';

import 'es_es.dart';
import 'en_us.dart';
import 'de_de.dart';
import 'pt_br.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'es_ES': esES,
        'en_US': enUS,
        'de_DE': deDE,
        'pt_BR': ptBR,
      };
}

