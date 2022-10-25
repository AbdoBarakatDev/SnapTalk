import 'package:flutter/material.dart';
import 'package:flutter_social/shared/components/components.dart';

class ReelsScreen extends StatelessWidget {
  static const String id = "ReelsScreenId";
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, title: "New Reel"),
      body: const Center(child: Text("Reels Screen Under Creation")),
    );
  }
}
