import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view_model/app_view_model.dart';
import 'flavors.dart';

class App extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(appViewModelProvider);
    return MaterialApp(
      title: F.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: viewModel.homeView,
    );
  }
}
