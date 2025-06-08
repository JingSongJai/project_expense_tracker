import 'package:expanse_tracker/translation/en.dart';
import 'package:expanse_tracker/translation/km.dart';
import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': eng, 'km': km};
}
