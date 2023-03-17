import 'package:flutter/material.dart';

import 'demos_drawer.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  const AppScaffold({required this.title, required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: const DemosDrawer(),
      body: body,
    );
  }
}
