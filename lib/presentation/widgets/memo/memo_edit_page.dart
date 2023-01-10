import 'package:calendar/domain/models/memo_model.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/common/marker_colors.dart';
import 'package:calendar/presentation/widgets/common/section.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class MemoEditPage extends StatefulWidget {
  static const routeName = 'memo/edit';

  final MemoModel memoModel;

  const MemoEditPage({super.key, required this.memoModel});

  @override
  State<StatefulWidget> createState() {
    return _MemoEditPageState();
  }
}

class _MemoEditPageState extends State<MemoEditPage> {
  late TextEditingController _titleEditingController;
  late TextEditingController _contentEditingController;
  late List<Color> _selectedTags;
  late List<Color> _candidateTags;

  @override
  void initState() {
    super.initState();

    _titleEditingController = TextEditingController();
    _titleEditingController.text = widget.memoModel.title;

    _contentEditingController = TextEditingController();
    _contentEditingController.text = widget.memoModel.content;

    _selectedTags = markerColors.sublist(0, 3);
    _candidateTags = markerColors.sublist(3);
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();

    super.dispose();
  }

  void _handleUnselectTag(int index) {
    final color = _selectedTags[index];

    setState(() {
      _selectedTags.removeAt(index);
      _candidateTags.insert(0, color);
    });
  }

  void _handleSelectTag(int index) {
    final color = _candidateTags[index];

    setState(() {
      _candidateTags.removeAt(index);
      _selectedTags.add(color);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          CustomAppBar(leftActions: const [
            CustomAppBarBackButton()
          ], rightActions: [
            CustomAppBarMenuButton(onPressed: () {}),
            CustomAppBarEditButton(onPressed: () {})
          ]),
          SectionTitleEditor(textEditingController: _titleEditingController),
          Expanded(
              child: TextField(
                  controller: _contentEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.only(
                          left: 24, right: 24, top: 18, bottom: 18)),
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 16))),
          _TagSelector(
              selectedTags: _selectedTags,
              candidateTags: _candidateTags,
              onUnselect: _handleUnselectTag,
              onSelect: _handleSelectTag)
        ]),
        bottomNavigationBar:
            const CustomNavigationBar(selectedType: CustomNavigationType.memo));
  }
}

class _TagSelector extends StatelessWidget {
  final List<Color> selectedTags;
  final List<Color> candidateTags;
  final void Function(int) onUnselect;
  final void Function(int) onSelect;

  const _TagSelector(
      {super.key,
      required this.selectedTags,
      required this.candidateTags,
      required this.onUnselect,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        padding: const EdgeInsets.only(top: 14, bottom: 28),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: CustomTheme.gray.gray4,
                    width: 1,
                    style: BorderStyle.solid))),
        child: Column(children: [
          Row(children: [
            Text('색깔 Tag를 추가해서, 메모를 필터링해보세요',
                style: TextStyle(
                    color: CustomTheme.gray.gray3,
                    fontSize: 12,
                    fontWeight: FontWeight.w500))
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const SizedBox(width: 4),
            ...selectedTags.mapIndexed((index, color) => _MarkerButton(
                color: color,
                onPressed: () {
                  onUnselect(index);
                })),
            Container(
                width: 1,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(color: CustomTheme.gray.gray2)),
            Expanded(
                child: Container(
                    alignment: Alignment.centerLeft,
                    height: 44,
                    padding: const EdgeInsets.only(left: 14),
                    decoration: BoxDecoration(
                        color: CustomTheme.groupedBackground.primary,
                        borderRadius: BorderRadius.circular(12)),
                    child: SingleChildScrollView(
                        child: Row(
                            children: candidateTags
                                .mapIndexed((index, color) => _MarkerButton(
                                    color: color,
                                    onPressed: () {
                                      onSelect(index);
                                    }))
                                .toList()))))
          ])
        ]));
  }
}

class _MarkerButton extends StatelessWidget {
  final Color color;
  final void Function() onPressed;

  const _MarkerButton(
      {super.key, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 7),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)));
  }
}
