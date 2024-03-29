import 'package:calendar/common/utils/custom_date_utils.dart';
import 'package:calendar/domain/models/schedule_model.dart';
import 'package:calendar/presentation/providers/add_schedule_page_provider.dart';
import 'package:calendar/presentation/providers/schedule_search_provider.dart';
import 'package:calendar/presentation/widgets/common/marker_colors.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../secert/admob_id.dart';
import '../common/custom_theme.dart';
import '../layout/custom_navigation_bar.dart';

enum TimeState { past, todayAndFuture }

class ScheduleSearchPage extends StatefulWidget {
  static const routeName = 'scheduleSearch';

  const ScheduleSearchPage({Key? key}) : super(key: key);

  @override
  State<ScheduleSearchPage> createState() => _ScheduleSearchPageState();
}

class _ScheduleSearchPageState extends State<ScheduleSearchPage> {
  late ScheduleSearchProvider viewModel;
  late BannerAd banner;

  @override
  void initState() {
    super.initState();
    banner = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdmobId.bannerId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

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

  Widget _createTextField(ScheduleSearchProvider viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
      child: TextField(
        controller: viewModel.textEditingController,
        onChanged: _onChanged,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 14),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: '검색어를 입력하세요.',
          hintStyle: TextStyle(color: CustomTheme.gray.gray2, fontSize: 18),
          fillColor: CustomTheme.background.secondary,
          filled: true,
        ),
      ),
    );
  }

  Widget _createHighlightText({
    required String fullText,
    required String searchKeyword,
    Color? textColor,
    required double fontSize,
  }) {
    var style = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: textColor ?? CustomTheme.scale.scale11,
    );
    final List<String> texts = fullText.split(searchKeyword);
    texts.insert(1, searchKeyword);
    return Row(
      children: [
        Text(
          texts[0],
          style: style,
        ),
        Container(
          color: CustomTheme.tint.yellow.withOpacity(0.2),
          child: Text(
            texts[1],
            style: style,
          ),
        ),
        Text(
          texts[2],
          style: style,
        ),
      ],
    );
  }

  Widget _createTitleText({
    required ScheduleModel schedule,
    required Color color,
  }) {
    return viewModel.isSearchKeywordInTitle(schedule)
        ? _createHighlightText(
            fullText: schedule.title,
            searchKeyword: viewModel.textEditingController.text,
            fontSize: 17,
            textColor: color)
        : Text(
            schedule.title,
            style: TextStyle(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          );
  }

  Widget _createContentText({
    required ScheduleModel schedule,
    required Color color,
  }) {
    return viewModel.isSearchKeywordInContent(schedule)
        ? _createHighlightText(
            fullText: schedule.content,
            searchKeyword: viewModel.textEditingController.text,
            fontSize: 14,
            textColor: color,
          )
        : Text(
            schedule.content,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: color,
            ),
          );
  }

  Widget _createScheduleRow(
    ScheduleSearchProvider viewModel,
    int index,
    TimeState state,
  ) {
    var schedule = state == TimeState.todayAndFuture
        ? viewModel.todayAndFutureSchedules[index]
        : viewModel.pastSchedules[index];
    int dCount = CustomDateUtils.getDCount(schedule.start);
    String dString = '';

    if (state == TimeState.todayAndFuture) {
      dString = dCount != 0 ? 'D-$dCount' : 'D-Day';
    } else {
      dString = 'D-0';
    }

    Color dContainerColor = state == TimeState.todayAndFuture
        ? markerColors[schedule.colorIndex]
        : CustomTheme.gray.gray4;
    Color dTextColor = state == TimeState.todayAndFuture
        ? Colors.white
        : CustomTheme.gray.gray5;
    Color titleColor = state == TimeState.todayAndFuture
        ? CustomTheme.scale.scale11
        : CustomTheme.gray.gray3;
    Color contentColor = state == TimeState.todayAndFuture
        ? CustomTheme.scale.scale7.withOpacity(0.7)
        : CustomTheme.gray.gray4;
    Color? iconColor =
        state == TimeState.todayAndFuture ? null : const Color(0xffdcdfe3);

    return InkWell(
      onTap: () {
        context.read<AddSchedulePageProvider>().initWithSchedule(schedule);
        viewModel.textEditingController.text = '';
        viewModel.searchSchedules('');
        context.pushNamed('addSchedulePage');
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(19, 12, 0, 14),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: CustomTheme.gray.gray5))),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 60,
              height: 38,
              decoration: BoxDecoration(
                color: dContainerColor,
                borderRadius: schedule.type == ScheduleType.allDay
                    ? null
                    : BorderRadius.circular(39),
              ),
              child: Text(
                dString,
                style: TextStyle(
                  color: dTextColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Row(
                      children: [
                        Text(
                          '${DateFormat('M/d, a h:mm').format(schedule.start)}, ',
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _createTitleText(
                          schedule: schedule,
                          color: titleColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  height: 17,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Container(
                      constraints:const BoxConstraints(minWidth:1),
                      child: _createContentText(
                        schedule: schedule,
                        color: contentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 13),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: SvgPicture.asset(
                    'assets/icons/arrow_right_small_mono.svg',
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ScheduleSearchProvider>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
      bottomNavigationBar: const CustomNavigationBar(
          selectedType: CustomNavigationType.schedule),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomAppBar(rightActions: []),
            _createTextField(viewModel),
            Container(
              height: 1,
              color: CustomTheme.gray.gray4,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 20),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  '일정',
                  style: TextStyle(
                    fontSize: 13,
                    color: CustomTheme.gray.gray2,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: viewModel.searched.length + 1,
                  itemBuilder: (context, index) {
                    if (index < viewModel.todayAndFutureSchedules.length) {
                      return _createScheduleRow(
                          viewModel, index, TimeState.todayAndFuture);
                    } else if (index >
                        viewModel.todayAndFutureSchedules.length) {
                      return _createScheduleRow(
                        viewModel,
                        index - viewModel.todayAndFutureSchedules.length - 1,
                        TimeState.past,
                      );
                    } else {
                      return const SizedBox(height: 28);
                    }
                  }),
            ),
            const SizedBox(height: 28),
            SizedBox(
                height: AdSize.mediumRectangle.height.toDouble(),
                child: AdWidget(ad: banner)),
          ],
        ),
      );
  }
}
