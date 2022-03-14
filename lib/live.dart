// import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Material App',
//       home: Home(),
//     );
//   }
// }

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
//   late final TabController tabController;
//   @override
//   void initState() {
//     tabController = TabController(length: 4, vsync: this);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TabBar(
//           controller: tabController,
//           tabs: const [
//             Tab(text: 'Tab 1'),
//             Tab(text: 'Tab 2'),
//             Tab(text: 'Tab 3'),
//             Tab(text: 'Tab 4'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: tabController,
//         children: const [
//           TabPageExample(
//             theTestOne: true,
//           ),
//           TabPageExample(),
//           TabPageExample(),
//           TabPageExample(),
//         ],
//       ),
//     );
//   }
// }

// class TabPageExample extends StatefulWidget {
//   final bool theTestOne;
//   const TabPageExample({Key? key, this.theTestOne = false}) : super(key: key);

//   @override
//   State<TabPageExample> createState() => _TabPageExampleState();
// }

// // if you want to maintain the build state and not rebuild the widget mix it AutomaticKeepAliveClientMixin!!
// class _TabPageExampleState extends State<TabPageExample>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   Widget build(BuildContext context) {
//     // yeah it seems redundant but it's necessary to call super.build(context)
//     super.build(context);

//     // to test is it really building or not  let's print something if it evaled in your console then that means something wrong
//     if (widget.theTestOne) print('object');

//     final state = context.findAncestorStateOfType<_HomeState>()!;
//     return Center(
//       child: AnimatedBuilder(
//           animation: state.tabController,
//           builder: (_, __) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('selected index = ${state.tabController.index}'),
//                 Text('pages count = ${state.tabController.length}'),
//                 Text(
//                     'is currently scrolling or animating = ${state.tabController.indexIsChanging}'),
//                 Text(
//                     'scrolling percentage = ${state.tabController.animation?.value}'),
//               ],
//             );
//           }),
//     );
//   }

//   @override
//   // if you wish to rebuild set it to false
//   bool get wantKeepAlive => true;
// }
