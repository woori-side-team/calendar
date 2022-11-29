import 'package:calendar/presentation/providers/schedule_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScheduleSearchPage extends StatefulWidget {
  static const routeName = 'scheduleSearch';

  const ScheduleSearchPage({Key? key}) : super(key: key);

  @override
  State<ScheduleSearchPage> createState() => _ScheduleSearchPageState();
}

class _ScheduleSearchPageState extends State<ScheduleSearchPage> {
  late ScheduleSearchProvider viewModel;

  void _onChanged(String text) async {
    final viewModel = context.read<ScheduleSearchProvider>();
    await viewModel.searchSchedules(text);
  }

  @override
  void dispose() {
    viewModel.textEditingController.text = '';
    viewModel.searched.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ScheduleSearchProvider>();
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          TextField(
            controller: viewModel.textEditingController,
            onChanged: _onChanged,
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
                itemCount: viewModel.searched.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('제목: ${viewModel.searched[index].title}'),
                      Text('내용: ${viewModel.searched[index].content}'),
                      Text(DateFormat('yy-MM-dd HH:mm')
                          .format(viewModel.searched[index].start)),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
