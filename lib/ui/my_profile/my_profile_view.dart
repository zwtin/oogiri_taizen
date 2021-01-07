import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:oogiritaizen/data/provider/alert.dart';
import 'package:oogiritaizen/data/provider/tab_1_navigator.dart';
import 'package:oogiritaizen/ui/bottom_tab/bottom_tab_view_model.dart';
import 'package:oogiritaizen/ui/my_profile/my_profile_view_model.dart';
import 'package:sweetalert/sweetalert.dart';

class MyProfileView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      onChange: (BuildContext context, Alert alert) {
        if (alert.viewName == 'MyProfileView') {
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
        onChange: (BuildContext context, Tab1Navigator navigator) {
          if (navigator.n == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.read(bottomTabViewModelProvider).tapped(0);
            }
          }
        },
        provider: tab1NavigatorProvider,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'マイページ',
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
                  MaterialPageRoute<MyProfileView>(
                    builder: (BuildContext context) {
                      return MyProfileView();
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
