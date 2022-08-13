import 'dart:io';

class PlatformSupport {
  String getLocalhost() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2';
    else // for iOS simulator
      return 'http://localhost';
  }
}