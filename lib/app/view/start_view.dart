import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/view_model/start_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';

class StartView extends HookWidget {
  final _key = UniqueKey();
  final _logger = Logger();

  @override
  Widget build(BuildContext context) {
    _logger.d('StartView = $_key');
    final viewModel = useProvider(startViewModelProvider(_key));

    useEffect(
      () {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          context.read(startViewModelProvider(_key)).checkNeedUpdate();
        });
      },
      const [],
    );

    return RouterWidget(
      key: _key,
      child: Scaffold(
        body: Container(
          color: const Color(0xFFFFCC00),
        ),
      ),
    );
  }
}
