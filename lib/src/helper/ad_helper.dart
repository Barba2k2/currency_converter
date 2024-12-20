import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7278601840642594/7891283132'; // Test ID para Android
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7278601840642594/5860016162'; // Test ID para iOS
    } else {
      throw UnsupportedError('Plataforma não suportada');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test ID para Android
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Test ID para iOS
    } else {
      throw UnsupportedError('Plataforma não suportada');
    }
  }
}
