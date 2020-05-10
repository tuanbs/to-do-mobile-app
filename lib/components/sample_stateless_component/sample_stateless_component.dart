import 'package:flutter/material.dart';

class SampleStatelessComponent extends StatelessWidget {
  static const String title = 'SampleStatelessComponent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SampleStatelessComponent.title),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Card(
              child: Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}