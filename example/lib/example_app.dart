import 'package:example/page_one/page_one.dart';
import 'package:example/page_two/page_two.dart';
import 'package:flutter/material.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => const PageOne(),
        "/sub": (BuildContext context) => const PageTwo(),
      },
    );
  }
}
