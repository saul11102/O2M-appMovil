import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionUtil{
  final storage = new FlutterSecureStorage();
  void add (key, value) async {
    await storage.write(key: key, value: value);
  }

  void removeItem(key) async {
    await storage.delete(key: key);
  }

  void removeAll() async {
    await storage.deleteAll();
  }

  Future<String?> getValue(key) async {
    return storage.read(key: key);
  }
}