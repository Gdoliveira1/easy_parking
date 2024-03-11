import "dart:math";

import "package:uuid/uuid.dart";

// RandomHelper: A utility class for generating random identifiers.
abstract class RandomHelper {
  // Uuid instance for generating universally unique identifiers (UUIDs).
  static const Uuid _uuid = Uuid();
  static const _chars =
      "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";

  static String identifier({int size = 28}) {
    final Random random = Random();
    final String randomString = String.fromCharCodes(Iterable.generate(
            size, (_) => _chars.codeUnitAt(random.nextInt(_chars.length))))
        .toUpperCase();
    return randomString;
  }

  // Generates a UUID (Universally Unique Identifier) using the Uuid package.
  static String generateUuid() {
    return _uuid.v4();
  }
}
