import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Flavor { development, production }

@immutable
class Constants {
  const Constants({
    @required this.flavor,
  });

  factory Constants.of() {
    if (_instance != null) {
      return _instance;
    }

    final flavor = EnumToString.fromString(
      Flavor.values,
      const String.fromEnvironment('FLAVOR'),
    );

    switch (flavor) {
      case Flavor.development:
        _instance = Constants._dev();
        break;
      case Flavor.production:
        _instance = Constants._prd();
    }
    return _instance;
  }

  factory Constants._dev() {
    return const Constants(
      flavor: Flavor.development,
    );
  }

  factory Constants._prd() {
    return const Constants(
      flavor: Flavor.production,
    );
  }

  // Routing name
  static const String pageHome = '/home';
  static const String pageSignIn = '/signIn';
  static const String pageDetail = '/detail';

  static const bool isDebugMode = kDebugMode;

  static Constants _instance;

  final Flavor flavor;
}
