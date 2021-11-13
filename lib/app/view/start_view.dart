import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view_model/start_view_model.dart';
import 'package:oogiri_taizen/app/widget/alert_widget.dart';

class StartView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('StartView = $_key');
    final viewModel = useProvider(startViewModelProvider(_key));

    return AlertWidget(
      child: Scaffold(
        body: Container(
          color: const Color(0xFFFFCC00),
        ),
      ),
    );
  }
}
