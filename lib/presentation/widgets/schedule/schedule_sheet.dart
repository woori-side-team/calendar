import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/presentation/providers/schedules_provider.dart';
import 'package:calendar/presentation/providers/sheet_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../secert/admob_id.dart';
import '../../providers/add_schedule_page_provider.dart';
import '../common/marker_colors.dart';

class ScheduleSheet extends StatefulWidget {
  const ScheduleSheet({super.key, this.minSizeRatio});

  final double? minSizeRatio;

  @override
  State<StatefulWidget> createState() {
    return _ScheduleSheet();
  }
}

class _ScheduleSheet extends State<ScheduleSheet> {
  late int sheetIndex;
  late BannerAd banner;

  void _handlePressEdit() {
    final viewModel = context.read<SheetProvider>();
    viewModel.setSheetEditMode(sheetIndex);
  }

  void _handlePressView() {
    final viewModel = context.read<SheetProvider>();
    viewModel.setSheetViewMode(sheetIndex);
  }

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<SheetProvider>();
    sheetIndex = viewModel.sheetScrollControllers.length - 1;

    banner = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: AdmobId.bannerId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  Widget _createHeader(SheetProvider viewModel) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 14, left: 20, right: 18),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('다가오는 일정',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: CustomTheme.scale.scale10)),
          viewModel.sheetModes[sheetIndex] == SheetMode.view
              ? TextButton(
                  onPressed: _handlePressEdit,
                  child: Text('편집',
                      style: TextStyle(
                          fontSize: 17, color: CustomTheme.tint.blue)))
              : IconButton(
                  onPressed: _handlePressView,
                  icon:
                      SvgPicture.asset('assets/icons/schedule_sheet_close.svg'))
        ]));
  }

  Widget _createScheduleView(
      SheetProvider viewModel, BuildContext context, ScheduleModel schedule) {
    const controlWidth = 24.0;
    const controlHeight = 24.0;
    final dCount = CustomDateUtils.getDCount(schedule.start);
    final schedulesProvider = context.read<SchedulesProvider>();

    return Container(
        height: 24,
        margin: const EdgeInsets.only(bottom: 24, right: 24),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              width: 40,
              height: 24,
              margin: const EdgeInsets.only(left: 28, right: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: schedule.type == ScheduleType.hours
                      ? BorderRadius.circular(50)
                      : null,
                  color: markerColors[schedule.colorIndex]),
              child: Text(dCount != 0 ? 'D-$dCount' : 'D-Day',
                  style: TextStyle(
                      color: CustomTheme.background.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400))),
          Expanded(
              child: TextButton(
                  onPressed: () {
                    final schedulesProvider = context.read<SchedulesProvider>();
                    schedulesProvider.getOneDaySchedules(schedule.start);
                    context.pushNamed('dayPage', params: {
                      'selectedDate':
                          CustomDateUtils.dateToString(schedule.start)
                    });
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.centerLeft),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text('${schedule.title}: ${schedule.content}',
                          style: TextStyle(
                              color: CustomTheme.scale.max,
                              fontSize: 14,
                              fontWeight: FontWeight.w400))))),
          viewModel.sheetModes[sheetIndex] == SheetMode.view
              ? Container()
              : Row(children: [
                  SizedBox(
                      width: controlWidth,
                      height: controlHeight,
                      child: IconButton(
                          onPressed: () {
                            context
                                .read<AddSchedulePageProvider>()
                                .initWithSchedule(schedule);
                            context.pushNamed('addSchedulePage');
                          },
                          padding: const EdgeInsets.all(0),
                          icon: SvgPicture.asset(
                              'assets/icons/schedule_sheet_schedule_edit.svg'))),
                  SizedBox(
                      width: controlWidth,
                      height: controlHeight,
                      child: IconButton(
                          onPressed: () async {
                            await schedulesProvider.deleteSchedule(schedule.id);
                            if (schedulesProvider
                                .selectedMonthSchedules.isEmpty) {
                              viewModel.setSheetViewMode(sheetIndex);
                            }
                          },
                          padding: const EdgeInsets.all(0),
                          icon: SvgPicture.asset(
                              'assets/icons/schedule_sheet_schedule_close.svg')))
                ])
        ]));
  }

  Widget _createDot() {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: CustomTheme.background.tertiary),
        width: 4,
        height: 4,
        margin: const EdgeInsets.only(top: 4));
  }

  Widget _createContent(SheetProvider viewModel, BuildContext context) {
    final schedules =
        context.watch<SchedulesProvider>().sortedSelectedMonthSchedules;
    final schedulesToShow =
        schedules.where((schedule) => viewModel.isScheduleToShow(schedule));

    // 최대 몇개까지만 보여줄지.
    const maxShowCount = 7;

    return Container(
        margin: const EdgeInsets.only(top: 24),
        child: Column(children: [
          ...schedulesToShow
              .take(maxShowCount)
              .map((schedule) =>
                  _createScheduleView(viewModel, context, schedule))
              .toList(),
          Container(
              margin: const EdgeInsets.only(top: 4),
              child: Column(
                  children: schedulesToShow.length < maxShowCount
                      ? []
                      : [_createDot(), _createDot(), _createDot()]))
        ]));
  }

  Widget _createCommandTextField() {
    var schedulesViewModel = context.read<SchedulesProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: TextField(
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: '일정을 입력하세요.',
          hintStyle: TextStyle(color: CustomTheme.gray.gray2, fontSize: 15),
          fillColor: CustomTheme.background.secondary,
          filled: true,
        ),
        onSubmitted: (command) {
          schedulesViewModel.addSchedule(command);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SheetProvider>();

    return Column(children: [
      _createCommandTextField(),
      Container(
        color: CustomTheme.gray.gray4,
        height: 1,
      ),
      _createHeader(viewModel),
      _createContent(viewModel, context),
      SizedBox(
          height: AdSize.largeBanner.height.toDouble(),
          child: AdWidget(ad: banner)),
    ]);
  }
}
