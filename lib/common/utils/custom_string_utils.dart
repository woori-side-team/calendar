import 'package:uuid/uuid.dart';

class CustomStringUtils {
  static const _uuid = Uuid();

  static String generateID() {
    return _uuid.v4();
  }
}
