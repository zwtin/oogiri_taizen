import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/alert.dart';
import 'package:oogiritaizen/data/provider/tab_0_navigator.dart';
import 'package:oogiritaizen/ui/answer_list/answer_list_view_model.dart';
import 'package:sweetalert/sweetalert.dart';

class AnswerListView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      onChange: (BuildContext context, Alert alert) {
        if (alert.viewName == 'AnswerListView') {
          SweetAlert.show(
            context,
            title: alert.title,
            subtitle: alert.subtitle,
            showCancelButton: alert.showCancelButton,
            onPress: alert.onPress,
            style: alert.style,
          );
        }
      },
      provider: alertProvider,
      child: ProviderListener(
        onChange: (BuildContext context, Tab0Navigator navigator) {
          if (navigator.n == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              SystemNavigator.pop();
            }
          }
        },
        provider: tab0NavigatorProvider,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'ホーム',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFFFFCC00),
            elevation: 0,
            bottom: PreferredSize(
              child: Container(
                color: Colors.white24,
                height: 1,
              ),
              preferredSize: const Size.fromHeight(1),
            ),
          ),
          body: Center(
            child: RaisedButton(
              child: Text('aaa'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<AnswerListView>(
                    builder: (BuildContext context) {
                      return AnswerListView();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
