import 'package:calendar/common/di/di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// 등록한 인스턴스들 가져올 때 사용.
final getIt = GetIt.instance;

/// DI 세팅.
@InjectableInit()
void configureDependencies() {
  $initGetIt(getIt);
}
