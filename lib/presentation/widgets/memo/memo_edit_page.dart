import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MemoEditPage extends StatelessWidget {
  static const routeName = 'memo/edit';

  const MemoEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: const [
          CustomAppBar(modeType: CustomAppBarModeType.horizontal),
          Text('Memo edit page')
        ]),
        bottomNavigationBar: const CustomNavigationBar());
  }
}
