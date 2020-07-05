import 'dart:async';
import 'dart:io';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'hooks/custom.dart';
import 'steps/list.dart';
import 'steps/navigation.dart';
import 'steps/no_found.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/**.feature")]
    ..stepDefinitions = [
      NavigationStep(),
      ListingStep(),
      ExpectNotExistStep(),
    ]
    ..hooks = [CustomHooks()]
    ..order = ExecutionOrder.sequential
    ..onBeforeFlutterDriverConnect = () async {
      final Map<String, String> envVars = Platform.environment;
      final String adbPath =
          envVars['ANDROID_SDK_ROOT'] + '/platform-tools/adb.exe';
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'com.example.apppackage',
        'android.permission.ACCESS_FINE_LOCATION'
      ]);
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'com.example.apppackage',
        'android.permission.ACCESS_COARSE_LOCATION'
      ]);
    }
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart"
    // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);
}
