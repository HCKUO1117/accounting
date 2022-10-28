import 'package:accounting/app.dart';
import 'package:accounting/generated/l10n.dart';

class TranslateLanguage {
  List<String> getLanguages(List<String> list) {
    List<String> listLang = [];

    for (var element in list) {
      listLang.add(getLanguageByContext(element));
    }

    return listLang;
  }

  String getLanguageByContext(String code) {
    switch (code) {
      
      case "mon":
        return S.of(App.navigatorKey.currentContext!).mon;
      case "tue":
        return S.of(App.navigatorKey.currentContext!).tue;
      case "wed":
        return S.of(App.navigatorKey.currentContext!).wed;
      case "thu":
        return S.of(App.navigatorKey.currentContext!).thu;
      case "fri":
        return S.of(App.navigatorKey.currentContext!).fri;
      case "sat":
        return S.of(App.navigatorKey.currentContext!).sat;
      case "sun":
        return S.of(App.navigatorKey.currentContext!).sun;
      case "monday":
        return S.of(App.navigatorKey.currentContext!).monday;
      case "tuesday":
        return S.of(App.navigatorKey.currentContext!).tuesday;
      case "wednesday":
        return S.of(App.navigatorKey.currentContext!).wednesday;
      case "thursday":
        return S.of(App.navigatorKey.currentContext!).thursday;
      case "friday":
        return S.of(App.navigatorKey.currentContext!).friday;
      case "saturday":
        return S.of(App.navigatorKey.currentContext!).saturday;
      case "sunday":
        return S.of(App.navigatorKey.currentContext!).sunday;
      case "recommendation":
        return S.of(App.navigatorKey.currentContext!).recommendation;
      case "errorReport":
        return S.of(App.navigatorKey.currentContext!).errorReport;
      case "usageProblem":
        return S.of(App.navigatorKey.currentContext!).usageProblem;
      case "other":
        return S.of(App.navigatorKey.currentContext!).other;
      default:
        return code;
    }
  }
}
