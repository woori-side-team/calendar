import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemoGridViewPage extends StatelessWidget {
  static const routeName = 'memo/grid';

  const MemoGridViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
          CustomAppBar(actions: [
            const CustomAppBarSearchButton(),
            CustomAppBarModeButton(
                type: CustomAppBarModeType.vertical,
                onPressed: () {
                  context.pushNamed('memoListViewPage');
                }),
            const CustomAppBarProfileButton()
          ]),
          const Text('Memo grid view page')
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
        body: Column(children: [
          CustomAppBar(actions: [
            const CustomAppBarSearchButton(),
            CustomAppBarModeButton(
                type: CustomAppBarModeType.horizontal,
                onPressed: () {
                  context.pushNamed('memoGridViewPage');
                }),
            const CustomAppBarProfileButton()
          ]),
          const Text('Memo list view page')
        ]),
        bottomNavigationBar: const CustomNavigationBar());
  }
}
