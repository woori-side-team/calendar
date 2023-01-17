import 'package:calendar/presentation/providers/add_schedule_page_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_popup_menu.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/common/custom_time_picker.dart';
import 'package:calendar/presentation/widgets/common/marker_colors.dart';
import 'package:flutter/cupertino.dart' hide CupertinoDatePickerMode;
import 'package:flutter/material.dart' hide PopupMenuItem;
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/schedules_provider.dart';

class AddSchedulePage extends StatelessWidget {
  const AddSchedulePage({Key? key}) : super(key: key);

  Widget _createAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(blurRadius: 20, color: CustomTheme.gray.gray3),
      ], color: CustomTheme.background.primary),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            height: 56,
            child: Row(children: [
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  context.pop();
                },
                child: SizedBox(
                    height: 28,
                    width: 28,
                    child: SvgPicture.asset(
                      'assets/icons/app_bar_back.svg',
                      color: CustomTheme.scale.scale7,
                    )),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _createTextFieldsContainer(BuildContext context, AddSchedulePageProvider viewModel) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 28, 20, 14),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: CustomTheme.gray.gray6,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextField(
            controller: viewModel.titleTextEditingController,
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: CustomTheme.scale.scale10),
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 0.5, color: CustomTheme.gray.gray2)),
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(4, 15, 4, 6),
                hintText: '이벤트 제목',
                hintStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: CustomTheme.gray.gray2)),
          ),
          TextField(
            controller: viewModel.contentTextEditingController,
            style: TextStyle(fontSize: 15, color: CustomTheme.scale.scale10),
            decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(4, 17, 4, 8),
                hintText: '내용을 여기에 써주세요(선택)',
                hintStyle:
                    TextStyle(fontSize: 15, color: CustomTheme.gray.gray2)),
          ),
        ],
      ),
    );
  }

  // 시간을 제외한 날짜 ex) 1월 5일 목요일
  Widget _createDateText(BuildContext context, String dateString) {
    return Container(
      height: 28,
      padding: const EdgeInsets.only(top: 7, left: 4),
      child: Text(
        dateString,
        style: TextStyle(fontSize: 14, color: CustomTheme.scale.scale10),
      ),
    );
  }

  Widget _createHourText(BuildContext context, String hourString) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Container(
        height: 28,
        width: 92,
        padding: const EdgeInsets.only(top: 7, left: 8, right: 8),
        child: Text(
          hourString,
          style: TextStyle(fontSize: 14, color: CustomTheme.scale.scale10),
        ),
      ),
    );
  }

  Widget _createDateStartTimeTable(
      BuildContext context, AddSchedulePageProvider viewModel) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FixedColumnWidth(112),
      },
      children: [
        TableRow(children: [
          GestureDetector(
              onTap: () async {
                DateTime? selectedDate =
                    await _getDateWithPicker(context, viewModel.startDateTime);
                if (selectedDate != null) {
                  viewModel.startDateTime = selectedDate;
                }
              },
              child: _createDateText(context, viewModel.startDateString)),
          GestureDetector(
              onTap: () {
                viewModel.changeStartTimeSpinnerScale();
              },
              child: _createHourText(context, viewModel.startTimeString)),
        ]),
      ],
    );
  }

  Widget _createDateEndTimeTable(
      BuildContext context, AddSchedulePageProvider viewModel) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FixedColumnWidth(112),
      },
      children: [
        TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: GestureDetector(
                    onTap: () async {
                      DateTime? selectedDate = await _getDateWithPicker(
                          context, viewModel.endDateTime);
                      if (selectedDate != null) {
                        viewModel.endDateTime = selectedDate;
                      }
                    },
                    child: _createDateText(context, viewModel.endDateString)),
              ),
              GestureDetector(
                onTap: () {
                  viewModel.changeEndTimeSpinnerScale();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 6),
                  child: _createHourText(context, viewModel.endTimeString),
                ),
              ),
            ],
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.5, color: CustomTheme.gray.gray2)))),
      ],
    );
  }

  Widget _createAllDaySwitchRow(
      BuildContext context, AddSchedulePageProvider viewModel) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FixedColumnWidth(112),
      },
      children: [
        TableRow(children: [
          Container(
            height: 28,
            padding: const EdgeInsets.only(top: 10, left: 4),
            child: Text(
              '종일',
              style: TextStyle(fontSize: 14, color: CustomTheme.scale.scale10),
            ),
          ),
          SizedBox(
              height: 28 + 6,
              child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, right: 36 + 6),
                    child: CupertinoSwitch(
                        value: viewModel.isAllDay,
                        onChanged: (value) {
                          viewModel.isAllDay = value;
                        }),
                  ))),
        ]),
      ],
    );
  }

  Widget _createNotificationRow(
      BuildContext context, AddSchedulePageProvider viewModel) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 16),
          child: SvgPicture.asset(
            'assets/icons/siren_mono.svg',
            height: 24,
            width: 24,
            color: CustomTheme.gray.gray2,
          ),
        ),
        GestureDetector(
          onTapDown: (detail) async {
            await showCustomMenu(
              context: context,
              initialValue: viewModel.notificationTime,
              constraints:
                  const BoxConstraints.tightFor(width: 145, height: 196),
              position: RelativeRect.fromSize(
                  detail.globalPosition &
                      Size(
                          0,
                          78.4 * viewModel.notificationTime.index.toDouble() +
                              39.2),
                  (Overlay.of(context)?.context.findRenderObject() as RenderBox)
                      .size),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              items: NotificationTime.values
                  .map((e) => PopupMenuItem(
                      height: 39.2,
                      value: e,
                      onTap: () {
                        viewModel.notificationTime = e;
                      },
                      child: Text(
                        e.name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: CustomTheme.scale.scale7),
                      )))
                  .toList(),
              elevation: 8.0,
            );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 14),
                child: Container(
                  width: 84 - 14,
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    viewModel.notificationTime.name,
                    style: TextStyle(
                        fontSize: 14, color: CustomTheme.scale.scale10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: SvgPicture.asset(
                    'assets/icons/arrow_right_small_mono.svg',
                    height: 14,
                    width: 14,
                    color: CustomTheme.gray.gray2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _createTimeSpinner(
      BuildContext context, double scale, Function(DateTime) onDateTimeChanged,
      {DateTime? initialDateTime}) {
    return AnimatedContainer(
      height: 180 * scale,
      curve: Curves.easeOutCirc,
      transform: Matrix4.identity()..scale(0.99, scale),
      duration: const Duration(milliseconds: 500),
      child: CustomCupertinoDatePicker(
        initialDateTime: initialDateTime,
        mode: CupertinoDatePickerMode.time,
        onDateTimeChanged: onDateTimeChanged,
      ),
    );
  }

  Widget _createColorRow(
      BuildContext context, AddSchedulePageProvider viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 16, top: 8),
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(36),
          1: FixedColumnWidth(16),
          2: FlexColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: markerColors[viewModel.tagColorIndex]),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7.5, vertical: 8),
                child: Container(
                  height: 28,
                  color: CustomTheme.gray.gray2,
                ),
              ),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: CustomTheme.gray.gray6,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 10),
                  scrollDirection: Axis.horizontal,
                    itemCount: markerColors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          viewModel.tagColorIndex = index;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: markerColors[index],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _getDateWithPicker(
      BuildContext context, DateTime initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AddSchedulePageProvider(),
        builder: (context, __) {
          final viewModel = context.watch<AddSchedulePageProvider>();
          return Scaffold(
            backgroundColor: CustomTheme.background.primary,
            floatingActionButton: FloatingActionButton.extended(onPressed: () async {
              final schedulesProvider = context.read<SchedulesProvider>();
              schedulesProvider.addScheduleBySaveButton(viewModel.getSchedule());
              context.pop();
            }, label: const Text('저장'), icon: const Icon(Icons.save),),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _createAppBar(context),
                _createTextFieldsContainer(context, viewModel),
                Container(
                  height: 0.5,
                  color: CustomTheme.gray.gray2,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
                      child: SvgPicture.asset(
                        'assets/icons/clock_mono.svg',
                        height: 24,
                        width: 24,
                        color: CustomTheme.gray.gray2,
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _createDateStartTimeTable(context, viewModel),
                    )),
                  ],
                ),
                _createTimeSpinner(context, viewModel.startTimeSpinnerScale,
                    (value) {
                  viewModel.startTime = value;
                }),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 52),
                      child: _createDateEndTimeTable(context, viewModel),
                    ),
                    _createTimeSpinner(context, viewModel.endTimeSpinnerScale,
                        (value) {
                      viewModel.endTime = value;
                    }, initialDateTime: viewModel.endTime),
                    Padding(
                      padding: const EdgeInsets.only(left: 52),
                      child: _createAllDaySwitchRow(context, viewModel),
                    ),
                  ],
                ),
                const SizedBox(height: 14 - 6),
                Container(
                  height: 0.5,
                  color: CustomTheme.gray.gray2,
                ),
                _createNotificationRow(context, viewModel),
                const SizedBox(height: 14),
                Container(
                  height: 0.5,
                  color: CustomTheme.gray.gray2,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '색깔 Tag를 추가해서, 이벤트를 식별하세요 (중복선택 X)',
                      style: TextStyle(
                          color: CustomTheme.gray.gray1,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
                  ),
                ),
                _createColorRow(context, viewModel),
              ],
            ),
          );
        });
  }
}
