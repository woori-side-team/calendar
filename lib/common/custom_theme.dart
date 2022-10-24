import 'package:flutter/material.dart';

class CustomTheme {
  static const scale = _Scale();
  static const gray = _Gray();
  static const tint = _Tint();
  static const background = _Background();
  static const label = _Label();
  static const separator = _Separator();
  static const groupedBackground = _GroupedBackground();
  static const fill = _Fill();
  static const disabled = _State();
}

class _Scale {
  const _Scale();

  final Color scale1 = const Color(0xfff2f2f7);
  final Color scale2 = const Color(0xffe5e5ea);
  final Color scale3 = const Color(0xffd1d1d6);
  final Color scale4 = const Color(0xffc7c7cc);
  final Color scale5 = const Color(0xffaeaeb2);
  final Color scale6 = const Color(0xff8e8e93);
  final Color scale7 = const Color(0xff636366);
  final Color scale8 = const Color(0xff48484a);
  final Color scale9 = const Color(0xff3a3a3c);
  final Color scale10 = const Color(0xff2c2c2e);
  final Color scale11 = const Color(0xff1c1c1e);
  final Color min = const Color(0xfff2f2f7); // First.
  final Color max = const Color(0xff1c1c1e); // Last.
}

class _Gray {
  const _Gray();

  final gray1 = const Color(0xff8e8e93);
  final gray2 = const Color(0xffaeaeb2);
  final gray3 = const Color(0xffc7c7cc);
  final gray4 = const Color(0xffd1d1d6);
  final gray5 = const Color(0xffe5e5ea);
  final gray6 = const Color(0xfff2f2f7);
}

class _Tint {
  const _Tint();

  final blue = const Color(0xff007aff);
  final green = const Color(0xff34c759);
  final indigo = const Color(0xff5856d6);
  final orange = const Color(0xffff9500);
  final pink = const Color(0xffff2d55);
  final purple = const Color(0xffaf52de);
  final red = const Color(0xffff3b30);
  final teal = const Color(0xff5ac8fa);
  final yellow = const Color(0xffffcc00);
}

class _Background {
  const _Background();

  final primary = const Color(0xffffffff);
  final secondary = const Color(0xfff2f2f7);
  final tertiary = const Color(0xffc7c7c7);
}

class _Label {
  const _Label();

  final primary = const Color(0xff000000);
  final secondary = const Color(0xff757579);
  final tertiary = const Color(0xff9c9c9e);
  final quarternary = const Color(0xffb1b1b2);
}

class _Separator {
  const _Separator();

  final opaque = const Color(0xffc6c6c8);
  final nonOpaque = const Color(0xff9c9c9e);
}

class _GroupedBackground {
  const _GroupedBackground();

  final primary = const Color(0xfff2f2f7);
  final secondary = const Color(0xffffffff);
  final tertiary = const Color(0xfff2f2f7);
}

class _Fill {
  const _Fill();

  final primary = const Color(0xffbababc);
  final secondary = const Color(0xffbdbdbe);
  final tertiary = const Color(0xffc0c0c1);
  final quarternary = const Color(0xffc4c4c5);
}

class _State {
  const _State();

  final disabled = const Color(0xff979592);
}
