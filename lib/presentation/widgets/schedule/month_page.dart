import 'package:admob_flutter/admob_flutter.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/layout/scaffold_overlay_bottom_navigation_bar.dart';
import 'package:calendar/presentation/widgets/schedule/month_selector.dart';
import 'package:calendar/presentation/widgets/schedule/month_view.dart';
import 'package:calendar/secert/admob_id.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../providers/schedules_provider.dart';
import '../common/custom_carousel.dart';

class MonthPage extends StatelessWidget {
  static const routeName = 'schedule/month';
  late final BannerAd banner;

  MonthPage({super.key}) {
    banner = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: AdmobId.bannerId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return ScaffoldOverlayBottomNavigationBar(
        scaffold: Scaffold(
          body: Stack(children: [
            Column(children: [
              CustomAppBar(isScheduleAppBar: true, rightActions: [
                CustomAppBarModeButton(
                    type: CustomAppBarModeType.vertical,
                    onPressed: () {
                      context.pushNamed('weekPage');
                    }),
                const CustomAppBarSearchButton(type: PageType.schedule),
              ]),
              const MonthSelector(),
              const _MonthViewCarousel(),
              Padding(
                padding: EdgeInsets.only(bottom: 112 + bottomPadding),
                child: SizedBox(
                    height: AdSize.largeBanner.height.toDouble(),
                    child: AdWidget(ad: banner)),
              )
            ]),
          ]),
        ),
        bottomNavigationBar: CustomNavigationBar(
            selectedType: CustomNavigationType.schedule,
            onPressSchedule: () {
              context.pushNamed('weekPage');
            }));
  }
}

class _MonthViewCarousel extends StatelessWidget {
  const _MonthViewCarousel();

  @override
  Widget build(BuildContext context) {
    final schedulesProvider = context.watch<SchedulesProvider>();

    return Expanded(
        child: CustomCarousel<DateTime>(
            options: CarouselOptions(
                height: double.infinity,
                enableInfiniteScroll: false,
                autoPlay: false,
                viewportFraction: 1),
            items: schedulesProvider.neighborMonthDates,
            selectedIndex: schedulesProvider.selectedNeighborMonthDateIndex,
            onPageChanged: (index) {
              schedulesProvider.selectNeighborMonthDate(index);
            },
            renderItem: (item, isActive, index, controller) {
              return MonthView(monthDate: item);
            }));
  }
}
