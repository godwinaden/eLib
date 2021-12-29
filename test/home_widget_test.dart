import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elib/pages/home/home.dart';

void main() {
  testWidgets('check', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp( home: MyHomePage(title: "eLib",)));
    await tester.pump();
    expect(find.byType(Scaffold,skipOffstage: true), findsOneWidget);
    expect(find.byType(InkWell,skipOffstage: true), findsWidgets);
  });
}