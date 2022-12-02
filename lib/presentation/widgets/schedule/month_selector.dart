import 'dart:collection';

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
    final selectedMonthDate =
        context.watch<SchedulesProvider>().getSelectedMonthDate();
    final Queue<DateTime> initialItems = Queue();

    for (var month = 1; month <= 12; month++) {
      initialItems.addLast(DateTime(selectedMonthDate.year, month));
    }

    return CustomCarousel<DateTime>(
        options: CarouselOptions(
          height: 36,
          viewportFraction: 0.35,
          enableInfiniteScroll: false,
          autoPlay: false,
        ),
        initialItems: initialItems,
        initialSelectedIndex: selectedMonthDate.month - 1,
        createPrevItem: (item) => DateTime(item.year, item.month - 1),
        createNextItem: (item) => DateTime(item.year, item.month + 1),
        onSelectItem: (item) {
          context.read<SchedulesProvider>().setSelectedMonthDate(item);
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
                  controller.animateToPage(index);
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
