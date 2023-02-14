import 'package:calendar/common/utils/async_utils.dart';
import 'package:calendar/common/utils/debug_utils.dart';
import 'package:calendar/domain/models/memo_model.dart';
import 'package:calendar/presentation/providers/memos_provider.dart';
import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:calendar/presentation/widgets/common/marker_colors.dart';
import 'package:calendar/presentation/widgets/common/section.dart';
import 'package:calendar/presentation/widgets/layout/custom_app_bar.dart';
import 'package:calendar/presentation/widgets/layout/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MemoEditPage extends StatefulWidget {
  static const routeName = 'memo/edit';

  final MemoModel memoModel;

  const MemoEditPage({super.key, required this.memoModel});

  @override
  State<StatefulWidget> createState() {
    return _MemoEditPageState();
  }
}

const _menuWidth = 120.0;

class _MemoEditPageState extends State<MemoEditPage> {
  late MemoModel _currentMemoModel;
  late TextEditingController _titleEditingController;
  late TextEditingController _contentEditingController;

  final _titleEditingDebouncer = Debouncer();
  final _contentEditingDebouncer = Debouncer();

  bool _updateMemoWhenQuit = true;

  @override
  void initState() {
    super.initState();

    _currentMemoModel = widget.memoModel;

    _titleEditingController = TextEditingController();
    _titleEditingController.text = _currentMemoModel.title;

    _contentEditingController = TextEditingController();
    _contentEditingController.text = _currentMemoModel.content;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DebugUtils.print('[MemoEditPage] Registering the listeners...');
      final memosProvider = context.read<MemosProvider>();

      _titleEditingController.addListener(() {
        _titleEditingDebouncer.run(const Duration(milliseconds: 300), () {
          memosProvider.updateMemo(
              _currentMemoModel.copyWith(title: _titleEditingController.text));
          DebugUtils.print('[MemoEditPage] Saved title!');
        });
      });

      _contentEditingController.addListener(() {
        _contentEditingDebouncer.run(const Duration(milliseconds: 300), () {
          memosProvider.updateMemo(_currentMemoModel.copyWith(
              content: _contentEditingController.text));
          DebugUtils.print('[MemoEditPage] Saved content!');
        });
      });
    });
  }

  @override
  void deactivate() {
    if (!_updateMemoWhenQuit) {
      return;
    }

    // 페이지 어떤 이유로든 나갈 때 메모 무조건 저장하도록 함.
    // context 접근 때문에 dispose 대신 deactivate에서 호출.
    final memosProvider = context.read<MemosProvider>();

    memosProvider.updateMemo(
        _currentMemoModel.copyWith(title: _titleEditingController.text));
    DebugUtils.print('[MemoEditPage] Saved title!');

    memosProvider.updateMemo(
        _currentMemoModel.copyWith(content: _contentEditingController.text));
    DebugUtils.print('[MemoEditPage] Saved content!');

    super.deactivate();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();

    super.dispose();
  }

  void _handleUnselectTag(MemosProvider memosProvider, int index) {
    final newSelectedColorIndices = [..._currentMemoModel.selectedColorIndices];
    newSelectedColorIndices.remove(index);

    memosProvider.updateMemo(_currentMemoModel.copyWith(
        selectedColorIndices: newSelectedColorIndices));
  }

  void _handleSelectTag(MemosProvider memosProvider, int index) {
    final newSelectedColorIndices = [..._currentMemoModel.selectedColorIndices];
    newSelectedColorIndices.add(index);

    memosProvider.updateMemo(_currentMemoModel.copyWith(
        selectedColorIndices: newSelectedColorIndices));
  }

  void _handlePressMenu(BuildContext context, MemosProvider memosProvider) {
    final screenWidth = MediaQuery.of(context).size.width;

    const top = 60.0;
    const right = 60.0;
    const bottom = 40.0;

    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            screenWidth - _menuWidth - right, top, right, bottom),
        items: [
          PopupMenuItem(
              value: 1,
              onTap: () {
                memosProvider.shareMemo(_currentMemoModel);
              },
              child: _MenuItem(
                  icon:
                      SvgPicture.asset('assets/icons/memo_edit_page_share.svg'),
                  label: 'Share')),
          PopupMenuItem(
              value: 2,
              onTap: () {
                memosProvider.copyMemo(_currentMemoModel);
              },
              child: _MenuItem(
                  icon:
                      SvgPicture.asset('assets/icons/memo_edit_page_copy.svg'),
                  label: 'Copy')),
          PopupMenuItem(
              value: 3,
              onTap: () async {
                Navigator.pop(context);
                await memosProvider.deleteMemo(_currentMemoModel.id);
                _updateMemoWhenQuit = false;
              },
              child: _MenuItem(
                  icon: SvgPicture.asset(
                      'assets/icons/memo_edit_page_delete.svg'),
                  label: 'Delete'))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final memosProvider = context.watch<MemosProvider>();

    final List<int> selectedColorIndices = [
      ..._currentMemoModel.selectedColorIndices
    ];

    final List<int> unselectedColorIndices = [];

    // TODO: 이거 더 효율적으로 바꾸기.
    for (var i = 0; i < markerColors.length; i++) {
      if (!_currentMemoModel.selectedColorIndices.contains(i)) {
        unselectedColorIndices.add(i);
      }
    }

    (() async {
      final newMemoModel =
          await memosProvider.getMemoByID(_currentMemoModel.id);

      if (newMemoModel != null) {
        setState(() {
          _currentMemoModel = newMemoModel;
        });
      }
    })();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          CustomAppBar(leftActions: const [
            CustomAppBarBackButton()
          ], rightActions: [
            CustomAppBarMenuButton(onPressed: () {
              _handlePressMenu(context, memosProvider);
            }),
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
              selectedColorIndices: selectedColorIndices,
              candidateColorIndices: unselectedColorIndices,
              onUnselect: (index) {
                _handleUnselectTag(memosProvider, index);
              },
              onSelect: (index) {
                _handleSelectTag(memosProvider, index);
              })
        ]),
        bottomNavigationBar:
            const CustomNavigationBar(selectedType: CustomNavigationType.memo));
  }
}

class _MenuItem extends StatelessWidget {
  final Widget icon;
  final String label;

  const _MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: _menuWidth,
        child: Row(children: [
          icon,
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CustomTheme.scale.scale7))
        ]));
  }
}

class _TagSelector extends StatelessWidget {
  final List<int> selectedColorIndices;
  final List<int> candidateColorIndices;
  final void Function(int) onUnselect;
  final void Function(int) onSelect;

  const _TagSelector(
      {super.key,
      required this.selectedColorIndices,
      required this.candidateColorIndices,
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
            ...selectedColorIndices.map((index) => _MarkerButton(
                color: markerColors[index],
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
                            children: candidateColorIndices
                                .map((index) => _MarkerButton(
                                    color: markerColors[index],
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
