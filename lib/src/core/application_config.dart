import 'package:firebase_core/firebase_core.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import '../../firebase_options.dart';

class ApplicationConfig {
  final shorebirdCodePush = ShorebirdCodePush();

  Future<void> consfigureApp() async {
    await _firebaseCoreConfig();
    await _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    final isUpdateAvailable = await shorebirdCodePush.isNewPatchAvailableForDownload();
    if (isUpdateAvailable) {
      await shorebirdCodePush.downloadUpdateIfAvailable();
    }
  }

  Future<void> _firebaseCoreConfig() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
