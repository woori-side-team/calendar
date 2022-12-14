import 'package:calendar/presentation/widgets/common/custom_theme.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final Widget? icon;
  final String title;

  const SectionTitle({super.key, this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 32, bottom: 10),
        padding: const EdgeInsets.only(top: 14, bottom: 14, left: 20),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: CustomTheme.scale.scale11))),
        child: Row(children: [
          ...(icon != null ? [icon!, const SizedBox(width: 4)] : []),
          Expanded(
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  )))
        ]));
  }
}

class SectionTitleEditor extends StatelessWidget {
  final TextEditingController textEditingController;

  const SectionTitleEditor({super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 32, bottom: 10),
        padding: const EdgeInsets.only(top: 14, bottom: 14, left: 20),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: CustomTheme.scale.scale11))),
        child: Row(children: [
          Expanded(
              child: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero),
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  )))
        ]));
  }
}

class SubsectionTitle extends StatelessWidget {
  final Widget icon;
  final String title;

  const SubsectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 32, bottom: 10),
        padding: const EdgeInsets.only(top: 14, bottom: 14, left: 20),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: CustomTheme.gray.gray3))),
        child: Row(children: [
          icon,
          const SizedBox(width: 4),
          Text(title, style: const TextStyle(fontSize: 18))
        ]));
  }
}
