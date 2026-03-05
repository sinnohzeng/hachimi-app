import 'dart:convert';

import 'package:crypto/crypto.dart';

class UidHasher {
  UidHasher._();

  static String hash(String uid) {
    final bytes = utf8.encode(uid);
    return sha256.convert(bytes).toString();
  }
}
