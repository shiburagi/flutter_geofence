import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class NavigationStep extends GivenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // implement your code
    world.driver.tap(find.byTooltip('Back'));
  }

  @override
  RegExp get pattern => RegExp(r"I click back button");
}
