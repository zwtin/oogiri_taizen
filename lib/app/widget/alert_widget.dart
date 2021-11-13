import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';

class AlertWidget extends HookWidget {
  const AlertWidget({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      onChange: (BuildContext context, AlertNotifer alertNotifer) async {
        if (alertNotifer.alertViewData == null) {
          Navigator.of(context).pop();
          return;
        }

        final buttons = <DialogButton>[];
        if (alertNotifer.alertViewData!.cancelButtonTitle != null) {
          buttons.add(
            DialogButton(
              onPressed: alertNotifer.alertViewData!.cancelButtonAction,
              color: const Color(0xFFFFCC00),
              child: Text(alertNotifer.alertViewData!.cancelButtonTitle!),
            ),
          );
        }
        if (alertNotifer.alertViewData!.okButtonTitle != null) {
          buttons.add(
            DialogButton(
              onPressed: alertNotifer.alertViewData!.okButtonAction,
              color: const Color(0xFFFFCC00),
              child: Text(alertNotifer.alertViewData!.okButtonTitle!),
            ),
          );
        }

        await Alert(
          context: context,
          title: alertNotifer.alertViewData!.title,
          desc: alertNotifer.alertViewData!.message,
          style: const AlertStyle(
            animationType: AnimationType.grow,
            isCloseButton: false,
            isOverlayTapDismiss: false,
            overlayColor: Colors.black54,
            alertElevation: 0,
          ),
          buttons: buttons,
          onWillPopActive: true,
        ).show();
      },
      provider: alertNotiferProvider,
      child: child,
    );
  }
}
