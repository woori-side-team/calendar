import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MemoGridViewPage extends StatelessWidget {
  static const routeName = 'memo/grid';

  const MemoGridViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: const [
          CustomAppBar(modeType: CustomAppBarModeType.vertical),
          Text('Memo grid view page')
        ]),
        bottomNavigationBar: const CustomNavigationBar());
  }
}

class MemoListViewPage extends StatelessWidget {
  static const routeName = 'memo/list';

  const MemoListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: const [
          CustomAppBar(modeType: CustomAppBarModeType.horizontal),
          Text('Memo list view page')
        ]),
        bottomNavigationBar: const CustomNavigationBar());
  }
}
