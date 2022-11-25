import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/presentation/providers/schedules_provider.dart';
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
  List<ScheduleModel> searched = [];

  void _onChanged(String text) async {
    final viewModel = context.read<SchedulesProvider>();
    searched = await viewModel.searchSchedules(text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          TextField(
            onChanged: _onChanged,
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
                itemCount: searched.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('제목: ${searched[index].title}'),
                      Text('내용: ${searched[index].content}'),
                      Text(DateFormat('yy-MM-dd HH:mm').format(searched[index].start)),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
