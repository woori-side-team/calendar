import 'package:calendar/common/di/di.dart';
import 'package:calendar/presentation/providers/add_schedule_page_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/common/custom_time_picker.dart';
import 'package:flutter/cupertino.dart' hide CupertinoDatePickerMode;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

  Widget _createTextFieldsContainer(BuildContext context) {
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
  Widget _createDateText(BuildContext context) {
    String dateString = '1월 5일 목요일';
    return Container(
      height: 28,
      padding: const EdgeInsets.only(top: 7, left: 4),
      child: Text(
        dateString,
        style: TextStyle(fontSize: 14, color: CustomTheme.scale.scale10),
      ),
    );
  }

  Widget _createHourText(BuildContext context) {
    String hourString = '오전 10:30';
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

  Widget _createDateStartTimeTable(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FixedColumnWidth(112),
      },
      children: [
        TableRow(children: [
          _createDateText(context),
          _createHourText(context),
        ]),
      ],
    );
  }

  Widget _createDateEndTimeTable(BuildContext context) {
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
                child: _createDateText(context),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6),
                child: _createHourText(context),
              ),
            ],
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.5, color: CustomTheme.gray.gray2)))),

      ],
    );
  }

  Widget _createAllDaySwitchRow(BuildContext context) {
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
                    child: CupertinoSwitch(value: true, onChanged: (_) {}),
                  ))),
        ]),
      ],
    );
  }

  Widget _createAlarmRow(BuildContext context) {
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
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 14),
          child: Container(
            width: 84 - 14,
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '10분 전',
              style: TextStyle(fontSize: 14, color: CustomTheme.scale.scale10),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AddSchedulePageProvider>(),
      builder: (context, __) {
        return Scaffold(
          backgroundColor: CustomTheme.background.primary,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createAppBar(context),
              _createTextFieldsContainer(context),
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
                      padding: const EdgeInsets.only(top: 14),
                      child: Column(
                        children: [
                          _createDateStartTimeTable(context),
                          AnimatedContainer(
                            height: 182.56,
                            //transform: Matrix4.identity()..scale(0.99,_scale),
                            duration: const Duration(milliseconds: 500),
                            child: CustomCupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: (_) {},
                            ),
                          ),
                          _createDateEndTimeTable(context),
                          _createAllDaySwitchRow(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14 - 6),
              Container(
                height: 0.5,
                color: CustomTheme.gray.gray2,
              ),
              _createAlarmRow(context),
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
            ],
          ),
        );
      }
    );
  }
}
