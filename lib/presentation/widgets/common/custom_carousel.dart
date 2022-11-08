import 'dart:collection';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// 무한 캐러셀입니다. 양쪽 끝으로 이동했을 때 아이템들이 자동으로 생성되는 기능을 제공합니다.
/// 현재 선택된 아이템은 상위에서 직접 state로 관리해야 합니다.
class CustomCarousel<Item> extends StatefulWidget {
  /// 캐러셀 옵션. (https://pub.dev/packages/carousel_slider 참고)
  final CarouselOptions options;

  /// 초기 아이템 목록.
  final Queue<Item> initialItems;

  /// 처음에 무슨 아이템을 선택할지.
  final int initialSelectedIndex;

  /// 첫부분으로 이동했을 때 아이템을 새롭게 생성.
  final Item Function(Item) createPrevItem;

  /// 마지막 부분으로 이동했을 때 아이템을 새롭게 생성.
  final Item Function(Item) createNextItem;

  /// 아이템이 선택될 때 불림.
  final void Function(Item) onSelectItem;

  /// 각 아이템을 어떻게 렌더할지.
  final Widget Function(Item, bool, int, CarouselController) renderItem;

  const CustomCarousel(
      {super.key,
      required this.options,
      required this.initialItems,
      required this.initialSelectedIndex,
      required this.createPrevItem,
      required this.createNextItem,
      required this.onSelectItem,
      required this.renderItem});

  @override
  State<StatefulWidget> createState() {
    return _CustomCarouselState<Item>();
  }
}

class _CustomCarouselState<Item> extends State<CustomCarousel<Item>> {
  // Rebuild 이후에도 새로 만들지 않고 재사용해야 하므로 state로 들고 있음.
  late final CarouselController _carouselController;

  late Queue<Item> _items;
  late int _selectedIndex;

  void _handlePageChange(int index, CarouselPageChangedReason reason) {
    if (index == 0) {
      setState(() {
        _items.addFirst(widget.createPrevItem(_items.first));
        _selectedIndex = 1;
      });
    } else if (index == _items.length - 1) {
      setState(() {
        _items.addLast(widget.createNextItem(_items.last));
        _selectedIndex = _items.length - 2;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }

    widget.onSelectItem(_items.elementAt(_selectedIndex));
  }

  @override
  void initState() {
    super.initState();

    _carouselController = CarouselController();
    _items = widget.initialItems;
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        carouselController: _carouselController,
        items: _items
            .mapIndexed((index, item) => widget.renderItem(
                _items.elementAt(index),
                _selectedIndex == index,
                index,
                _carouselController))
            .toList(),
        options: widget.options.copyWith(
            initialPage: _selectedIndex, onPageChanged: _handlePageChange));
  }
}
