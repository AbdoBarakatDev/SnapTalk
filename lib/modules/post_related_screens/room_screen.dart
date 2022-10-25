import 'package:flutter/material.dart';
import 'package:flutter_social/shared/components/components.dart';

class RoomScreen extends StatelessWidget {
  static const String id = "RoomScreenId";
  const RoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, title: "Create New Room"),
      body: const Center(child: Text("Room Screen Under Creation")),
    );
  }
}
