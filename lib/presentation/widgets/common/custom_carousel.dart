import 'dart:async';
import 'dart:collection';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// 무한 캐러셀입니다. 양쪽 끝으로 이동했을 때 아이템들이 자동으로 생성되는 기능을 제공합니다.
/// 현재 선택된 아이템은 상위에서 직접 state로 관리해야 합니다.
class CustomCarousel<Item> extends StatefulWidget {
  /// 캐러셀 옵션. (https://pub.dev/packages/carousel_slider 참고)
  final CarouselOptions options;

  /// 아이템 목록.
  final Queue<Item> items;

  /// 무슨 아이템을 선택할지.
  final int selectedIndex;

  /// 아이템 변경 시.
  final void Function(int index) onPageChanged;

  /// 각 아이템을 어떻게 렌더할지.
  final Widget Function(Item, bool, int, CarouselController) renderItem;

  const CustomCarousel(
      {super.key,
      required this.options,
      required this.items,
      required this.selectedIndex,
      required this.onPageChanged,
      required this.renderItem});

  @override
  State<StatefulWidget> createState() {
    return _CustomCarouselState<Item>();
  }
}

class _CustomCarouselState<Item> extends State<CustomCarousel<Item>> {
  // Rebuild 이후에도 새로 만들지 않고 재사용해야 하므로 state로 들고 있음.
  late final CarouselController _carouselController;
  late int _carouselIndex;

  void _handlePageChange(int index, CarouselPageChangedReason reason) {
    widget.onPageChanged(index);

    setState(() {
      _carouselIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _carouselController = CarouselController();
    _carouselIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedIndex != _carouselIndex) {
      Timer.run(() {
        _carouselController.animateToPage(widget.selectedIndex);
      });
    }

    return CarouselSlider(
        carouselController: _carouselController,
        items: widget.items
            .mapIndexed((index, item) => widget.renderItem(
                widget.items.elementAt(index),
                widget.selectedIndex == index,
                index,
                _carouselController))
            .toList(),
        options: widget.options.copyWith(
            initialPage: widget.selectedIndex,
            onPageChanged: _handlePageChange));
  }
}
