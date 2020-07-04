import 'package:gherkin/gherkin.dart';

class CustomHooks extends Hook {
  @override
  Future<void> onBeforeRun(TestConfiguration config) async {
    return super.onBeforeRun(config);
  }
}
