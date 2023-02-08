import 'package:calendar/presentation/providers/schedules_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_carousel.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final schedulesProvider = context.watch<SchedulesProvider>();
    final selectedMonthDate = schedulesProvider.getSelectedMonthDate();

    return CustomCarousel<DateTime>(
        options: CarouselOptions(
          height: 36,
          viewportFraction: 0.35,
          enableInfiniteScroll: false,
          autoPlay: false,
        ),
        items: schedulesProvider.neighborMonthDates,
        selectedIndex: schedulesProvider.selectedNeighborMonthDateIndex,
        onPageChanged: (index) {
          schedulesProvider.selectNeighborMonthDate(index);
        },
        renderItem: (item, isActive, index, controller) {
          final text = '${item.year}.${'${item.month}'.padLeft(2, '0')}';

          if (isActive) {
            return Container(
                width: 107,
                height: 48,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: CustomTheme.scale.max))),
                child: Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text(text,
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: CustomTheme.scale.max)),
                    )));
          } else {
            return TextButton(
                onPressed: () {
                  schedulesProvider.selectNeighborMonthDate(index);
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Text(text,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: CustomTheme.scale.scale4)));
          }
        });
  }
}
