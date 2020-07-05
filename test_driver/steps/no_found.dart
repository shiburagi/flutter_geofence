import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

import '../utils/finder.dart';

class ExpectNotExistStep extends Then1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String key) async {
    if (!(await isAbsent(find.byValueKey(key), world.driver,
        timeout: timeout))) {
      await reporter.message(
          "Step error '${pattern.pattern}'", MessageLevel.error);
      throw Exception("Step error '${pattern.pattern}'");
    }
  }

  @override
  RegExp get pattern => RegExp(r'I expect the {string} not exist$');
}
