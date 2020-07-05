import 'package:flutter_driver/flutter_driver.dart';

Future<bool> isAbsent(SerializableFinder finder, FlutterDriver driver,
    {Duration timeout = const Duration(seconds: 1)}) async {
  try {
    await driver.waitForAbsent(finder, timeout: timeout);
    return true;
  } catch (e) {
    return false;
  }
}
