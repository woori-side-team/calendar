import 'package:flutter/material.dart';

/// 라우팅 관련 유틸들.
class CustomRouteUtils {
  /// 라우트들을 설정할 때 사용합니다.
  /// 라우팅 애니메이션 등을 우리가 원하는 대로 바꾸기 위해 사용합니다.
  static Route createRoute(Widget Function() builder) {
    return _CustomPageRoute(builder: (context) => builder());
  }

  /// 새 라우트로 이동합니다.
  /// 이전 라우트들이 히스토리에 남아 있습니다.
  static void push(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
}

class _CustomPageRoute extends MaterialPageRoute {
  _CustomPageRoute({required super.builder});

  @override
  Duration get transitionDuration {
    // 애니메이션 끔.
    return const Duration(milliseconds: 0);
  }
}
