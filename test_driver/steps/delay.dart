import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class DelayStep extends Given1WithWorld<int, FlutterWorld> {
  @override
  Future<void> executeStep(int seconds) async {
    // implement your code
    await Future.delayed(Duration(seconds: seconds));
  }

  @override
  RegExp get pattern => RegExp(r"I wait for {int} seconds");
}
