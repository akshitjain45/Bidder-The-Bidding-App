import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorageUtils {
  FirebaseStorage _storage = FirebaseStorage.instance;
  String _getExt(String t) => t.split('.').last;
  Future<String> upload({
    required File file,
    required String path,
    String? name,
  }) async {
    Reference ref = _storage.ref().child('$path/');
    if (name != null) {
      ref = ref.child('$name.${_getExt(file.path)}');
    } else {
      ref = ref.child('${DateTime.now()}');
    }
    UploadTask task = ref.putFile(
      file,
    );
    var t = await task;
    return await t.ref.getDownloadURL();
  }
}
