import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';

class localStorage {

  final LocalStorage storage = new LocalStorage('medschoolcoach');

  localStorage();

  Future<void> _write({
    String key,
    String value
  }){
    if (!kIsWeb) FlutterSecureStorage().write(key:key,value:value);
    else storage.setItem(key, value);
  }

  Future<void> write({
    String key,
    String value
  }) =>
      value != null
          ? _write(key: key,value:value)
          : delete(key: key);

  Future<String> read({String key}) async {
    return  await _read(key:key);
  }

  Future<String> _read({String key}) async {
    if (kIsWeb)  return await storage.getItem(key);
    else  return FlutterSecureStorage().read(key:key);
  }

  Future<void> delete({
    String key
  }) => _delete(key:key);


  Future<void> _delete({
    String key
  }){
    if (!kIsWeb) FlutterSecureStorage().delete(key:key);
    else storage.deleteItem(key);
  }

  Future<void> deleteAll() => _deleteAll();


  Future<void> _deleteAll(){
    if (!kIsWeb) FlutterSecureStorage().deleteAll();
    //else storage.deleteItem(key);
  }
}