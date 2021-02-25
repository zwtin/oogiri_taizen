import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:oogiritaizen/ui/bottom_tab/bottom_tab_view.dart';

class App extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomTabView(),
    );
  }
}
