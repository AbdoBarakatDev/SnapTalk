import 'package:flutter/material.dart';
import 'package:flutter_social/shared/components/components.dart';

class LiveScreen extends StatelessWidget {
  static const String id = "LiveScreenId";
  const LiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, title: "Start a Live"),
      body: const Center(child: Text("Live Screen Under Creation")),
    );
  }
}
