# Flutter geofence

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Setup & Execute
This project develop & written using [VS Code](https://code.visualstudio.com/).

1) Install package:  ```flutter pub get ```
2) Run: ```flutter run```

## APK
https://drive.google.com/file/d/1fU-Eqgkxaw_AP_gyL7DTdzBwaY4qm8ih/view?usp=sharing

## Testing
The project using flutter_driver and [flutter_gherkin](https://pub.dev/packages/flutter_gherkin) for execute automation testing.
Gherkin or Cucumber able to support **Behaviour-Driven Development(BDD)**, which is make test script more understandable.
There are **5 test cases** covered,
1) Add Geofence
2) Status inside
3) Edit Geofence
4) Status outside
5) Delete geofence

However, for the permission need manually accept it

All the list of features are available in https://github.com/shiburagi/setel_geofence/tree/master/test_driver/features.

1) Install package:  ```flutter pub get ```
2) Run: ```dart test_driver/app_test.dart```


