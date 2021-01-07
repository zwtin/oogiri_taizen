import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnswerListView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '詳細',
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
      body: Container(
        color: const Color(0xFFFFCC00),
      ),
    );
  }
}
