import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class ListingStep extends Given1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String text) async {
    // implement your code
    world.driver.getText(find.text(text));
  }

  @override
  RegExp get pattern => RegExp(r"I expect {string} exists in the list");
}
