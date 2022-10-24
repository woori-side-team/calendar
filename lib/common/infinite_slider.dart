import 'dart:collection';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class InfiniteSlider<Item> extends StatefulWidget {
  final CarouselOptions options;
  final Queue<Item> initialItems;
  final int initialSelectedIndex;
  final Item Function(Item) createPrevItem;
  final Item Function(Item) createNextItem;
  final void Function(Item) onSelectItem;
  final Widget Function(Item, bool, int, CarouselController) renderItem;

  const InfiniteSlider(
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
    return _InfiniteSliderState<Item>();
  }
}

class _InfiniteSliderState<Item> extends State<InfiniteSlider<Item>> {
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
    final List<Widget> itemBuilders = [];

    for (var index = 0; index < _items.length; index++) {
      itemBuilders.add(Builder(builder: (itemContext) {
        final isActive = _selectedIndex == index;

        return widget.renderItem(
            _items.elementAt(index), isActive, index, _carouselController);
      }));
    }

    return CarouselSlider(
        carouselController: _carouselController,
        items: itemBuilders,
        options: widget.options.copyWith(
            initialPage: _selectedIndex, onPageChanged: _handlePageChange));
  }
}
