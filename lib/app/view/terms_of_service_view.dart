import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/view_model/terms_of_service_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsOfServiceView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('TermsOfServiceView = $_key');
    final viewModel = useProvider(termsOfServiceViewModelProvider(_key));

    return RouterWidget(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '利用規約',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFFFCC00),
          elevation: 0, // 影をなくす
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.white24,
              height: 1,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: const Color(0xFFFFCC00),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).padding.left,
                bottom: MediaQuery.of(context).padding.bottom,
                right: MediaQuery.of(context).padding.right,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Html(
                  data: viewModel.html,
                  style: {
                    'head': Style(color: Colors.white),
                    'body': Style(color: Colors.white),
                    'li': Style(
                      fontSize: const FontSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
