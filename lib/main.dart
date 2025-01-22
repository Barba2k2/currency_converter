import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/app_widget.dart';
import 'src/core/application_config.dart';
import 'src/helpers/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApplicationConfig().consfigureApp();

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // Inglês
        Locale('pt'), // Português
        // Locale('es'), // Espanhol
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        // Verifique se o idioma do dispositivo é suportado
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale?.languageCode) {
            return locale;
          }
        }
        // Caso não seja suportado, retorna o inglês como padrão
        return const Locale('en');
      },
      home: const AppWidget(),
    );
  }
}
