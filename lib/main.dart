import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliver_bottom_bar/sliver_bottom_bar.dart';
import 'live.dart' as live;

const int testItemsLength = 12;
// void main() => live.main();
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: ScrollConfiguration(
        behavior: const CupertinoScrollBehavior().copyWith(
          dragDevices: PointerDeviceKind.values.toSet(),
          scrollbars: false,
        ),
        child: const AbstractSliverBottomBarTest(),
      ),
    );
  }
}

class AbstractSliverBottomBarTest extends StatefulWidget {
  const AbstractSliverBottomBarTest({Key? key}) : super(key: key);

  @override
  State<AbstractSliverBottomBarTest> createState() =>
      _AbstractSliverBottomBarTestState();
}

class _AbstractSliverBottomBarTestState
    extends State<AbstractSliverBottomBarTest>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GroupsBottomNavigationBar(
        itemsBeneath: GroupsBottomNavigationBar.generateDefaultItemsBeneath(
            itemsLength: 12, returnLength: 4),
        pageBuilder: (_, index) => ListView.builder(
          itemBuilder: (_, listIndex) => ListTile(
            title: Text(
              'Page $index Item No $listIndex',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ),
        items: [
          for (var i = 0; i < testItemsLength; i++)
            GroupItem(
              shrinkedIcon: const Icon(Icons.ac_unit),
              shrinkedLabel: 'Item No $i',
            ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Sliver Bottom Bar Test'),
      ),
    );
  }
}
