import 'package:flutter/material.dart';
import 'package:flutter_social/shared/components/components.dart';

class GroupScreen extends StatelessWidget {
  static const String id = "GroupScreenId";
  const GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, title: "Create New Group"),
      body: const Center(child: Text("Group Screen Under Creation")),
    );
  }
}
